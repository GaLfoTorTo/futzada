import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/alerts/alert_widget.dart';

class AppHelper {
  //VERIFICAÇÃO DE COMPLEXIDADE DE SENHAS
  static Map<String, dynamic> complexidadeSenha(String senha) {
    //PADRÕES DE COMPLEXIDADE 
    RegExp padraoLetras = RegExp(r'[a-zA-Z]');
    RegExp padraoNumeros = RegExp(r'[0-9]');
    RegExp padraoCaracteresEspeciais = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    //VERIFICAR COMPRIMENTO DA SENHA
    if (senha.length < 8) {
      Map<String, dynamic> indicador = {
        "indicador": "Fraca",
        "color": AppColors.red_300
      };
      return indicador;
    }
    //VERIFICAR SE SENHA CONTÉM LETRAS MAIÚSCULAS E MINÚSCULAS
    if (!padraoLetras.hasMatch(senha)) {
      Map<String, dynamic> indicador = {
        "indicador": "Fraca",
        "color": AppColors.red_300
      };
      return indicador;
    }
    //VERIFICAR SE SENHA CONTÉM NÚMEROS
    if (!padraoNumeros.hasMatch(senha)) {
      Map<String, dynamic> indicador = {
        "indicador": "Intermediária",
        "color": AppColors.orange_300
      };
      return indicador;
    }
    //VERIFICAR SE SENHA CONTÉM CARACTERES ESPECIÁIS
    if (!padraoCaracteresEspeciais.hasMatch(senha)) {
      Map<String, dynamic> indicador = {
        "indicador": "Intermediária",
        "color": AppColors.orange_300
      };
      return indicador;
    }
    //SE SENHA CONTEMPLAR TODOS OS PARAMETROS
    Map<String, dynamic> indicador = {
      "indicador": "Forte",
      "color": AppColors.green_300
    };
    return indicador;
  }

  //CONVERTER SVG EM STRING 
  static Future<String> svgToString(String assetPath) async {
    //CARREGAR SVG
    String svgString = await rootBundle.loadString(assetPath);
    //RETORNAR SVG EM FORMATO DE STRING
    return svgString;
  }

  //FUNÇÃO PARA CONVERTER CORES PARA HEXADECIMAL
  static String convertColor(Color color){
    //CONVERSÃO
    String colorHex = color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    //REMOVER FF RESTANTE DA CONVERSÃO
    colorHex = colorHex.substring(2); 
    //RETORNAR COR CONVERTIDA
    return colorHex;
  }

  //FUNÇÃO PARA ALTERAR COR DE ESTAMPAS DO SVG
  static String alterSvgColor(String svg, String estampa, bool checked, Color color) {
    //FORMATAR COR PARA HEX
    String colorSelected = convertColor(color);
    //VERIFICAR SE ESTAMAPA ESTÁ SELECIONADA
    if (checked == true) {
      //BUSCAR ESTAMAPA NO SVG E ALTERAR A COR
      svg = svg.replaceAll(
        'id="$estampa"',
        'id="$estampa" fill="#$colorSelected"',
      );
    } else {
      //VERIFICAR SE ESTAMPA RECEBIDA NÃO E O BG
      if (estampa != 'bg') {
        //BUSCAR ESTAMPA NO SVG E REMOVER COR
        svg = svg.replaceAll(
          'id="$estampa"',
          'id="$estampa" fill="none"',
        );
      }
    }
    //RETORNAR SVG RECOLORIDO
    return svg;
  }

  //FUNÇÃO PARA DEFINIR POSIÇÃO PRINCIPAL DO USUARIO
  static String setMainPosition(String svg){
    //FORMATAR COR DE INDICADOR DE POSIÇÃO PRINCIPAL
    String goldColor = convertColor(AppColors.yellow_500);
    //ADICIONAR FUNÇÃO PRINCIPAL DA POSIÇÃO
    svg = svg.replaceAll(
      'id="main" fill="none"',
      'id="main" fill="#$goldColor"'
    );
    //RETORNAR NOVO SVG
    return svg;
  }

  static String saudacaoPeriodo(){
    //BUSCAR HORA ATUAL
    DateTime now = DateTime.now();
    //TRANSFORMAR HORA EM INTEIRO
    int hour = now.hour;
    //VERIFICAR PERIDO DO DIA (MANHÃ,TARDE, NOITE)
    if (hour >= 5 && hour < 12) {
      return 'Bom Dia';
    } else if (hour >= 12 && hour < 18) {
      return 'Boa Tarde';
    } else {
      return 'Boa Noite';
    }
  }

  //FUNÇÃO PARA MOSTRAR ALERTA DE ERRO
  static void erroMessage(context, message) {
    final snackBar = AlertMessageWidget.createSnackBar(
      message: message,
      type: 'Error'
    );
    //EXIBIR ALERTA
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //FUNÇÃO PARA TRATAMENTO DE ERROS
  static Map<String, dynamic> tratamentoErros(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        //RETORNO PARA CONEXÃO CANCELADA
        return {
          'status': 504,
          'message':'Operação cancelada!'
        };
      case DioExceptionType.connectionTimeout || DioExceptionType.sendTimeout || DioExceptionType.receiveTimeout:
        //RETORNO PARA TEMPO EXPIRADO
        return {
          'status': 408,
          'message':'Conexão expirada!'
        };
      case DioExceptionType.badResponse:
        //RESGATAR  MENSAGEM DE ERRO
        var errorMessage = error.response?.data['message'];
        //RETORNO PARA TEMPO EXPIRADO
        return {
          'status': 400,
          'message': errorMessage
        };
      case DioExceptionType.unknown:
        //RETORNO PARA ERRO DESCONHECIDO
        return {
          'status': 500,
          'message':'Erro no servidor!'
        };
      default:
        //RETORNO PARA ERRO DESCONHECIDO
        return {
          'status': 504,
          'message':'Erro no servidor!'
        };
    }
  }
  //FUNÇÃO PARA RESGATAR ALTURA DO DISPOSITIVO
  static Map<String, double> getDimensions(BuildContext context){
    var dimensions = MediaQuery.of(context).size;
    return{
      'width': dimensions.width,
      'height': dimensions.height,
    };
  }

  //ESCOLHER TOM MAIS CLARO DA COR
  static Color brightnessColor(color){
    var newKey; 
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

  //FUNÇÃO PARA RESGATAR A ALTURA DA TELA
  static double screenHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
  
  //FUNÇÃO PARA RESGATAR A LARGURA DA TELA
  static double screenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  //FUNÇÃO PARA ESCONDER O TECLADO
  static void hideKeyboard(BuildContext context){
    FocusScope.of(context).requestFocus(FocusNode());
  }

  //FUNÇÃO PARA DEFINIR COR DO STATUS BAR
  static Future<void>setStatusBarColor(Color color) async{
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color)
    );
  }

  //FUNÇÃO PARA ALTERAR HORIENTAÇÃO DO CELULRA
  static bool alterOrientation(BuildContext context, bool orientation){
    final viewInsert = View.of(context).viewInsets;
    if(orientation){
      return viewInsert.bottom == 0;
    }else{
      return viewInsert.bottom != 0;
    }
  }

  //FUNÇÃO PARA EXIBIR TELA CHEIA
  static void setFullScreen(bool enable){
    SystemChrome.setEnabledSystemUIMode(enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge);
  }

  //ALTERAR A EXIBIÇÃO DE SENHA
  static bool toggleVisibility(bool visible) {
    return visible = !visible;
  }
}
