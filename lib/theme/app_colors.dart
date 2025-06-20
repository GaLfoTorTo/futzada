import 'dart:math';
import 'package:futzada/theme/app_images.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class AppColors {
  AppColors._();
  //GREEN
  static const green_700 = Color(0xFF015924);
  static const green_500 = Color(0xFF03983E);
  static const green_300 = Color(0xFF04D361);
  static const green_100 = Color(0xFF93D6B1);
  //BEGE
  static const bege_700 = Color(0xFF946C4B);
  static const bege_500 = Color(0xFFD1A57A);
  static const bege_300 = Color(0xFFF6D1A8);
  static const bege_100 = Color(0xFFF8E3CB);
  //ORANGE
  static const orange_700 = Color(0xFF9B2908);
  static const orange_500 = Color(0xFFEB3D0B);
  static const orange_300 = Color(0xFFEF5F08);
  static const orange_100 = Color(0xFFE7AC88);
  //RED
  static const red_700 = Color(0xFF660404);
  static const red_500 = Color(0xFFE20505);
  static const red_300 = Color(0xFFF44336);
  static const red_100 = Color(0xFFF3AAA4);
  //YELLOW
  static const yellow_700 = Color(0xFFBF9500);
  static const yellow_500 = Color(0xFFFFC700);
  static const yellow_300 = Color(0xFFFFF500);
  static const yellow_100 = Color(0xFFFFE69C);
  //BLUE
  static const blue_700 = Color(0xFF0C0626);
  static const blue_500 = Color(0xFF140750);
  static const blue_300 = Color(0xFF1F7BF2);
  static const blue_100 = Color(0xFFA1C2EC);
  //PURPLE
  static const purple_700 = Color(0xFF21054E);
  static const purple_500 = Color(0xFF450CA0);
  static const purple_300 = Color(0xFF6610F2);
  static const purple_100 = Color(0xFFAB85E8);
  //CYAN
  static const cyan_700 = Color(0xFF055160);
  static const cyan_500 = Color(0xFF0DCAF0);
  static const cyan_300 = Color(0xFF6EDFF6);
  static const cyan_100 = Color(0xFFBEEFF9);
  //BROWN
  static const brown_700 = Color(0xFF472302);
  static const brown_500 = Color(0xFF9C4D03);
  static const brown_300 = Color(0xFFDF8C3E);
  static const brown_100 = Color(0xFFF8D9BD);
  //BASE
  static const dark_700 = Color(0xFF181818);
  static const dark_500 = Color(0xFF272727);
  static const dark_300 = Color(0xFF454545);
  static const gray_700 = Color(0xFF969696);
  static const gray_500 = Color(0xFFAAAAAA);
  static const gray_300 = Color(0xFFCCCCCC);
  static const light = Color(0xFFE8EDFA);
  static const white = Color(0xFFFFFFFF);
  //TODAS AS CORES EM STRING
  static Map<String, Color> colors = {
    'green_700': green_700,
    'green_500': green_500,
    'green_300': green_300,
    'green_100': green_100,
    'bege_700': bege_700,
    'bege_500': bege_500,
    'bege_300': bege_300,
    'bege_100': bege_100,
    'orange_700': orange_700,
    'orange_500': orange_500,
    'orange_300': orange_300,
    'orange_100': orange_100,
    'red_700': red_700,
    'red_500': red_500,
    'red_300': red_300,
    'red_100': red_100,
    'yellow_700': yellow_700,
    'yellow_500': yellow_500,
    'yellow_300': yellow_300,
    'yellow_100': yellow_100,
    'blue_700': blue_700,
    'blue_500': blue_500,
    'blue_300': blue_300,
    'blue_100': blue_100,
    'purple_700': purple_700,
    'purple_500': purple_500,
    'purple_300': purple_300,
    'purple_100': purple_100,
    'cyan_700': cyan_700,
    'cyan_500': cyan_500,
    'cyan_300': cyan_300,
    'cyan_100': cyan_100,
    'brown_700': brown_700,
    'brown_500': brown_500,
    'brown_300': brown_300,
    'brown_100': brown_100,
    'dark_700': dark_700,
    'dark_500': dark_500,
    'dark_300': dark_300,
    'gray_700': gray_700,
    'gray_500': gray_500,
    'gray_300': gray_300,
    'light': light,
    'white': white,
  };

  //FUNÇÃO PARA CALCULAR A DISTANCIA ENTRE DUAS CORES NO ESPAÇO RGB
  static double colorDistance(Color color1, Color color2) {
    //RESGATAR DIFERENÇA DE VALORES RGB ENTRE AS DUAS CORES
    final rDiff = color1.r - color2.r;
    final gDiff = color1.g - color2.g;
    final bDiff = color1.b - color2.b;
    //RETORNAR VALOR DE COR OBTIDO
    return rDiff * rDiff + gDiff * gDiff + bDiff * bDiff;
  }

  //FUNÇÃO PARA ENCONTRAR A COR MAIS PROXIMA DA CLASSE
  static Color findClosestColor(Color targetColor) {
    //LISTA DE CORES
    List<Color> listColors = AppColors.colors.values.toList();
    //COR PADRÃO 
    Color nearestColor = AppColors.green_300;
    //DISTANCIA MINIMA
    double minDistance = double.infinity;
    //PERCORRER TODAS AS CORES
    for (final appColor in listColors) {
      //CALCULAR DISTANCIA DE COR RECEBIDA COM COR DO LOOP
      final distance = colorDistance(targetColor, appColor);
      //VERIFICAR DISTANCI ENTRE CORES
      if (distance < minDistance) {
        minDistance = distance;
        nearestColor = appColor;
      }
    }
    //RETORNAR COR MAIS PROXIMA
    return nearestColor;
  }
  
  //FUNÇÃO PARA RESGATAR COR PREDOMINANTE DA IMAGEM
  static Future<Color> getDominantColor(String? image) async {
    //DEFINIR COR PADRÃO
    Color colorDefault = AppColors.green_300;
    try {
      //RESGATAR IMAGEM A SER ANALISADA 
      final imageProvider = image != null
        ? NetworkImage(image)
        : const AssetImage(AppImages.gramado) as ImageProvider;
      //GERAR PALETA DE CORES APARTIR DA IMAGEM
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        imageProvider,
        maximumColorCount: 10, //NUMERO MAXIMO DE CORES A SEREM COLETADAS
      );
      //VERIFICAR SE FOI POSSIVEL GERAR A PALETA DE CORES
      if (paletteGenerator.colors.isNotEmpty) {
        // RESGATAR A PRIMEIRA COR DA PALETA DE CORES
        final dominantColor = paletteGenerator.dominantColor?.color;
        //VERIFICAR SE COR PREDOMINANTE FOI ENCONTRADA
        if (dominantColor != null) {
          return dominantColor;
          //ENCONTRAR A COR MAIS PRÓXIMA EM AppColors
          return findClosestColor(dominantColor);
        }
      }
      //RETORNAR COR PADRÃO
      return colorDefault;
    } catch (e) {
      //RETORNAR COR PADRÃO
      return colorDefault;
    }
  }
  
  //ESCOLHER TOM MAIS CLARO DA COR
  static Color brightnessColor(color){
    var newKey = []; 
    //LOOP NAS CORES
    AppColors.colors.forEach((key, value){
      //FILTRAR CORES DO TIPO 100
      if(value == color){
        newKey = key.split('_');
      }
    });
    return AppColors.colors['${newKey[0]}']!;
  }

  //ESCOLHER A COR DO CARD ALEATORIAMENTE
  static Color randomColor(){
    //DEFINIR ARRAY DE ITEMS
    List items = [];
    //LOOP NAS CORES
    AppColors.colors.forEach((key, value){
      //FILTRAR CORES DO TIPO 100
      if(key.contains('100')){
        items.add(value);
      }
    });
    //INSTANCIAR RANDOM
    Random random = Random();
    //SELECIONAR ITEM ALEATORIAMENTE
    int i = random.nextInt(items.length);
    //RETORNAR COR ALEATORIA
    return items[i];
  }
}