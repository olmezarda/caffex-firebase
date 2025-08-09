import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? backgroundColor;

  const LoadingIndicator({super.key, this.size = 200, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      alignment: Alignment.center,
      child: Lottie.asset(
        'assets/animations/loading.json',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
