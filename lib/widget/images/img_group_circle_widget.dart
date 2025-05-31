import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImgGroupCircularWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<dynamic>? images;
  final Color? borderColor;

  const ImgGroupCircularWidget({
    super.key, 
    required this.width, 
    required this.height,
    this.images,
    this.borderColor
  });

  @override
  Widget build(BuildContext context) {
    //VERIFICAR SE FORAM RECEBIDAS IMAGENS
    final imgs = images ?? const [AppImages.userDefault, AppImages.userDefault];
    
    return SizedBox(
      width: width + (imgs.length * 10) * 2,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(imgs.length, (i) {
          //RESGATAR IMAGEM
          var image = imgs[i];
          return Positioned(
            left: i * 25.0,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image != null 
                      ? CachedNetworkImageProvider(image) 
                      : AssetImage(image) as ImageProvider,
                  fit: BoxFit.cover
                ),
                color: AppColors.gray_300,
                border: Border.all(
                  color: borderColor != null ? borderColor! : AppColors.gray_500,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(width / 2),
              ),
            )
          );
        }),
      ),
    );
  }
}