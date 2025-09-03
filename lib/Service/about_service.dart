import 'package:cloud_firestore/cloud_firestore.dart';

class AboutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> fetchAboutText() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('about')
          .doc('about_1')
          .get();

      if (doc.exists && doc.data() != null) {
        return doc['text'] ?? "";
      } else {
        return "";
      }
    } catch (e) {
      print("Error fetching about text: $e");
      return "";
    }
  }

  /// Stream مباشر للتحديثات الحية
  Stream<String> streamAboutText() {
    return _firestore
        .collection('about')
        .doc('about_1')
        .snapshots()
        .map((doc) => doc.exists ? (doc['text'] ?? "") : "");
  }
}
