// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:events_app/feature/news/presentation/controller/news_page_controller.dart';
// import 'package:events_app/feature/news/presentation/widget/news_card.dart';
// import 'package:events_app/feature/news/presentation/page/news_detail_page.dart';

// class NewsPage extends StatefulWidget {
//   const NewsPage({super.key});

//   @override
//   State<NewsPage> createState() => _NewsPageState();
// }

// class _NewsPageState extends State<NewsPage> {
//   late final NewsPageController c;
//   late final TextEditingController _searchCtrl;

//   @override
//   void initState() {
//     super.initState();
//     c = Get.put(NewsPageController());
//     _searchCtrl = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header with gradient and search
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF5BC0FF), Color(0xFF4A90E2)],
//                 ),
//                 borderRadius:
//                     const BorderRadius.vertical(bottom: Radius.circular(16)),
//               ),
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 4),
//                   const Text('Tin tức',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 12),
//                   // Search field
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _searchCtrl,
//                           onChanged: (v) => c.setQuery(v),
//                           style: const TextStyle(color: Colors.black87),
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Tìm kiếm tin tức...',
//                             prefixIcon: const Icon(Icons.search),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 0, horizontal: 12),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none),
//                             suffixIcon: Obx(() {
//                               final q = c.query.value;
//                               if (q.isEmpty) return const SizedBox.shrink();
//                               return IconButton(
//                                 icon: const Icon(Icons.clear),
//                                 onPressed: () {
//                                   _searchCtrl.clear();
//                                   c.setQuery('');
//                                 },
//                               );
//                             }),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       // optional filter icon can be added here
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Tabs / chips
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
//               child: Obx(() {
//                 final idx = c.selectedTab.value;
//                 return Row(
//                   children: [
//                     _tabChip('Tất cả', idx == 0, () => c.setTab(0)),
//                     const SizedBox(width: 8),
//                     _tabChip('Nổi bật', idx == 1, () => c.setTab(1)),
//                     const SizedBox(width: 8),
//                     _tabChip('Đã lưu', idx == 2, () => c.setTab(2)),
//                   ],
//                 );
//               }),
//             ),
//             // List
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Obx(() {
//                   final list = c.filtered;
//                   if (list.isEmpty)
//                     return const Center(child: Text('Không có tin tức'));
//                   return ListView.separated(
//                     padding: const EdgeInsets.only(bottom: 24, top: 4),
//                     itemBuilder: (context, index) {
//                       final item = list[index];
//                       // show bookmark on all tabs; in Saved tab it appears as "saved (blue)" and tapping will unsave
//                       return NewsCard(
//                         news: item,
//                         onTap: () => Navigator.of(context).push(
//                             MaterialPageRoute(
//                                 builder: (_) => NewsDetailPage(news: item))),
//                         onBookmark: () => c.toggleSaved(item.id),
//                         isSaved: c.isSaved(item.id),
//                         hideBookmark: false,
//                       );
//                     },
//                     separatorBuilder: (_, __) => const SizedBox(height: 12),
//                     itemCount: list.length,
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _tabChip(String label, bool active, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: active ? Colors.white : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//               color: active ? Colors.transparent : Colors.grey.shade300),
//           boxShadow: active
//               ? [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.06),
//                       blurRadius: 6,
//                       offset: const Offset(0, 3))
//                 ]
//               : null,
//         ),
//         child: Text(label,
//             style:
//                 TextStyle(color: active ? Colors.black : Colors.grey.shade700)),
//       ),
//     );
//   }
// }
