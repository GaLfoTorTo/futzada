import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:futzada/controllers/map_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:latlong2/latlong.dart';

class UserMarkerWidget extends StatelessWidget {
  const UserMarkerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE MAPA (CUSTOM)
    MapWidgetController mapWidgetController = MapWidgetController.instance;

    return MarkerLayer(
      markers: [
        Marker(
          point: LatLng(
            mapWidgetController.currentPosition.value!.latitude, 
            mapWidgetController.currentPosition.value!.longitude
          ),
          width: 50,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.green_300.withAlpha(50),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.green_300,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.white, width: 2),
                ),
              ),
            ),
          )
        )
      ]
    );
  }
}