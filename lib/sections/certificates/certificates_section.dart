import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'certificates_carousel.dart';

class CertificatesSection extends StatelessWidget {
  const CertificatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            "My Certificates",
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const CertificatesCarousel(),
        ],
      ),
    );
  }
}
