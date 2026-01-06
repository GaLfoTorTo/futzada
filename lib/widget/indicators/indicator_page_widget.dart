import 'package:futzada/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IndicatorPageWidget extends StatelessWidget {
  //CONTROLLADOR DE PAGINAS
  final PageController pageController;
  final int options;
  const IndicatorPageWidget({
    super.key,
    required this.pageController,
    required this.options
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SmoothPageIndicator(
      controller: pageController,
      count: options,
      effect: ExpandingDotsEffect(
        dotHeight: 8,
        dotWidth: 8,
        activeDotColor: isDark ? AppColors.white : AppColors.blue_500,
        dotColor: AppColors.gray_500,
        expansionFactor: 2,
      )
    );
  }
}