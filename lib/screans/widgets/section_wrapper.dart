import 'package:flutter/material.dart';
import '../../core/widgets/animated_visibility_widget.dart';

class SectionWrapper extends StatelessWidget {
  final GlobalKey sectionKey;
  final Offset offset;
  final double scale;
  final Widget child;

  const SectionWrapper({
    super.key,
    required this.sectionKey,
    required this.offset,
    this.scale = 1,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedVisibility(
      key: sectionKey,
      offset: offset,
      scale: scale,
      child: child,
    );
  }
}
