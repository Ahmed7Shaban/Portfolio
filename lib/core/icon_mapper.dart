import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconMapper {
  static IconData getFontAwesomeIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case "code":
        return FontAwesomeIcons.code;
      case "paintbrush":
        return FontAwesomeIcons.paintBrush;
      case "mobile":
        return FontAwesomeIcons.mobileScreenButton;
      case "desktop":
        return FontAwesomeIcons.desktop;
      case "database":
        return FontAwesomeIcons.database;
      case "server":
        return FontAwesomeIcons.server;
      case "cloud":
        return FontAwesomeIcons.cloud;
      case "html5":
        return FontAwesomeIcons.html5;
      case "css3":
        return FontAwesomeIcons.css3;
      case "js":
        return FontAwesomeIcons.js;
      case "react":
        return FontAwesomeIcons.react;
      case "node":
        return FontAwesomeIcons.node;
      case "git":
        return FontAwesomeIcons.gitAlt;
      case "github":
        return FontAwesomeIcons.github;
      case "android":
        return FontAwesomeIcons.android;
      case "apple":
        return FontAwesomeIcons.apple;
      case "python":
        return FontAwesomeIcons.python;
      case "php":
        return FontAwesomeIcons.php;
      case "briefcase":
        return FontAwesomeIcons.briefcase;
      case "laptop":
        return FontAwesomeIcons.laptop;
      case "facebook":
        return FontAwesomeIcons.facebook;
      case "twitter":
        return FontAwesomeIcons.twitter;
      case "linkedin":
        return FontAwesomeIcons.linkedin;
      case "wordpress":
        return FontAwesomeIcons.wordpress;
      case "figma":
        return FontAwesomeIcons.figma;
      case "angular":
        return FontAwesomeIcons.angular;
      case "vuejs":
        return FontAwesomeIcons.vuejs;
      case "docker":
        return FontAwesomeIcons.docker;
      case "aws":
        return FontAwesomeIcons.aws;
      case "cogs":
        return FontAwesomeIcons.cogs;
      default:
        return FontAwesomeIcons.solidStar; // fallback
    }
  }

  static List<String> availableIcons = [
    "code",
    "paintbrush",
    "mobile",
    "desktop",
    "database",
    "server",
    "cloud",
    "html5",
    "css3",
    "js",
    "react",
    "node",
    "git",
    "github",
    "android",
    "apple",
    "python",
    "php",
    "briefcase",
    "laptop",
    "facebook",
    "twitter",
    "linkedin",
    "wordpress",
    "figma",
    "angular",
    "vuejs",
    "docker",
    "aws",
    "cogs", // آخر حاجة زي ما هي
  ];
}
