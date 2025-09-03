import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/color/colors.dart';

class ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String desc;
  final int delay;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    this.delay = 0,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isVisible = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _triggerAnimation() async {
    if (!_isVisible) {
      setState(() => _isVisible = true);
      await Future.delayed(Duration(milliseconds: widget.delay));
      if (mounted) _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return VisibilityDetector(
      key: ValueKey(widget.title),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2) {
          _triggerAnimation();
        }
      },
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedScale(
              scale: _isHovered && !isDark ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.2) // ثابت في Dark
                          : (_isHovered
                                ? Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.4)
                                : Colors.black.withOpacity(0.05)),
                      blurRadius: _isHovered && !isDark ? 20 : 8,
                      spreadRadius: _isHovered && !isDark ? 2 : 0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      size: 48,
                      color: _isHovered
                          ? primaryColor 
                          : (isDark
                                ?Colors.grey[800] 
                                :  primaryColor), 
                    ),

                    const SizedBox(height: 16),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.desc,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
