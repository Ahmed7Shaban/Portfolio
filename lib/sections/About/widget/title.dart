import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleW extends StatelessWidget {
  const TitleW({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child:  Text(
        "About Me ",
        style: GoogleFonts.montserrat(
          textStyle:  TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Theme.of(context).textTheme.bodyMedium?.color,

        ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
