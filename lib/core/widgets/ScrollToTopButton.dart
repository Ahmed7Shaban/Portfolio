import 'package:flutter/material.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController controller;

  const ScrollToTopButton({super.key, required this.controller});

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  bool _isHovered = false;

  late AnimationController _animController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    widget.controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.controller.offset > 400 && !_isVisible) {
      setState(() => _isVisible = true);
    } else if (widget.controller.offset <= 400 && _isVisible) {
      setState(() => _isVisible = false);
    }
  }

  void _scrollToTop() {
    widget.controller.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scrollListener);
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🎨 الجراديانت الأساسي
    final gradientColors = isDark
        ? [Colors.white, Colors.grey.shade400]
        : [const Color(0xFF6D28D9), const Color(0xFF3B82F6)];

    // 🎨 الجراديانت لما تعمل Hover
    final hoverGradientColors = isDark
        ? [Colors.amber.shade200, Colors.orange.shade400]
        : [const Color(0xFF14B8A6), const Color(0xFF06B6D4)];

    final iconColor = isDark ? Colors.black : Colors.white;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      child: _isVisible
          ? Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bounceAnimation.value),
                      child: MouseRegion(
                        onEnter: (_) => setState(() => _isHovered = true),
                        onExit: (_) => setState(() => _isHovered = false),
                        child: GestureDetector(
                          onTap: _scrollToTop,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            transform: Matrix4.identity()
                              ..scale(_isHovered ? 1.15 : 1.0),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _isHovered
                                    ? hoverGradientColors
                                    : gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_upward,
                              color: iconColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
