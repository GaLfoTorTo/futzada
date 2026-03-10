import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonProfileWidget extends StatelessWidget {
  const SkeletonProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        spacing: 30,
        children: [
          SizedBox(
            height: 420,
            child: Stack(
              alignment: AlignmentGeometry.center,
              children: [
                Column(
                  children: [
                    Container(
                      width: dimensions.width,
                      height: 270,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                        color: AppColors.green_300,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                      ),
                      child: IconButton(
                        onPressed: () => Get.back(), 
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.blue_500,
                        )
                      ),
                    ),
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(10.0),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    spacing: 10,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(100)
                        ),
                        child: Shimmer.fromColors(
                          baseColor: AppColors.grey_300.withAlpha(50),
                          highlightColor: AppColors.grey_300.withAlpha(100),
                          period: const Duration(milliseconds: 1000),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(100)
                            ),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: AppColors.grey_300.withAlpha(50),
                        highlightColor: AppColors.grey_300.withAlpha(100),
                        period: const Duration(milliseconds: 1000),
                        child: Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.white.withAlpha(200),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: AppColors.grey_300.withAlpha(50),
                        highlightColor: AppColors.grey_300.withAlpha(100),
                        period: const Duration(milliseconds: 1000),
                        child: Container(
                          width: 150,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.white.withAlpha(200),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Shimmer.fromColors(
            baseColor: AppColors.grey_300.withAlpha(50),
            highlightColor: AppColors.grey_300.withAlpha(100),
            period: const Duration(milliseconds: 1000),
            child: Column(
              spacing: 15,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                      ),
                    ),
                    Container(
                      width: dimensions.width / 2,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                      ),
                    ),
                  ]
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                        ),
                      ),
                    ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Container(
                        height: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}