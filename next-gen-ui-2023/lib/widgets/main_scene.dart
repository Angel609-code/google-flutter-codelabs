import 'package:flutter/material.dart';
import '../utils/assets.dart';
import '../utils/styles.dart';
import 'image_coloring.dart';

class MainScene extends StatelessWidget {
  const MainScene({super.key});

  final _finalReceiveLightAmt = 0.7;
  final _finalEmitLightAmt = 0.5;

  @override
  Widget build(BuildContext context) {
    final orbColor = AppColors.orbColors[0];
    final emitColor = AppColors.emitColors[0];

    return Stack(
      children: [
        // Bg-base
        Image.asset(AssetPaths.titleBgBase),

        // Bg-receive
        ImageColoring(
          color: orbColor,
          imgSrc: AssetPaths.titleBgReceive,
          lightAmt: _finalReceiveLightAmt,
        ),

        // Mg-base
        ImageColoring(
          color: orbColor,
          imgSrc: AssetPaths.titleMgBase,
          lightAmt: _finalReceiveLightAmt,
        ),

        // Mg-receive
        ImageColoring(
          color: orbColor,
          imgSrc: AssetPaths.titleMgReceive,
          lightAmt: _finalReceiveLightAmt,
        ),

        // Mg-emit
        ImageColoring(
          color: emitColor,
          imgSrc: AssetPaths.titleMgEmit,
          lightAmt: _finalEmitLightAmt,
        ),

        // Fg-rocks
        Image.asset(AssetPaths.titleFgBase),

        // Fg-receive
        ImageColoring(
          color: orbColor,
          imgSrc: AssetPaths.titleFgReceive,
          lightAmt: _finalReceiveLightAmt,
        ),

        // Fg-emit
        ImageColoring(
          color: emitColor,
          imgSrc: AssetPaths.titleFgEmit,
          lightAmt: _finalEmitLightAmt,
        ),
      ],
    );
  }
}
