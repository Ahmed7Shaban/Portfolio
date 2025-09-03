import 'package:flutter/material.dart';

import '../../core/widgets/sub_title.dart';
import 'widget/desc_about.dart';
import 'widget/download_resume.dart';
import 'widget/title.dart';

class AboutSection extends StatefulWidget {
  final VoidCallback? onResumePressed;

  const AboutSection({super.key, this.onResumePressed});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeTitle, _fadeSubtitle, _fadeDesc, _fadeButton;
  late Animation<Offset> _slideTitle, _slideDesc, _slideButton;
  late Animation<double> _scaleSubtitle;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Title Animation
    _fadeTitle = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    _slideTitle = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(_fadeTitle);

    // Subtitle Animation
    _fadeSubtitle = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    );
    _scaleSubtitle = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.5)),
    );

    // Description Animation
    _fadeDesc = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
    );
    _slideDesc = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(_fadeDesc);

    // Button Animation
    _fadeButton = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );
    _slideButton = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimated({
    required Widget child,
    required Animation<double> fade,
    Animation<Offset>? slide,
    Animation<double>? scale,
  }) {
    Widget animatedChild = child;

    if (slide != null) {
      animatedChild = SlideTransition(position: slide, child: animatedChild);
    }
    if (scale != null) {
      animatedChild = ScaleTransition(scale: scale, child: animatedChild);
    }

    return FadeTransition(opacity: fade, child: animatedChild);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAnimated(
              child: const TitleW(),
              fade: _fadeTitle,
              slide: _slideTitle,
            ),
            _buildAnimated(
              child: SubTitle(subTitle: 'Get to know me'),
              fade: _fadeSubtitle,
              scale: _scaleSubtitle,
            ),
            SizedBox(height: 20),
            _buildAnimated(
              child: const DescAbout(),
              fade: _fadeDesc,
              slide: _slideDesc,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: _buildAnimated(
                child: DownloadResume(),
                fade: _fadeButton,
                slide: _slideButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
