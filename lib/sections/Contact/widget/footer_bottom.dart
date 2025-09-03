import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Service/links_service.dart';
import 'social_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterBottom extends StatelessWidget {
  const FooterBottom({super.key});

  IconData _getIconFromName(String name) {
    switch (name.toLowerCase()) {
      case "facebook":
        return FontAwesomeIcons.facebook;
        case "phone":
        return FontAwesomeIcons.phone;
      case "instagram":
        return FontAwesomeIcons.instagram;
      case "linkedin":
        return FontAwesomeIcons.linkedin;
      case "github":
        return FontAwesomeIcons.github;
      case "whatsapp":
        return FontAwesomeIcons.whatsapp;
      case "email":
        return FontAwesomeIcons.envelope;
      case "playstore":
        return FontAwesomeIcons.googlePlay;
      default:
        return FontAwesomeIcons.filePdf;
    }
  }

  @override
  Widget build(BuildContext context) {
    final LinksService linksService = LinksService();

    return StreamBuilder<Map<String, String>>(
      stream: linksService.streamAllLinks(), // كل الروابط من Firestore
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final linksMap = snapshot.data!; // key = icon name, value = url

        final icons = linksMap.entries.map((entry) {
          final iconName = entry.key;
          final url = entry.value;
          return SocialIcon(
            icon: _getIconFromName(iconName),
            url: url,
          );
        }).toList();

        final text = Text(
          "© 2025 All rights reserved.",
          style: GoogleFonts.openSans(fontSize: 14),
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;
            return isMobile
                ? Column(children: [text, const SizedBox(height: 16), Wrap(spacing: 16, children: icons)])
                : Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [text, Wrap(spacing: 16, children: icons)],
                              ),
                );
          },
        );
      },
    );
  }
}
