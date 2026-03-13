// import 'package:flutter/material.dart';
// import 'package:events_app/feature/news/data/models/news_model.dart';

// /// Clean single implementation of NewsCard.
// class NewsCard extends StatelessWidget {
//   final NewsModel news;
//   final VoidCallback? onTap;
//   final VoidCallback? onBookmark;
//   final bool isSaved;
//   final bool hideBookmark;

//   const NewsCard({
//     super.key,
//     required this.news,
//     this.onTap,
//     this.onBookmark,
//     this.isSaved = false,
//     this.hideBookmark = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image + chips overlay (placeholder gray image)
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius:
//                       const BorderRadius.vertical(top: Radius.circular(12)),
//                   child: SizedBox(
//                     height: 160,
//                     width: double.infinity,
//                     child: Container(
//                       color: Colors.grey.shade200,
//                       child: Center(
//                         child: Icon(
//                           Icons.image,
//                           color: Colors.grey.shade400,
//                           size: 40,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: 12,
//                   top: 12,
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade600,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(news.category,
//                         style:
//                             const TextStyle(color: Colors.white, fontSize: 12)),
//                   ),
//                 ),
//                 if (!hideBookmark)
//                   Positioned(
//                     right: 8,
//                     top: 8,
//                     child: Material(
//                       color: Colors.white.withOpacity(0.6),
//                       shape: const CircleBorder(),
//                       child: IconButton(
//                         icon: Icon(
//                             isSaved ? Icons.bookmark : Icons.bookmark_border,
//                             color: isSaved
//                                 ? Colors.blue.shade700
//                                 : Colors.black54),
//                         onPressed: onBookmark,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(news.title,
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.w600),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis),
//                   const SizedBox(height: 8),
//                   Text(news.excerpt,
//                       style:
//                           TextStyle(color: Colors.grey.shade700, fontSize: 13),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.access_time,
//                               size: 14, color: Colors.grey.shade600),
//                           const SizedBox(width: 6),
//                           Text(news.timeAgo,
//                               style: TextStyle(
//                                   color: Colors.grey.shade600, fontSize: 12)),
//                           const SizedBox(width: 12),
//                           Icon(Icons.remove_red_eye,
//                               size: 14, color: Colors.grey.shade600),
//                           const SizedBox(width: 6),
//                           Text('${news.views} xem',
//                               style: TextStyle(
//                                   color: Colors.grey.shade600, fontSize: 12)),
//                         ],
//                       ),
//                       const Icon(Icons.share, size: 18, color: Colors.grey),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
