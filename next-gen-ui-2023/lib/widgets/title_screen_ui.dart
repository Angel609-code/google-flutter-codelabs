import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusable_control_builder/focusable_control_builder.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../common/shader_effect.dart';
import '../common/ticking_builder.dart';
import '../common/ui_scaler.dart';
import '../utils/assets.dart';
import '../utils/styles.dart';

/// This widget contains the title and all the buttons that make up the user interface for this app.
class TitleScreenUi extends StatelessWidget {
  final int difficulty;
  final void Function(int difficulty) onDifficultyPressed;
  final void Function(int? difficulty) onDifficultyFocused;
  final VoidCallback onStartPressed;

  const TitleScreenUi({
    super.key,
    required this.difficulty,
    required this.onDifficultyPressed,
    required this.onDifficultyFocused,
    required this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
      child: Stack(
        children: [
          /// Title Text
          const TopLeft(
            child: UiScaler(
              alignment: Alignment.topLeft,
              child: _TitleText(),
            ),
          ),

          /// Difficulty Buttons
          BottomLeft(
            child: UiScaler(
              alignment: Alignment.bottomLeft,
              child: _DifficultyButtons(
                difficulty: difficulty,
                onDifficultyPressed: onDifficultyPressed,
                onDifficultyFocused: onDifficultyFocused,
              ),
            ),
          ),

          /// Start button
          BottomRight(
            child: UiScaler(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 40),
                child: _StartButton(
                  onPressed: onStartPressed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(-(TextStyles.h1.letterSpacing! * .5), 0),
              child: Text(
                'OUTPOST',
                style: TextStyles.h1,
              ),
            ),
            Image.asset(
              AssetPaths.titleSelectedLeft,
              height: 65,
            ),
            Text(
              '57',
              style: TextStyles.h2,
            ),
            Image.asset(
              AssetPaths.titleSelectedRight,
              height: 65,
            ),
          ],
        ).animate().fadeIn(
              delay: .8.seconds,
              duration: .7.seconds,
            ),
        Text(
          'INTO THE UNKNOWN',
          style: TextStyles.h3,
        ).animate().fadeIn(
              delay: 1.seconds,
              duration: .7.seconds,
            ),
      ],
    );

    return Consumer<FragmentPrograms?>(
      builder: (context, fragmentPrograms, __) {
        if (fragmentPrograms == null) {
          return content;
        }

        return TickingBuilder(
          builder: (_, time) {
            return AnimatedSampler(
              (
                image,
                size,
                canvas,
              ) {
                const double overdrawPx = 30;

                final shader = fragmentPrograms.ui.fragmentShader();

                shader
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, time)
                  ..setImageSampler(0, image);

                Rect rect = Rect.fromLTWH(
                  -overdrawPx,
                  -overdrawPx,
                  size.width + overdrawPx,
                  size.height + overdrawPx,
                );

                canvas.drawRect(rect, Paint()..shader = shader);
              },
              child: content,
            );
          },
        );
      },
    );
  }
}

class _DifficultyButtons extends StatelessWidget {
  final int difficulty;
  final void Function(int difficulty) onDifficultyPressed;
  final void Function(int? difficulty) onDifficultyFocused;

  const _DifficultyButtons({
    super.key,
    required this.difficulty,
    required this.onDifficultyPressed,
    required this.onDifficultyFocused,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DifficultyButton(
          label: 'Casual',
          selected: difficulty == 0,
          onPressed: () => onDifficultyPressed(0),
          onHover: (over) => onDifficultyFocused(over ? 0 : null),
        )
            .animate()
            .fadeIn(
              delay: 1.3.seconds,
              duration: .35.seconds,
            )
            .slide(
              begin: const Offset(0, .2),
            ),
        _DifficultyButton(
          label: 'Normal',
          selected: difficulty == 1,
          onPressed: () => onDifficultyPressed(1),
          onHover: (over) => onDifficultyFocused(over ? 1 : null),
        )
            .animate()
            .fadeIn(
              delay: 1.5.seconds,
              duration: .35.seconds,
            )
            .slide(
              begin: const Offset(0, .2),
            ),
        _DifficultyButton(
          label: 'Hardcore',
          selected: difficulty == 2,
          onPressed: () => onDifficultyPressed(2),
          onHover: (over) => onDifficultyFocused(over ? 2 : null),
        )
            .animate()
            .fadeIn(
              delay: 1.7.seconds,
              duration: .25.seconds,
            )
            .slide(
              begin: const Offset(0, .2),
            ),
        const Gap(20),
      ],
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final void Function(bool hasFocus) onHover;

  const _DifficultyButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableControlBuilder(
      onPressed: onPressed,
      onHoverChanged: (_, state) => onHover.call(state.isHovered),
      onFocusChanged: (_, state) => onHover.call(state.isFocused),
      builder: (_, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 250,
            height: 60,
            child: Stack(children: [
              /// Bg with fill and outline
              AnimatedOpacity(
                opacity:
                    (!selected && (state.isHovered || state.isFocused)) ? 1 : 0,
                duration: .3.seconds,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D1FF).withOpacity(.1),
                    border: Border.all(
                      color: Colors.white,
                      width: 5,
                    ),
                  ),
                ),
              ),

              /// If state is hovered or focused
              if (state.isHovered || state.isFocused) ...[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D1FF).withOpacity(.1),
                  ),
                ),
              ],

              /// Cross-hairs (Selected state)
              if (selected) ...[
                CenterLeft(
                  child: Image.asset(AssetPaths.titleSelectedLeft),
                ),
                CenterRight(
                  child: Image.asset(AssetPaths.titleSelectedRight),
                ),
              ],

              /// Label
              Center(
                  child: Text(
                label.toUpperCase(),
                style: TextStyles.btn,
              ))
            ]),
          ),
        );
      },
    );
  }
}

class _StartButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _StartButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<_StartButton> createState() => __StartButtonState();
}

class __StartButtonState extends State<_StartButton> {
  AnimationController? _btnAnim;
  bool _wasHovered = false;

  @override
  Widget build(BuildContext context) {
    return FocusableControlBuilder(
      cursor: SystemMouseCursors.click,
      onPressed: widget.onPressed,
      builder: (_, state) {
        /// If hovered or focused and it was not hovered before and button animation status is forward
        if ((state.isHovered || state.isFocused) &&
            !_wasHovered &&
            _btnAnim?.status == AnimationStatus.forward) {
          _btnAnim?.forward(from: 0);
        }

        _wasHovered = (state.isHovered || state.isFocused);

        return SizedBox(
          width: 520,
          height: 100,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(AssetPaths.titleStartBtn),
              ),

              /// If hovered or focused
              if (state.isHovered || state.isFocused) ...[
                Positioned.fill(
                  child: Image.asset(AssetPaths.titleStartBtnHover),
                ),
              ],

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'START MISSION',
                      style: TextStyles.btn
                          .copyWith(fontSize: 24, letterSpacing: 18),
                    )
                  ],
                ),
              ),
            ],
          )
              .animate(
                autoPlay: false,
                onInit: (c) => _btnAnim = c,
              )
              .shimmer(
                duration: .7.seconds,
                color: Colors.black,
              ),
        )
            .animate()
            .fadeIn(
              delay: 2.3.seconds,
            )
            .slide(
              begin: const Offset(0, .2),
            );
      },
    );
  }
}
