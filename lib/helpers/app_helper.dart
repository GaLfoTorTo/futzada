import 'dart:convert';

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

  static String setMainPosition(String svg){
    //FORMATAR COR DE INDICADOR DE POSIÇÃO PRINCIPAL
    String goldColor = convertColor(AppColors.yellow_500);
    //BUSCAR SVG
    svg = svg.replaceAll('id="main" fill="none"', 'fill="$goldColor"');
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

  static Map<String, dynamic> tratamentoErros(DioException error) {
    switch (error) {
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
}
