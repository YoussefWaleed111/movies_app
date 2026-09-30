import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

enum PlaceholderType {
  poster,
  heroPoster,
  cast,
  screen,
  avatar,
  logo,
  lock,
  generic,
}

class NonImagePlaceholder extends StatelessWidget {
  final PlaceholderType type;
  final String? label;
  final IconData? customIcon;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isCircle;
  final Color? backgroundColor;
  final Color? accentColor;

  const NonImagePlaceholder({
    super.key,
    required this.type,
    this.label,
    this.customIcon,
    this.width,
    this.height,
    this.borderRadius = 10.0,
    this.isCircle = false,
    this.backgroundColor,
    this.accentColor,
  });

  IconData get _defaultIcon {
    if (customIcon != null) return customIcon!;
    switch (type) {
      case PlaceholderType.poster:
      case PlaceholderType.heroPoster:
        return Icons.local_movies_rounded;
      case PlaceholderType.cast:
        return Icons.person_outline_rounded;
      case PlaceholderType.screen:
        return Icons.movie_creation_outlined;
      case PlaceholderType.avatar:
        return Icons.account_circle_rounded;
      case PlaceholderType.logo:
        return Icons.play_circle_fill_rounded;
      case PlaceholderType.lock:
        return Icons.lock_outline_rounded;
      case PlaceholderType.generic:
        return Icons.image_not_supported_outlined;
    }
  }

  String get _defaultLabel {
    if (label != null) return label!;
    switch (type) {
      case PlaceholderType.poster:
        return 'Poster';
      case PlaceholderType.heroPoster:
        return 'Watch Now Poster';
      case PlaceholderType.cast:
        return 'Cast';
      case PlaceholderType.screen:
        return 'Screen';
      case PlaceholderType.avatar:
        return 'Avatar';
      case PlaceholderType.logo:
        return 'Cinema Logo';
      case PlaceholderType.lock:
        return 'Security';
      case PlaceholderType.generic:
        return 'Placeholder';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.placeholderDark;
    final accent = accentColor ?? AppColors.textSecondary;

    Widget containerContent = Stack(
      alignment: Alignment.center,
      children: [
        // Diagonal watermark cross / grid pattern lines for wireframe feel
        CustomPaint(
          size: Size(width ?? double.infinity, height ?? double.infinity),
          painter: _PlaceholderGridPainter(color: AppColors.placeholderBorder.withOpacity(0.3)),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _defaultIcon,
              size: type == PlaceholderType.heroPoster ? 48 : (type == PlaceholderType.avatar ? 36 : 28),
              color: accent,
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                _defaultLabel.toUpperCase(),
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall.copyWith(
                  color: accent.withValues(alpha: 0.85),
                  fontSize: type == PlaceholderType.avatar ? 9.5 : 10.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );

    if (isCircle) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.placeholderBorder, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: ClipOval(child: containerContent),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.placeholderBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: containerContent,
      ),
    );
  }
}

class _PlaceholderGridPainter extends CustomPainter {
  final Color color;
  _PlaceholderGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Subtle diagonal crossing lines to emphasize wireframe placeholder architecture
    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
