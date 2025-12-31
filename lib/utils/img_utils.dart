import 'package:flutter/material.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/models/event_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImgUtils {
  //FUNÇÃO PARA RESGATAR IMAGEM DO EVENTO
  static ImageProvider getEventImg(String? photo){
    //RESGATAR IMAGEM DA PELADA
    final imgProvider = photo != null
      ? CachedNetworkImageProvider(photo)
      : const AssetImage(AppImages.gramado) as ImageProvider;
      return imgProvider;
  }
  
  static ImageProvider getUserImg(String? photo){
    //RESGATAR IMAGEM DA PELADA
    final imgProvider = photo != null
      ? CachedNetworkImageProvider(photo)
      : const AssetImage(AppImages.userDefault) as ImageProvider;
      return imgProvider;
  }
}