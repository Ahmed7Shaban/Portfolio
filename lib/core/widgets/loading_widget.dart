import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.lottie});
final String lottie ;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Lottie.asset(
          lottie,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
