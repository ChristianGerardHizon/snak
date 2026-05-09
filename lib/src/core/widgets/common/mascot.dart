import 'package:flutter/material.dart';

/// Available mascot poses.
enum MascotPose {
  running,
  armsOut,
  waiting,
  thumbs,
  wave,
  lay,
  sit,
  nod,
}

/// Displays a single mascot pose image.
class Mascot extends StatelessWidget {
  const Mascot({
    super.key,
    required this.pose,
    this.width,
    this.height,
  });

  const Mascot.running({super.key, this.width, this.height})
      : pose = MascotPose.running;

  const Mascot.armsOut({super.key, this.width, this.height})
      : pose = MascotPose.armsOut;

  const Mascot.waiting({super.key, this.width, this.height})
      : pose = MascotPose.waiting;

  const Mascot.thumbs({super.key, this.width, this.height})
      : pose = MascotPose.thumbs;

  const Mascot.wave({super.key, this.width, this.height})
      : pose = MascotPose.wave;

  const Mascot.lay({super.key, this.width, this.height})
      : pose = MascotPose.lay;

  const Mascot.sit({super.key, this.width, this.height})
      : pose = MascotPose.sit;

  const Mascot.nod({super.key, this.width, this.height})
      : pose = MascotPose.nod;

  /// Native pixel size of each mascot image (square).
  static const double nativeSize = 768;

  /// Aspect ratio of a mascot image (1:1).
  static const double aspect = 1.0;

  final MascotPose pose;
  final double? width;
  final double? height;

  String get _path {
    switch (pose) {
      case MascotPose.running:
        return 'assets/images/animated_mascots/1_apple_running_nobg.webp';
      case MascotPose.armsOut:
        return 'assets/images/animated_mascots/2_apple_arms_out_nobg.webp';
      case MascotPose.waiting:
        return 'assets/images/animated_mascots/3_apple_waiting_nobg.webp';
      case MascotPose.thumbs:
        return 'assets/images/animated_mascots/4_apple_thumbs_nobg.webp';
      case MascotPose.wave:
        return 'assets/images/animated_mascots/5_apple_wave_nobg.webp';
      case MascotPose.lay:
        return 'assets/images/animated_mascots/6_apple_lay_nobg.webp';
      case MascotPose.sit:
        return 'assets/images/animated_mascots/7_apple_sit_nobg.webp';
      case MascotPose.nod:
        return 'assets/images/animated_mascots/8_apple_nod_nobg.webp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _path,
      width: width,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}
