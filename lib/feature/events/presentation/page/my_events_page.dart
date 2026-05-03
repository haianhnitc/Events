import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/event_management/presentation/page/ctv_detail_page.dart';
import 'package:events_app/feature/event_management/presentation/page/event_detail_page.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/events/presentation/page/my_event_card_widgets.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/registration/presentation/controller/registration_controller.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RegistrationController _regController =
      RegistrationController.ensureInstance();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAll();
  }

  void _loadAll() {
    _regController.loadMyRegistrations(refresh: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xff06B6D4),
        elevation: 0,
        title: const Text(
          'Sự Kiện Của Tôi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadAll,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Sắp diễn ra'),
            Tab(text: 'Đã tham dự'),
          ],
        ),
      ),
      body: Obx(() {
        if (_regController.isLoading.value &&
            _regController.registrations.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff06B6D4)),
          );
        }
        return TabBarView(
          controller: _tabController,
          children: [
            _buildUpcomingList(),
            _buildAttendedList(),
          ],
        );
      }),
    );
  }

  List<ParticipantEntity> get _upcomingParticipants {
    return _regController.registrations.where((p) {
      if (p.status == ParticipantStatus.attended ||
          p.status == ParticipantStatus.noShow ||
          p.isCheckOut == true) return false;
      return true;
    }).toList()
      ..sort((a, b) {
        final aTime = a.registeredTime ?? DateTime(1900);
        final bTime = b.registeredTime ?? DateTime(1900);
        return aTime.compareTo(bTime);
      });
  }

  List<ParticipantEntity> get _attendedParticipants {
    return _regController.registrations.where((p) {
      return p.status == ParticipantStatus.attended ||
          p.status == ParticipantStatus.noShow ||
          p.isCheckOut == true;
    }).toList()
      ..sort((a, b) {
        final aTime = a.registeredTime ?? DateTime(1900);
        final bTime = b.registeredTime ?? DateTime(1900);
        return bTime.compareTo(aTime);
      });
  }

  void _navigateToDetail(ParticipantEntity participant) {
    if (participant.participantType == ParticipantType.ctv) {
      Get.to(
        () => CtvDetailPage(ctvRecruitmentId: participant.recruitmentId),
      );
    } else {
      Get.to(
        () => EventDetailPage(eventId: participant.eventId),
      );
    }
  }

  Widget _buildUpcomingList() {
    final list = _upcomingParticipants;
    if (list.isEmpty)
      return _buildEmptyState('Chưa có sự kiện nào sắp diễn ra');
    return RefreshIndicator(
      onRefresh: () async => _loadAll(),
      color: const Color(0xff06B6D4),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) => EventCard(
          participant: list[index],
          showQrButton: true,
          onTap: () => _navigateToDetail(list[index]),
        ),
      ),
    );
  }

  Widget _buildAttendedList() {
    final list = _attendedParticipants;
    if (list.isEmpty) return _buildEmptyState('Chưa có sự kiện nào đã tham dự');
    return RefreshIndicator(
      onRefresh: () async => _loadAll(),
      color: const Color(0xff06B6D4),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) => EventCard(
          participant: list[index],
          showQrButton: false,
          onTap: () => _navigateToDetail(list[index]),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.event_available,
              size: 40,
              color: Color(0xffB0B4C0),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xff67688C),
            ),
          ),
        ],
      ),
    );
  }
}