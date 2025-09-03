import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavItem extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  final TextStyle? style;
  final bool isActive;

  const NavItem({
    super.key,
    required this.title,
    this.onTap,
    this.style,
    this.isActive = false,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = GoogleFonts.montserrat(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );

    final activeStyle = defaultStyle.copyWith(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
      decorationThickness: 2,
    );

    final hoverStyle = defaultStyle.copyWith(
      color: Theme.of(context).primaryColor.withOpacity(0.8),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.1 : 1.0), 
        child: InkWell(
          onTap: widget.onTap,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: widget.style ??
                (widget.isActive
                    ? activeStyle
                    : (_isHovered ? hoverStyle : defaultStyle)),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
