import 'package:futzada/helpers/date_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/api/api.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/services/escalation_service.dart';
import 'package:futzada/services/integration_map_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:futzada/widget/buttons/button_icon_widget.dart';
import 'package:futzada/widget/dialogs/map_travel_dialog.dart';
import 'package:futzada/widget/text/expandable_text_widget.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/controllers/event_controller.dart';

class EventHomePage extends StatefulWidget {
  
  const EventHomePage({
    super.key,
  });

  @override
  State<EventHomePage> createState() => _EventHomePageState();
}

class _EventHomePageState extends State<EventHomePage> {
  //DEFINIR CONTROLLERS
  EventController eventController = EventController.instance;
  GameController gameController = GameController.instance;
  MapController mapController = MapController();
  late PageController highligtsController;
  //DEFINIR SERVIÇO DE CAMPO/QUADRA
  EscalationService escalationService = EscalationService();
  //RESGATAR EVENT
  late EventModel event = eventController.event;
  //ESTADO - DESTAQUES
  late List<Map<String, dynamic>> highlights;
  //ESTADO - AVALIAÇÕES
  late double avaliation;
  //ESTADO - MAP
  late LatLng eventLatLog;
  //CONTROLLADOR DE CARREGAMENTO DE INFORMAÇÕES
  RxBool isMapLoaded = false.obs;
  
  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE HIGHLIGHTS
    highligtsController = PageController();
    //RESGATAR DESTAQUES DO EVENTO
    highlights = eventController.getHighlights(event);
    //RESGATAR AVALIAÇÕES DO EVENTO
    avaliation = eventController.getAvaliations(event.avaliations);
    //RESGATAR LAT E LONG DO ENDEREÇO DO EVENTO
    eventLatLog = LatLng(-15.8059539, -47.9104129);//LatLng(event.address!.latitude!, event.address!.longitude!);
    // Aguardar controllers estarem prontos se necessário
    Future.delayed(const Duration(milliseconds: 100));
    //VERIFICAR SE MAPA ESTA PRONTO PARA INICIAR
    isMapLoaded.value = true;
  }
    
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size; 
    //LISTA DE INFORMAÇÕES SOBRE AS PARTIDAS
    List<Map<String, dynamic>> infoGame = [
      {
        'label': "Jogadores por Equipe",
        'icon': AppIcones.users_solid,
        'value' : event.gameConfig!.playersPerTeam.toString(),
      },
      {
        'label': "Duração (min)",
        'icon': AppIcones.stopwatch_solid,
        'value' : event.gameConfig!.duration.toString(),
      },
      {
        'label': "Limite de Gols",
        'icon': Icons.scoreboard,
        'value' : event.gameConfig!.goalLimit.toString(),
      },
      {
        'label': "2 Tempos",
        'icon': Icons.safety_divider_rounded,
        'value' : event.gameConfig!.hasTwoHalves! ? "Sim" : "Não",
      },
      {
        'label': "Pênaltis",
        'icon': Icons.sports_soccer,
        'value' : event.gameConfig!.hasPenalty! ? "Sim" : "Não",
      },
      {
        'label': "Árbitro",
        'icon': AppIcones.apito,
        'value' : event.gameConfig!.hasRefereer! ? "Sim" : "Não",
      },
    ];
    //RESGATAR FOTO DOS 3 PRIMEIROS PARTICIPANTES
    List<String?> imgParticipantes = [];
    //VERIFICAR SE EXISTEM PARTICIPANTES
    if(event.participants != null && event.participants!.isNotEmpty){
      //RESGATAR FOTOS DOS 3 PRIMEIROS PARTICIPANTES
      imgParticipantes = event.participants!.take(3).map((participante) => participante.user.photo).toList();
    }
    //RESGATAR ORGANIZADOR
    ParticipantModel? organizador = event.participants!.firstWhere((participante) => participante.role!.contains("Organizator"));

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        color: AppColors.white,
        width: dimensions.width,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                spacing: 10,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.green_300,
                        size: 20
                      ),
                      Container(
                        width: dimensions.width - 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${event.address!.street} ${event.address!.suburb} ${event.address!.city}, ${event.address!.state}",
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]
                  ),
                  Row(
                    children: [
                      const Icon(
                        AppIcones.calendar_solid,
                        color: AppColors.green_300,
                        size: 20
                      ),
                      Container(
                        width: dimensions.width - 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${DateHelper.getEventDate(event)} - ${event.startTime} as ${event.endTime}",
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]
                  ),
                  Row(
                    children: [
                      const Icon(
                        AppIcones.pen_solid,
                        color: AppColors.green_300,
                        size: 20
                      ),
                      Container(
                        width: dimensions.width - 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Iniciada em: ${DateFormat("dd/MM/y").format(event.createdAt!)}",
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]
                  ),
                ],
              ),
            ),
            if(event.bio != null)...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ExpandableTextWidget(
                  text: event.bio!
                ),
              ),
            ],
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: CircleAvatar(
                              backgroundImage: organizador.user.photo != null
                                ? CachedNetworkImageProvider(organizador.user.photo!) 
                                : const AssetImage(AppImages.userDefault) as ImageProvider,
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
                      Row(
                        spacing: 5,
                        children: [
                          ButtonIconWidget(
                            icon: AppIcones.paper_plane_solid,
                            iconSize: 20,
                            padding: 15,
                            iconColor: AppColors.green_300,
                            backgroundColor: AppColors.green_300.withAlpha(50),
                            action: () {},
                          ),
                          ButtonIconWidget(
                            icon: AppIcones.user_plus_solid,
                            iconSize: 20,
                            padding: 15,
                            iconColor: AppColors.green_300,
                            backgroundColor: AppColors.green_300.withAlpha(50),
                            action: () {},
                          ),
                        ],
                      ),
                    ]
                  ),
                ],
              ),
            ),
            const Divider(),
            Container(
              width: dimensions.width,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Detalhes',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 20,
              children: [
                Column(
                  children: [
                    ButtonIconWidget(
                      icon: AppIcones.users_solid,
                      iconSize: 30,
                      padding: 20,
                      iconColor: AppColors.green_300,
                      backgroundColor: AppColors.green_300.withAlpha(50),
                      action: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "${event.participants!.length}",
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: AppColors.green_300,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Participantes",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    ButtonIconWidget(
                      icon: AppIcones.escalacao_solid,
                      iconSize: 30,
                      padding: 20,
                      iconColor: AppColors.green_300,
                      backgroundColor: AppColors.green_300.withAlpha(50),
                      action: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        event.gameConfig!.category!,
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: AppColors.green_300,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Categoria",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    ButtonIconWidget(
                      icon: AppIcones.apito,
                      iconSize: 30,
                      padding: 20,
                      iconColor: AppColors.green_300,
                      backgroundColor: AppColors.green_300.withAlpha(50),
                      action: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "${event.games?.length ?? 0}",
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: AppColors.green_300,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Partidas",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    ButtonIconWidget(
                      icon: AppIcones.lock_solid,
                      iconSize: 30,
                      padding: 20,
                      iconColor: AppColors.green_300,
                      backgroundColor: AppColors.green_300.withAlpha(50),
                      action: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        event.visibility!.name,
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: AppColors.green_300,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Visibilidade",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  //CONTAINER BASE DE DIMENSIONAMENTO
                  SizedBox(
                    width: dimensions.width,
                    height: 400,
                  ), 
                  //AREA DE BOTÕES 
                  Positioned(
                    bottom: -10,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: dimensions.width,
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          ...infoGame.map((item){
                            return SizedBox(
                              width: dimensions.width * 0.25,
                              child: Column(
                                spacing: 5,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: AppColors.green_300.withAlpha(50),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Icon(
                                      item['icon'],
                                      color: AppColors.green_300,
                                      size: 25,
                                    ),
                                  ),
                                  Text(
                                    item['value'],
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.green_300,
                                      fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    item['label'],
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),           
                  // COMPONENTE DE CAMPO
                  Positioned(
                    bottom: 130,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateZ(pi / 2)
                        ..rotateY(0.9),
                      child: Container(
                        width: 200,
                        height: 380,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.white, width: 5),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dark_300.withAlpha(50),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(5, 0),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          escalationService.fieldType(event.gameConfig!.category),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
            const Divider(),
            Container(
              width: dimensions.width,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Localização',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Container(
              width: dimensions.width,
              height: dimensions.height * 0.25,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              color: AppColors.gray_300,
              child: Obx(() {
                //EXIBIR LOADING DE CARREGAMENTO DO MAPA
                if (!isMapLoaded.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.green_300,
                    )
                  );
                }
                return FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: eventLatLog,
                    initialZoom: 12,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: AppApi.map,
                      userAgentPackageName: 'com.example.futzada',
                      subdomains: ['a', 'b', 'c', 'd'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: eventLatLog,
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.location_on,
                            size: 20,
                            color: AppColors.green_300,
                          )
                        ),
                      ],
                    ),
                  ],
                );
              })
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gray_300),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                spacing: 10,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 60,
                    color: AppColors.blue_500,
                  ),
                  Expanded(
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${event.address!.street} ${event.address!.suburb}",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.blue_500
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${event.address!.borough}, ${event.address!.city}",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColors.blue_500
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
                        )
                      ],
                    ),
                  )
                ],
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 20,
              children: [
                Obx((){
                return Column(
                    children: [
                      ButtonIconWidget(
                        icon: eventController.travelMode['icon'],
                        iconSize: 30,
                        padding: 15,
                        iconColor: AppColors.green_300,
                        backgroundColor: AppColors.green_300.withAlpha(50),
                        action: () => Get.bottomSheet(const MapTravelDialog())
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Text(
                              eventController.travelMode['distance'],
                              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                Column(
                  children: [
                    ButtonIconWidget(
                      icon: Icons.directions,
                      iconSize: 30,
                      padding: 15,
                      iconColor: AppColors.green_300,
                      backgroundColor: AppColors.green_300.withAlpha(50),
                      action: () => IntegrationRouteService.openDialogApps(event.address!.copyWith(latitude: -15.8059539, longitude: -47.9104129), travelModel: eventController.travelMode['type']),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Text(
                            "Ver Rotas",
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            Container(
              width: dimensions.width,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Destaques',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}