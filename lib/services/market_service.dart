import 'package:flutter/material.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';

class MarketService {  
  //ESTADO DE FILTRO PADRÃO DE MERCADO
  Map<String, dynamic> filtrosMarket = {
    'status' : [PlayerStatus.Avaliable.name, PlayerStatus.Out.name, PlayerStatus.Doubt.name, PlayerStatus.None.name],
    'price' : 'Maior preço',
    'media' : '',
    'game' : '',
    'valorization' : '',
    'lastPontuation' : '',
    'nome' : '',
    'bestSide' : '',
    'positions' : [],
  };

  //LISTA DE FILTROS DE METRICA DO MERCADO
  Map<String, List<Map<String, dynamic>>> filterOptions = {
    'price': [
      {
        'id' : '',
        'title': 'Preço',
        'icon': Icons.monetization_on,
        'color': AppColors.gray_300,
      },
      {
        'id' : 'Maior preço',
        'title': 'Maior preço',
        'icon': Icons.arrow_upward,
        'color': AppColors.green_300,
      },
      {
        'id' : 'Menor preço',
        'title': 'Menor preço',
        'icon': Icons.arrow_downward ,
        'color': AppColors.red_300, 
      },
    ],
    'media': [
      {
        'id' : '',
        'title': 'Média',
        'icon': null,
        'color': AppColors.gray_300,
      },
      {
        'id' : 'Maior média',
        'title': 'Maior média',
        'icon': Icons.arrow_upward,
        'color': AppColors.green_300,
      },
      {
        'id' : 'Menor média',
        'title': 'Menor média',
        'icon': Icons.arrow_downward,
        'color': AppColors.red_300, 
      },
    ],
    'games': [
      {
        'id' : '',
        'title': 'Jogos',
        'icon': null,
        'color': AppColors.gray_300,
      },
      {
        'id' : 'Mais jogos',
        'title': 'Mais jogos',
        'icon': Icons.arrow_upward,
        'color': AppColors.green_300,
      },
      {
        'id' : 'Menos jogos',
        'title': 'Menos jogos',
        'icon': Icons.arrow_downward ,
        'color': AppColors.red_300, 
      },
    ],
    'valorization': [
      {
        'id' : '',
        'title': 'Valorização',
        'icon': null,
        'color': AppColors.gray_300,
      },
      {
        'id' : 'Mais valorizados',
        'title': 'Mais valorizados',
        'icon': Icons.arrow_upward,
        'color': AppColors.green_300,
      },
      {
        'id' : 'Menos valorizados',
        'title': 'Menos valorizados',
        'icon': Icons.arrow_downward,
        'color': AppColors.red_300, 
      },
    ],
    'lastPontuation': [
      {
        'id' : '',
        'title': 'Pontuação',
        'icon': null,
        'color': AppColors.gray_300,
      },
      {
        'id' : 'Maior pontuação',
        'title': 'Maior pontuação',
        'icon': Icons.arrow_upward,
        'color': AppColors.green_300,
      },
      {
        'id' : 'Menor pontuação',
        'title': 'Menor pontuação',
        'icon': Icons.arrow_downward,
        'color': AppColors.red_300, 
      },
    ],
    'status': [
      {
        'id' : PlayerStatus.Avaliable.name,
        'title': 'Ativo',
        'color': AppColors.green_300,
        'icon': AppIcones.check_circle_solid
      },
      {
        'id' : PlayerStatus.Out.name,
        'title': 'Inativo',
        'icon': AppIcones.times_circle_solid ,
        'color': AppColors.red_300, 
      },
      {
        'id' : PlayerStatus.Doubt.name,
        'title': 'Duvida',
        'icon': AppIcones.question_circle_solid ,
        'color': AppColors.yellow_500, 
      },
      {
        'id' : PlayerStatus.None.name,
        'title': 'Neutro',
        'icon': Icons.minimize_rounded,
        'color': AppColors.gray_500, 
      },
    ],
  };

  //LISTA DE FILTROS DE USUARIO DO MERCADO
  Map<String, List<Map<String, dynamic>>> filterPlayerOptions = {
    'nome': [
      {
        'id' : '',
        'title': 'Ordenação (nome)',
        'icon': null,
        'color': AppColors.gray_300,
      },
      {
        'id' : 'Crescente',
        'title': 'Crescente',
        'icon': Icons.arrow_upward,
        'color': AppColors.green_300,
      },
      {
        'id' : 'Decrescente',
        'title': 'Decrescente',
        'icon': Icons.arrow_downward ,
        'color': AppColors.red_300, 
      },
    ],
  };
}