import 'package:flutter/material.dart';

import '../widgets/main_scene.dart';

/// The background, midground, and foreground layers are each represented by a group of two or three images.
class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: MainScene(),
      ),
    );
  }
}