import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:website/core/widgets/sub_title.dart';
import '../../core/icon_mapper.dart';
import '../../core/widgets/error_loading.dart';
import '../../core/widgets/loading_widget.dart';
import 'widget/service_card.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "What I do",
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const SubTitle(subTitle: "My Services"),
          const SizedBox(height: 30),

          // 🟢 Firebase Services
          StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseFirestore.instance.collection("services").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const ErrorLoading();
              }
              if (!snapshot.hasData) {
                return LoadingWidget(lottie: 'assets/animations/Coding.json',);
              }

              final services = snapshot.data!.docs;

              return LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 1000
                      ? 3
                      : constraints.maxWidth > 700
                      ? 2
                      : 1;

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
                          childAspectRatio: crossAxisCount == 1
                              ? 1.6
                              : crossAxisCount == 2
                              ? 1.3
                              : 1.1,
                        ),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final data =
                          services[index].data() as Map<String, dynamic>;

                          final title = data["title"] ?? "";
                          final desc = data["description"] ?? "";
                          final iconName = data["icon"] ?? "star";

                          return ServiceCard(
                            icon:IconMapper.getFontAwesomeIcon(iconName),
                            title: title,
                            desc: desc,
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

