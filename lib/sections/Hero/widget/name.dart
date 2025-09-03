import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Name extends StatelessWidget {
  const Name({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 8),
      child: Text(
       name,
        style: GoogleFonts.montserrat(
          fontSize: 42,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
