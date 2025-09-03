import 'package:flutter/material.dart';
import 'widget/logo_text.dart';
import 'widget/nav_controls.dart';
import 'widget/nav_links.dart';

class Navbar extends StatefulWidget {
  final Function(String section)? onItemSelected;
  final String activeSection;

  const Navbar({
    super.key,
    this.onItemSelected,
    required this.activeSection,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // تابع يحدد حجم الجهاز
  bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1024;
  bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LogoText(),

              // Responsive: Desktop & Tablet & Mobile
              if (isDesktop(context))
                NavLinks(
                  onItemSelected: widget.onItemSelected,
                  activeSection: widget.activeSection,
                )
              else if (isTablet(context))
                Row(
                  children: [
                    NavLinks(
                      onItemSelected: widget.onItemSelected,
                      activeSection: widget.activeSection,
                    ),
                    const SizedBox(width: 16),
                    _menuButton(),
                  ],
                )
              else
                _menuButton(),

              const NavControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton() {
    return Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
      ),
    );
  }
}
