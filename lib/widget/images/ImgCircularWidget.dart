import 'package:flutter/material.dart';
import 'package:futzada/api/api.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImgCircularWidget extends StatelessWidget {
  final double width;
  final double height;
  final String? image;
  final Color? borderColor;

  const ImgCircularWidget({
    super.key, 
    required this.width, 
    required this.height,
    required this.image,
    this.borderColor
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR URL DA IMAGEM DO USUARIO
    String urlImage = AppImages.user_default;
    //VERIFI CAR SE IMAGEM NÃO SETÁ VAZIA
    if(image != null){
      if (image!.contains('/storage')) {
        urlImage = AppApi.uri + image!;
      } else {
        urlImage = image!;
      }
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image != null 
              ? CachedNetworkImageProvider(urlImage) 
              : AssetImage(urlImage) as ImageProvider,
          fit: BoxFit.cover
        ),
        color: AppColors.gray_300,
        border: Border.all(
          color: borderColor != null ? borderColor! : AppColors.gray_500,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(width / 2),
      ),
    );
  }
}