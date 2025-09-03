import 'package:flutter/material.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

import '../../core/utils/responsive.dart';
import '../../sections/NavBar/nav_bar.dart';
import '../core/widgets/ScrollToTopButton.dart';
import 'widgets/home_drawer.dart';
import 'widgets/section_wrapper.dart';
import 'widgets/section_list.dart';

class HomeResponsive extends StatefulWidget {
  const HomeResponsive({super.key});

  @override
  State<HomeResponsive> createState() => _HomeResponsiveState();
}

class _HomeResponsiveState extends State<HomeResponsive> {
  final ScrollController _scrollController = ScrollController();
  SectionType _activeSection = SectionType.home;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  /// تحديد أي سكشن ظاهر حاليًا
  void _onScroll() {
    for (var section in SectionList.items) {
      final ctx = section.key.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero).dy;

        if (pos < MediaQuery.of(context).size.height / 2 &&
            pos > -box.size.height / 2) {
          if (_activeSection != section.type) {
            setState(() => _activeSection = section.type);
          }
          break;
        }
      }
    }
  }

  /// سكرول لسكشن معين
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// نافيجيشن من الـ Drawer أو Navbar
  void _handleNavigation(SectionType type) {
    final section = SectionList.items.firstWhere(
          (item) => item.type == type,
      orElse: () => SectionList.items.first,
    );
    _scrollToSection(section.key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: (Responsive.isMobile(context) || Responsive.isTablet(context))
          ? HomeDrawer(onItemSelected: _handleNavigation)
          : null,
      body: Stack(
        children: [
          WebSmoothScroll(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Navbar(
                    activeSection: SectionList.items
                        .firstWhere((s) => s.type == _activeSection)
                        .title,
                    onItemSelected: (title) {
                      final type = SectionList.items
                          .firstWhere((s) => s.title == title)
                          .type;
                      _handleNavigation(type);
                    },
                  ),
                  ...SectionList.items.map(
                        (section) => SectionWrapper(
                      sectionKey: section.key,
                      offset: section.offset,
                      scale: section.scale,
                      child: section.child,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ScrollToTopButton(controller: _scrollController),
        ],
      ),
    );
  }
}
