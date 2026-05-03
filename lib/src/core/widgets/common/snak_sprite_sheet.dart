import 'package:flutter/material.dart';

import '../../assets/assets.gen.dart';

/// Poses in [Assets.images.spritesSheet] (3×2 grid on a 3260×1834 sheet).
enum SnakSprite {
  /// Row 0, column 0 — winking wave.
  waving(0, 0),

  /// Row 0, column 1 — hands together, closed smile.
  happy(1, 0),

  /// Row 0, column 2 — two thumbs up.
  thumbsUp(2, 0),

  /// Row 1, column 0 — jumping / arms out.
  jumping(0, 1),

  /// Row 1, column 1 — shy, hand near mouth.
  shy(1, 1),

  /// Row 1, column 2 — arms crossed, confident.
  confident(2, 1);

  const SnakSprite(this.column, this.row);

  /// Column index in the sheet (0…2).
  final int column;

  /// Row index in the sheet (0…1).
  final int row;
}

/// Poses in [Assets.images.spritesSheet2] (3×2 grid on a 2556×1438 sheet).
enum SnakSprite2 {
  /// Row 0, column 0 — sitting, looking slightly left.
  sittingLeft(0, 0),

  /// Row 0, column 1 — sitting, facing forward.
  sittingForward(1, 0),

  /// Row 0, column 2 — squashed / flattened.
  squashed(2, 0),

  /// Row 1, column 0 — sitting, looking slightly right.
  sittingRight(0, 1),

  /// Row 1, column 1 — lying on side.
  lyingSide(1, 1),

  /// Row 1, column 2 — tilted / rolling.
  rolling(2, 1);

  const SnakSprite2(this.column, this.row);

  /// Column index in the sheet (0…2).
  final int column;

  /// Row index in the sheet (0…1).
  final int row;
}

/// Static const access to each [SnakSprite] for use with [SnakSpriteSheet].
///
/// Example: `SnakSpriteSheet(sprite: SnakSprites.thumbsUp)`.
abstract final class SnakSprites {
  SnakSprites._();

  static const SnakSprite waving = SnakSprite.waving;
  static const SnakSprite happy = SnakSprite.happy;
  static const SnakSprite thumbsUp = SnakSprite.thumbsUp;
  static const SnakSprite jumping = SnakSprite.jumping;
  static const SnakSprite shy = SnakSprite.shy;
  static const SnakSprite confident = SnakSprite.confident;
}

/// Static const access to each [SnakSprite2] for use with [SnakSpriteSheet.sheet2].
abstract final class SnakSprites2 {
  SnakSprites2._();

  static const SnakSprite2 sittingLeft = SnakSprite2.sittingLeft;
  static const SnakSprite2 sittingForward = SnakSprite2.sittingForward;
  static const SnakSprite2 squashed = SnakSprite2.squashed;
  static const SnakSprite2 sittingRight = SnakSprite2.sittingRight;
  static const SnakSprite2 lyingSide = SnakSprite2.lyingSide;
  static const SnakSprite2 rolling = SnakSprite2.rolling;
}

/// Displays a single frame from a Snak apple sprite sheet ([sprites_sheet] or
/// [sprites_sheet_2]).
///
/// Use [SnakSprite] / [SnakSprite2] values or the named constructors on this
/// widget for each pose.
class SnakSpriteSheet extends StatelessWidget {
  const SnakSpriteSheet({
    super.key,
    required this.sprite,
    this.width,
    this.height,
  }) : sprite2 = null;

  const SnakSpriteSheet.sheet2({
    super.key,
    required this.sprite2,
    this.width,
    this.height,
  }) : sprite = null;

  const SnakSpriteSheet.waving({
    super.key,
    this.width,
    this.height,
  })  : sprite = SnakSprite.waving,
        sprite2 = null;

  const SnakSpriteSheet.happy({
    super.key,
    this.width,
    this.height,
  })  : sprite = SnakSprite.happy,
        sprite2 = null;

  const SnakSpriteSheet.thumbsUp({
    super.key,
    this.width,
    this.height,
  })  : sprite = SnakSprite.thumbsUp,
        sprite2 = null;

  const SnakSpriteSheet.jumping({
    super.key,
    this.width,
    this.height,
  })  : sprite = SnakSprite.jumping,
        sprite2 = null;

  const SnakSpriteSheet.shy({
    super.key,
    this.width,
    this.height,
  })  : sprite = SnakSprite.shy,
        sprite2 = null;

  const SnakSpriteSheet.confident({
    super.key,
    this.width,
    this.height,
  })  : sprite = SnakSprite.confident,
        sprite2 = null;

  const SnakSpriteSheet.sittingLeft({
    super.key,
    this.width,
    this.height,
  })  : sprite = null,
        sprite2 = SnakSprite2.sittingLeft;

  const SnakSpriteSheet.sittingForward({
    super.key,
    this.width,
    this.height,
  })  : sprite = null,
        sprite2 = SnakSprite2.sittingForward;

  const SnakSpriteSheet.squashed({
    super.key,
    this.width,
    this.height,
  })  : sprite = null,
        sprite2 = SnakSprite2.squashed;

  const SnakSpriteSheet.sittingRight({
    super.key,
    this.width,
    this.height,
  })  : sprite = null,
        sprite2 = SnakSprite2.sittingRight;

  const SnakSpriteSheet.lyingSide({
    super.key,
    this.width,
    this.height,
  })  : sprite = null,
        sprite2 = SnakSprite2.lyingSide;

  const SnakSpriteSheet.rolling({
    super.key,
    this.width,
    this.height,
  })  : sprite = null,
        sprite2 = SnakSprite2.rolling;

  /// Pixel width of [Assets.images.spritesSheet].
  static const double sheet1Width = 3260;

  /// Pixel height of [Assets.images.spritesSheet].
  static const double sheet1Height = 1834;

  /// Pixel width of [Assets.images.spritesSheet2].
  static const double sheet2Width = 2556;

  /// Pixel height of [Assets.images.spritesSheet2].
  static const double sheet2Height = 1438;

  /// Number of columns in each sheet.
  static const int columnCount = 3;

  /// Number of rows in each sheet.
  static const int rowCount = 2;

  /// Native width of one cell on sheet 1 ([sprites_sheet.png]).
  static double get cellWidth => sheet1Width / columnCount;

  /// Native height of one cell on sheet 1 ([sprites_sheet.png]).
  static double get cellHeight => sheet1Height / rowCount;

  /// Native width of one cell on sheet 2 ([sprites_sheet_2.png]).
  static double get sheet2CellWidth => sheet2Width / columnCount;

  /// Native height of one cell on sheet 2 ([sprites_sheet_2.png]).
  static double get sheet2CellHeight => sheet2Height / rowCount;

  final SnakSprite? sprite;

  /// When set, draws from [Assets.images.spritesSheet2] instead of
  /// [Assets.images.spritesSheet].
  final SnakSprite2? sprite2;

  /// When null, uses [cellWidth].
  final double? width;

  /// When null, uses [cellHeight].
  final double? height;

  @override
  Widget build(BuildContext context) {
    final s1 = sprite;
    final s2 = sprite2;
    assert(
      (s1 != null) ^ (s2 != null),
      'Provide exactly one of sprite (sheet 1) or sprite2 (sheet 2).',
    );
    final column = s1?.column ?? s2!.column;
    final row = s1?.row ?? s2!.row;
    final assetPath = s2 != null
        ? Assets.images.spritesSheet2.path
        : Assets.images.spritesSheet.path;

    final sheetW = s2 != null ? sheet2Width : sheet1Width;
    final sheetH = s2 != null ? sheet2Height : sheet1Height;
    final cellW = sheetW / columnCount;
    final cellH = sheetH / rowCount;

    final outW = width ?? cellW;
    final outH = height ?? cellH;
    final sx = outW / cellW;
    final sy = outH / cellH;
    final left = -column * cellW * sx;
    final top = -row * cellH * sy;

    return SizedBox(
      width: outW,
      height: outH,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: left,
            top: top,
            width: sheetW * sx,
            height: sheetH * sy,
            child: Image.asset(
              assetPath,
              width: sheetW * sx,
              height: sheetH * sy,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ],
      ),
    );
  }
}
