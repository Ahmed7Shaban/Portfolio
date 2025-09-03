import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DescHero extends StatefulWidget {
  const DescHero({super.key, required this.fullText});
final String fullText;
  @override
  State<DescHero> createState() => _DescHeroState();
}

class _DescHeroState extends State<DescHero>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  String _visibleText = "";
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();

    // Fade + Slide Animation
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Typewriter Effect
    _startTyping();
  }

  void _startTyping() async {
    while (_charIndex < widget.fullText.length) {
      await Future.delayed(const Duration(milliseconds: 40));
      setState(() {
        _visibleText += widget.fullText[_charIndex];
        _charIndex++;
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
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: SizedBox(
          width: 600,
          child: Text(
            _visibleText,
            style: GoogleFonts.openSans(
              fontSize: 16,
              height: 1.6,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
