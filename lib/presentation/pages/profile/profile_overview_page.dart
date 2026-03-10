import 'package:flutter/material.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:futzada/presentation/controllers/profile_controller.dart';
import 'package:futzada/presentation/widget/cards/card_event_search_widget.dart';
import 'package:futzada/presentation/widget/cards/card_level_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_page_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileOverviewPage extends StatefulWidget {
  const ProfileOverviewPage({super.key});

  @override
  State<ProfileOverviewPage> createState() => _ProfileOverviewPageState();
}

class _ProfileOverviewPageState extends State<ProfileOverviewPage> {
  //CONTROLLERS
  ProfileController profileController = ProfileController.instance;
  PageController pageController = PageController(viewportFraction: 0.8);
  //ESTADO - ITEMS EVENTO
  late Map<String, dynamic> modalityInfo;
  late Color modalityColor;
  late Color modalityTextColor;
  late List<Modality> modalities;
  late Modality mainModality;
  //LISTA DE EVENTOS QUE O USUARIO PARTICIPA
  late List<EventModel> events;

  @override
  void initState(){
    super.initState();
    //RESGATAR TEMA PERSONALIZADO PARA MODALIDADE PRINCIPAL DO USUARIO
    modalityInfo = ModalityHelper.getEventModalityColor(profileController.user.config!.mainModality!.name);
    modalityColor = modalityInfo['color'];
    modalityTextColor = modalityInfo['textColor'];
    mainModality = profileController.user.config!.mainModality!;
    modalities = reorderModalities();
    //RESGATAR EVENTOS DO USUARIO
    events = profileController.events;
  }

  //FUNÇÃO DE REORDENAÇÃO DE MODALIDADES
  List<Modality> reorderModalities(){
    final list = profileController.user.config!.modalities!;
    if (list.contains(mainModality)){
      list.remove(mainModality);
      final int centerIndex = (list.length / 2).floor();
      list.insert(centerIndex, mainModality);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            CardLevelWidget(
              user: profileController.user,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: modalities.map((item){
                //RESGATAR ICONE DE MODALIDADES
                final isMainModality = mainModality.name == item.name;
                final icon = ModalityHelper.getIconModality(item.name);
                final itemColor = isMainModality ? modalityColor : AppColors.grey_500;
                final itemSize = isMainModality ? 50.0 : 40.0;
                
                return Stack(
                  alignment: AlignmentGeometry.topCenter,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: itemColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: itemColor, width: 2)
                      ),
                      child: Icon(
                        icon['icon'],
                        color: itemColor,
                        size: itemSize,
                      ),
                    ),
                    if(isMainModality)...[
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          LineAwesomeIcons.crown_solid,
                          color: AppColors.yellow_500,
                          size: 25,
                        ),
                      ),
                    ],
                  ],
                );
              }).toList()
            ),
            Text(
              "Peladas",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              width: dimensions.width,
              height: 200,
              child: PageView.builder(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                padEnds: false,
                itemCount: events.take(5).length,
                itemBuilder: (context, index) {
                  final value = events[index];
                  //DEFINIR CARD
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: CardEventSearchWidget(event: value)
                  );
                },
              ),
            ),
            Center(child: IndicatorPageWidget(pageController: pageController, options: events.take(5).length)),
            Text(
              "Peladas",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      )
    );
  }
}