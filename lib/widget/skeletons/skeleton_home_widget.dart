import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonHomeWidget extends StatelessWidget {
  const SkeletonHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray_300.withOpacity(0.3),
      highlightColor: AppColors.gray_300.withOpacity(0.6),
      period: Duration(milliseconds: 1000),
      child: Container(
        width: double.maxFinite,
        height: 130,
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.white,
                    ),
                  ),
                  Container(
                    width: 200.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}