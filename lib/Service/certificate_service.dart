import 'package:cloud_firestore/cloud_firestore.dart';

class CertificateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> streamCertificates() {
    return _firestore.collection('certificate').snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'title': data['title'] ?? '',
            'issuer': data['issuer'] ?? '',
            'date': data['date'] ?? '',
            'imageUrl': data['imageUrl'] ?? '',
          };
        }).toList();
      },
    );
  }
}
