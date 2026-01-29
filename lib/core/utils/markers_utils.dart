import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:flutter_map/flutter_map.dart';

class MarkersUtils {
  //FUNÇÃO PARA OBTER COR DO ESPORTE DOMINANTE
  static String getDominantSport(List<Marker> markers){
    //CONTADORES DE ESPORTE PREDOMINANTE
    final sportCounts = {};
    //FILTRAR KEYS DA LISTA DE MARKERS
    markers.map((m) => m.key.toString()).forEach((sport) {
      var key = sport.replaceFirst("[<'",'').replaceFirst(">]'",'').split("_id")[0];
      sportCounts[key] = (sportCounts[key] ?? 0) + 1;
    });
    //REDUCE DE ESPORTES DOMINANTES
    final dominantSport = sportCounts.entries
      .reduce((a, b) => a.value >= b.value ? a : b)
      .key;
    return dominantSport;
  }
  
  //FUNÇÃO PARA SELECIONAR O ESTILO DO MARKER APARTIR DO SPORT
  static Map<String, dynamic> getMarkerStyle(String sport) {
    switch (sport) {
      case 'Futsal':
      case 'Fut7':
      case 'Futebol':
        return {
          'color': AppColors.green_300,
          'icon' : AppIcones.futebol_ball_solid,
        };

      case 'Basquete':
        return {
          'color': AppColors.orange_300,
          'icon' : AppIcones.basquete_ball_solid,
        };

      case 'Volei':
        return {
          'color': AppColors.yellow_300,
          'icon' : AppIcones.volei_ball_solid,
        };

      case 'Volei de Praia':
        return {
          'color': AppColors.bege_300,
          'icon' : AppIcones.volei_ball_solid,
        };

      default:
        return {
          'color': AppColors.grey_300,
          'icon' : AppIcones.modality_solid,
        };
    }
  }
}