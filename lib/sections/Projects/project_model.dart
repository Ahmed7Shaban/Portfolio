import 'package:flutter/material.dart';

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final Map<String, String> links; // روابط ديناميكية
  final int order;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.links,
    required this.order,
  });

  factory ProjectModel.fromMap(String id, Map<String, dynamic> data) {
    return ProjectModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      links: Map<String, String>.from(data['links'] ?? {}),
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'links': links,
      'order': order,
    };
  }
}
