import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonGamesWidget extends StatelessWidget {
  const SkeletonGamesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray_300.withAlpha(100),
      highlightColor: AppColors.gray_300.withAlpha(150),
      period: Duration(milliseconds: 1000),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 30,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white,
              ),
            ),
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white,
              ),
            ),
            Center(
              child: Container(
                width: 100,
                height: 20,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.white,
                ),
              ),
            ),
            Container(
              width: 120,
              height: 30,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white,
              ),
            ),
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white,
              ),
            ),
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}