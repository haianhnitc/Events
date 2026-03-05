import 'package:flutter/material.dart';
import 'package:events_app/feature/events/presentation/controller/event_page_controller.dart';

class EventFilterSheet extends StatefulWidget {
  final EventPageController controller;

  const EventFilterSheet({super.key, required this.controller});

  @override
  State<EventFilterSheet> createState() => _EventFilterSheetState();
}

class _EventFilterSheetState extends State<EventFilterSheet> {
  late final List<String> _categories;
  late final List<String> _formats;

  // selection state is kept in `_draft` map to keep UI logic minimal
  late final ScrollController _mainScrollController;
  late final ScrollController _catsScrollController;
  late final ScrollController _formatsScrollController;

  late Map<String, dynamic> _draft;

  @override
  void initState() {
    super.initState();
    // fixed university list (match design screenshot)
    _categories = [
      'ĐH Bách Khoa TP.HCM',
      'ĐH Thể dục Thể thao Hà Nội',
      'ĐH Ngoại thương',
      'ĐH Ngoại ngữ - ĐHQGHN',
      'ĐH Công nghệ - ĐHQGHN',
      'ĐH Y Hà Nội',
      'ĐH FPT Hà Nội',
      'ĐH Quốc gia TP.HCM',
    ];
    final c = widget.controller;
    _formats = [
      'Công nghệ',
      'Văn hóa - Nghệ thuật',
      'Kỹ năng mềm',
      'Khởi nghiệp',
      'Thể thao',
      'Định hướng nghề nghiệp',
      'Học thuật',
      'Tình nguyện',
    ];

    // UI uses a draft map; controller remains the source of truth
    _mainScrollController = ScrollController();
    _catsScrollController = ScrollController();
    _formatsScrollController = ScrollController();
    _draft = {
      'cats': Set<String>.from(c.cats),
      'formats': Set<String>.from(c.formats),
      'free': c.freeOnly.value,
      'student5': c.student5.value,
      'bonusPoints': c.bonusPoints.value,
      'priceRange': c.priceRange.value,
    };
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _catsScrollController.dispose();
    _formatsScrollController.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      _draft['cats'] = <String>{};
      _draft['formats'] = <String>{};
      _draft['free'] = false;
      _draft['student5'] = false;
      _draft['bonusPoints'] = false;
      _draft['priceRange'] = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // show the fixed list of universities (no search)
    final filteredCats = _categories;

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.84,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header: grab handle + title + actions
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 16, right: 12, bottom: 6),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Bộ lọc',
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                        ),
                        IconButton(
                          onPressed: _clearAll,
                          tooltip: 'Xóa bộ lọc',
                          icon:
                              const Icon(Icons.refresh, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Content
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Scrollbar(
                    controller: _mainScrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _mainScrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category
                          const SizedBox(height: 6),
                          _sectionTitle('Trường đại học', theme),
                          const SizedBox(height: 8),
                          const SizedBox(height: 12),
                          _buildCheckboxPanel(filteredCats,
                              (_draft['cats'] as Set<String>?) ?? <String>{},
                              controller: _catsScrollController),
                          const SizedBox(height: 18),

                          // Fields
                          _sectionTitle('Lĩnh vực', theme),
                          const SizedBox(height: 8),
                          _buildCheckboxPanel(_formats,
                              (_draft['formats'] as Set<String>?) ?? <String>{},
                              controller: _formatsScrollController),
                          const SizedBox(height: 18),

                          // Price
                          _sectionTitle('Giá', theme),
                          const SizedBox(height: 8),
                          _buildPriceChips(),
                          const SizedBox(height: 18),

                          // Criteria
                          _sectionTitle('Tiêu chí', theme),
                          const SizedBox(height: 8),
                          _buildCriteria(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Actions
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Hủy'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(_draft);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                            child:
                                Text('Áp dụng', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, ThemeData theme) {
    return Row(
      children: [
        Text(text,
            style: theme.textTheme.labelLarge
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
      ],
    );
  }

  Widget _buildCheckboxPanel(List<String> items, Set<String> selected,
      {ScrollController? controller}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 260),
        child: controller != null
            ? Scrollbar(
                controller: controller,
                thumbVisibility: true,
                child: ListView.separated(
                  controller: controller,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    final it = items[index];
                    final active = selected.contains(it);
                    return InkWell(
                      onTap: () => setState(() =>
                          active ? selected.remove(it) : selected.add(it)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: active
                                        ? Colors.blue.shade700
                                        : Colors.grey.shade400),
                                color: active
                                    ? Colors.blue.shade700
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: active
                                  ? const Icon(Icons.check,
                                      size: 16, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Text(it,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  final it = items[index];
                  final active = selected.contains(it);
                  return InkWell(
                    onTap: () => setState(
                        () => active ? selected.remove(it) : selected.add(it)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: active
                                      ? Colors.blue.shade700
                                      : Colors.grey.shade400),
                              color:
                                  active ? Colors.blue.shade700 : Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: active
                                ? const Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text(it,
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildPriceChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('Miễn phí'),
              selected: (_draft['free'] as bool?) ?? false,
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.white,
              onSelected: (v) => setState(() => _draft['free'] = v),
              labelStyle: TextStyle(
                  color: ((_draft['free'] as bool?) ?? false)
                      ? Colors.white
                      : Colors.black87),
            ),
            ChoiceChip(
              label: const Text('0 - 150.000d'),
              selected: ((_draft['priceRange'] as String?) ?? '') == '0-150',
              onSelected: (v) =>
                  setState(() => _draft['priceRange'] = v ? '0-150' : ''),
            ),
            ChoiceChip(
              label: const Text('150.000d - 300.000d'),
              selected: ((_draft['priceRange'] as String?) ?? '') == '150-300',
              onSelected: (v) =>
                  setState(() => _draft['priceRange'] = v ? '150-300' : ''),
            ),
            ChoiceChip(
              label: const Text('300.000d+'),
              selected: ((_draft['priceRange'] as String?) ?? '') == '300+',
              onSelected: (v) =>
                  setState(() => _draft['priceRange'] = v ? '300+' : ''),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCriteria() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          SwitchListTile.adaptive(
            value: (_draft['student5'] as bool?) ?? false,
            title: const Text('Chứng chỉ 5 tốt'),
            subtitle: const Text('Nhận chứng chỉ 5 tốt khi tham gia'),
            onChanged: (v) => setState(() => _draft['student5'] = v),
          ),
          // bonus points checkbox wired to draft
          CheckboxListTile(
            dense: true,
            value: (_draft['bonusPoints'] as bool?) ?? false,
            onChanged: (v) =>
                setState(() => _draft['bonusPoints'] = v ?? false),
            title: const Text('Cộng điểm rèn luyện/ điểm đoàn'),
            subtitle: const Text('Tự động cộng điểm nếu được chấp nhận'),
          ),
        ],
      ),
    );
  }
}
