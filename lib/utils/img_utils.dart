import 'package:flutter/material.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/models/event_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImgUtils {
  //FUNÇÃO PARA RESGATAR IMAGEM DO EVENTO
  static ImageProvider getEventImg(EventModel event){
    //RESGATAR IMAGEM DA PELADA
    final imgProvider = event.photo != null
      ? CachedNetworkImageProvider(event.photo!)
      : const AssetImage(AppImages.gramado) as ImageProvider;
      return imgProvider;
  }
  
  static ImageProvider getUserImg(UserModel user){
    //RESGATAR IMAGEM DA PELADA
    final imgProvider = user.photo != null
      ? CachedNetworkImageProvider(user.photo!)
      : const AssetImage(AppImages.userDefault) as ImageProvider;
      return imgProvider;
  }
}