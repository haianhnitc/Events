import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/user_management/data/model/user_summary_model.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_summary_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class _SelectableEventItem {
  final EventSummaryEntity event;
  final int? eventParticipantId;
  ParticipantType? participantType;
  bool isSelected;
  String? displayTitle;
  String? displayRole;
  String? displayNote;

  _SelectableEventItem({
    required this.event,
    this.eventParticipantId,
    this.participantType,
    this.isSelected = false,
    this.displayTitle,
    this.displayRole,
    this.displayNote,
  });
}

class PortfolioCreatePage extends StatefulWidget {
  const PortfolioCreatePage({super.key});

  @override
  State<PortfolioCreatePage> createState() => _PortfolioCreatePageState();
}

class _PortfolioCreatePageState extends State<PortfolioCreatePage> {
  final UserRepository _userRepo = networkGetIt<UserRepository>();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  final RxBool _isLoading = true.obs;
  final RxBool _isSubmitting = false.obs;
  final RxList<_SelectableEventItem> _events = <_SelectableEventItem>[].obs;
  final RxInt _selectedCount = 0.obs;
  final RxString _error = ''.obs;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    _isLoading.value = true;
    final userId = AuthController.to.currentUser.value?.userId;
    if (userId == null) {
      _isLoading.value = false;
      return;
    }

    final result = await _userRepo.getUserParticipatedEvents(userId: userId);
    result.fold(
      (failure) {
        _error.value = 'Không thể tải danh sách sự kiện';
        _isLoading.value = false;
      },
      (events) async {
        final List<_SelectableEventItem> items = [];
        for (final event in events) {
          final epResult = await _userRepo.getRegistrations(
            eventId: event.eventId!,
            userId: userId,
          );
          int? eventParticipantId;
          ParticipantType? participantType;

          epResult.fold(
            (_) {},
            (registrations) {
              if (registrations.isNotEmpty) {
                eventParticipantId = registrations.first.eventParticipantId;
                participantType = registrations.first.participantType;
              }
            },
          );

          items.add(_SelectableEventItem(
            event: event,
            eventParticipantId: eventParticipantId,
            participantType: participantType,
          ));
        }
        _events.value = items;
        _isLoading.value = false;
      },
    );
  }

  void _toggleSelection(int index) {
    final item = _events[index];
    setState(() {
      item.isSelected = !item.isSelected;
      _selectedCount.value = _events.where((e) => e.isSelected).length;
    });
  }

  void _showEditItemSheet(_SelectableEventItem item, int index) {
    final titleCtrl = TextEditingController(text: item.event.title);
    final roleCtrl = TextEditingController(text: item.displayRole ?? '');
    final noteCtrl = TextEditingController(text: item.displayNote ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Tuỳ chỉnh hiển thị', style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700,
                  color: Color(0xff273143),
                )),
                const SizedBox(height: 4),
                Text(item.event.title ?? '', style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade600,
                )),
                const SizedBox(height: 16),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề hiển thị',
                    hintText: 'VD: CTV tại Tech Summit',
                    filled: true, fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: roleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Vai trò',
                    hintText: 'VD: Team Lead',
                    filled: true, fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Ghi chú',
                    hintText: 'VD: Phụ trách điều phối 200+ người',
                    filled: true, fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        item.displayTitle = titleCtrl.text.trim().isNotEmpty
                            ? titleCtrl.text.trim() : null;
                        item.displayRole = roleCtrl.text.trim().isNotEmpty
                            ? roleCtrl.text.trim() : null;
                        item.displayNote = noteCtrl.text.trim().isNotEmpty
                            ? noteCtrl.text.trim() : null;
                      });
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06B6D4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Lưu', style: TextStyle(
                      fontWeight: FontWeight.w700,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final selected = _events.where((e) => e.isSelected && e.eventParticipantId != null).toList();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất 1 sự kiện')),
      );
      return;
    }

    _isSubmitting.value = true;

    final body = {
      'title': _titleController.text.trim(),
      if (_descController.text.trim().isNotEmpty)
        'description': _descController.text.trim(),
      'price': 0,
      'coinUsed': 0,
      'items': selected.asMap().entries.map((entry) {
        final idx = entry.key;
        final item = entry.value;
        return {
          'eventParticipantId': item.eventParticipantId,
          if (item.displayTitle != null) 'displayTitle': item.displayTitle,
          if (item.displayRole != null) 'displayRole': item.displayRole,
          if (item.displayNote != null) 'displayNote': item.displayNote,
          'displayOrder': idx + 1,
        };
      }).toList(),
    };

    final result = await _userRepo.createPortfolio(body);
    result.fold(
      (failure) {
        _isSubmitting.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tạo thất bại: ${failure.toString()}')),
        );
      },
      (tx) {
        _isSubmitting.value = false;
        if (tx != null && tx.status == TransactionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tạo hồ sơ hoạt động thành công!'),
              backgroundColor: Color(0xFF22C55E),
            ),
          );
          Navigator.pop(context, true);
        } else if (tx != null && tx.status == TransactionStatus.pending) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo hồ sơ thành công!')),
          );
          Navigator.pop(context, true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff64748B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tạo hồ sơ hoạt động',
          style: TextStyle(
            color: Color(0xff273143),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
          );
        }

        if (_error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(_error.value, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _loadEvents,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        if (_events.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_busy, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('Chưa tham gia sự kiện nào', style: TextStyle(
                  fontSize: 15, color: Colors.grey.shade600,
                )),
                const SizedBox(height: 4),
                Text('Hãy tham gia sự kiện trước', style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade500,
                )),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormCard(),
                    const SizedBox(height: 16),
                    _buildEventListCard(),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        );
      }),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thông tin hồ sơ', style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700,
              color: Color(0xff273143),
            )),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề hồ sơ *',
                hintText: 'VD: Hồ sơ CTV Event 2026',
                filled: true, fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEF4444)),
                ),
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Vui lòng nhập tiêu đề'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                hintText: 'Mô tả ngắn về hồ sơ của bạn...',
                filled: true, fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventListCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Chọn sự kiện', style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700,
                color: Color(0xff273143),
              )),
              const SizedBox(width: 8),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_selectedCount.value} đã chọn',
                  style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: Color(0xFF06B6D4),
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Column(
            children: _events.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return _buildEventTile(item, idx);
            }).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildEventTile(_SelectableEventItem item, int index) {
    final isSelected = item.isSelected;
    return GestureDetector(
      onTap: () => _toggleSelection(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF06B6D4).withValues(alpha: 0.06)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF06B6D4)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF06B6D4)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF06B6D4)
                          : Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.event.title ?? 'Không có tiêu đề',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF06B6D4)
                              : const Color(0xff273143),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (item.participantType != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: item.participantType == ParticipantType.ctv
                                    ? Colors.purple.shade50
                                    : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.participantType!.name,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: item.participantType == ParticipantType.ctv
                                      ? Colors.purple.shade700
                                      : Colors.blue.shade700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          if (item.event.youthUnionPoint != null) ...[
                            Icon(Icons.star, size: 12, color: Colors.amber.shade700),
                            const SizedBox(width: 2),
                            Text(
                              '${item.event.youthUnionPoint} điểm',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  GestureDetector(
                    onTap: () => _showEditItemSheet(item, index),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: Color(0xFF06B6D4),
                      ),
                    ),
                  ),
              ],
            ),
            if (isSelected && item.displayRole != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.displayRole!,
                  style: const TextStyle(
                    fontSize: 11, color: Color(0xff64748B),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16, right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Obx(() => SizedBox(
        width: double.infinity, height: 50,
        child: ElevatedButton(
          onPressed: _isSubmitting.value ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF06B6D4),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: const Color(0xFF94A3B8),
          ),
          child: _isSubmitting.value
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Tạo hồ sơ hoạt động',
                  style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      )),
    );
  }
}
