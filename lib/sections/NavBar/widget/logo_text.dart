import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoText extends StatefulWidget {
  const LogoText({super.key});

  @override
  State<LogoText> createState() => _LogoTextState();
}

class _LogoTextState extends State<LogoText> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // لمعة
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    // دخول اللوجو
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    // لمعة مستمرة
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // لون ثابت للنص حسب وضع الثيم
    Color baseColor = isDark ? Colors.cyanAccent : Theme.of(context).primaryColor;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                // لمعة شفافة تتحرك على النص
                return LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.2, 0.5, 0.8],
                  begin: Alignment(-1.0 - 2 * _shimmerController.value, 0),
                  end: Alignment(1.0 - 2 * _shimmerController.value, 0),
                ).createShader(bounds);
              },
              blendMode: BlendMode.lighten,
              child: child,
            );
          },
          child: Text(
            "Ahmed Shaban",
            style: GoogleFonts.pacifico(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: baseColor, // اللون ثابت حسب وضع الثيم
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
