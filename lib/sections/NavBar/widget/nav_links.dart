import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Service/links_service.dart';
import 'nav_item .dart';

class NavLinks extends StatefulWidget {
  final Function(String section)? onItemSelected;
  final String activeSection;

  const NavLinks({
    super.key,
    this.onItemSelected,
    required this.activeSection,
  });

  @override
  State<NavLinks> createState() => _NavLinksState();
}

class _NavLinksState extends State<NavLinks>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  final List<String> items = [
    "Home",
    "About",
    "certificates",
    "Services",
    "Projects",
    "Resume",
    "Contact Me",
  ];

  final LinksService linksService = LinksService(); // الخدمة

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _slideAnimations = items.asMap().entries.map((entry) {
      int index = entry.key;
      return Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.1, 1, curve: Curves.easeOut),
        ),
      );
    }).toList();

    _fadeAnimations = items.asMap().entries.map((entry) {
      int index = entry.key;
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(index * 0.1, 1, curve: Curves.easeIn),
      );
    }).toList();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle _getStyle(BuildContext context, bool isActive) {
    final defaultStyle = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );

    return isActive
        ? defaultStyle.copyWith(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
      decorationThickness: 2,
    )
        : defaultStyle;
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(items.length, (index) {
        final title = items[index];
        final isContact = title == "Contact Me";
        final isResume = title == "Resume";

        return SlideTransition(
          position: _slideAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: Padding(
              padding: EdgeInsets.only(right: (isContact || isResume) ? 0 : 16),
              child: isContact
                  ? OutlinedButton(
                onPressed: () => widget.onItemSelected?.call(title),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  side: BorderSide(
                    color: widget.activeSection == title
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor,
                  ),
                ),
                child: Text(
                  title,
                  style: _getStyle(
                      context, widget.activeSection == title),
                ),
              )
                  :isResume
                  ? FutureBuilder<String>(
                future: linksService.fetchLink("resume"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Skeleton داخل الزر
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Skeletonizer(
                        child: Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: 60,
                            height: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Skeletonizer(
                        child: Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: 60,
                            height: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    );                  } else {
                    final resumeUrl = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: OutlinedButton(
                        onPressed: () => _launchURL(resumeUrl),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          side: BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        child: Text(title, style: _getStyle(context, false)),
                      ),
                    );
                  }
                },
              )

                  : NavItem(
                title: title,
                onTap: () => widget.onItemSelected?.call(title),
                style: _getStyle(
                    context, widget.activeSection == title),
              ),
            ),
          ),
        );
      }),
    );
  }
}
