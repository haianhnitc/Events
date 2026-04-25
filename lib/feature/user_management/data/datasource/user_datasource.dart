import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/user_management/data/model/rank_model.dart';
import 'package:events_app/feature/user_management/data/model/user_model.dart';
import 'package:events_app/feature/user_management/domain/usecase/update_current_user_usecase.dart';
import 'package:events_app/feature/portfolio/data/model/portfolio_detail_model.dart';
import 'package:events_app/feature/payment/data/model/transaction_model.dart';
import 'package:injectable/injectable.dart';

abstract class UserDatasource {
  Future<ApiResponse<UserModel?>> getCurrentUser();

  Future<ApiResponse<UserModel?>> getUserById(int userId);

  Future<ApiResponse<UserModel?>> updateCurrentUser(
      UpdateCurrentUserParams params);

  Future<ApiResponse<Map<String, dynamic>>> getUserParticipatedEvents({
    required int userId,
    String? participantType,
    int page = 0,
    int size = 20,
  });

  Future<ApiResponse<Map<String, dynamic>>> getRegistrations({
    required int eventId,
    required int userId,
  });

  Future<ApiResponse<Map<String, dynamic>>> getPackages({
    int page = 0,
    int size = 20,
    String? sort,
  });

  Future<ApiResponse<Map<String, dynamic>>> getUserPackages({
    int page = 0,
    int size = 20,
  });

  Future<ApiResponse<Map<String, dynamic>>> getExpiredPackages({
    int page = 0,
    int size = 20,
  });

  Future<ApiResponse<RankModel?>> getUserRank(int userId);

  Future<ApiResponse<Map<String, dynamic>>> getRanks({
    String? levelName,
    int page = 0,
    int size = 20,
  });

  Future<ApiResponse<Map<String, dynamic>>> getPortfolios({
    int? userId,
    bool? isPublished,
    int page = 0,
    int size = 20,
  });

  Future<ApiResponse<PortfolioDetailModel?>> getPortfolioDetail(int id);

  Future<ApiResponse<TransactionModel?>> createPortfolio(
      Map<String, dynamic> body);
}

@Injectable(as: UserDatasource)
class UserDatasourceImpl extends ApiProvider implements UserDatasource {
  UserDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<UserModel?>> getCurrentUser() async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.usersMe,
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<UserModel?>(
        response,
        (object) {
          if (object == null) return null;
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return UserModel.fromJson(object);
        },
        fallbackError: 'Lấy thông tin user thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<UserModel?>> getUserById(int userId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.userDetail(userId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<UserModel?>(
        response,
        (object) {
          if (object == null) return null;
          return UserModel.fromJson(object as Map<String, dynamic>);
        },
        fallbackError: 'Lấy thông tin người dùng thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<UserModel?>> updateCurrentUser(
      UpdateCurrentUserParams params) async {
    try {
      final response = await put<Map<String, dynamic>>(
        ApiPath.usersMe,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<UserModel?>(
        response,
        (object) {
          if (object == null) return null;
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return UserModel.fromJson(object);
        },
        fallbackError: 'Cập nhật thông tin thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getUserParticipatedEvents({
    required int userId,
    String? participantType,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (participantType != null)
        queryParams['participantType'] = participantType;

      final response = await get<Map<String, dynamic>>(
        ApiPath.userParticipatedEvents(userId),
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: true,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) => object as Map<String, dynamic>,
        fallbackError: 'Lấy lịch sử tham dự thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getPackages({
    int page = 0,
    int size = 20,
    String? sort,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (sort != null) queryParams['sort'] = sort;

      final response = await get<Map<String, dynamic>>(
        ApiPath.packages,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: false,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) => object as Map<String, dynamic>,
        fallbackError: 'Lấy danh sách gói dịch vụ thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getUserPackages({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.userPackages,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: {'page': page, 'size': size},
        requireAuth: true,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) => object as Map<String, dynamic>,
        fallbackError: 'Lấy gói đã mua thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getExpiredPackages({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.userPackagesCheckExpiry,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: {'page': page, 'size': size},
        requireAuth: true,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) => object as Map<String, dynamic>,
        fallbackError: 'Lấy gói hết hạn thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<RankModel?>> getUserRank(int userId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.rankByUser(userId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: false,
      );

      return forwardEnvelopeResponse<RankModel?>(
        response,
        (object) {
          if (object == null) return null;
          return RankModel.fromJson(object as Map<String, dynamic>);
        },
        fallbackError: 'Lấy xếp hạng thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getRanks({
    String? levelName,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (levelName != null) queryParams['levelName'] = levelName;

      final response = await get<Map<String, dynamic>>(
        ApiPath.ranks,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: false,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) => object as Map<String, dynamic>,
        fallbackError: 'Lấy danh sách xếp hạng thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getPortfolios({
    int? userId,
    bool? isPublished,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (userId != null) queryParams['userId'] = userId;
      if (isPublished != null) queryParams['isPublished'] = isPublished;

      final response = await get<Map<String, dynamic>>(
        ApiPath.portfolios,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: true,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) => object as Map<String, dynamic>,
        fallbackError: 'Lấy danh sách portfolio thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<PortfolioDetailModel?>> getPortfolioDetail(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.portfolioDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<PortfolioDetailModel?>(
        response,
        (object) {
          if (object == null) return null;
          return PortfolioDetailModel.fromJson(object as Map<String, dynamic>);
        },
        fallbackError: 'Lấy chi tiết portfolio thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<TransactionModel?>> createPortfolio(
      Map<String, dynamic> body) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.portfolios,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(body),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<TransactionModel?>(
        response,
        (object) {
          if (object == null) return null;
          return TransactionModel.fromJson(object as Map<String, dynamic>);
        },
        fallbackError: 'Tạo portfolio thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getRegistrations({
    required int eventId,
    required int userId,
  }) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.registrations,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: {'eventId': eventId, 'userId': userId},
        requireAuth: true,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) => object as Map<String, dynamic>,
        fallbackError: 'Lấy thông tin đăng ký thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
