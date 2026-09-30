import 'package:flutter/material.dart';

class OnboardingPageModel {
  final int pageIndex;
  final String title;
  final String subtitle;
  final String actionButtonText;
  final bool hasBackButton;
  final String posterLabel;
  final String movieTag;
  final Gradient backgroundGradient;

  const OnboardingPageModel({
    required this.pageIndex,
    required this.title,
    required this.subtitle,
    required this.actionButtonText,
    this.hasBackButton = true,
    required this.posterLabel,
    required this.movieTag,
    required this.backgroundGradient,
  });
}
