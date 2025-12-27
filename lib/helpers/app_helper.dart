import 'dart:async';
import 'dart:ui' as ui;
import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
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
  
  //FUNÇÃO PARA AJUSTAR A COR DA BORDAS DAS POSIÇÕES
  static Color setColorPosition(dynamic position){
    //VERIFICAR AREA DO CAMPO
    switch (position) {
      case 'ata':
        return AppColors.blue_300;
      case 'mei':
        return AppColors.green_300;
      case 'zag':
        return AppColors.red_300;
      case 'lat':
        return AppColors.orange_300;
      case 'gol':
        return AppColors.yellow_300;
      default:
        return AppColors.white;
    }
  }

  //FUNÇÃO PARA AJUSTAR COR DE ITEMS DE ACORDO COM BRILHO DA IMAGEM
  static Future<bool> isImageDark(ImageProvider imageProvider) async {
    final ImageStream imageStream = imageProvider.resolve(const ImageConfiguration());
    final Completer<ui.Image> completer = Completer<ui.Image>();

    void listener(ImageInfo info, bool _) {
      completer.complete(info.image);
      imageStream.removeListener(ImageStreamListener(listener));
    }

    imageStream.addListener(ImageStreamListener(listener));

    final ui.Image image = await completer.future;
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return false;

    int darkPixels = 0;
    int totalPixels = image.width * image.height;

    for (int i = 0; i < byteData.lengthInBytes; i += 4 * 50) {
      final int r = byteData.getUint8(i);
      final int g = byteData.getUint8(i + 1);
      final int b = byteData.getUint8(i + 2);
      final double brightness = (r * 0.299 + g * 0.587 + b * 0.114);
      if (brightness < 128) darkPixels++;
    }

    return darkPixels > totalPixels / 2;
  }

  //VERIFICAR SE EVENTO ESTA ACONTECENDO NO MOMENTO
  static bool verifyInLive(startDate, endDate) {
    //CONVERTER DATA E HORARIO DO EVENTO
    DateTime eventDateTimeStart = DateFormat("dd/MM/yyyy HH:mm").parse("$startDate");
    DateTime eventDateTimeEnd = DateFormat("dd/MM/yyyy HH:mm").parse("$endDate");
    //COMPARAR DATAS PARA VERIFICAÇÃO DE AO VIVO
    return DateTime.now().isAfter(eventDateTimeStart) && DateTime.now().isBefore(eventDateTimeEnd);
  }

  //FUNÇÃO PARA RETORNAR COR DE PONTUAÇÃO
  static Map<String, dynamic> setColorPontuation(dynamic value) {
    //VERIFICAR PONTUAÇÃO
    switch (value) {
      case > 0:
        return {
          'color': AppColors.green_300,
          'icon': Icons.arrow_upward_outlined 
        };
      case < 0:
        return {
          'color': AppColors.red_300,
          'icon': Icons.arrow_downward_outlined 
        };
      default:
        return {
          'color': AppColors.gray_300,
          'icon': Icons.rectangle_rounded
        };
    }
  }
  
  //FUNÇÃO PARA RETORNAR COR DE PONTUAÇÃO
  static Map<String, dynamic> setRankColocation(String? value) {
    switch (value) {
      case 'up':
        return {
          'color': AppColors.green_300,
          'icon': Icons.arrow_upward_outlined 
        };
      case 'down':
        return {
          'color': AppColors.red_300,
          'icon': Icons.arrow_downward_outlined 
        };
      default:
        return {
          'color': AppColors.gray_300,
          'icon': Icons.rectangle_rounded
        };
    }
  }

  //FUNÇÃO PARA DEFINIR ICONE E COR DE STATUS DE JOGADOR
  static Map<String, dynamic> setStatusPlayer(PlayerStatus status){
    //VERIFICAR PONTUAÇÃO DO JOGADOR (VALORES POSITIVOS)
    switch (status) {
      case PlayerStatus.Avaliable:
        return {
          'color': AppColors.green_300,
          'icon': AppIcones.check_circle_solid
        };
      case PlayerStatus.Out:
        return {
          'color': AppColors.red_300, 
          'icon': AppIcones.times_circle_solid 
        };
      case PlayerStatus.Doubt:
        return {
          'color': AppColors.yellow_500, 
          'icon': AppIcones.question_circle_solid 
        };
      case PlayerStatus.None:
        return {
          'color': AppColors.gray_300, 
          'icon': Icons.minimize_rounded 
        };
    }
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
    //FORMATAR OLD COR PARA HEX
    String oldColorSelected = getFillColor(svg, estampa);
    //VERIFICAR SE SVG CONTEM A COR ANTIGA
    bool existColor = svg.contains('id="$estampa" fill="#$oldColorSelected"');
    bool existNone = svg.contains('id="$estampa" fill="none"');
    //VERIFICAR SE ESTAMAPA ESTÁ SELECIONADA
    if(checked){
      //VERIFICAR SE ESTAMPA ESTAVA COLORIDA
      if(existColor){
        //BUSCAR ESTAMAPA NO SVG E ALTERAR A COR
        svg = svg.replaceAll(
          'id="$estampa" fill="#$oldColorSelected"',
          'id="$estampa" fill="#$colorSelected"',
        );
      }
      //VERIFICAR SE ESTAMPA NÃO ESTAVA COLORIDA
      if(existNone){
        //BUSCAR ESTAMAPA NO SVG E ALTERAR A COR
        svg = svg.replaceAll(
          'id="$estampa" fill="none"',
          'id="$estampa" fill="#$colorSelected"',
        );
      }
    } else {
      //BUSCAR ESTAMPA NO SVG E REMOVER COR
      svg = svg.replaceAll(
        'id="$estampa" fill="#$oldColorSelected"',
        'id="$estampa" fill="none"',
      );
    }
    //RETORNAR SVG RECOLORIDO
    return svg;
  }
  
  //FUNÇÃO PARA RESGATAR A COR DO SVG
  static String getFillColor(String svg, String estampa) {
    return svg.contains('id="$estampa" fill="#') 
      ? svg.split('id="$estampa" fill="#')[1].split('"')[0] 
      : '#04D361';
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
  
  //FUNÇÃO PARA ADICIONAR A COR DO EMBLEMA PRINCIPAL
  static Future<String> mainPosition(posicao) async {
    //CONVERTER SVG TO STRING
    String posicaoString = await AppHelper.svgToString(posicao);
    //ALTERAR COR DA ESTAMPA SELECIONADA NO EMBLEMA
    posicaoString = AppHelper.setMainPosition(posicaoString);
    //RETORNAR POSIÇÃO
    return posicaoString;
  } 

  //FUNDAÇÃO DE SAUDAÇÃO DE ACORDO COM O PERÍODO DO DIA
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

  //FUNÇÃO PARA EXIBIÇÃO DE OVERLAY
  static void showLoadOverlay(BuildContext context, int duration) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Container(
            color: Colors.black.withAlpha(150),
          ),
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.green_300,
            )
          ),
        ],
      ),
    );
    //ADICIONAR OVERLAY NA PAGINA
    overlay.insert(entry);
    Future.delayed(Duration(seconds: duration), () => entry.remove());
  }

  //FUNÇÃO PARA MOSTRAR ALERTA DE ERRO
  static void feedbackMessage(context, message, {String? type}) {
    final snackBar = AlertMessageWidget.createSnackBar(
      message: message,
      type: type ?? 'Error'
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
  
  //FUNÇÃO PARA FORMATAR DATAS
  static String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return "$day/$month/$year";
  }

  //FUNÇÃO PARA VERIFICAR SE VALOR É UM CEP VALIDO
  static bool isCep(String cep) {
    // REGEX PARA VALIDAR CEP: XXXXX-XXX ou XXXXXXXX
    final cepRegExp = RegExp(r'^\d{5}-?\d{3}$');
    return cepRegExp.hasMatch(cep);
  }

  //FUNÇÃO PARA BUSCAR ENDEREÇO NO VIA CEP
  static dynamic getAddress(String address) async {
    //DEFINIR URL DE BUSCA
    String url = '';
    //VERIFICAR SE VALOR RECEBIDO É CEP
    if(isCep(address)){
      //REMOVER HIFÉN DO CEP SE HOUVER
      String cep = address.replaceAll('-','');
      //DEFINIR URL DE BUSCA PARA ENDEREÇO
      url = 'https://viacep.com.br/ws/${cep}/json/';
    }else{
      //SEPARAR ENDEREÇO RECEBIDO POR ESPAÇOS
      List<String> addressSplited = address.split(' - ');
      //VERIFICAR SE O ENDEREÇO FOI INFORMADO COMPLETAMENTE (LOGRADOURO, CIDADE E UF)
      if(addressSplited.length < 3){
        return {'error': 'Informe um endereço no formato compativel!'};
      }
      //VERIFICAR SE LOGRADOURO E CIDADE TEM NO MINIMO 3 CARACTERES
      if(addressSplited[0].length < 2 && addressSplited[1].length < 2){
        return {'error': 'Logradouro e Cidades devem conter no minimo 3 caracteres!'};
      }
      //RESGATAR PARAMETROS DE ENDEREÇO
      String logradouro = addressSplited[0];
      String cidade = addressSplited[1];
      String uf = addressSplited[2].trim();
      //DEFINIR URL DE BUSCA PARA ENDEREÇO
      url = 'https://viacep.com.br/ws/${uf.toUpperCase()}/${Uri.encodeComponent(cidade)}/${Uri.encodeComponent(logradouro)}/json/';
    }
    //VERIFICAR SE URL NÃO ESTA VAZIA
    if(url.isNotEmpty){
      try {
        //FAZER REQUISIÇÃO AO VIA CEP
        var resp = await Dio().get(url);
        //VERIFICAR SE A RESPOSTA E VALIDA
        if (resp.statusCode == 200) {
          //VERIFICAR SE ENDEREÇO FOI ENCONTRADO
          if(resp.data.length == 0){
            //RETORNAR ERRO
            return {"error": "Nenhum endereço encontrado!"};  
          }
          //RETORNAR ENDEREÇOS
          return resp.data;
        } else {
          //RETORNAR ERRO
          return {"error": "Nenhum endereço encontrado!"};
        }
      } catch (e) {
        print(e);
        //RETORNAR ERRO DE REQUISIÇÃO
        return {"error": 'Não foi possível buscar um endereço'};
      }
    }
    return {};
  }

  /// Inicializa a detecção de plataforma
  static Future<String> getDevicePlatform() async {    
    return io.Platform.isIOS ? 'IOS' : 'Android';
  }
}
