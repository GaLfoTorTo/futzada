import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';

class ImgGroupCircularWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<dynamic>? images;
  final Color? borderColor;
  final String side;

  const ImgGroupCircularWidget({
    super.key, 
    required this.width, 
    required this.height,
    this.images,
    this.borderColor,
    this.side = "right"
  });

  @override
  Widget build(BuildContext context) {
    final imgs = images ?? const [AppImages.userDefault, AppImages.userDefault];
    double sideExtra = (width * imgs.length) - ((width * imgs.length) - 35);

    return Container(
      width: (width * imgs.length) - sideExtra,
      height: height,
      alignment: side == "left" ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        children: List.generate(imgs.length, (i){
          final index = side == "left" ? imgs.length - 1 - i : i;
          final position = i * 23.0;
          
          return Positioned(
            left: side == "right" ? position : null,
            right: side == "left" ? position : null,
            child: ImgCircularWidget(
              width: width ,
              height: height ,
              image: images != null ? imgs[index] : null,
              borderColor: borderColor,
            ),
          );
        })
      ), 
    );
  }
}