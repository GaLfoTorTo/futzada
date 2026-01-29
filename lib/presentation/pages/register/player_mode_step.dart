import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:futzada/presentation/controllers/register_controller.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';
import 'package:futzada/presentation/widget/cards/card_info_widget.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';
import 'package:futzada/presentation/widget/inputs/select_rounded_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_circular_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_outline_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';

class PlayerModeStep extends StatefulWidget {
  const PlayerModeStep({super.key});

  @override
  State<PlayerModeStep> createState() => PlayerModeStepState();
}

class PlayerModeStepState extends State<PlayerModeStep> {
  //CONTROLADORES
  final RegisterController registerController = RegisterController.instance;
  final GlobalKey<FormState> formKeyStep3Player = GlobalKey<FormState>();
  //CONTROLLADOR DE MELHOR PÉ
  bool iconSide = true;
  //CONTROLLADOR DE ARQUETIPO
  late String selectedArquetipo;
  //VALIDADORES
  late bool validatePositions;
  late bool validateFoot;
  //LISTA DE OPTIONS PARA AS POSIÇÕES
  final Map<String, dynamic> positions = {
    "Futebol" : [
      {'position': 'Atacante', 'alias': 'ATA','icon': AppImages.positions["ATA"], "description" : "Vive para o gol. Está sempre buscando o melhor posicionamento, finaliza com confiança e não foge da responsabilidade de decidir o jogo quando a chance aparece."},
      {'position': 'Meio-Campo', 'alias': 'MEI','icon': AppImages.positions["MEI"], "description" : "É quem faz o jogo acontecer. Distribui passes, dita o ritmo da partida, ajuda na marcação e está sempre conectado com defesa e ataque."},
      {'position': 'Lateral', 'alias': 'LAT','icon': AppImages.positions["LAT"], "description" : "Corre o campo inteiro. Defende com intensidade e apoia o ataque com velocidade, cruzamentos e presença constante pelos lados."},
      {'position': 'Zagueiro', 'alias': 'ZAG','icon': AppImages.positions["ZAG"], "description" : "Imponente e concentrado. Protege a área, antecipa jogadas, ganha duelos e transmite segurança para todo o time."},
      {'position': 'Goleiro', 'alias': 'GOL','icon': AppImages.positions["GOL"], "description" : "Defende o gol com reflexos rápidos, lidera a defesa e muitas vezes salva o time nos momentos mais difíceis."},
    ],
    "Volei" : [
      {'position': 'Levantador', 'alias': 'LEV','icon': AppImages.positions["LEV"], "description" : "Enxerga o jogo como ninguém. Decide quem ataca, controla o ritmo da partida e transforma boas recepções em grandes jogadas."},
      {'position': 'Oposto', 'alias': 'OPO','icon': AppImages.positions["OPO"], "description" : "Principal finalizador do time. Atua no lado oposto ao levantador, atacando bolas altas e ajudando no bloqueio."},
      {'position': 'Central', 'alias': 'CEN','icon': AppImages.positions["CEN"], "description" : "Domina a rede. Especialista em bloqueios e ataques rápidos, impõe presença física e dificulta a vida dos atacantes adversários."},
      {'position': 'Ponteiro', 'alias': 'PON','icon': AppImages.positions["PON"], "description" : "Atua nas extremidades da rede. É responsável por atacar, receber saques e ajudar na defesa, sendo uma das posições mais completas."},
      {'position': 'Libero', 'alias': 'LIB','icon': AppImages.positions["LIB"], "description" : "Especialista em defesa e recepção. Não ataca nem saca e não pode ir à rede. Atua com agilidade e precisão no passe."},
    ],
    "Basquete" : [
      {'position': 'Armador', 'alias': 'ARM','icon': AppImages.positions["ARM"], "description" : "Comanda o time dentro da quadra. Organiza jogadas, controla o ritmo e faz os companheiros jogarem melhor."},
      {'position': 'Ala', 'alias': 'ALA','icon': AppImages.positions["ALA"], "description" : "Equilibrado, dinâmico, versátil, atua tanto no ataque quanto na defesa. Contribui com arremessos, infiltrações e marcação."},
      {'position': 'Ala-Armador', 'alias': 'ALM','icon': AppImages.positions["ALM"], "description" : "Combina funções de armador e ala. Ajuda na criação de jogadas, pontuação e defesa, sendo muito dinâmico."},
      {'position': 'Ala-Pivô', 'alias': 'ALP','icon': AppImages.positions["ALP"], "description" : "Atua próximo ao garrafão, mas também pode arremessar de média distância. Contribui com rebotes, força física e pontuação."},
      {'position': 'Pivô', 'alias': 'PIV','icon': AppImages.positions["PIV"], "description" : "Jogador mais alto e forte. Atua perto da cesta, sendo responsável por rebotes, bloqueios e finalizações próximas ao aro."},
    ],
  };
  
  //LISTA DE OPTIONS PARA O MELHOR PÉ
  final List<Map<String, dynamic>> bestSide = [
    {'value': 'Left', "label": "Esquerda", 'icon': AppIcones.foot_left_solid},
    {'value': 'Right', "label": "Direita", 'icon': AppIcones.foot_right_solid},
  ];

  @override
  void initState() {
    super.initState();
    //INICIAR LOOP DE TROCA DE ICONE
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return false;
      setState(() => iconSide = !iconSide);
      return true;
    });
    //INICIALIZAR ARQUETIPO
    selectedArquetipo = registerController.player.type ?? "Item";
    //INICIALIZAR VALIDADOR DE POSICOES
    validatePositions = true;
    validateFoot = true;
  }

  //FUNÇÃO PARA SELECIONAR POSIÇÃO PRINCIPAL
  void selectPosition(String position, String modality, bool main){
    setState(() {
      //SELECIONAR POSIÇÃO
      if(!registerController.positions.contains(position)){
        registerController.positions.add(position);
        if(main){
          //ATUALIZAR VALOR DO CONTROLER
          registerController.mainPositions[modality] = position;
        }
      }else{
        registerController.positions.remove(position);
        if(main){
          //ATUALIZAR VALOR DO CONTROLER
          registerController.mainPositions[modality] = "";
        }
      }
    });
  }

  //SELECIONAR O MELHOR PÉ
  void selectBestSide(String value){
    setState(() {
      //ATUALIZAR VALOR DO CONTROLER
      registerController.bestSideController.text = value;
    });
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //VALIDAR FORMULÁRIO
    if(registerController.bestSideController.text.isNotEmpty && registerController.positions.isNotEmpty && registerController.mainPositions.isNotEmpty){
      registerController.playerChecked = true;
      //RETORNAR PARA APRESENTAÇÃO DOS MODOS
      Get.offNamed("/register");
    }else{
      AppHelper.feedbackMessage(context, "Informe o seu melhor lado e escolha as posições que você atua em cada modalidade.");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: HeaderWidget(
        title: "Cadastro", 
        leftAction: () => Get.back()
      ),
      body: SafeArea(
        child: Form(
          key: formKeyStep3Player,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Atuação Jogador",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Atuação jogador são para os atletas da pelada, aqueles que entregam tudo de si dentro de campo em suas participações.",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  ButtonCircularWidget(
                    color: AppColors.green_300,
                    icon: AppIcones.foot_futebol_solid,
                    iconColor: AppColors.white,
                    iconSize: 40.0,
                    checked: true,
                    size: 130,
                    action: () => {},
                  ),
                  const CardInfoWidget(description: "Informe em quais posições você costuma ou gosta de joga, seja no campo, quadra ou campos society. Você pode escolher mais de uma posição mas deve definir uma como sendo a principal."),
                  const Divider(),
                  Text(
                    "Melhor Lado",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: bestSide.map((item){
                      return SelectRoundedWidget(
                        label: item["label"],
                        value: item['value'],
                        icon: iconSide ? Icons.back_hand_rounded : item['icon'],
                        checked: registerController.bestSideController.text == item['value'],
                        onChanged: selectBestSide,
                      );
                    }).toList()
                  ),
                  if(validateFoot == false)...[
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Informe qual o seu melhor lado!',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.red_300
                        )
                      ),
                    ),
                  ],
                  if(registerController.modalities.isNotEmpty)...[
                    Column(
                      spacing: 10,
                      children: [
                        Text(
                          "Posições",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          "Selecione as posições que você mais gosta de jogar em todas as modalidades que você deseja participar.",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const CardInfoWidget(description: "Selecione sua posição principal clicando 2 vezes na posição escolhida em cada modalidade."),
                        Column(
                          children: registerController.modalities.map((modality){
                            final modalitySettings = AppHelper.getIconCategory(modality);
                            return ExpansionTile(
                              initiallyExpanded: true,
                              title: Text(
                                modality,
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: modalitySettings["color"]
                                )
                              ),
                              leading: Icon(
                                modalitySettings["icon"],
                                size: 30,
                                color: modalitySettings["color"],
                              ),
                              children: [
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: 550,
                                    initialPage: 0,
                                    autoPlay: false,
                                    enableInfiniteScroll: true,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.2,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  items: [
                                    ...positions[modality].map((item){
                                      
                                      return Card(
                                        child: InkWell(
                                          onTap: () => selectPosition(item['alias'], modality, false),
                                          onDoubleTap: () => selectPosition(item['alias'], modality, true),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: registerController.positions.contains(item['alias']) ? modalitySettings["color"] : AppColors.white,
                                              border: Border.all(
                                                color: registerController.positions.contains(item['alias']) ? AppColors.white : AppColors.grey_300,
                                                width: registerController.positions.contains(item['alias']) ? 4 : 2,
                                              ),
                                            ),
                                            child: Column(
                                              spacing: 10,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  item['icon'], 
                                                  width: 250,
                                                  height: 250,
                                                ),
                                                PositionWidget(
                                                  width: 50,
                                                  position: item['alias'],
                                                ),
                                                Text(
                                                  item["position"],
                                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                    color: AppColors.blue_500
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  item['description'],
                                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                    color: AppColors.blue_500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                if(registerController.mainPositions[modality] == item['alias'])...[
                                                  Container(
                                                    padding: const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.white,
                                                      borderRadius: BorderRadius.circular(50),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: AppColors.dark_500.withAlpha(50),
                                                          blurRadius: 5,
                                                          offset: const Offset(0, 3),
                                                        ),
                                                      ]
                                                    ),
                                                    child: const Icon(
                                                      Icons.workspace_premium,
                                                      color: AppColors.yellow_500,
                                                      size: 36,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Posição Principal",
                                                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                                      color: AppColors.blue_500,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ]
                                              ],
                                            )
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ]
                                )
                              ],
                            );
                          }).toList(),
                        ),
                        if (validatePositions == false)...[
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              'Ao menos 1 posição deve ser selecionada',
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: AppColors.red_300
                              )
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ButtonOutlineWidget(
                        text: "Voltar",
                        width: 100,
                        action: () => Get.back()
                      ),
                      ButtonTextWidget(
                        text: "Definir",
                        icon: Icons.save,
                        width: 100,
                        action: submitForm
                      ),
                    ],
                  ),
                ]
              )
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}