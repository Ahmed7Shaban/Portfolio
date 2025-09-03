import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;

  const SocialIcon({super.key, required this.icon, required this.url});

  @override
  State<SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<SocialIcon> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch ${widget.url}");
    }
  }

  @override
  Widget build(BuildContext context) {
    String tooltipMessage = "";

    if (widget.url.contains("facebook")) tooltipMessage = "Facebook";
    else if (widget.url.contains("instagram")) tooltipMessage = "Instagram";
    else if (widget.url.contains("linkedin")) tooltipMessage = "LinkedIn";
    else if (widget.url.contains("github")) tooltipMessage = "GitHub";
    else if (widget.url.contains("wa.me")) tooltipMessage = "WhatsApp";
    else if (widget.url.contains("mailto")) tooltipMessage = "Email";

    return Tooltip(
      message: tooltipMessage,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: IconButton(
            onPressed: _launchUrl,
            icon: Icon(widget.icon,
                color: _isHovered
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).iconTheme.color),
          ),
        ),
      ),
    );
  }
}
