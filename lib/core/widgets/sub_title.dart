import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubTitle extends StatefulWidget {
  const SubTitle({super.key, required this.subTitle});
  final String subTitle;

  @override
  State<SubTitle> createState() => _SubTitleState();
}

class _SubTitleState extends State<SubTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // سرعة الدخول
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // يبدأ الأنيميشن مرة واحدة
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              const Color(0xFF4FC3F7),
              isDark ? Colors.white : const Color(0xFF484E53),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Text(
                widget.subTitle,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: Colors.white, // مهم عشان ShaderMask يبان
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      )
    ;
  }
}
