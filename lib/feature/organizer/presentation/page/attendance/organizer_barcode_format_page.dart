import 'package:flutter/material.dart';

class OrganizerBarcodeFormatPage extends StatelessWidget {
  const OrganizerBarcodeFormatPage({super.key});

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
        title: const Text('Mã vạch & QR Code', style: TextStyle(color: Color(0xff273143), fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Loại mã', 'Chọn loại mã phù hợp với nhu cầu'),
            const SizedBox(height: 12),
            _buildFormatCard(
              title: 'QR Code',
              subtitle: 'Mã QR 2 chiều',
              description: 'Phổ biến nhất, scan nhanh, chứa nhiều thông tin',
              icon: Icons.qr_code_2,
              color: const Color(0xFF06B6D4),
              isRecommended: true,
              formats: ['QR Code', 'Data Matrix'],
            ),
            const SizedBox(height: 12),
            _buildFormatCard(
              title: 'Mã vạch 1D',
              subtitle: 'Barcode tuyến tính',
              description: 'Tương thích rộng, phù hợp in trên vé nhỏ',
              icon: Icons.barcode_reader,
              color: const Color(0xFFF59E0B),
              isRecommended: false,
              formats: ['Code 128', 'Code 39', 'EAN-13', 'UPC-A'],
            ),
            const SizedBox(height: 12),
            _buildFormatCard(
              title: 'Mã vạch 2D',
              subtitle: 'PDF417, Aztec',
              description: 'Dung lượng cao, phù hợp dữ liệu phức tạp',
              icon: Icons.grid_on,
              color: const Color(0xFF8B5CF6),
              isRecommended: false,
              formats: ['PDF417', 'Aztec', 'MaxiCode'],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Hướng dẫn chọn loại mã', ''),
            const SizedBox(height: 12),
            _buildGuideCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xff273143))),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        ],
      ],
    );
  }

  Widget _buildFormatCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required bool isRecommended,
    required List<String> formats,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRecommended ? color.withOpacity(0.5) : Colors.transparent,
          width: 2,
        ),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xff273143))),
                        if (isRecommended) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Đề xuất', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(description, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: formats.map((f) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.06),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(f, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard() {
    final guides = [
      _GuideItem(Icons.phone_iphone, 'Sự kiện nhỏ', 'Dưới 200 người', 'QR Code hoặc Barcode 1D'),
      _GuideItem(Icons.business, 'Sự kiện lớn', '200-1000 người', 'QR Code với màu sắc'),
      _GuideItem(Icons.celebration, 'Hội sách/Triển lãm', 'Nhiều ngày', 'Mã vạch 1D (dễ in)'),
      _GuideItem(Icons.theater_comedy, 'Sự kiện VIP', 'Kiểm soát cao', 'QR Code có logo'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)],
      ),
      child: Column(
        children: guides.map((g) => _buildGuideRow(g)).toList(),
      ),
    );
  }

  Widget _buildGuideRow(_GuideItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF06B6D4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 20, color: const Color(0xFF06B6D4)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff273143))),
                Text(item.subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(item.recommend, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }
}

class _GuideItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String recommend;

  _GuideItem(this.icon, this.title, this.subtitle, this.recommend);
}