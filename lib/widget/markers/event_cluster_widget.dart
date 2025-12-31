import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:futzada/utils/img_utils.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/utils/markers_utils.dart';
import 'package:futzada/widget/dialogs/event_explore_dialog.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class EventClusterWidget extends StatelessWidget {
  final List<EventModel> events;
  const EventClusterWidget({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    //FUNÇÃO DE AGRUPAMENTO DE EVENTOS NA MESMA LOCALIZAÇÃO
    Map<String, List<EventModel>> groupEventsByLocation(List<EventModel> events) {
      final Map<String, List<EventModel>> grouped = {};

      for (final event in events) {
        //RESGATAR LATITUDE E LONGITUDE
        final lat = event.address!.latitude!;
        final lng = event.address!.longitude!;

        //GERAR CHAVE BASEADA NA LATITUDE E LONGITUDE
        final key = '$lat,$lng';
        //ADICIONAR EVENTOS NO OBJETO
        grouped.putIfAbsent(key, () => []);
        grouped[key]!.add(event);
      }
      //RETORNAR GRUPO DE EVENTOS
      return grouped;
    }
    //RESGATAR EVENTOS AGRUPADOS
    final groupedEvents = groupEventsByLocation(events);
    //FUNÇÃO PARA GERAÇÃO DE WIDGET DE MARKER DE EVENTO
    Widget setEventWidget(EventModel marker, {bool isCluster = false, List<ImageProvider> imgs = const [], int totalEvents = 1}) {
      //RESGATAR ESTILOS DO MARKER
      final style = MarkersUtils.getMarkerStyle(marker.gameConfig!.category!);
      //ATUALIZAR BADGE DE QUANTIDADE DE EVENTOS
      int count = totalEvents;

      return Stack(
        children: [
          Container(
            width: 80,
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark_500.withAlpha(50),
                  spreadRadius: 0.5,
                  blurRadius: 5,
                  offset: const Offset(2, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for(var img in imgs)...[
                  Container(
                    width: 80 / imgs.length,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.white, width: 2),
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: img,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
          if(count > 3)...[
            Positioned(
              right: 5,
              top: 0,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: AppColors.red_300,
                  borderRadius: BorderRadius.circular(50)
                ),
                alignment: Alignment.center,
                child: Text(
                  "+$count",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            )
          ],
          Positioned(
            right: 48,
            bottom: 25,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(50)
              ),
              alignment: Alignment.center,
              child: Icon(
                style['icon'],
                color: AppColors.blue_500,
                size: 20
              )
            )
          )
        ],
      );
    }

    return MarkerClusterLayerWidget(
      options: MarkerClusterLayerOptions(
        maxClusterRadius: 100,
        size: const Size(100, 100),
        markers: groupedEvents.entries.map((entry) {
          //RESGATAR EVENTOS DO GRUPO
          final eventsAtSamePlace = entry.value;
          //RESGATAR PRIMEIRO EVENTO DO GRUPO
          final marker = eventsAtSamePlace.first;
          //RESGATAR POSIÇÃO DO MARKER
          final point = LatLng(
            marker.address!.latitude!,
            marker.address!.longitude!,
          );

          final imgs = eventsAtSamePlace
              .take(3)
              .map((e) => ImgUtils.getEventImg(e.photo))
              .toList();

          return Marker(
            point: point,
            width: 100,
            height: 100,
            key: ValueKey("${marker.id}"),
            rotate: true,
            child: InkWell(
              onTap: () => Get.bottomSheet(EventExploreDialog(events: eventsAtSamePlace), isScrollControlled: true),
              child: setEventWidget(marker, imgs: imgs, totalEvents: eventsAtSamePlace.length),
            )
          );
        }).toList(),
        builder: (context, markers) {
          final widgetKey = markers.first.key.toString().numericOnly();
          final marker = events.firstWhere((e) => e.id.toString() == widgetKey);
          final imgs = markers.take(3).map((m){
            //EVENTO DO MARKER
            final markerImg = events.firstWhere((e) => e.id.toString() == m.key.toString().numericOnly());
            //RESGATAR IMAGEM DO EVENTO E ADICIONAR A LISTA
            return ImgUtils.getEventImg(markerImg.photo);
          }).toList();

          return setEventWidget(marker, imgs: imgs, isCluster: true, totalEvents: markers.length);
        },
        disableClusteringAtZoom: 14,
      ),
    );
  }
}
