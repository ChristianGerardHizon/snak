import 'package:flutter/material.dart';

import '../../assets/assets.gen.dart';

/// Available mascot poses.
enum MascotPose {
  thumbsUp,
  shy,
  winking,
  walking,
  sitting,
  sleeping,
  bitten,
  running,
  standing,
}

/// Displays a single mascot pose image.
///
/// Mascot artwork is authored as 1:1 square PNGs in `assets/images/mascot/`.
class Mascot extends StatelessWidget {
  const Mascot({
    super.key,
    required this.pose,
    this.width,
    this.height,
  });

  const Mascot.thumbsUp({super.key, this.width, this.height})
      : pose = MascotPose.thumbsUp;

  const Mascot.shy({super.key, this.width, this.height})
      : pose = MascotPose.shy;

  const Mascot.winking({super.key, this.width, this.height})
      : pose = MascotPose.winking;

  const Mascot.walking({super.key, this.width, this.height})
      : pose = MascotPose.walking;

  const Mascot.sitting({super.key, this.width, this.height})
      : pose = MascotPose.sitting;

  const Mascot.sleeping({super.key, this.width, this.height})
      : pose = MascotPose.sleeping;

  const Mascot.bitten({super.key, this.width, this.height})
      : pose = MascotPose.bitten;

  const Mascot.running({super.key, this.width, this.height})
      : pose = MascotPose.running;

  const Mascot.standing({super.key, this.width, this.height})
      : pose = MascotPose.standing;

  /// Native pixel size of each mascot PNG (square).
  static const double nativeSize = 768;

  /// Aspect ratio of a mascot image (1:1).
  static const double aspect = 1.0;

  final MascotPose pose;
  final double? width;
  final double? height;

  AssetGenImage get _asset {
    switch (pose) {
      case MascotPose.thumbsUp:
        return Assets.images.mascot.mascotThumbsUp;
      case MascotPose.shy:
        return Assets.images.mascot.mascotShy;
      case MascotPose.winking:
        return Assets.images.mascot.mascotWinking;
      case MascotPose.walking:
        return Assets.images.mascot.mascotWalking;
      case MascotPose.sitting:
        return Assets.images.mascot.mascotSitting;
      case MascotPose.sleeping:
        return Assets.images.mascot.mascotSleeping;
      case MascotPose.bitten:
        return Assets.images.mascot.mascotBitten;
      case MascotPose.running:
        return Assets.images.mascot.runningMascot;
      case MascotPose.standing:
        return Assets.images.mascot.standingMascot;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pose == MascotPose.thumbsUp) {
      return Image.asset(
        'assets/images/mascot/mascot_thumbs_up_nobg.webp',
        width: width,
        height: height,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      );
    }
    if (pose == MascotPose.sitting) {
      return Image.asset(
        'assets/images/mascot/mascot_sitting_nobg.webp',
        width: width,
        height: height,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      );
    }
    return _asset.image(
      width: width,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}
