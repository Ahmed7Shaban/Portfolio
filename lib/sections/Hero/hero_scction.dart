import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/widgets/sub_title.dart';
import 'widget/desc_hero.dart';
import 'widget/name.dart';
import 'widget/profile_avatar.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _floatController;
  late AnimationController _glowController;

  late Animation<double> _fade1, _fade2, _fade3, _fade4;
  late Animation<Offset> _slide1, _slide2, _slide3, _slide4;
  late Animation<double> _floatAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    // ===== Staggered Entrance =====
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fade1 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    _fade2 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    );
    _fade3 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
    );
    _fade4 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    _slide1 = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(_fade1);
    _slide2 = Tween<Offset>(
      begin: const Offset(-0.4, 0),
      end: Offset.zero,
    ).animate(_fade2);
    _slide3 = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(_fade3);
    _slide4 = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(_fade4);

    _controller.forward();

    // ===== Floating Avatar =====
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // ===== Glow Effect =====
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 10, end: 30).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  // Helper لعمل Fade + Slide
  Widget _buildAnimatedWidget({
    required Widget child,
    required Animation<double> fade,
    required Animation<Offset> slide,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('heroes')
          .doc('hero_123')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading hero data"));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          // Skeleton كامل لشاشة الـ Hero
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar وهمي
                  Skeletonizer(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // الاسم وهمي
                  Skeletonizer(
                    child:Container(
                      width: 180,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // الوظيفة وهمي
                  Skeletonizer(
                    child: Container(
                      width: 140,
                      height: 16,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // خط وهمي
                  Skeletonizer(
                    child:Container(
                      height: 3,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // الوصف وهمي
                  Skeletonizer(
                    child:Column(
                      children: List.generate(3, (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          width: 250,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          );
        }


        final data = snapshot.data!.data() as Map<String, dynamic>;
        final image = data['image'] ?? '';
        final name = data['name'] ?? '';
        final job = data['job'] ?? '';
        final bio = data['bio'] ?? '';

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([_floatController, _glowController]),
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnim.value),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.6),
                              blurRadius: _glowAnim.value,
                              spreadRadius: _glowAnim.value / 4,
                            ),
                          ],
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: _buildAnimatedWidget(
                    child: ProfileAvatar(imagePath: image),
                    fade: _fade1,
                    slide: _slide1,
                  ),
                ),

                // ===== Name =====
                _buildAnimatedWidget(
                  child: Name(name: name),
                  fade: _fade2,
                  slide: _slide2,
                ),

                // ===== Subtitle =====
                _buildAnimatedWidget(
                  fade: _fade3,
                  slide: _slide3,
                  child: SubTitle(subTitle: job),
                ),

                const SizedBox(height: 20),

                _buildAnimatedWidget(
                  fade: _fade3,
                  slide: _slide3,
                  child: Container(
                    height: 3,
                    width: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ===== Description =====
                _buildAnimatedWidget(
                  child: DescHero(fullText: bio),
                  fade: _fade4,
                  slide: _slide4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
