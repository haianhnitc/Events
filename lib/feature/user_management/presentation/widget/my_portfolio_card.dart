import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_entity.dart';
import 'package:events_app/feature/user_management/presentation/page/portfolio_detail_page.dart';
import 'package:events_app/feature/user_management/presentation/page/portfolio_create_page.dart';
import 'package:events_app/feature/user_management/presentation/page/portfolio_list_page.dart';
import 'package:events_app/common/path/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MyPortfolioCard extends StatefulWidget {
  const MyPortfolioCard({super.key});

  @override
  State<MyPortfolioCard> createState() => _MyPortfolioCardState();
}

class _MyPortfolioCardState extends State<MyPortfolioCard> {
  final _userRepo = networkGetIt<UserRepository>();

  final RxList<PortfolioEntity> _portfolios = <PortfolioEntity>[].obs;
  final RxBool _isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading.value = true;
    final userId = AuthController.to.currentUser.value?.userId;

    final result = await _userRepo.getPortfolios(userId: userId);
    result.fold(
      (failure) => _isLoading.value = false,
      (list) {
        _portfolios.value = list;
        _isLoading.value = false;
      },
    );
  }

  void _openCreatePortfolio() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PortfolioCreatePage()),
    ).then((_) => _loadData());
  }

  void _openAllPortfolios() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PortfolioListPage()),
    ).then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthController.to.currentUser.value;
    final freePortfolios = user?.userProfile?.remainingFreePortfolios ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), offset: Offset(0, 4), blurRadius: 16),
        ],
      ),
      child: Obx(() {
        if (_isLoading.value) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF06B6D4)),
              ),
            ),
          );
        }

        final published = _portfolios.where((p) => p.isPublished == true).toList();
        final drafts = _portfolios.where((p) => p.isPublished != true).toList();
        final total = _portfolios.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(freePortfolios),
            if (total == 0)
              _buildEmptyState()
            else ...[
              if (published.isNotEmpty) ...[
                _buildSectionHeader(
                  'Đã xuất bản',
                  '${published.length}',
                  Colors.green,
                ),
                ...published.take(3).map((p) => _PortfolioRowItem(
                      portfolio: p,
                      onTap: () => _openDetail(p),
                    )),
              ],
              if (drafts.isNotEmpty) ...[
                _buildSectionHeader(
                  'Bản nháp',
                  '${drafts.length}',
                  Colors.orange,
                ),
                ...drafts.take(2).map((p) => _PortfolioRowItem(
                      portfolio: p,
                      onTap: () => _openDetail(p),
                    )),
              ],
            ],
            _buildActionButtons(total),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(int freePortfolios) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF06B6D4), Color(0xFF155DFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(AssetPath.folderIcon, height: 18, width: 18, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Hồ sơ hoạt động',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.workspace_premium, size: 12, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '$freePortfolios miễn phí',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String count, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xff64748B),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xff64748B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.folder_off_outlined, size: 24, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chưa có hồ sơ nào',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff273143)),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tạo hồ sơ để giới thiệu thành tích hoạt động của bạn',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(int total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.visibility_rounded,
              label: 'Xem tất cả',
              onTap: total > 0 ? _openAllPortfolios : null,
              isSecondary: true,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionButton(
              icon: Icons.add_rounded,
              label: 'Tạo mới',
              onTap: _openCreatePortfolio,
              isSecondary: false,
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(PortfolioEntity portfolio) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PortfolioDetailPage(portfolioId: portfolio.portfolioId!),
      ),
    );
  }
}

class _PortfolioRowItem extends StatelessWidget {
  final PortfolioEntity portfolio;
  final VoidCallback onTap;

  const _PortfolioRowItem({required this.portfolio, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                portfolio.isPublished == true ? Icons.verified_rounded : Icons.edit_note_rounded,
                size: 18,
                color: const Color(0xFF06B6D4),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    portfolio.title ?? 'Không có tiêu đề',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff273143),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${portfolio.viewCount ?? 0} lượt xem • ${portfolio.downloadCount ?? 0} lượt tải',
                    style: const TextStyle(fontSize: 11, color: Color(0xff94A3B8)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isSecondary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    if (isSecondary) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: isDisabled ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDisabled ? const Color(0xFFE2E8F0) : const Color(0xFF06B6D4).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isDisabled ? const Color(0xFF94A3B8) : const Color(0xFF06B6D4),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDisabled ? const Color(0xFF94A3B8) : const Color(0xFF06B6D4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF155DFC)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              'Tạo mới',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreatePortfolioSheet extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController codeController;
  final TextEditingController descController;
  final VoidCallback onSubmit;

  const _CreatePortfolioSheet({
    required this.formKey,
    required this.titleController,
    required this.codeController,
    required this.descController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setSheetState) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.add_box_rounded, color: Color(0xFF06B6D4), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Tạo hồ sơ hoạt động',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xff273143)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Hồ sơ giúp bạn giới thiệu thành tích và hoạt động của mình.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: titleController,
                    label: 'Tiêu đề',
                    hint: 'VD: Hồ sơ CTV Event 2026',
                    icon: Icons.title,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập tiêu đề' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: codeController,
                    label: 'Mã hồ sơ',
                    hint: 'VD: portfolio-001',
                    icon: Icons.code,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập mã' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: descController,
                    label: 'Mô tả',
                    hint: 'Mô tả ngắn về hồ sơ của bạn...',
                    icon: Icons.description_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sử dụng quyền miễn phí còn lại để tạo hồ sơ',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Tạo hồ sơ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: '$label *',
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xff64748B), size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
      ),
      validator: validator,
    );
  }
}

class _PortfolioDetailSheet extends StatelessWidget {
  final PortfolioEntity portfolio;

  const _PortfolioDetailSheet({required this.portfolio});

  @override
  Widget build(BuildContext context) {
    final isPublished = portfolio.isPublished == true;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.folder_special_rounded, color: Color(0xFF06B6D4), size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      portfolio.title ?? 'Không có tiêu đề',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xff273143)),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isPublished ? Colors.green.shade50 : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPublished ? 'Đã xuất bản' : 'Bản nháp',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isPublished ? Colors.green.shade700 : Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatChip(Icons.visibility_rounded, '${portfolio.viewCount ?? 0}', 'Lượt xem'),
              const SizedBox(width: 12),
              _buildStatChip(Icons.download_rounded, '${portfolio.downloadCount ?? 0}', 'Lượt tải'),
            ],
          ),
          if (portfolio.description != null && portfolio.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              portfolio.description!,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
            ),
          ],
          if (portfolio.price != null && portfolio.price! > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.attach_money_rounded, size: 16, color: Color(0xFF22C55E)),
                  const SizedBox(width: 4),
                  Text(
                    'Giá: ${_formatCurrency(portfolio.price!)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF22C55E)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xff64748B),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Đóng', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF06B6D4)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xff273143))),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}tr';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)}k';
    return '$amount đ';
  }
}

class _AllPortfoliosPage extends StatelessWidget {
  const _AllPortfoliosPage();

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
          'Tất cả hồ sơ',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xff273143)),
        ),
        centerTitle: true,
      ),
      body: Builder(
        builder: (ctx) {
          final repo = networkGetIt<UserRepository>();
          final userId = AuthController.to.currentUser.value?.userId;

          return FutureBuilder(
            future: repo.getPortfolios(userId: userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF06B6D4)));
              }

              final portfolios = (snapshot.data as dynamic)?.fold(
                (failure) => <PortfolioEntity>[],
                (list) => list.cast<PortfolioEntity>(),
              ) as List<PortfolioEntity>? ?? [];

              if (portfolios.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.folder_off_outlined, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text('Chưa có hồ sơ nào', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                    ],
                  ),
                );
              }

              final published = portfolios.where((p) => p.isPublished == true).toList();
              final drafts = portfolios.where((p) => p.isPublished != true).toList();

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (published.isNotEmpty) ...[
                    _sectionTitle('Đã xuất bản', published.length),
                    ...published.map((p) => _PortfolioCardItem(portfolio: p)),
                  ],
                  if (drafts.isNotEmpty) ...[
                    _sectionTitle('Bản nháp', drafts.length),
                    ...drafts.map((p) => _PortfolioCardItem(portfolio: p)),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff273143))),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
            child: Text('$count', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xff64748B))),
          ),
        ],
      ),
    );
  }
}

class _PortfolioCardItem extends StatelessWidget {
  final PortfolioEntity portfolio;

  const _PortfolioCardItem({required this.portfolio});

  @override
  Widget build(BuildContext context) {
    final isPublished = portfolio.isPublished == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), offset: const Offset(0, 2), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPublished ? Icons.verified_rounded : Icons.edit_note_rounded,
                  color: const Color(0xFF06B6D4),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      portfolio.title ?? 'Không có tiêu đề',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xff273143)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.visibility_outlined, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text('${portfolio.viewCount ?? 0}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        const SizedBox(width: 12),
                        Icon(Icons.download_outlined, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text('${portfolio.downloadCount ?? 0}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPublished ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isPublished ? 'Công khai' : 'Nháp',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPublished ? Colors.green.shade700 : Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
          if (portfolio.description != null && portfolio.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              portfolio.description!,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
