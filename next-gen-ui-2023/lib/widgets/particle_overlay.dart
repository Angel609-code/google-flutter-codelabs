import 'dart:math';

import 'package:flutter/material.dart';
import 'package:particle_field/particle_field.dart';
import 'package:rnd/rnd.dart';

class ParticleOverlay extends StatelessWidget {
  final Color color;
  final double energy;

  const ParticleOverlay({
    super.key,
    required this.color,
    required this.energy,
  });

  @override
  Widget build(BuildContext context) {
    return ParticleField(
      spriteSheet: SpriteSheet(
        image: const AssetImage('assets/images/particle-wave.png'),
      ),
      // Blend the image's alpha with the specified color
      blendMode: BlendMode.dstIn,
      // This runs every tick
      onTick: (controller, _, size) {
        List<Particle> particles = controller.particles;

        // Add a new particle with random angle, distance & velocity
        double a = rnd(pi * 2);
        double dist = rnd(1, 4) * 35 + 150 * energy;
        double vel = rnd(1,  2) * (1 + energy + 1.8);
        particles.add(
          Particle(
            // How many ticks this particle will live
            lifespan: rnd(1, 2) * 20 + energy * 15,
            // Starting distance from center:
            x: cos(a) * dist,
            y: sin(a) * dist,
            // Starting velocity:
            vx: cos(a) * vel,
            vy: sin(a) * vel,
            // Other starting values:
            rotation: a,
            scale: rnd(1, 2) * 0.6 + energy * 0.5,
          ),
        );

        // Update all of the particles:
        for (int i = 0; i < particles.length; i++) {
          Particle p = particles[i];
          if (p.lifespan <= 0){
            // particle is expired, remove it:
            particles.removeAt(i);
            continue;
          }
          p.update(
            scale: p.scale * 1.025,
            vx: p.vx * 1.025,
            vy: p.vy * 1.025,
            color: color.withOpacity(p.lifespan * 0.001 + 0.01),
            lifespan: p.lifespan - 1,
          );
        }
      },
    );
  }
}
