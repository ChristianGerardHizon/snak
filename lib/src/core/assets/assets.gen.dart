// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/app_icon.png
  AssetGenImage get appIcon => const AssetGenImage('assets/icons/app_icon.png');

  /// File path: assets/icons/app_icon_dev.png
  AssetGenImage get appIconDev =>
      const AssetGenImage('assets/icons/app_icon_dev.png');

  /// File path: assets/icons/app_icon_mac.png
  AssetGenImage get appIconMac =>
      const AssetGenImage('assets/icons/app_icon_mac.png');

  /// File path: assets/icons/app_icon_stg.png
  AssetGenImage get appIconStg =>
      const AssetGenImage('assets/icons/app_icon_stg.png');

  /// File path: assets/icons/app_icon_transparent.png
  AssetGenImage get appIconTransparent =>
      const AssetGenImage('assets/icons/app_icon_transparent.png');

  /// File path: assets/icons/app_icon_transparent_dev.png
  AssetGenImage get appIconTransparentDev =>
      const AssetGenImage('assets/icons/app_icon_transparent_dev.png');

  /// File path: assets/icons/app_icon_transparent_stg.png
  AssetGenImage get appIconTransparentStg =>
      const AssetGenImage('assets/icons/app_icon_transparent_stg.png');

  /// File path: assets/icons/snak_logo_banner.png
  AssetGenImage get snakLogoBanner =>
      const AssetGenImage('assets/icons/snak_logo_banner.png');

  /// File path: assets/icons/snak_logo_small.png
  AssetGenImage get snakLogoSmall =>
      const AssetGenImage('assets/icons/snak_logo_small.png');

  /// File path: assets/icons/snak_logo_small_transparent.png
  AssetGenImage get snakLogoSmallTransparent =>
      const AssetGenImage('assets/icons/snak_logo_small_transparent.png');

  /// File path: assets/icons/snak_logo_square.png
  AssetGenImage get snakLogoSquare =>
      const AssetGenImage('assets/icons/snak_logo_square.png');

  /// File path: assets/icons/snak_logo_square_transparent.png
  AssetGenImage get snakLogoSquareTransparent =>
      const AssetGenImage('assets/icons/snak_logo_square_transparent.png');

  /// File path: assets/icons/snak_logo_white.png
  AssetGenImage get snakLogoWhite =>
      const AssetGenImage('assets/icons/snak_logo_white.png');

  /// File path: assets/icons/snak_logo_wide.png
  AssetGenImage get snakLogoWide =>
      const AssetGenImage('assets/icons/snak_logo_wide.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        appIcon,
        appIconDev,
        appIconMac,
        appIconStg,
        appIconTransparent,
        appIconTransparentDev,
        appIconTransparentStg,
        snakLogoBanner,
        snakLogoSmall,
        snakLogoSmallTransparent,
        snakLogoSquare,
        snakLogoSquareTransparent,
        snakLogoWhite,
        snakLogoWide
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/background.png');

  /// File path: assets/images/snak_logo.png
  AssetGenImage get snakLogo =>
      const AssetGenImage('assets/images/snak_logo.png');

  /// File path: assets/images/sprites_sheet.png
  AssetGenImage get spritesSheet =>
      const AssetGenImage('assets/images/sprites_sheet.png');

  /// File path: assets/images/sprites_sheet_2.png
  AssetGenImage get spritesSheet2 =>
      const AssetGenImage('assets/images/sprites_sheet_2.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [background, snakLogo, spritesSheet, spritesSheet2];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
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
