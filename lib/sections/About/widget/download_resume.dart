import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Service/links_service.dart';
import '../../../core/color/colors.dart';

class DownloadResume extends StatelessWidget {
  const DownloadResume({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final LinksService linksService = LinksService();

    return FutureBuilder<String>(
      future: linksService.fetchLink("resume"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Skeleton داخل الزر أثناء التحميل
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Skeletonizer(
              child: Container(
                width: 200, // عرض تقريبي للزر
                height: 60, // ارتفاع الزر
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text("Failed to load resume link");
        } else {
          final resumeUrl = snapshot.data!;
          return OutlinedButton(
            onPressed: () => _launchURL(resumeUrl),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              side: BorderSide(color: primaryColor, width: 2),
            ),
            child: Text(
              "Download Resume",
              style: GoogleFonts.daiBannaSil(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
