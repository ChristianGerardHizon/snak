// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/animated_mascots
  $AssetsImagesAnimatedMascotsGen get animatedMascots =>
      const $AssetsImagesAnimatedMascotsGen();

  /// File path: assets/images/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/background.png');

  /// File path: assets/images/snak_logo.png
  AssetGenImage get snakLogo =>
      const AssetGenImage('assets/images/snak_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [background, snakLogo];
}

class $AssetsVideosGen {
  const $AssetsVideosGen();

  /// File path: assets/videos/background_animated.mp4
  String get backgroundAnimated => 'assets/videos/background_animated.mp4';

  /// List of all assets
  List<String> get values => [backgroundAnimated];
}

class $AssetsImagesAnimatedMascotsGen {
  const $AssetsImagesAnimatedMascotsGen();

  /// File path: assets/images/animated_mascots/1_apple_running_nobg.webp
  AssetGenImage get a1AppleRunningNobg => const AssetGenImage(
      'assets/images/animated_mascots/1_apple_running_nobg.webp');

  /// File path: assets/images/animated_mascots/2_apple_arms_out_nobg.webp
  AssetGenImage get a2AppleArmsOutNobg => const AssetGenImage(
      'assets/images/animated_mascots/2_apple_arms_out_nobg.webp');

  /// File path: assets/images/animated_mascots/3_apple_waiting_nobg.webp
  AssetGenImage get a3AppleWaitingNobg => const AssetGenImage(
      'assets/images/animated_mascots/3_apple_waiting_nobg.webp');

  /// File path: assets/images/animated_mascots/4_apple_thumbs_nobg.webp
  AssetGenImage get a4AppleThumbsNobg => const AssetGenImage(
      'assets/images/animated_mascots/4_apple_thumbs_nobg.webp');

  /// File path: assets/images/animated_mascots/5_apple_wave_nobg.webp
  AssetGenImage get a5AppleWaveNobg => const AssetGenImage(
      'assets/images/animated_mascots/5_apple_wave_nobg.webp');

  /// File path: assets/images/animated_mascots/6_apple_lay_nobg.webp
  AssetGenImage get a6AppleLayNobg => const AssetGenImage(
      'assets/images/animated_mascots/6_apple_lay_nobg.webp');

  /// File path: assets/images/animated_mascots/7_apple_sit_nobg.webp
  AssetGenImage get a7AppleSitNobg => const AssetGenImage(
      'assets/images/animated_mascots/7_apple_sit_nobg.webp');

  /// File path: assets/images/animated_mascots/8_apple_nod_nobg.webp
  AssetGenImage get a8AppleNodNobg => const AssetGenImage(
      'assets/images/animated_mascots/8_apple_nod_nobg.webp');

  /// List of all assets
  List<AssetGenImage> get values => [
        a1AppleRunningNobg,
        a2AppleArmsOutNobg,
        a3AppleWaitingNobg,
        a4AppleThumbsNobg,
        a5AppleWaveNobg,
        a6AppleLayNobg,
        a7AppleSitNobg,
        a8AppleNodNobg
      ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsVideosGen videos = $AssetsVideosGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
