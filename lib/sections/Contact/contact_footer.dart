import 'package:flutter/material.dart';

import 'widget/animated_fade_slide.dart';
import 'widget/footer_bottom.dart';
import 'widget/footer_top.dart';

class ContactFooter extends StatelessWidget {
  const ContactFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedFadeSlide(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            FooterTop(),
            SizedBox(height: 30),
            Divider(thickness: 1),
            SizedBox(height: 20),
            FooterBottom(),
          ],
        ),
      ),
    );
  }
}
