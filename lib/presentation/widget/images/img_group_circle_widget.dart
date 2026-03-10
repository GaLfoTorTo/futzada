import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';

class ImgGroupCircularWidget extends StatelessWidget {
  final double size;
  final List<dynamic>? images;
  final Color? borderColor;
  final String side;

  const ImgGroupCircularWidget({
    super.key, 
    required this.size, 
    this.images,
    this.borderColor,
    this.side = "left"
  });

  static const int max = 3;
  static const double coverage = 0.6;

  @override
  Widget build(BuildContext context) {
    final imgs = images ?? [AppImages.userDefault, AppImages.userDefault];

    final bool hasExtra = imgs.length > max;
    final int extraCount = imgs.length - max;
    final visibleItems = hasExtra ? imgs.take(max).toList() : imgs;
    final totalItems = visibleItems.length + (hasExtra ? 1 : 0);
    final spacing = size * coverage;

    return Container(
      width: size + spacing * (totalItems - 1),
      height: size,
      margin: EdgeInsets.only(
        right: side == "left" && hasExtra ? coverage * size : 0, 
        left: side == "right" && hasExtra ? coverage * size : 0, 
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          ...List.generate(visibleItems.length, (index) {
            if(side == "right"){
              return Positioned(
                left: index * spacing,
                child: ImgCircularWidget(
                  size: size,
                  borderColor: borderColor,
                  image: visibleItems[index],
                ),
              );
            }
            return Positioned(
              right: index * spacing,
              child: ImgCircularWidget(
                size: size,
                borderColor: borderColor,
                image: visibleItems[index],
              ),
            );

          }),

          /// Avatar +N
          if (hasExtra)...[
            if(side == "left")...[
              Positioned(
                left: 4.5 * spacing,
                child: Container(
                  width: size - 10,
                  height: size - 10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(size / 2),
                  ),
                  child: Text(
                    "+$extraCount",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                )
              ),
            ]else...[
              Positioned(
                right: 3.5 * spacing,
                child: Container(
                  width: size - 10,
                  height: size - 10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(size / 2),
                  ),
                  child: Text(
                    "+$extraCount",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                )
              ),
            ]
          ]
        ],
      ),
    );
  }
}