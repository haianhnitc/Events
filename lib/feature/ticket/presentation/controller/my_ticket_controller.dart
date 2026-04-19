import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/ticket/domain/entity/ticket_entity.dart';
import 'package:events_app/feature/ticket/domain/usecase/ticket_usecase.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:get/get.dart';

class MyTicketController extends GetxController {
  final GetMyTicketsUsecase _getMyTicketsUsecase = networkGetIt<GetMyTicketsUsecase>();
  final UpdateTicketStatusUsecase _updateTicketStatusUsecase =
      networkGetIt<UpdateTicketStatusUsecase>();

  final RxList<TicketEntity> tickets = <TicketEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 0.obs;

  static MyTicketController get to => Get.find<MyTicketController>();

  static MyTicketController ensureInstance() {
    if (!Get.isRegistered<MyTicketController>()) {
      Get.put(MyTicketController());
    }
    return Get.find<MyTicketController>();
  }

  @override
  void onInit() {
    super.onInit();
    loadTickets();
  }

  Future<void> loadTickets({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
      tickets.clear();
    }

    if (!hasMore.value) return;

    isLoading.value = true;

    final userId = _getCurrentUserId();
    if (userId == null) {
      isLoading.value = false;
      return;
    }

    final result = await _getMyTicketsUsecase(
      GetMyTicketsParams(userId: userId, page: currentPage.value, size: 20),
    );

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        if (data.isEmpty) {
          hasMore.value = false;
        } else {
          if (refresh) {
            tickets.value = data;
          } else {
            tickets.addAll(data);
          }
          currentPage.value++;
        }
        isLoading.value = false;
      },
    );
  }

  Future<void> refreshTickets() async {
    await loadTickets(refresh: true);
  }

  Future<void> payTicket(int ticketId) async {
    isLoading.value = true;

      final result = await _updateTicketStatusUsecase(
      UpdateTicketStatusParams(ticketId: ticketId, status: TicketStatus.issued.apiValue),
    );

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (updatedTicket) {
        final index = tickets.indexWhere((t) => t.ticketId == ticketId);
        if (index != -1) {
          tickets[index] = updatedTicket;
        }
        AppSnackbarUtils.showSuccess('Thành công', 'Thanh toán vé thành công');
        isLoading.value = false;
      },
    );
  }

  List<TicketEntity> get unpaidTickets =>
      tickets.where((t) => t.status == TicketStatus.unpaid).toList();

  List<TicketEntity> get usableTickets =>
      tickets.where((t) => t.status == TicketStatus.issued).toList();

  List<TicketEntity> get usedTickets =>
      tickets.where((t) => t.status == TicketStatus.used).toList();

  int? _getCurrentUserId() {
    final user = AuthController.to.currentUser.value;
    return user?.userId;
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message),
      dataParsingFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message),
    );
  }
}