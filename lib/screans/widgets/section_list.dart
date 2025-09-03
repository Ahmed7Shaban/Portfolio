import 'package:flutter/material.dart';
import '../../../sections/About/about_scation.dart';
import '../../../sections/Contact/contact_footer.dart';
import '../../../sections/Hero/hero_scction.dart';
import '../../../sections/Projects/projects_section.dart';
import '../../../sections/Services/services_sections.dart';
import '../../../sections/certificates/certificates_section.dart';

enum SectionType {
  home,
  about,
  certificates,
  services,
  projects,
  resume,
  contact,
}

class SectionItem {
  final SectionType type;
  final String title;
  final GlobalKey key;
  final Widget child;
  final Offset offset;
  final double scale;

  const SectionItem({
    required this.type,
    required this.title,
    required this.key,
    required this.child,
    this.offset = Offset.zero,
    this.scale = 1,
  });
}

class SectionList {
  static final Map<SectionType, GlobalKey> _keys = {
    SectionType.home: GlobalKey(),
    SectionType.about: GlobalKey(),
    SectionType.certificates: GlobalKey(),
    SectionType.services: GlobalKey(),
    SectionType.projects: GlobalKey(),
    SectionType.resume: GlobalKey(),
    SectionType.contact: GlobalKey(),
  };

  static GlobalKey getKey(SectionType type) => _keys[type]!;

  static final List<SectionItem> items = [
    SectionItem(
      type: SectionType.home,
      title: "Home",
      key: getKey(SectionType.home),
      child: const HeroSection(),
      offset: Offset(0, 0.2),
      scale: 0.8,
    ),
    SectionItem(
      type: SectionType.about,
      title: "About",
      key: getKey(SectionType.about),
      child: const AboutSection(),
      offset: Offset(-0.3, 0),
    ),
    SectionItem(
      type: SectionType.certificates,
      title: "certificates",
      key: getKey(SectionType.certificates),
      child: const CertificatesSection(),
      offset: Offset(0, 0.2),
    ),
    SectionItem(
      type: SectionType.services,
      title: "Services",
      key: getKey(SectionType.services),
      child: const ServicesSection(),
      offset: Offset(0.3, 0),
    ),
    SectionItem(
      type: SectionType.projects,
      title: "Projects",
      key: getKey(SectionType.projects),
      child: const ProjectsSection(),
      offset: Offset(0, 0.2),
    ),
    SectionItem(
      type: SectionType.contact,
      title: "Contact Me",
      key: getKey(SectionType.contact),
      child: const ContactFooter(),
      offset: Offset(0.2, 0),
    ),
  ];
}
