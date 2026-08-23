import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/presentation/controllers/statistics_controller.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';
import 'package:esportly/presentation/widget/cards/card_team_widget.dart';
import 'package:esportly/presentation/widget/cards/card_player_game_widget.dart';
import 'package:esportly/presentation/widget/indicators/indicator_page_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_dropdown_icon_widget.dart';

class StatisticsPage extends StatefulWidget {  
  const StatisticsPage({
    super.key,
  });

  @override
  State<StatisticsPage> createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  //RESGATAR CONTROLLER DE ESCALAÇÃO
  StatisticsController statisticsController = StatisticsController.instance;

  //FUNÇÃO PARA SELECIONAR EVENTO
  void selectEvent(id){
    setState(() {
      //SELECIONAR EVENTO
      statisticsController.setEvent(id);
      //ATUALIZAR CONTROLLER
          });
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR EVENTOS DO USUARIO COMO MAP
    List<Map<String, dynamic>> userEvents = statisticsController.userEvents.map((event){
      return {'id': event.id, 'title' : event.title, 'photo': event.photo};
    }).toList();
    //CONTROLLADOR DE BARRA DE ROLAGEM
    PageController teamsController = PageController();

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Estatisticas',
        leftAction: () => context.pop(),
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: dimensions.width,
                height: 70,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.dark_500 : AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark_500.withAlpha(30),
                      spreadRadius: 0.5,
                      blurRadius: 7,
                      offset: const Offset(2, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: dimensions.width * 0.4,
                      child: ButtonDropdownIconWidget(
                        selectedItem: statisticsController.event!.id,
                        items: userEvents,
                        menuWidth: dimensions.width * 0.4,
                        iconAfter: false,
                        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.dark_300 : AppColors.white,
                        onChange: selectEvent,
                      ),
                    ),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minha equipe',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Destaques do mercado',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Mais Escalados da rodada',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(
                      height: 210,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 15,
                          children: statisticsController.event!.participants!.take(5).map((item){
                            //RESGATAR PARTICIPANT
                            UserModel user = item;
                            return CardPlayerGameWidget(user: user);
                          }).toList(),
                        )
                      )
                    ),
                    Text(
                      'Mais Escalados',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Queridinho dos tecnicos',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Equipes mais caras',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(
                      width: dimensions.width,
                      height: 400,
                      child: PageView(
                        controller: teamsController,
                        children: statisticsController.event!.participants!.where((u) => u.manager != null).take(3).map((user){
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 10, bottom: 10),
                            child: CardTeamWidget(
                              user: user,
                            ),
                          );
                        }).toList()
                      )
                    ),
                    Center(
                      child: IndicatorPageWidget(pageController: teamsController, options: statisticsController.event!.participants!.take(3).length)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}