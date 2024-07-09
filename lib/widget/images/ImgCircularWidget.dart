import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class ImgCircularWidget extends StatelessWidget {
  final double width;
  final double height;
  final String image;

  const ImgCircularWidget({
    super.key, 
    required this.width, 
    required this.height,
    required this.image
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:  AssetImage(
            image,//ADICIONAR IMAGEM
          ),
          fit: BoxFit.fill
        ),
        color: AppColors.blue_500,
        border: Border.all(
          color: AppColors.gray_500,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(width / 2),
      ),
    );
  }
}