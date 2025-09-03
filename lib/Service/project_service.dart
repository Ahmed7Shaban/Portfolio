import 'package:cloud_firestore/cloud_firestore.dart';
import '../sections/Projects/project_model.dart';

class ProjectService {
  final CollectionReference projectsRef =
  FirebaseFirestore.instance.collection('projects');

  Future<List<ProjectModel>> getProjects() async {
    final snapshot = await projectsRef.orderBy('order').get();
    return snapshot.docs
        .map((doc) => ProjectModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addProject(ProjectModel project) async {
    await projectsRef.add(project.toMap());
  }

  Future<void> deleteProject(String id) async {
    await projectsRef.doc(id).delete();
  }

  Future<void> updateProjectOrder(String id, int order) async {
    await projectsRef.doc(id).update({'order': order});
  }
}
