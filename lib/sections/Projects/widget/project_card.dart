import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final int delay;

  const ProjectCard({super.key, required this.project, this.delay = 0});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  IconData _getIconForLink(String key) {
    switch (key) {
      case 'github':
        return FontAwesomeIcons.github;
      case 'playstore':
        return FontAwesomeIcons.googlePlay;
      case 'appstore':
        return FontAwesomeIcons.appStore;
      case 'facebook':
        return FontAwesomeIcons.facebook;
      case 'linkedin':
        return FontAwesomeIcons.linkedin;
      default:
        return Icons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    final links = widget.project["links"] ?? {};

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        scale: _isHovered ? 1.05 : 1.0,
        child: FadeTransition(
          opacity: _opacity,
          child: SlideTransition(
            position: _offset,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? Theme.of(context).primaryColor.withOpacity(0.4)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: _isHovered ? 20 : 8,
                    spreadRadius: _isHovered ? 2 : 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // صورة المشروع من Firestore
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                    child: AnimatedScale(
                      scale: _isHovered ? 1.1 : 1.05,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      child: Image.network(
                        widget.project["imageUrl"],
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // بيانات المشروع
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.project["title"] ?? "",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.project["description"] ?? "",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // روابط الأيقونات
                        Wrap(
                          spacing: 8,
                          children: (links as Map<String, dynamic>)
                              .entries
                              .map((entry) {
                            final key = entry.key;
                            final url = entry.value.toString();
                            if (url.isEmpty) return const SizedBox.shrink();
                            return IconButton(
                              icon: Icon(
                                _getIconForLink(key),
                                size: 22,
                                color: Colors.blueGrey[800],
                              ),
                              onPressed: () => _launchUrl(url),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
