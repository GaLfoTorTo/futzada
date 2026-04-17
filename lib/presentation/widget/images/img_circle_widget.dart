import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/img_helper.dart';

class ImgCircularWidget extends StatelessWidget {
  final double size;
  final String? image;
  final String? element;
  final Color? borderColor;

  const ImgCircularWidget({
    super.key, 
    required this.size, 
    this.image,
    this.element,
    this.borderColor
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider getImg(){
      if(element == "event") return ImgHelper.getEventImg(image);
      return ImgHelper.getUserImg(image);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: getImg(),
          fit: BoxFit.cover
        ),
        color: AppColors.grey_300,
        border: Border.all(
          color: borderColor ?? AppColors.grey_500,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}