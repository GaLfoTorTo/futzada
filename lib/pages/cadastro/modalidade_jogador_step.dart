import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/cadastro_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_circular_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/inputs/input_posicao_widget.dart';
import 'package:futzada/widget/inputs/select_rounded_widget.dart';
import 'package:futzada/widget/inputs/select_widget.dart';
import 'package:get/get.dart';

class ModalidadeJogadorStep extends StatefulWidget {
  const ModalidadeJogadorStep({super.key});

  @override
  State<ModalidadeJogadorStep> createState() => ModalidadeJogadorStepState();
}

class ModalidadeJogadorStepState extends State<ModalidadeJogadorStep> {
  //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  //CONTROLADOR DOS INPUTS DO FORMULÁRIO
  final CadastroController controller = Get.put(CadastroController());
  //CONTROLLER DE POSIÇÕES
  late List<dynamic> posicoes;
  //CONTROLLERS DE POSIÇÕES
  late bool isCheckedGol;
  late bool isCheckedZag;
  late bool isCheckedMei;
  late bool isCheckedAta;
  //CONTROLLADOR DE MELHOR PÉ
  late bool isCheckedEsquerdo;
  late bool isCheckedDireito;
  //CONTROLLADOR DE ARQUETIPO
  late String selectedArquetipo;
  //VALIDADORES
  late bool validatePositions;
  late bool validateFoot;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE POSIÇÃO E CONVERTER STRING PARA MAP
    posicoes = controller.model.posicoes != null ? jsonDecode(controller.model.posicoes!) : [];
    //INICIALIZAÇÃO DE CONTROLLERS DE POSIÇÕES
    isCheckedAta = posicoes.contains('ATA') ? true : false;
    isCheckedMei = posicoes.contains('MEI') ? true : false;
    isCheckedZag = posicoes.contains('ZAG') ? true : false;
    isCheckedGol = posicoes.contains('GOL') ? true : false;
    //INICIALIZAÇÃO DE CONTROLLERS DE MELHOR PÉ
    isCheckedDireito = controller.model.melhorPe != null && controller.model.melhorPe == 'Direito' ? true : false;
    isCheckedEsquerdo =  controller.model.melhorPe != null && controller.model.melhorPe == 'Esquerdo' ? true : false;
    //INICIALIZAR ARQUETIPO
    selectedArquetipo = controller.model.arquetipo != null ? controller.model.arquetipo! : "Item";
    //INICIALIZAR VALIDADOR DE POSICOES
    validatePositions = true;
    validateFoot = true;
  }

  //FUNÇÃO PARA SELECIONAR POSIÇÕES DO JOGADOR
  void selectPosition(bool checked, String position){
    setState(() {
      //VERIFICAR POSIÇÃO SELECIONADO
      switch (position) {
        case 'ATA':
          isCheckedAta = checked;
          break;
        case 'MEI':
          isCheckedMei = checked;
          break;
        case 'ZAG':
          isCheckedZag = checked;
          break;
        case 'GOL':
          isCheckedGol = checked;
          break;
        default:
      }
      //ADICIONAR OU REMOVER POSIÇÃO DO ARRAY DE POSIÇÕES
      checked == true ? posicoes.add(position) : posicoes.remove(position);
      controller.onSaved({"posicoes": jsonEncode(posicoes)});
    });
  }

  //SELECIONAR O MELHOR PÉ
  void selectMelhorPe(String value){
    setState(() {
      //ATUALIZAR VALOR DO CONTROLER
      controller.melhorPeController.text = value;
      controller.onSaved({"melhorPe": value});
      //VERIFICAR E ALTERAR PÉ SELECIONADO
      isCheckedEsquerdo = value == 'Esquerdo' ?  true : false;
      isCheckedDireito = value == 'Direito' ? true : false;
    });
  }

  //SELECIONAR ARQUETIPO
  void selectArquetipo(String value){
    setState(() {
      //ATUALIZAR VALOR DO CONTROLER
      controller.arquetipoController.text = value;
      controller.onSaved({"arquetipo": value});
    });
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //ATUALIZAR STATUS
    setState(() {
      //VERIFICAR SE AO MENOS 1 POSIÇÃO FOI SELECIONADA
      validatePositions = posicoes.length > 0 ? true : false;
      //VERIFICAR SE AO MENOS 1 PÉ FOI SELECIONADO
      validateFoot = controller.melhorPeController.text.isNotEmpty ? true : false;
    });
    //VALIDAR FORMULÁRIO
    if(validatePositions && validateFoot){
      //SALVAR DADOS CRUCIAIS DO FORMULÁRIO
      formData?.save();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    //LISTA DE OPTIONS PARA AS POSIÇÕES
    final List<Map<String, dynamic>> posicoes = [
      {'posicao': 'Atacante', 'sigla': 'ATA', 'icon': AppIcones.posicao["ata"],'icon_posicao': AppIcones.silhueta["ata"], 'checked': isCheckedAta},
      {'posicao': 'Meio-Campo', 'sigla': 'MEI', 'icon': AppIcones.posicao["mei"],'icon_posicao': AppIcones.silhueta["mei"], 'checked': isCheckedMei},
      {'posicao': 'Zagueiro', 'sigla': 'ZAG', 'icon': AppIcones.posicao["zag"],'icon_posicao': AppIcones.silhueta["zag"], 'checked': isCheckedZag},
      {'posicao': 'Goleiro', 'sigla': 'GOL', 'icon': AppIcones.posicao["gol"],'icon_posicao': AppIcones.silhueta["gol"], 'checked': isCheckedGol},
    ];
    //LISTA DE OPTIONS PARA O MELHOR PÉ
    final List<Map<String, dynamic>> melhorPe = [
      {'value': 'Esquerdo', 'icon': AppIcones.foot_left_solid, 'checked': isCheckedEsquerdo},
      {'value': 'Direito', 'icon': AppIcones.foot_right_solid, 'checked': isCheckedDireito},
    ];
    //LISTA DE OPTIONS PARA O ARQUETIPO
    final List<String> arquetipos = [
      "Goleiro Clássico","Goleador","Capitão","Artilheiro","Driblador","Carrasco das Bolas Paradas","Mestre da Defesa","Talento em Ascensão","Estrategista do Meio-Campo","Atacante Veloz","Firme na Marcação","Líder Nato","Motor do Time","Veterano","Versátil","Raçudo","Incansável","Gênio da Assistência","Muralha","Destruidor de Jogadas","Garçom","Estrategista Tático","Finalizador","Gênio","Lenda","Caçador","Guerreiro","Mágico","Bruxo","Lutador","Especialista em Cruzamentos","Maestro","Camisa 10 Clássico","Sem Freio","Acelerador","Dono da Area","Expert na Recuperação","Sem Pressão","Articulador","Estrategista","Imbatível","Mestre da Comunicação","Especialista em Desarmes","Controlador do Ritmo","Mito da Torcida","Lançador","Determinado","Jogador de Classe","Joga de terno","Velocista","Inteligente","Ídolo","Marcador","Vai e Volta","Trator","Retranqueiro","Experiente","Protetor do Gol","Dono do Campo","Gelado",
    ];
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Cadastro", 
        leftAction: () => Get.back()
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: dimensions.width,
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const IndicatorFormWidget(
                    length: 3,
                    etapa: 1
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "A modalidade jogador são para os atletas da pelada, aqueles que entregam tudo de si dentro de campo com suas atuações.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          'Jogador',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ButtonCircularWidget(
                            color: AppColors.green_300,
                            icon: AppIcones.foot_field_solid,
                            iconColor: AppColors.white,
                            iconSize: 40.0,
                            checked: true,
                            size: 130,
                            action: () => {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Informe em quais posições você costuma ou gosta de joga, seja no campo, quadra ou campos society. Você pode escolher mais de uma posição mas deve definir uma como sendo a principal.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            "Posições",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        Wrap(
                          spacing: 50, 
                          runSpacing: 15,
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 560,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                autoPlay: false,
                                enlargeCenterPage: true,
                                enlargeFactor: 0.2,
                                scrollDirection: Axis.horizontal,
                              ),
                              items: posicoes.map((item) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: AppColors.white.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            item['icon_posicao'],
                                            width: 400,
                                            height: 400,
                                            color: item['checked'] ? AppColors.green_300 : AppColors.gray_500,
                                          ),
                                          InputPosicaoWidget(
                                            title: item['posicao'],
                                            sigla: item['sigla'],
                                            isChecked: item['checked'],
                                            icon: item['icon'],
                                            onChanged: selectPosition,
                                          ),
                                        ],
                                      )
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            if (validatePositions == false)
                              const Padding(
                                padding: EdgeInsets.only(top: 16.0),
                                child: Text(
                                  'Ao menos 1 posição deve ser selecionada',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            "Melhor pé",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for(var item in melhorPe)
                              SelectRoundedWidget(
                                value: item['value'],
                                icon: item['icon'],
                                checked: item['checked'],
                                controller: controller,
                                onChanged: selectMelhorPe,
                              )
                          ],
                        ),
                        if (validateFoot == false)
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Informe qual o seu melhor pé!',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ]
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SelectWidget(
                      label: "Arquetipo", 
                      options: arquetipos, 
                      selected: selectedArquetipo,
                      onChanged: selectArquetipo
                    ),
                  ),
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
                        text: "Próximo",
                        width: 100,
                        action: submitForm
                      ),
                    ],
                  ),
                ]
              )
            )
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