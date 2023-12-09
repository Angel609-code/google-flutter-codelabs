import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../orb_shader/orb_shader_config.dart';
import '../orb_shader/orb_shader_widget.dart';
import '../utils/assets.dart';
import '../utils/styles.dart';
import 'animated_colors.dart';
import 'image_coloring.dart';
import 'particle_overlay.dart';
import 'title_screen_ui.dart';

class MainScene extends StatefulWidget {
  const MainScene({super.key});

  @override
  State<MainScene> createState() => _MainSceneState();
}

class _MainSceneState extends State<MainScene>
    with SingleTickerProviderStateMixin {
  /// Current difficulty level.
  int _difficulty = 0;

  /// Current focused difficulty (If any)
  int? _difficultyOverridde;
  double _orbEnergy = 0;
  double _minOrbEnergy = 0;

  /// Editable Settings
  /// 0-1, receive light strength
  final _minReceiveLightAmt = 0.35;
  final _maxReceiveLightAmt = 0.7;

  // 0-1, emit light strength
  final _minEmitLightAmt = 0.5;
  final _maxEmitLightAmt = 0.8;

  /// Internal
  var _mousePos = Offset.zero;

  final _orbKey = GlobalKey<OrbShaderWidgetState>();

  Duration _getRndPulseDuration() => 100.ms + 200.ms * Random().nextDouble();

  late final _pulseEffect = AnimationController(
    vsync: this,
    duration: _getRndPulseDuration(),
    lowerBound: -1,
    upperBound: 1,
  );

  Color get _emitColor =>
      AppColors.emitColors[_difficultyOverridde ?? _difficulty];
  Color get _orbColor =>
      AppColors.orbColors[_difficultyOverridde ?? _difficulty];

  double get _finalReceiveLightAmt {
    final light = lerpDouble(
          _minReceiveLightAmt,
          _maxReceiveLightAmt,
          _orbEnergy,
        ) ??
        0;

    return light + _pulseEffect.value * .05 * _orbEnergy;
  }

  double get _finalEmitLightAmt {
    return lerpDouble(
          _minEmitLightAmt,
          _maxEmitLightAmt,
          _orbEnergy,
        ) ??
        0;
  }

  double _getMinEnergyForDifficulty(int difficulty) => switch (difficulty) {
        1 => 0.3,
        2 => 0.6,
        _ => 0,
      };

  void _handlePulseEffectUpdate() {
    if (_pulseEffect.status == AnimationStatus.completed) {
      _pulseEffect.reverse();
      _pulseEffect.duration = _getRndPulseDuration();
    } else if (_pulseEffect.status == AnimationStatus.dismissed) {
      _pulseEffect.duration = _getRndPulseDuration();
      _pulseEffect.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    _pulseEffect.forward();
    _pulseEffect.addListener(_handlePulseEffectUpdate);
  }

  Future<void> _bumpMinEnergy([double amount = 0.1]) async {
    setState(() {
      _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty) + amount;
    });
    await Future<void>.delayed(.2.seconds);
    setState(() {
      _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
    });
  }

  void _handleDifficultyPressed(int value) {
    setState(() {
      _difficulty = value;
    });
    _bumpMinEnergy();
  }

  void _handleStartPressed() => _bumpMinEnergy(0.3);

  void _handleDifficultyFocused(int? value) {
    setState(() {
      _difficultyOverridde = value;
      if (value == null) {
        _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
      } else {
        _minOrbEnergy = _getMinEnergyForDifficulty(value);
      }
    });
  }

  /// Update mouse position so the orbWidget can use it, doing it here prevents
  /// buttons from blocking the mouse-move events in the widget itself.
  void _handleMouseMove(PointerHoverEvent event) {
    setState(() {
      _mousePos = event.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedColors(
        orbColor: _orbColor,
        emitColor: _emitColor,
        builder: (_, orbColor, emitColor) {
          return Stack(
            children: [
              /// Bg-base
              Image.asset(AssetPaths.titleBgBase),

              /// Bg-receive
              ImageColoring(
                color: _orbColor,
                imgSrc: AssetPaths.titleBgReceive,
                lightAmt: _finalReceiveLightAmt,
                pulseEffect: _pulseEffect,
              ),

              /// Orb
              Positioned.fill(
                child: Stack(
                  children: [
                    // orb
                    OrbShaderWidget(
                      key: _orbKey,
                      mousePos: _mousePos,
                      minEnergy: _minOrbEnergy,
                      config: OrbShaderConfig(
                        ambientLightColor: orbColor,
                        materialColor: orbColor,
                        lightColor: orbColor,
                      ),
                      onUpdate: (energy) => setState(() {
                        _orbEnergy = energy;
                      }),
                    )
                  ],
                ),
              ),

              /// Mg-base
              ImageColoring(
                color: _orbColor,
                imgSrc: AssetPaths.titleMgBase,
                lightAmt: _finalReceiveLightAmt,
                pulseEffect: _pulseEffect,
              ),

              /// Mg-receive
              ImageColoring(
                color: _orbColor,
                imgSrc: AssetPaths.titleMgReceive,
                lightAmt: _finalReceiveLightAmt,
                pulseEffect: _pulseEffect,
              ),

              /// Mg-emit
              ImageColoring(
                color: _emitColor,
                imgSrc: AssetPaths.titleMgEmit,
                lightAmt: _finalEmitLightAmt,
                pulseEffect: _pulseEffect,
              ),

              /// Particle Field
              Positioned.fill(
                child: IgnorePointer(
                  child: ParticleOverlay(
                    color: _orbColor,
                    energy: _orbEnergy,
                  ),
                ),
              ),

              /// Fg-rocks
              Image.asset(AssetPaths.titleFgBase),

              /// Fg-receive
              ImageColoring(
                color: _orbColor,
                imgSrc: AssetPaths.titleFgReceive,
                lightAmt: _finalReceiveLightAmt,
                pulseEffect: _pulseEffect,
              ),

              /// Fg-emit
              ImageColoring(
                color: _emitColor,
                imgSrc: AssetPaths.titleFgEmit,
                lightAmt: _finalEmitLightAmt,
                pulseEffect: _pulseEffect,
              ),

              /// UI
              Positioned.fill(
                child: TitleScreenUi(
                  difficulty: _difficulty,
                  onDifficultyPressed: _handleDifficultyPressed,
                  onDifficultyFocused: _handleDifficultyFocused,
                  onStartPressed: _handleStartPressed,
                ),
              )
            ],
          ).animate().fadeIn(
                duration: 1.seconds,
                delay: .3.seconds,
              );
        },
      ),
    );
  }
}
