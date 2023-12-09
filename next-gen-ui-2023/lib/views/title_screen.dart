import 'package:flutter/material.dart';

import '../assets.dart';

/// The background, midground, and foreground layers are each represented by a group of two or three images.
class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            // Bg-base
            Image.asset(AssetPaths.titleBgBase),

            // Bg-receive
            Image.asset(AssetPaths.titleBgReceive),

            // Mg-base
            Image.asset(AssetPaths.titleMgBase),

            // Mg-receive
            Image.asset(AssetPaths.titleMgReceive),

            // Mg-emit
            Image.asset(AssetPaths.titleMgEmit),

            // Fg-rocks
            Image.asset(AssetPaths.titleFgBase),

            // Fg-receive
            Image.asset(AssetPaths.titleFgReceive),

            // Fg-emit
            Image.asset(AssetPaths.titleFgEmit),
          ],
        ),
      ),
    );
  }
}