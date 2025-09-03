import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/core/color/colors.dart';
import '../../../Service/links_service.dart';

class FooterTop extends StatefulWidget {
  const FooterTop({super.key});

  @override
  State<FooterTop> createState() => _FooterTopState();
}

class _FooterTopState extends State<FooterTop> {
  bool _isHovered = false;
  final LinksService linksService = LinksService();

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let’s",
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Work Together",
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );

        final button = StreamBuilder<String>(
          stream: linksService.streamLink("phone"), // رقم الهاتف من Firestore
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }

            final phoneNumber = snapshot.data!;
            final telUrl = "tel:$phoneNumber";

            return MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: _isHovered ? 1.05 : 1.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: isMobile ? double.infinity : 280,
                    child: OutlinedButton.icon(
                      onPressed: () => _launchUrl(telUrl),
                      icon: Icon(
                        Icons.phone,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text(
                        phoneNumber,
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 24),
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );

        return isMobile
            ? Column(
          children: [
            Row(
              children: [
                title,
              ],
            ),
            const SizedBox(height: 20),
            button,
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title,
            button,
          ],
        );
      },
    );
  }
}
