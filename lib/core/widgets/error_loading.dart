import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorLoading extends StatelessWidget {
  const ErrorLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Lottie.asset(
          "assets/animations/NoInternet.json",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
