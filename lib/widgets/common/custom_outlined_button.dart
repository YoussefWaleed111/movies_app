import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;
  final Color? backgroundColor;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 54.0,
    this.icon,
    this.borderColor,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppColors.figmaYellow;
    final effectiveTextColor = textColor ?? AppColors.figmaYellow;
    final effectiveBgColor = backgroundColor ?? Colors.transparent;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: effectiveTextColor,
        backgroundColor: effectiveBgColor,
        minimumSize: Size.fromHeight(height),
        side: BorderSide(color: effectiveBorderColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: effectiveTextColor),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: AppTypography.button.copyWith(
              color: effectiveTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
