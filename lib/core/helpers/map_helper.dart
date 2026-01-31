import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapHelper {

  //OPÇÕES DE TRANSPORTE
  static List<Map<String, dynamic>> transports = [
    {
      'type':'walking',
      'icon' : Icons.directions_walk_rounded,
      'label': 'A pé',
      'speed': 5,
      'distance': 5,
    },
    {
      'type':'bicycling',
      'icon' : Icons.directions_bike_rounded,
      'label': 'Bicicleta',
      'speed': 20,
      'distance': 10,
    },
    {
      'type':'driving',
      'icon' : Icons.directions_car_rounded,
      'label': 'Carro',
      'speed': 60,
      'distance': 20,
    },
    {
      'type':'transit',
      'icon' : Icons.directions_bus_rounded,
      'label': 'Onibus',
      'speed': 40,
      'distance': 50,
    },
  ];

  //FUNÇÃO PARA CALCULAR DIFERENÇA ENTRE 2 PONTOS
  static double getDistance(LatLng origin, LatLng destiny) {
    //FUNÇÃO DE CALCULO DE DIFERENÇA ENTRE LATITUDE E LONGITUDE
    double degToRad(double deg) => deg * (pi / 180);
    //RAIO DA TERRA (KM)
    const earthRadius = 6371;
    //DIFERENÇA DE LATITUDE E LONGITUDE ENTRE AS POSIÇÕES
    final dLat = degToRad(destiny.latitude - origin.latitude);
    final dLon = degToRad(destiny.longitude - origin.longitude);


    final a =
      //CALCULAR A DISTANCIA VERTICAL (NORTE E SUL)
      sin(dLat / 2) * sin(dLat / 2) +
      //AJUSTA A DISTANCIA LONGITUDINAL CONFORME A LATITUDE
      cos(degToRad(origin.latitude)) *
          cos(degToRad(destiny.latitude)) *
          //CALCULAR A DISTANCIA HORIZONTAL (LESTE E OESTE)
          sin(dLon / 2) *
          sin(dLon / 2);
    //TRANSFORMANDO VALOR CALCULADO EM UM ANGULO CENTRAL EM RADIANOS
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    //MULTIPLICAR RAIO DA TERRA COM ANGULO CENTRAL OBTIDO
    return earthRadius * c;
  }  

  //FUNÇÃO PARA BUSCAR MELHOR METODO DE TRANSPORTE
  static Map<String, dynamic> getTravelMode(double distance){
    return transports.reduce((a, b) {
      final diffA = (a['distance'] - distance).abs();
      final diffB = (b['distance'] - distance).abs();

      return diffB < diffA ? b : a;
    });
  }

  //FUNÇÃO PARA CALCULAR ESTIMATIVA DE TEMPO DE VIAGEM PARA CADA TIPO DE TRANSPORTE
  static Duration getTravelTime( double distance, int speed) {
    final timeInHours = distance / speed;
    final timeInMinutes = (timeInHours * 60).round();
    return Duration(minutes: timeInMinutes);
  }

  //FUNÇÃO PARA FORMATAR TEMPO DE VIAGEM
  static String setTimeTravel(Duration timeTravelMode) {
    final hours = timeTravelMode.inHours;
    final minutes = timeTravelMode.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes.toString().padLeft(2, '0')}min';
    }

    if (hours > 0) {
      return '${hours}h';
    }

    return '${minutes} min';
  }

  //FUNÇÃO PARA RESGATAR ENDEREÇO DO USUARIO
  static String getLocation() {
    //RESGATAR LOCALIZACAO DO USUARUI
    final RxMap<String, dynamic> currentLocation = Get.find(tag: 'userLocation');
    //VERIFICAR SE LOCALIZACAO DO USUARIO CONTEM CHAVE ESPECIFICA
    if (currentLocation.containsKey('ISO3166-2-lvl4')) {
      final iso = currentLocation['ISO3166-2-lvl4'] as String?;
      if (iso != null && iso.contains('-')) {
        return "${currentLocation['city']}/${iso.split('-').last}";
      }
    }
    //RETORNAR STRING VAZIA
    return 'Não encontrado';
  }
}