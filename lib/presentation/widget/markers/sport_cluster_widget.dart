import 'package:flutter/material.dart';
import 'package:futzada/presentation/widget/buttons/button_icon_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/markers_helper.dart';
import 'package:futzada/presentation/controllers/map_controller.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class SportClusterWidget extends StatelessWidget {
  final List<Map<String, dynamic>> sportPlaces;
  const SportClusterWidget({
    super.key,
    required this.sportPlaces,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE MAP (CUSTOM)
    MapWidgetController mapWidgetController = MapWidgetController.instance;

    Widget setSportPlaceMarkerWidget(Map<String, dynamic> marker) {
      //RESGATAR ESPORTE DOMINANTE NA AREA E ESTILOS
      final dominantSport = MarkersHelper.getDominantSport(marker['sport']);
      final style = MarkersHelper.getMarkerStyle(dominantSport);

      return ButtonIconWidget(
        icon: style['icon'],
        iconSize: 20,
        padding: 5,
        iconColor: AppColors.blue_500,
        backgroundColor: style['color'],
        borderRadius: 40,
        shadow: true,
        action: () {},
      );
    }

    return MarkerClusterLayerWidget(
      options: MarkerClusterLayerOptions(
        maxClusterRadius: 100,
        size: const Size(40, 40),
        markers: sportPlaces.map((marker) {
          //RESGATAR POSIÇÕES DO MARKER
          final point = LatLng(marker['lat'], marker['lon']);

          return Marker(
            point: point,
            width: mapWidgetController.baseSize.value,
            height: mapWidgetController.baseSize.value,
            key: ValueKey("${marker['id']}"),
            child: setSportPlaceMarkerWidget(marker),
          );
        }).toList(),
        builder: (context, markers) {
          final widgetKey = markers.first.key.toString();
          final marker = sportPlaces.firstWhere((e) => e['id'].toString() == widgetKey);
          return setSportPlaceMarkerWidget(marker);
        },
        disableClusteringAtZoom: 14,
      ),
    );
  }
}
