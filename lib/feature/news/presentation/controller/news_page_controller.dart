// import 'package:get/get.dart';
// import 'package:events_app/feature/news/data/models/news_model.dart';
// import 'package:events_app/data_mock/news_mock.dart';

// class NewsPageController extends GetxController {
//   // explicit Rx types
//   final RxList<NewsModel> all = RxList<NewsModel>();
//   final RxString query = RxString('');
//   final RxInt selectedTab = RxInt(0); // 0: all, 1: featured, 2: saved
//   final RxSet<int> saved = RxSet<int>();

//   @override
//   void onInit() {
//     super.onInit();
//     loadMock();
//   }

//   void loadMock() {
//     all.assignAll(newsMock);
//   }

//   void setQuery(String q) => query.value = q;

//   void setTab(int i) => selectedTab.value = i;

//   void toggleSaved(int id) {
//     if (saved.contains(id)) {
//       saved.remove(id);
//     } else {
//       saved.add(id);
//     }
//     // ensure observers are notified
//     saved.refresh();
//   }

//   bool isSaved(int id) => saved.contains(id);

//   List<NewsModel> get filtered {
//     final q = query.value.trim().toLowerCase();
//     Iterable<NewsModel> it = all;

//     // apply tab filter efficiently (no early copying)
//     if (selectedTab.value == 1) {
//       // Defensive access: avoid crashing if a hot-reload left invalid objects in memory.
//       it = it.where((n) {
//         try {
//           return n.featured == true;
//         } catch (_) {
//           return false;
//         }
//       });
//     } else if (selectedTab.value == 2) {
//       it = it.where((n) => saved.contains(n.id));
//     }

//     if (q.isNotEmpty) {
//       it = it.where((n) =>
//           n.title.toLowerCase().contains(q) ||
//           n.excerpt.toLowerCase().contains(q) ||
//           n.category.toLowerCase().contains(q));
//     }

//     return it.toList();
//   }
// }
