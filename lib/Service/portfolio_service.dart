import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> loadAllData() async {
    try {
      final services = await _firestore.collection("services").get();
      final heroes = await _firestore.collection("heroes").get();
      final projects = await _firestore.collection("projects").get();
      final certificate = await _firestore.collection("certificate").get();
      final about = await _firestore.collection("about").get();
      final buttons = await _firestore.collection("buttons").get();
      final contact = await _firestore.collection("contact").get();

      return {
        "services": services.docs,
        "heroes": heroes.docs,
        "projects": projects.docs,
        "certificate": certificate.docs,
        "about": about.docs,
        "buttons": buttons.docs,
        "contact": contact.docs,
      };
    } catch (e) {
      rethrow;
    }
  }
}
