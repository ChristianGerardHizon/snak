import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A reusable cached avatar widget that displays an image from a URL
/// with a customizable placeholder.
///
/// Uses [CachedNetworkImage] for efficient disk/memory caching.
class CachedAvatar extends StatelessWidget {
  const CachedAvatar({
    super.key,
    this.imageUrl,
    this.radius = 20,
    this.placeholder,
    this.placeholderIcon = Icons.person,
    this.onTap,
  });

  /// The URL of the image to display. If null, shows the placeholder.
  final String? imageUrl;

  /// The radius of the avatar. Defaults to 20.
  final double radius;

  /// Custom placeholder widget. If null, uses a default CircleAvatar
  /// with [placeholderIcon].
  final Widget? placeholder;

  /// The icon to show in the default placeholder. Defaults to [Icons.person].
  final IconData placeholderIcon;

  /// Optional callback when the avatar is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultPlaceholder = CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Icon(
        placeholderIcon,
        size: radius,
        color: theme.colorScheme.primary,
      ),
    );

    final placeholderWidget = placeholder ?? defaultPlaceholder;

    if (imageUrl == null || imageUrl!.isEmpty) {
      return onTap != null
          ? GestureDetector(onTap: onTap, child: placeholderWidget)
          : placeholderWidget;
    }

    final avatar = CachedNetworkImage(
      imageUrl: imageUrl!,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          placeholderIcon,
          size: radius,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      errorWidget: (context, url, error) => placeholderWidget,
    );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: avatar)
        : avatar;
  }
}
