import 'package:flutter/material.dart';
//import 'package:futzada/core/theme/app_colors.dart';

class ManagerHelper {
  //FUNÇÃO DE GERAÇÃO DE OBJETO PADRÃO DE EMBLEMA
  static Map<String, Map<String, dynamic>> configEmblem(Color primaryColor) {
    //DEFINIR CONFIGURAÇÃO INICIAL DE EMBLEMA
    return {
    'bg': {
      'checked': true,
      'color': primaryColor,
    },
    'mt': {
      'checked': false,
      'color': null,
    },
    'mb': {
      'checked': false,
      'color': null,
    },
    'ml': {
      'checked': false,
      'color': null,
    },
    'mr': {
      'checked': false,
      'color': null,
    },
    'lv': {
      'checked': false,
      'color': null,
    },
    'lh': {
      'checked': false,
      'color': null,
    },
  };
}

//FUNÇÃO DE GERAÇÃO DE OBJETO PADRÃO DE UNIFORME
static Map<String, Map<String, dynamic>> configUniform(Color primaryColor) {
  //DEFINIR CONFIGURAÇÃO INICIAL DE EMBLEMA
  return {
      'bg': {
        'checked': true,
        'color': primaryColor,
      },
      'mt': {
        'checked': false,
        'color': null,
      },
      'mb': {
        'checked': false,
        'color': null,
      },
      'ml': {
        'checked': false,
        'color': null,
      },
      'mr': {
        'checked': false,
        'color': null,
      },
      'lvc': {
        'checked': false,
        'color': null,
      },
      'lvl': {
        'checked': false,
        'color': null,
      },
      'lhc': {
        'checked': false,
        'color': null,
      },
      'lhl': {
        'checked': false,
        'color': null,
      },
      'mc': {
        'checked': false,
        'color': null,
      },
      'mm': {
        'checked': false,
        'color': null,
      },
      'mxl': {
        'checked': false,
        'color': null,
      },
    };
  }
}