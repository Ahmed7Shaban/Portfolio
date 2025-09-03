import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/core/widgets/loading_widget.dart';
import 'package:website/core/widgets/sub_title.dart';
import '../../core/widgets/error_loading.dart';
import 'widget/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            "Projects",
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SubTitle(subTitle: "My Work"),
          const SizedBox(height: 40),

          // ✅ جلب المشاريع من Firestore
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('projects')
                .orderBy('order')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(lottie: 'assets/animations/projects.json');
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const ErrorLoading();
              }

              final projects = snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              return LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 900
                      ? 3
                      : constraints.maxWidth > 700
                      ? 2
                      : 1;
                  double aspectRatio = crossAxisCount == 1
                      ? 1.3
                      : crossAxisCount == 2
                      ? 1.1
                      : 0.9;

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: aspectRatio,
                        ),
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return ProjectCard(
                            project: project,
                            delay: 200 * index,
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
