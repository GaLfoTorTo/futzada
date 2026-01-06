import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/services/integration_map_service.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';

class BottomSheetMapApps extends StatelessWidget {
  final List<AppMap> apps;
  final RideRequestParams params;
  const BottomSheetMapApps({
    super.key,
    required this.apps,
    required this.params
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            Text(
              'Abrir com',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const Divider(color: AppColors.gray_300),
            ...apps.map((app) {
              return ListTile(
                leading: SvgPicture.asset(
                  app.icon,
                  width: 40,
                  height: 40,
                ),
                title: Text(
                  app.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                onTap: () => app.method
                  ? MapLauncher.showDirections(
                    mapType: app.mapType!,
                    destination: Coords(params.endLat, params.endLng),
                    destinationTitle: params.endName,
                    directionsMode: DirectionsMode.values.firstWhereOrNull((t) => t.name == params.travelMode) ?? DirectionsMode.driving, 
                    origin: Coords(params.startLat, params.startLng),
                    originTitle: params.startName,
                  )
                : IntegrationRouteService.openRouteApps(params, app.type),
              );
            })
          ],
        ),
      ),
    );
  }
}