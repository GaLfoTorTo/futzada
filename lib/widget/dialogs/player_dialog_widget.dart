import 'package:flutter/material.dart';
import 'package:futzada/models/player_model.dart';
import 'package:get/get.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class PlayerDialogWidget extends StatefulWidget {
  final PlayerModel player;

  const PlayerDialogWidget({
    super.key,
    required this.player,
  });

  @override
  State<PlayerDialogWidget> createState() => PlayerDialogWidgetState();
}

class PlayerDialogWidgetState extends State<PlayerDialogWidget> {
  //RESGATAR CONTROLLER DE ESCALAÇÃO
  var controller = EscalationController.instace;
  //CONTROLADOR DE POSICAO PRINCIPAL
  String? position;
  //RESGATAR JOGADOR COMO MAP
  Map<String, dynamic> player = {};

  @override
  void initState() {
    super.initState();
    //RESGATAR JOGADOR COMO MAP
    player = widget.player.toMap();
    //ADICIONAR A FLAG DE POSIÇÃO PRINCIPAL
    loadPosition();
  }

  //FUNÇÃO PARA CARREGAR ICONE DE POSIÇÃO DO JOGADOR
  Future<void> loadPosition() async {
    //TENTAR CARREGAR SVG DE POSIÇÃO COMO STRING
    try {
      var string_position = await AppHelper.mainPosition(AppIcones.posicao[player['position']]);
      position = string_position;
    } catch (e) {
      position = null;
    }
    //ATUALIZAR STATE
    setState(() {});
  }

  //FUNÇÃO PARA ADICIONAR OU REMOVER JOGADOR DA ESCALAÇÃO
  void setPlayerPosition(uuid){
    //SELECIONAR JOGADOR
    controller.setPlayerEscalation(uuid);
    //FECHAR BOTTOM SHEET
    Get.back();
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //LISTA DE METRICAS DO CARD
    List<Map<String, dynamic>> metrics = [
      {
        'name':'price',
        'label':'Valor de Mercado',
        'icon': AppIcones.money_check_solid,
        'price':true
      },
      {
        'name':'valorization',
        'label':'Valorização',
        'icon': AppIcones.sort_amount_up_solid,
        'price':false
      },
      {
        'name':'lastPontuation',
        'label':'Última Pontuação',
        'icon': AppIcones.calculator_solid,
        'price':false
      },
      {
        'name':'media',
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
      height: ( dimensions.height / 2 ) + 50,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(position == null)...[
            const CircularProgressIndicator(
              color: AppColors.green_300,
              strokeWidth: 2,
            ),
          ]else...[
            SizedBox(
              child: Column(
                children: [
                  ImgCircularWidget(
                    height: 100,
                    width: 100,
                    image: player['user']['photo'],
                    borderColor: player['borderColor'],
                  ),
                  Text(
                    "${player['user']['firstName']} ${player['user']['lastName']}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark_500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "@${player['user']['userName']}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray_300,
                    ),
                  ),
                  SvgPicture.string(
                    position!,
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
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
                        color: AppColors.gray_300.withAlpha(40),
                        borderRadius: const BorderRadius.all(Radius.circular(5))
                      ),
                      child: Column(
                        children: [
                          if(name == 'status')...[
                            Icon(
                              AppHelper.setStatusPlayer(player[name])['icon'],
                              size: 30,
                              color: AppHelper.setStatusPlayer(player[name])['color'],
                            )
                          ]else...[
                            Text(
                              "${player[name]}",
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppHelper.setColorPontuation(player[name])['color']),
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
                  text: "Tornar Capitão",
                  icon: Icons.copyright,
                  width: (dimensions.width / 2) - 40,
                  height: 30,
                  backgroundColor: AppColors.yellow_300,
                  textColor: AppColors.dark_500,
                  action: () {print('Tornar Capitão');},
                ),
                ButtonTextWidget(
                  text: "Remover",
                  icon: AppIcones.trash_solid,
                  width: (dimensions.width / 2) - 40,
                  height: 30,
                  backgroundColor: AppColors.red_300,
                  textColor: AppColors.white,
                  action: () => setPlayerPosition(player['id']),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}