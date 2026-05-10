import 'package:flutter/material.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/organizer_venue_usecase.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/venue_params.dart';
import 'package:events_app/feature/organizer/presentation/widget/event/venue_map_picker.dart';
import 'package:events_app/feature/venue/domain/entity/venue_entity.dart';

class VenuePickerResult {
  final VenueEntity? venue;
  final bool createdNew;

  const VenuePickerResult({this.venue, this.createdNew = false});
}

class VenuePickerDialog extends StatefulWidget {
  final VenueEntity? selectedVenue;

  const VenuePickerDialog({
    super.key,
    this.selectedVenue,
  });

  static Future<VenuePickerResult?> show(
    BuildContext context, {
    VenueEntity? selectedVenue,
  }) {
    return showModalBottomSheet<VenuePickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VenuePickerDialog(selectedVenue: selectedVenue),
    );
  }

  @override
  State<VenuePickerDialog> createState() => _VenuePickerDialogState();
}

class _VenuePickerDialogState extends State<VenuePickerDialog> {
  final _searchController = TextEditingController();
  final List<VenueEntity> _venues = [];
  bool _isLoading = true;
  bool _isCreating = false;
  bool _showCreateForm = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _capacityController = TextEditingController();

  double? _latitude;
  double? _longitude;
  String? _mapUrl;

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  List<VenueEntity> get _filteredVenues {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _venues;
    return _venues.where((v) {
      return (v.name?.toLowerCase().contains(query) ?? false) ||
          (v.address?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  Future<void> _loadVenues() async {
    setState(() => _isLoading = true);
    try {
      final usecase = networkGetIt<GetOrganizerVenuesUsecase>();
      final result =
          await usecase.call(const VenueListParams(page: 0, size: 100));
      result.fold(
        (failure) {
          _showFailureSnackbar(failure);
        },
        (data) {
          _venues.clear();
          _venues.addAll(data.items);
        },
      );
    } catch (e) {
      _showErrorSnackbar('Không thể tải danh sách địa điểm');
    }
    setState(() => _isLoading = false);
  }

  void _showFailureSnackbar(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => _showErrorSnackbar(message),
      dataParsingFailure: () =>
          _showErrorSnackbar('Không đọc được dữ liệu địa điểm'),
      noConnectionFailure: () => _showErrorSnackbar('Không có kết nối mạng'),
      systemFailure: (_, message) => _showErrorSnackbar(message),
    );
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _createVenue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);

    try {
      final usecase = networkGetIt<CreateOrganizerVenueUsecase>();
      final params = VenueCreateParams(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        capacity: int.tryParse(_capacityController.text),
        latitude: _latitude,
        longitude: _longitude,
        mapUrl: _mapUrl,
      );

      final result = await usecase(params);

      result.fold(
        (failure) {
          _handleFailure(failure);
          setState(() => _isCreating = false);
        },
        (venue) {
          AppSnackbarUtils.showSuccess('Thành công', 'Tạo địa điểm thành công');
          Navigator.pop(
            context,
            VenuePickerResult(venue: venue, createdNew: true),
          );
        },
      );
    } catch (e) {
      AppSnackbarUtils.showError('Lỗi', 'Đã xảy ra lỗi: $e');
      setState(() => _isCreating = false);
    }
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(),
          Flexible(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _showCreateForm
                  ? _buildCreateForm(bottomPadding)
                  : _buildVenueList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _showCreateForm ? 'Tạo địa điểm mới' : 'Chọn địa điểm',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xff273143),
              ),
            ),
          ),
          if (_showCreateForm)
            IconButton(
              onPressed: () => setState(() => _showCreateForm = false),
              icon: const Icon(Icons.arrow_back, size: 22),
              tooltip: 'Quay lại danh sách',
            )
          else
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, size: 22),
            ),
        ],
      ),
    );
  }

  Widget _buildVenueList() {
    return Column(
      children: [
        _buildSearchField(),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredVenues.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: _filteredVenues.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final venue = _filteredVenues[index];
                        final isSelected =
                            widget.selectedVenue?.venueId == venue.venueId;
                        return _buildVenueCard(venue, isSelected);
                      },
                    ),
        ),
        _buildCreateNewButton(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm địa điểm...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          filled: true,
          fillColor: const Color(0xFFF4F6F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_off, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'Chưa có địa điểm nào',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nhấn nút bên dưới để tạo địa điểm mới',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueCard(VenueEntity venue, bool isSelected) {
    return GestureDetector(
      onTap: () => Navigator.pop(
        context,
        VenuePickerResult(venue: venue, createdNew: false),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF06B6D4).withOpacity(0.08)
              : const Color(0xFFF4F6F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF06B6D4) : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF06B6D4) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.location_on,
                size: 20,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name ?? 'Không có tên',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF06B6D4)
                          : const Color(0xff273143),
                    ),
                  ),
                  if (venue.address != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      venue.address!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (venue.latitude != null && venue.longitude != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Lat: ${venue.latitude!.toStringAsFixed(4)}, Lng: ${venue.longitude!.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                size: 20,
                color: Color(0xFF06B6D4),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateNewButton() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 16,
        top: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _showCreateForm = true),
            icon: const Icon(Icons.add_location_alt_outlined, size: 20),
            label: const Text('Tạo địa điểm mới'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateForm(double bottomPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 4, 16, bottomPadding + 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Thông tin địa điểm'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _nameController,
              label: 'Tên địa điểm',
              hint: 'VD: Hội trường A, Trường ĐH...',
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Vui lòng nhập tên địa điểm';
                }
                if (v.length > 200) {
                  return 'Tên không được quá 200 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _addressController,
              label: 'Địa chỉ',
              hint: 'VD: 123 Nguyễn Huệ, Quận 1, TP.HCM',
              maxLines: 2,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Vui lòng nhập địa chỉ';
                }
                if (v.length < 10) {
                  return 'Địa chỉ phải có ít nhất 10 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _capacityController,
              label: 'Sức chứa',
              hint: 'VD: 500',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v != null && v.isNotEmpty) {
                  final n = int.tryParse(v);
                  if (n == null || n < 0) {
                    return 'Sức chứa phải là số dương';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Vị trí trên bản đồ'),
            const SizedBox(height: 10),
            VenueMapPicker(
              initialLatitude: _latitude,
              initialLongitude: _longitude,
              initialMapUrl: _mapUrl,
              onLocationChanged: (result) {
                setState(() {
                  _latitude = result.latitude;
                  _longitude = result.longitude;
                  _mapUrl = result.mapUrl;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildMapHint(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xff273143),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xff475569),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE53935)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapHint() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFEDD5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline,
            size: 18,
            color: Color(0xFFEA580C),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Nhấn "Vị trí hiện tại" để lấy tọa độ GPS, hoặc dán link Google Maps để tự động trích xuất lat/lng.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isCreating ? null : _createVenue,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF06B6D4),
          disabledBackgroundColor: const Color(0xFF06B6D4).withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isCreating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Text(
                'Tạo địa điểm',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
