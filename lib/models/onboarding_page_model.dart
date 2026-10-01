class OnboardingPageModel {
  final int pageIndex;
  final String title;
  final String subtitle;
  final String actionButtonText;
  final bool hasBackButton;
  final String? posterAsset;
  final bool isCardOverlay;

  const OnboardingPageModel({
    required this.pageIndex,
    required this.title,
    required this.subtitle,
    required this.actionButtonText,
    this.hasBackButton = true,
    this.posterAsset,
    this.isCardOverlay = true,
  });
}
