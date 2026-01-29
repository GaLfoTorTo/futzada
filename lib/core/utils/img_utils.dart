import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImgUtils {
  //FUNÇÃO PARA RESGATAR IMAGEM DO EVENTO
  static ImageProvider getEventImg(String? photo){
    //RESGATAR IMAGEM DA PELADA
    final imgProvider = photo != null
      ? CachedNetworkImageProvider(photo)
      : const AssetImage(AppImages.cardFootball) as ImageProvider;
      return imgProvider;
  }

  //FUNÇÃO PARA RESGATAR IMAGEM DO USUARIO
  static ImageProvider getUserImg(String? photo){
    //RESGATAR IMAGEM DA PELADA
    final imgProvider = photo != null
      ? CachedNetworkImageProvider(photo)
      : const AssetImage(AppImages.userDefault) as ImageProvider;
      return imgProvider;
  }

  //FUNÇÃO PARA RESGATAR IMAGEM DO ENDEREÇO
  static List<ImageProvider> getAddressImg(List<String>? photos){
    //LISTA DE IMAGENS
    List<ImageProvider> arrPhotos = [];
    //VERIFICAR SE EXISTEM FOTOS DO LOCAL
    if(photos != null){
      for(var photo in photos){
        //RESGATAR IMAGEM DA PELADA
        arrPhotos.add(CachedNetworkImageProvider(photo));
      }
    }
    return arrPhotos;
  }
}