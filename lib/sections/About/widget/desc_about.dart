import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../Service/about_service.dart';


class DescAbout extends StatefulWidget {
  const DescAbout({super.key});

  @override
  State<DescAbout> createState() => _DescAboutState();
}

class _DescAboutState extends State<DescAbout>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  String _visibleText = "";
  int _charIndex = 0;
  bool _showCursor = true;

  final AboutService _aboutService = AboutService();

  @override
  void initState() {
    super.initState();

    // إعداد Fade + Slide Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // بدء وميض المؤشر
    _startCursorBlink();
  }

  /// Typewriter effect
  void _startTyping(String fullText) async {
    _visibleText = "";
    _charIndex = 0;

    while (_charIndex < fullText.length && mounted) {
      await Future.delayed(const Duration(milliseconds: 35));
      setState(() {
        _visibleText += fullText[_charIndex];
        _charIndex++;
      });
    }
  }

  /// وميض المؤشر
  void _startCursorBlink() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _showCursor = !_showCursor;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _aboutService.streamAboutText(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Skeletonizer(
              child: Container(
                width: 700,
                height: 100, // ارتفاع تقريبي للنص
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          // ===== Loading Skeleton =====
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Skeletonizer(
              child: Container(
                width: 700,
                height: 100, // ارتفاع تقريبي للنص
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          );
        }

        final fullText = snapshot.data!;

        // بدء الكتابة عند تغير النص
        if (_visibleText != fullText) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startTyping(fullText);
          });
        }

        return FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 700,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      height: 1.6,
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          Colors.black,
                    ),
                    children: [
                      TextSpan(text: _visibleText),
                      if (_showCursor)
                        const TextSpan(
                          text: "|",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}