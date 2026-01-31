import 'package:futzada/core/helpers/player_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/data/models/player_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';

class BottomSheetPlayer extends StatefulWidget {
  final UserModel user;

  const BottomSheetPlayer({
    super.key,
    required this.user,
  });

  @override
  State<BottomSheetPlayer> createState() => BottomSheetPlayerState();
}

class BottomSheetPlayerState extends State<BottomSheetPlayer> {
  //RESGATAR CONTROLLER DE ESCALAÇÃO
  EscalationController escalationController = EscalationController.instance;
  bool isCapitan = false;

  @override
  void initState() {
    super.initState();
    //RESGATAR CAPITÃO
    isCapitan = escalationController.selectedPlayerCapitan.value == widget.user.id;
  }
  
  //FUNÇÃO PARA ADICIONAR OU REMOVER JOGADOR DA ESCALAÇÃO
  void setPlayerPosition(id, action){
    //VEERIFICAR TIPO DE AÇÃO
    if(action == 'setPosition'){
      //SELECIONAR JOGADOR
      escalationController.setPlayerEscalation(id);
    }else{
      //ATUALIZAR INDEX DE JOGADOR CAPITÃO
      escalationController.setPlayerCapitan(id);
    }
    //FECHAR BOTTOM SHEET
    Get.back();
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    //RESGATAR PARTICIPANTE
    UserModel user = widget.user;
    
    //RESGATAR DADOS DE JOGADOR DO PARTICIPANTE
    PlayerModel player = user.player!;

    //RESGTAR JOGADOR COMO MAP
    Map<String, dynamic> playerMap = player.toMap();
    

    //RESGATAR MODALIDADE DA PELADA
    String modality = escalationController.event!.modality!.name;
    
    //RESGATAR POSIÇÕES DO JOGADOR
    List<String> playerPositions = player.positions[escalationController.event!.modality!.name]!;
    //REMOVER POSIÇÃO PRINCIPAL DO ARRAY
    playerPositions.remove(player.mainPosition[escalationController.event!.modality!.name]);
    
    //LISTA DE METRICAS DO CARD
    List<Map<String, dynamic>> metrics = [
      {
        'name':'price',
        'label':'Valor de Mercado',
        'icon': AppIcones.money_check_solid,
        'price':true
      },
      {
        'name':'valuation',
        'label':'Valorização',
        'icon': AppIcones.sort_amount_up_solid,
        'price':false
      },
      {
        'name':'points',
        'label':'Última Pontuação',
        'icon': AppIcones.calculator_solid,
        'price':false
      },
      {
        'name':'avarage',
        'label':'Média',
        'icon': AppIcones.chart_line_solid,
        'price':false
      },
      {
        'name':'games',
        'label':'Jogos',
        'icon': AppIcones.clipboard_solid,
        'price':false
      },
      {
        'name':'status',
        'label':'Status',
        'icon': AppIcones.user_checked_solid,
        'price':false
      },
    ];

    return  Container(
      height: ( dimensions.height / 2 ) + 60,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children:[ 
              SizedBox(
                child: Column(
                  children: [
                    ImgCircularWidget(
                      height: 100,
                      width: 100,
                      image: user.photo,
                      borderColor: PlayerHelper.setColorPosition(player.mainPosition),
                    ),
                    Text(
                      UserHelper.getFullName(user),
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "@${user.userName}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    PositionWidget(
                      position: player.mainPosition[modality]!,
                      mainPosition: true,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...playerPositions.asMap().entries.map((entry){
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: PositionWidget(
                                position: entry.value,
                                mainPosition: false,
                              ),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if(isCapitan)...[
                const Positioned(
                  top: 70,
                  left: 80,
                  child: PositionWidget(
                    position: "cap",
                    mainPosition: true,
                    width: 35,
                    height: 25,
                    textSide: 10,
                  ),
                ),
              ]
            ]
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Wrap(
              spacing: 10,
              children: [
                ...metrics.asMap().entries.map((entry){
                  //RESGATAR OBJETO DE METRICA
                  final item = entry.value;
                  //RESGATAR CHAVE IDENTIFICADORA DDO ITEM
                  final name = item['name'];
                  
                  return Container(
                    width: ( dimensions.width / 2 ) - 25,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.grey_300.withAlpha(40),
                      borderRadius: const BorderRadius.all(Radius.circular(5))
                    ),
                    child: Column(
                      children: [
                        if(name == 'status')...[
                          Icon(
                            AppHelper.setStatusPlayer(UserHelper.getParticipant(user.participants, escalationController.event!.id!)!.status)['icon'],
                            size: 30,
                            color: AppHelper.setStatusPlayer(UserHelper.getParticipant(user.participants, escalationController.event!.id!)!.status)['color'],
                          )
                        ]else...[
                          Text(
                            "${playerMap['rating'][name]}",
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppHelper.setColorPontuation(playerMap['rating'][name])['color']),
                          ),
                        ],
                        Text(
                          "${item['label']}",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  );
                }),
              ]
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonTextWidget(
                text: !isCapitan ? "Tornar Capitão" : "Remover Capitão",
                icon: Icons.copyright,
                width: (dimensions.width / 2) - 40,
                height: 30,
                backgroundColor: AppColors.yellow_300,
                textColor: AppColors.dark_500,
                action: () => setPlayerPosition(player.id, 'setCapitan'),
              ),
              ButtonTextWidget(
                text: "Remover",
                icon: AppIcones.trash_solid,
                width: (dimensions.width / 2) - 40,
                height: 30,
                backgroundColor: AppColors.red_300,
                textColor: AppColors.white,
                action: () => setPlayerPosition(player.id, 'setPosition'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}