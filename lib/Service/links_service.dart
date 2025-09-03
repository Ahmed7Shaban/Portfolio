import 'package:cloud_firestore/cloud_firestore.dart';

class LinksService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // للحصول على رابط مستند محدد
  Future<String> fetchLink(String docId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('buttons')
          .doc(docId)
          .get();

      if (doc.exists && doc.data() != null) {
        return doc['url'] ?? "";
      } else {
        return "";
      }
    } catch (e) {
      print("Error fetching link: $e");
      return "";
    }
  }

  // Stream لمستند محدد
  Stream<String> streamLink(String docId) {
    return _firestore
        .collection('buttons')
        .doc(docId)
        .snapshots()
        .map((doc) => doc.exists ? (doc['url'] ?? "") : "");
  }

  // للحصول على كل المستندات داخل الكولكشن كـ Map
  Future<Map<String, String>> fetchAllLinks() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('buttons').get();
      Map<String, String> links = {};
      for (var doc in snapshot.docs) {
        links[doc.id] = doc['url'] ?? "";
      }
      return links;
    } catch (e) {
      print("Error fetching all links: $e");
      return {};
    }
  }

  // Stream لكل المستندات
  Stream<Map<String, String>> streamAllLinks() {
    return _firestore.collection('buttons').snapshots().map((snapshot) {
      Map<String, String> links = {};
      for (var doc in snapshot.docs) {
        links[doc.id] = doc['url'] ?? "";
      }
      return links;
    });
  }
}
