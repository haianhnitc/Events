import 'package:flutter/material.dart';
import 'package:events_app/feature/common/utils/app_map_utils.dart';
import 'package:events_app/common/utils/app_location_service.dart';

class VenueMapPicker extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialAddress;
  final String? initialMapUrl;
  final ValueChanged<({double? latitude, double? longitude, String? mapUrl})>?
      onLocationChanged;

  const VenueMapPicker({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialAddress,
    this.initialMapUrl,
    this.onLocationChanged,
  });

  @override
  State<VenueMapPicker> createState() => _VenueMapPickerState();
}

class _VenueMapPickerState extends State<VenueMapPicker> {
  final _mapUrlController = TextEditingController();
  final _locationService = AppLocationService();

  double? _latitude;
  double? _longitude;
  String? _mapUrl;
  bool _isLoadingLocation = false;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _latitude = widget.initialLatitude;
    _longitude = widget.initialLongitude;
    _mapUrl = widget.initialMapUrl;
    if (_mapUrl != null) {
      _mapUrlController.text = _mapUrl!;
    }
  }

  @override
  void dispose() {
    _mapUrlController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onLocationChanged?.call((
      latitude: _latitude,
      longitude: _longitude,
      mapUrl: _mapUrl,
    ));
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    final result = await _locationService.getCurrentLocation();

    setState(() {
      _isLoadingLocation = false;
      if (result.error != null) {
        _locationError = result.error!.message;
      } else if (result.coords != null) {
        _latitude = result.coords!.latitude;
        _longitude = result.coords!.longitude;
        _mapUrl = AppMapUtils.buildGoogleMapsShareUrl(
          _latitude!,
          _longitude!,
          null,
        );
        _mapUrlController.text = _mapUrl!;
        _locationError = null;
        _notifyChange();
      }
    });
  }

  void _parseMapUrl() {
    final url = _mapUrlController.text.trim();
    if (url.isEmpty) return;

    final parsed = AppMapUtils.parseLatLngFromUrl(url);
    if (parsed != null) {
      setState(() {
        _latitude = parsed.latitude;
        _longitude = parsed.longitude;
        _mapUrl = url;
        _locationError = null;
      });
      _notifyChange();
    } else {
      setState(() {
        _mapUrl = url;
        _locationError = null;
      });
      _notifyChange();
    }
  }

  void _clearLocation() {
    setState(() {
      _latitude = null;
      _longitude = null;
      _mapUrl = null;
      _mapUrlController.clear();
      _locationError = null;
    });
    _notifyChange();
  }

  bool get _hasLocation => _latitude != null && _longitude != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMapUrlInput(),
        const SizedBox(height: 12),
        _buildLocationActions(),
        if (_locationError != null) ...[
          const SizedBox(height: 8),
          Text(
            _locationError!,
            style: const TextStyle(fontSize: 12, color: Color(0xFFE53935)),
          ),
        ],
        if (_hasLocation) ...[
          const SizedBox(height: 12),
          _buildLocationPreview(),
        ],
      ],
    );
  }

  Widget _buildMapUrlInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Link Google Maps',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xff475569),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _mapUrlController,
          decoration: InputDecoration(
            hintText: 'Dán link Google Maps vào đây',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, size: 20),
              onPressed: _parseMapUrl,
              tooltip: 'Parse tọa độ từ URL',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          onSubmitted: (_) => _parseMapUrl(),
        ),
        const SizedBox(height: 4),
        Text(
          'Dán URL Google Maps — tọa độ sẽ được tự động trích xuất',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildLocationActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isLoadingLocation ? null : _getCurrentLocation,
            icon: _isLoadingLocation
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location, size: 18),
            label: Text(_isLoadingLocation ? 'Đang lấy...' : 'Vị trí hiện tại'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (_hasLocation)
          IconButton(
            onPressed: _clearLocation,
            icon: const Icon(Icons.clear, size: 20),
            tooltip: 'Xóa vị trí',
            style: IconButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
            ),
          ),
      ],
    );
  }

  Widget _buildLocationPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF06B6D4).withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF06B6D4).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            size: 20,
            color: Color(0xFF06B6D4),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tọa độ đã chọn',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF06B6D4),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Lat: ${_latitude!.toStringAsFixed(6)}, Lng: ${_longitude!.toStringAsFixed(6)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
