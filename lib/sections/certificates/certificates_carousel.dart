import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/widgets/error_loading.dart';
import '../../core/widgets/loading_widget.dart';
import 'certificate_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CertificatesCarousel extends StatefulWidget {
  const CertificatesCarousel({super.key});

  @override
  State<CertificatesCarousel> createState() => _CertificatesCarouselState();
}

class _CertificatesCarouselState extends State<CertificatesCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      setState(() {
        _currentPage = (_currentPage + 1) % _itemCount;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  void _goToPage(int index) {
    setState(() {
      _currentPage = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  int _itemCount = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('certificate').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorLoading();
        }

        if (!snapshot.hasData) {
          //  أثناء التحميل
          return LoadingWidget(lottie: 'assets/animations/Certificate.json',);
        }

        final certificates = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            "id": doc.id,
            "title": data["title"] ?? "",
            "issuer": data["issuer"] ?? "",
            "year": data["date"] ?? "",
            "image": data["imageUrl"] ?? "",
          };
        }).toList();

        _itemCount = certificates.length;

        if (certificates.isEmpty) {
          return const Center(child: Text("لا توجد شهادات بعد"));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth =
            constraints.maxWidth > 900 ? 800 : constraints.maxWidth * 0.9;

            return SizedBox(
              height: 420,
              width: maxWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // PageView
                  PageView.builder(
                    controller: _pageController,
                    itemCount: certificates.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final cert = certificates[index];
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 700),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.2, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: CertificateCard(
                          key: ValueKey(cert["id"]),
                          title: cert["title"]!,
                          issuer: cert["issuer"]!,
                          year: cert["year"]!,
                          imageUrl: cert["image"]!,
                        ),
                      );
                    },
                  ),

                  // زر يسار
                  Positioned(
                    left: 10,
                    child: _navButton(Icons.arrow_back_ios, () {
                      if (_currentPage > 0) {
                        _goToPage(_currentPage - 1);
                      } else {
                        _goToPage(certificates.length - 1);
                      }
                    }),
                  ),

                  // زر يمين
                  Positioned(
                    right: 10,
                    child: _navButton(Icons.arrow_forward_ios, () {
                      if (_currentPage < certificates.length - 1) {
                        _goToPage(_currentPage + 1);
                      } else {
                        _goToPage(0);
                      }
                    }),
                  ),

                  // Indicators
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        certificates.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 10,
                          width: _currentPage == index ? 24 : 10,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Theme.of(context).primaryColor
                                : Colors.grey[400],
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.black45,
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon, size: 26),
        color: Colors.white,
        onPressed: onTap,
      ),
    );
  }
}
