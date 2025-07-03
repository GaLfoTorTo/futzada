import 'package:futzada/controllers/game_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/images/img_group_circle_widget.dart';
import 'package:futzada/widget/indicators/indicator_avaliacao_widget.dart';
import 'package:futzada/widget/indicators/indicator_live_widget.dart';
import 'package:futzada/widget/text/expandable_text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:futzada/controllers/event_controller.dart';

class EventHomePage extends StatefulWidget {
  
  const EventHomePage({
    super.key,
  });

  @override
  State<EventHomePage> createState() => _EventHomePageState();
}

class _EventHomePageState extends State<EventHomePage> {
  //DEFINIR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
  //DEFINIR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //RESGATAR EVENT
  late EventModel event = eventController.event;
  //CONTROLLADOR DE DESTAQUES
  late PageController highligtsController;
  //ESTADO - DESTAQUES
  late List<Map<String, dynamic>> highlights;
  //ESTADO - AVALIAÇÕES
  late double avaliation;
  
  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE HIGHLIGHTS
    highligtsController = PageController();
    //RESGATAR DESTAQUES DO EVENTO
    highlights = eventController.getHighlights(event);
    //RESGATAR AVALIAÇÕES DO EVENTO
    avaliation = eventController.getAvaliations(event.avaliations);
  }

  //FUNÇÃO PARA RESGATAR DATA DA PELADA
  String getEventDate(EventModel event){
    //VARIAVEL PARA RESGATAR DATA DO EVENTO
    String date = "";
    //VERIFICAR SE FORAM DEFINIDOS DIAS DA SEMANA
    if(event.daysWeek != null){
      date = event.daysWeek!.replaceAll("[", '').replaceAll("]", '');
    }else{
      date = event.date.toString();
    }
    return "$date - ${event.startTime} as ${event.endTime}";
  }
    
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    //LISTA DE INFORMAÇÕES SOBRE O EVENT
    List<Map<String, dynamic>> infoEvent = [
      {
        'item': "Organizador:",
        'icon': AppIcones.user_cog_solid,
        'value' : "Zé Lasquinha",
        'foto' : null,
      },
      {
        'item': "Iniciada em",
        'icon': AppIcones.calendar_solid,
        'value' : DateFormat("dd/MM/yyyy").format(event.createdAt!),
      },
      {
        'item': "Participantes:",
        'icon': AppIcones.users_solid,
        'value' : event.participants!.length,
      },
      {
        'item': "Partidas Disputadas:",
        'icon': AppIcones.apito,
        'value' : "160",
      },
    ];
    //RESGATAR FOTO DOS 3 PRIMEIROS PARTICIPANTES
    List<String?> imgParticipantes = [];
    //VERIFICAR SE EXISTEM PARTICIPANTES
    if(event.participants != null && event.participants!.isNotEmpty){
      //RESGATAR FOTOS DOS 3 PRIMEIROS PARTICIPANTES
      imgParticipantes = event.participants!.take(3).map((participante) => participante.user.photo).toList();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: dimensions.width,
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark_500.withAlpha(30),
                  spreadRadius: 0.5,
                  blurRadius: 5,
                  offset: Offset(2, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: dimensions.width,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    image: DecorationImage(
                      image: event.photo != null 
                        ? CachedNetworkImageProvider(event.photo!) 
                        : const AssetImage(AppImages.gramado) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  event.title!,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: dimensions.width / 3,
                              child: Row(
                                children: [
                                  IndicatorAvaliacaoWidget(
                                    avaliation: avaliation,
                                    width: dimensions.width / 4.5,
                                    starSize: 15,
                                  ),
                                  Text(
                                    avaliation.toStringAsFixed(1),
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      if(event.bio != null)...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ExpandableTextWidget(
                            text: event.bio!,
                          ),
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            if(gameController.inProgressGames.isNotEmpty)...[
                              Container(
                                width: 100,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.red_300,
                                ),
                                child: const IndicatorLiveWidget(
                                  size: 15,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                            Row(
                              children: [
                                const Icon(
                                  AppIcones.calendar_solid,
                                  color: AppColors.gray_300,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    getEventDate(event),
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.gray_300
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ]
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.gray_300),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: dimensions.width * 0.50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          AppIcones.marker_solid,
                                          color: AppColors.green_300,
                                          size: 25,
                                        ),
                                        SizedBox(
                                          width: dimensions.width * 0.43,
                                          child: Text(
                                            "${event.address!.state}",
                                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                              color: AppColors.green_300
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                    child: Text(
                                      "${event.address!.street} ${event.address!.suburb} - ${event.address!.city}, \n${event.address!.state} - ${event.address!.country}, ${event.address!.zipCode}",
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: AppColors.gray_300
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            const Icon(
                                              AppIcones.walk_solid,
                                              color: AppColors.gray_300,
                                              size: 30,
                                            ),
                                            Text(
                                              "10 min",
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                color: AppColors.gray_300
                                              ),
                                            ),
                                          ],
                                        ),
                                        ButtonTextWidget(
                                          text: "Ver Endereço",
                                          textSize: 10,
                                          width: 80,
                                          height: 20,
                                          action: (){}
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: dimensions.width * 0.40,
                              height: 160,
                              decoration: BoxDecoration(
                                color: AppColors.gray_300,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.gray_300),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: dimensions.width / 2,
                              child: Column(
                                children: [
                                  ...infoEvent.map((item){
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: [
                                          Icon(
                                            item['icon'],
                                            color: AppColors.gray_300,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "${item['item']} ${item['value']}",
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                color: AppColors.gray_300
                                              ),
                                            ),
                                          ),
                                        ]
                                      ),
                                    );
                                  }).toList()
                                ],
                              ),
                            ),
                            SizedBox(
                              width: dimensions.width / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "Amigos que frequentam",
                                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  if(imgParticipantes.isNotEmpty)...[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: ImgGroupCircularWidget(
                                        width: 40,
                                        height: 40,
                                        images: imgParticipantes
                                      ),
                                    ),
                                  ],
                                  if(event.participants!.length > 3)...[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "+${event.participants!.length - 3} Amigos",
                                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                          color: AppColors.gray_300
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            )
          ),
          if(highlights.isNotEmpty)...[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Destaques",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ), 
                      ButtonTextWidget(
                        text: "Ver Mais",
                        width: 80,
                        height: 20,
                        textColor: AppColors.green_300,
                        backgroundColor: Colors.transparent,
                        action: () {},
                      ),
                    ]
                  ),
                ),
                SizedBox(
                  width: dimensions.width,
                  height: 250,
                  child: PageView(
                    controller: highligtsController,
                    children: [
                      ...highlights.map((item) {
                        //RESGATAR LISTA DE IMAGENS PARA NOTIFICAÇÃO
                        List<dynamic> imgHighlights = [];
                        //RESGATAR PARTICIPANTES DO DESTAQUE
                        List<UserModel> participants = item['participants'];
                        //ADICIONAR PHOTOS DOS PARTICIPANTES AO ARRAY
                        for (var user in participants) {
                          imgHighlights.add(user.photo);
                        }

                        return Container(
                          width: dimensions.width,
                          height: 200,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.dark_500.withAlpha(30),
                                spreadRadius: 0.5,
                                blurRadius: 5,
                                offset: Offset(2, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              if(imgHighlights.isNotEmpty)...[
                                if (imgHighlights.length > 1) ...[
                                  ImgGroupCircularWidget(
                                    width: 70,
                                    height: 70,
                                    images: imgHighlights,
                                  ),
                                ] else ...[
                                  ImgCircularWidget(
                                    width: 70,
                                    height: 70,
                                    image: imgHighlights[0],
                                  ),
                                ],
                              ],
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item['description'],
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300),
                                      ),
                                      if(item['params'] != null && item['params']['value'] != null)...[
                                        Row(
                                          children: [
                                            Text(
                                              item['params']['label'],
                                              style: Theme.of(context).textTheme.titleSmall,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                "${item['params']['value']}",
                                                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.green_300),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]
                                    ]
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SmoothPageIndicator(
                    controller: highligtsController,
                    count: highlights.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.blue_500,
                      dotColor: AppColors.gray_300,
                      expansionFactor: 2,
                    ),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}