import 'package:flutter/material.dart';

class ImageColoring extends StatelessWidget {
  final Color color;
  final String imgSrc;
  final AnimationController pulseEffect;

  /// The amount of lightness to apply to the image
  final double lightAmt;

  const ImageColoring({
    super.key,
    required this.color,
    required this.imgSrc,
    required this.lightAmt,
    required this.pulseEffect,
  });

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);

    return ListenableBuilder(
      listenable: pulseEffect,
      builder: (context, child) {
        return Image.asset(
          imgSrc,
          color: hsl.withLightness(hsl.lightness * lightAmt).toColor(),
          colorBlendMode: BlendMode.modulate,
        );
      },
    );
  }
}
