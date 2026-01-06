import 'package:futzada/controllers/map_controller.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/utils/map_utils.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/img_group_circle_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/utils/img_utils.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/helpers/date_helper.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/widget/indicators/indicator_avaliacao_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BottomSheetEventExplore extends StatelessWidget {
  final List<EventModel> events;
  const BottomSheetEventExplore({
    super.key,
    required this.events
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //DEFINIR CONTROLLER DE EVENTO 
    EventController eventController = EventController.instance;
    //DEFINIR CONTROLLER DE MAP (CUSTOM)
    MapWidgetController mapWidgetController = MapWidgetController.instance;
    //CONTROLLADOR DE BARRA DE ROLAGEM
    PageController pageController = PageController();
    //DEFINIR ALTURA DO DIALOG
    double height = events.length > 1 
      ? dimensions.height * 0.65
      : dimensions.height * 0.6;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              children: events.map((event) {
                //LISTA DE INFORMAÇÕES SOBRE A PELADA
                List<Map<String, dynamic>> infoEvent = [
                  {
                    'label': "Categoria",
                    'icon': AppIcones.escalacao_outline,
                    'value' : event.gameConfig!.category,
                  },
                  {
                    'label': "Participantes",
                    'icon': Icons.people_alt_sharp,
                    'value' : event.participants?.length ?? 0,
                  },
                  {
                    'label': "Partidas",
                    'icon': AppIcones.apito,
                    'value' : event.games?.length ?? 0,
                  },
                ];
                //RESGATAR AVALIAÇÃO DO EVENTO
                double avaliation = eventController.eventService.getEventAvaliation(event.avaliations);
                //RESGATAR DATA DO EVENTO
                String eventDate = DateHelper.getEventDate(event);
                //RESGATAR POSIÇÕES DO USUARIO
                final userLatLon = mapWidgetController.currentLatLog.value!;
                //RESGATAR POSIÇÕES DO MARKER
                final eventLatLon = LatLng(event.address!.latitude!, event.address!.longitude!);
                //RESGATAR DISTANCIA ATE O LOCAL
                double distance = MapUtils.getDistance(userLatLon, eventLatLon);
                //RESGATAR MELHOR METODO DE TRANSPORTE BASEADO NA DISTANCIA
                Map<String, dynamic> travelMode = MapUtils.getTravelMode(distance);
                //RESGATAR TEMPO DE VIAGEM ATE O LOCAL
                Duration timeTravelMode = MapUtils.getTravelTime(distance, travelMode['speed']);
                String timeTravel = MapUtils.setTimeTravel(timeTravelMode);
                //RESGATAR FOTO DOS 3 PRIMEIROS PARTICIPANTES
                List<String?> imgParticipantes = [];
                //VERIFICAR SE EXISTEM PARTICIPANTES
                if(event.participants != null && event.participants!.isNotEmpty){
                  //RESGATAR FOTOS DOS 3 PRIMEIROS PARTICIPANTES
                  imgParticipantes = event.participants!.take(3).map((participante) => participante.user.photo).toList();
                }
                //RESGATAR IMAGEM DO LOCAL
                final addressImg = ImgUtils.getAddressImg(event.address?.photos);
                //RESGATAR ORGANIZADOR
                ParticipantModel? organizador = event.participants!.firstWhere((participante) => participante.role!.contains("Organizator"));
            
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Container(
                                width: dimensions.width * 0.25,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: ImgUtils.getEventImg(event.photo),
                                    fit: BoxFit.cover
                                  )
                                ),
                              ),
                              SizedBox(
                                width: dimensions.width * 0.65,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 5,
                                  children: [
                                    Text(
                                      event.title!, 
                                      style: Theme.of(context).textTheme.titleSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis
                                    ),
                                    if(event.visibility!.name == "Public")...[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 5,
                                        children: [
                                          const Icon(
                                            AppIcones.calendar_solid,
                                            color: AppColors.gray_300,
                                            size: 20
                                          ),
                                          Text(
                                            eventDate,
                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                              color: AppColors.gray_500
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ]
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 5,
                                        children: [
                                          const Icon(
                                            Icons.timer,
                                            color: AppColors.gray_300,
                                            size: 20
                                          ),
                                          Text(
                                            "${event.startTime} as ${event.endTime}",
                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                              color: AppColors.gray_500
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ]
                                      ),
                                      Row(
                                        spacing: 5,
                                        children: [
                                          IndicatorAvaliacaoWidget(
                                            avaliation: avaliation,
                                            width: 100,
                                            starSize: 15,
                                          ),
                                          Text(
                                            "${avaliation.toStringAsFixed(1)}", 
                                            style: Theme.of(context).textTheme.titleSmall,
                                          ),
                                        ],
                                      ),
                                    ]else...[
                                      ...List.generate(3, (index) {
                                        return Container(
                                          width: 200,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: AppColors.gray_300.withAlpha(100),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        );
                                      })
                                    ]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(color: AppColors.gray_300),
                      if(event.visibility!.name == "Public")...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: dimensions.width * 0.6,
                              child: Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 5,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: AppColors.green_300,
                                        size: 20
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${event.address!.street} ${event.address!.suburb}",
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                            color: AppColors.green_300
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${event.address!.borough}, ${event.address!.city}",
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.dark_500
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${event.address!.city}/${event.address!.state}",
                                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                      color: AppColors.gray_500
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row( 
                                    spacing: 5,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.green_300.withAlpha(50),
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Icon(
                                          travelMode['icon'],
                                          color: AppColors.green_300,
                                          size: 20,
                                        ),
                                      ),
                                      Text(
                                        "${distance.toStringAsFixed(1)} Km ($timeTravel)",
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color: AppColors.gray_500
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            if(addressImg.isNotEmpty)...[
                              Stack(
                                children: [
                                  Container(
                                    width: dimensions.width * 0.3,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: AppColors.gray_300,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: addressImg[0]
                                      )
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Text(
                                      "+${addressImg.length - 1}",
                                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                        color: AppColors.white
                                      ),
                                    )
                                  )
                                ],
                              )
                            ]
                          ],
                        ),
                        const Divider(color: AppColors.gray_300),
                        Row(
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: 35,
                              height: 35,
                              child: CircleAvatar(
                                backgroundImage: ImgUtils.getUserImg(organizador.user.photo),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${organizador.user.firstName} ${organizador.user.lastName}",
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  "Organizador",
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: AppColors.gray_500,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(color: AppColors.gray_300),
                        Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: dimensions.width * 0.7,
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: infoEvent.map((item){
                                return Row(
                                  spacing: 5,
                                  children: [
                                    Icon(
                                      item['icon'],
                                      color: AppColors.gray_500,
                                    ),
                                    Text(
                                      "${item['label']}:",
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: AppColors.gray_500,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      "${item['value']}",
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: AppColors.gray_500,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                );
                              }).toList(), 
                            ),
                          ),
                          /* if(user.friends)...[ */
                            SizedBox(
                              width: dimensions.width * 0.2,
                              child: Column(
                                spacing: 5,
                                children: [
                                  ImgGroupCircularWidget(
                                    width: 40, 
                                    height: 40,
                                    images: imgParticipantes
                                  ),
                                  Text(
                                    "+ 3 amigos",
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.gray_500,
                                    ),
                                    textAlign: TextAlign.end,
                                  )
                                ],
                              ),
                            )
                          ]
                        /* ], */
                      ),
                      ]else...[
                        Column(
                          spacing: 20,
                          children: [
                            Text(
                              "Essa pelada é privada!!",
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: AppColors.gray_500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              width: 150,
                              height: 150,
                              padding: const EdgeInsets.all(20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.gray_300, width: 2),
                                borderRadius: BorderRadius.circular(100)
                              ),
                              child: const Icon(
                                Icons.lock_rounded,
                                color: AppColors.gray_300,
                                size: 100,
                              ),
                            ),
                            Text(
                              "Suas informações só podem ser visualizadas por seus participantes. Contate o organizador para participar ou para mais informações.",
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: AppColors.gray_500,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ],
                      const Divider(color: AppColors.gray_300),
                      ButtonTextWidget(
                        width: dimensions.width,
                        height: 30,
                        text: "Ver Pelada",
                        action: () => {
                          //DEFINIR EVENTO ATUAL NO CONTROLLER
                          eventController.setSelectedEvent(event),
                          //NAVEGAR PARA PAGINA DO EVENTO
                          Get.toNamed(
                            "/event/geral",
                            arguments: {
                              'event': event,
                            }
                          )
                        },
                      )
                    ],
                  ),
                );
              }).toList()
            ),
          ),
          if(events.length > 1)...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SmoothPageIndicator(
                controller: pageController,
                count: events.length > 3 ? 3 : events.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.blue_500,
                  dotColor: AppColors.gray_300,
                  expansionFactor: 2,
                ),
              ),
            ),
          ]
        ],
      )
    );
  }
}