import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';

class MapTravelDialog extends StatelessWidget {
  const MapTravelDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DO EVENTO
    EventController eventController = EventController.instance;

    //LISTA DE OPÇÕES
    List<Map<String, dynamic>> options = [
      {
        'type':'walking',
        'icon' : Icons.directions_walk_rounded,
        'label': 'A pé',
        'distance': '30 min'
      },
      {
        'type':'bicycling',
        'icon' : Icons.directions_bike_rounded,
        'label': 'Bicicleta',
        'distance': '25 min'
      },
      {
        'type':'driving',
        'icon' : Icons.directions_car_rounded,
        'label': 'Carro',
        'distance': '15 min'
      },
      {
        'type':'transit',
        'icon' : Icons.directions_bus_rounded,
        'label': 'Onibus',
        'distance': '20 min'
      },
    ];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            Text(
              'Tipo de Viagem',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const Divider(color: AppColors.gray_300),
            ...options.map((item) {
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.green_300.withAlpha(50),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(
                    item['icon'],
                    color: AppColors.green_300,
                    size: 30,
                  ),
                ),
                title: Text(
                  item['label'],
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                onTap: () => eventController.setTravelMode(item)
              );
            })
          ],
        ),
      ),
    );
  }
}