import 'package:flutter/material.dart';
import '../utils/assets.dart';
import '../utils/styles.dart';
import 'image_coloring.dart';
import 'title_screen_ui.dart';

class MainScene extends StatefulWidget {
  const MainScene({super.key});

  @override
  State<MainScene> createState() => _MainSceneState();
}

class _MainSceneState extends State<MainScene> {
  /// Current difficulty level.
  int _difficulty = 0;

  /// Current focused difficulty (If any)
  int? _difficultyOverridde;

  Color get _emitColor => AppColors.emitColors[_difficultyOverridde ?? _difficulty];
  Color get _orbColor => AppColors.orbColors[_difficultyOverridde ?? _difficulty];
  
  void _handleDifficultyPressed(int value) {
    setState(() {
      _difficulty = value;
    });
  }

  void _handleDifficultyFocused(int? value) {
    setState(() {
      _difficultyOverridde = value;
    });
  }

  final _finalReceiveLightAmt = 0.7;
  final _finalEmitLightAmt = 0.5;

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        // Bg-base
        Image.asset(AssetPaths.titleBgBase),

        // Bg-receive
        ImageColoring(
          color: _orbColor,
          imgSrc: AssetPaths.titleBgReceive,
          lightAmt: _finalReceiveLightAmt,
        ),

        // Mg-base
        ImageColoring(
          color: _orbColor,
          imgSrc: AssetPaths.titleMgBase,
          lightAmt: _finalReceiveLightAmt,
        ),

        // Mg-receive
        ImageColoring(
          color: _orbColor,
          imgSrc: AssetPaths.titleMgReceive,
          lightAmt: _finalReceiveLightAmt,
        ),

        // Mg-emit
        ImageColoring(
          color: _emitColor,
          imgSrc: AssetPaths.titleMgEmit,
          lightAmt: _finalEmitLightAmt,
        ),

        // Fg-rocks
        Image.asset(AssetPaths.titleFgBase),

        // Fg-receive
        ImageColoring(
          color: _orbColor,
          imgSrc: AssetPaths.titleFgReceive,
          lightAmt: _finalReceiveLightAmt,
        ),

        // Fg-emit
        ImageColoring(
          color: _emitColor,
          imgSrc: AssetPaths.titleFgEmit,
          lightAmt: _finalEmitLightAmt,
        ),

        // UI
        Positioned.fill(
          child: TitleScreenUi(
            difficulty: _difficulty,
            onDifficultyPressed: _handleDifficultyPressed,
            onDifficultyFocused: _handleDifficultyFocused,
          ),
        )
      ],
    );
  }
}
