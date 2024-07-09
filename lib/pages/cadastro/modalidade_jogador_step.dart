import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/cadastro_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/inputs/input_checkbox_widget.dart';
import 'package:futzada/widget/inputs/select_rounded_widget.dart';
import 'package:futzada/widget/inputs/select_widget.dart';

class ModalidadeJogadorStepState extends StatefulWidget {
  final VoidCallback proximo;
  final VoidCallback voltar;
  final int etapa;
  final CadastroController controller;

  const ModalidadeJogadorStepState({
    super.key, 
    required this.proximo, 
    required this.voltar, 
    required this.etapa, 
    required this.controller
  });

  @override
  State<ModalidadeJogadorStepState> createState() => ModalidadeJogadorStepStateState();
}

class ModalidadeJogadorStepStateState extends State<ModalidadeJogadorStepState> {
  //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  // CONTROLLERS DE CADA CAMPO
  late final TextEditingController melhorPeController;
  late final TextEditingController arquetipoController;
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
    //INICIALIZAR LISTENER
    widget.controller.addListener((){});
    //INICIALIZAR CONTROLLER DE POSIÇÃO E CONVERTER STRING PARA MAP
    posicoes = widget.controller.model.posicoes != null ? jsonDecode(widget.controller.model.posicoes!) : [];
    //INICIALIZAÇÃO DE CONTROLLERS DE POSIÇÕES
    isCheckedAta = posicoes.contains('ATA') ? true : false;
    isCheckedMei = posicoes.contains('MEI') ? true : false;
    isCheckedZag = posicoes.contains('ZAG') ? true : false;
    isCheckedGol = posicoes.contains('GOL') ? true : false;
    //INICIALIZAÇÃO DE CONTROLLERS DE MELHOR PÉ
    melhorPeController = TextEditingController(text: widget.controller.model.melhorPe);
    arquetipoController = TextEditingController(text: widget.controller.model.arquetipo);
    isCheckedDireito = melhorPeController.text != '' && melhorPeController.text == 'Direito' ? true : false;
    isCheckedEsquerdo =  melhorPeController.text != '' && melhorPeController.text == 'Esquerdo' ? true : false;
    //INICIALIZAR ARQUETIPO
    selectedArquetipo = arquetipoController.text != '' ? arquetipoController.text : "Item";
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
      widget.controller.onSaved({"posicoes": jsonEncode(posicoes)});
    });
  }

  //SELECIONAR O MELHOR PÉ
  void selectMelhorPe(String value){
    setState(() {
      //ATUALIZAR VALOR DO CONTROLER
      melhorPeController.text = value;
      widget.controller.onSaved({"melhorPe": value});
      //VERIFICAR E ALTERAR PÉ SELECIONADO
      isCheckedEsquerdo = value == 'Esquerdo' ?  true : false;
      isCheckedDireito = value == 'Direito' ? true : false;
    });
  }

  //SELECIONAR ARQUETIPO
  void selectArquetipo(String value){
    setState(() {
      //ATUALIZAR VALOR DO CONTROLER
      arquetipoController.text = value;
      widget.controller.onSaved({"arquetipo": value});
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
      validateFoot = melhorPeController.text.isNotEmpty ? true : false;
    });
    //VALIDAR FORMULÁRIO
    if(validatePositions && validateFoot){
      //SALVAR DADOS CRUCIAIS DO FORMULÁRIO
      formData?.save();
      widget.proximo();
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
      {'value': 'Esquerdo', 'icon': AppIcones.pe["esquerdo"], 'checked': isCheckedEsquerdo},
      {'value': 'Direito', 'icon': AppIcones.pe["direito"], 'checked': isCheckedDireito},
    ];
    //LISTA DE OPTIONS PARA O ARQUETIPO
    final List<String> arquetipos = [
      "Goleiro Clássico","Goleador","Capitão","Artilheiro","Driblador","Carrasco das Bolas Paradas","Mestre da Defesa","Talento em Ascensão","Estrategista do Meio-Campo","Atacante Veloz","Firme na Marcação","Líder Nato","Motor do Time","Veterano","Versátil","Raçudo","Incansável","Gênio da Assistência","Muralha","Destruidor de Jogadas","Garçom","Estrategista Tático","Finalizador","Gênio","Lenda","Caçador","Guerreiro","Mágico","Bruxo","Lutador","Especialista em Cruzamentos","Maestro","Camisa 10 Clássico","Sem Freio","Acelerador","Dono da Area","Expert na Recuperação","Sem Pressão","Articulador","Estrategista","Imbatível","Mestre da Comunicação","Especialista em Desarmes","Controlador do Ritmo","Mito da Torcida","Lançador","Determinado","Jogador de Classe","Joga de terno","Velocista","Inteligente","Ídolo","Marcador","Vai e Volta","Trator","Retranqueiro","Experiente","Protetor do Gol","Dono do Campo","Gelado",
    ];

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const IndicatorFormWidget(etapa: 2),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "A modalidade jogador são para os atletas da pelada, aqueles que entregam tudo de si dentro de campo com suas atuações.",
                  style: TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Jogador",
                        style: TextStyle(
                          color: AppColors.blue_500,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: AppColors.green_300,
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Transform.rotate(
                          angle: - 45 * 3.14159 / 180,
                          child: SvgPicture.asset(
                            AppIcones.chuteiras['campo']!,
                            width: double.infinity,
                            height: double.infinity,
                          ) 
                        ) 
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Informe em quais posições você costuma ou gosta de joga, seja no campo, quadra ou campos society. Você pode escolher mais de uma posição mas deve definir uma como sendo a principal.",
                  style: TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Posições",
                        style: TextStyle(
                          color: AppColors.dark_500,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
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
                                  padding: EdgeInsets.symmetric(horizontal: 15),
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
                                      InputCheckboxWidget(
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Melhor pé",
                        style: TextStyle(
                          color: AppColors.dark_500,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for(var pe in melhorPe)
                          SelectRoundedWidget(
                            value: pe['value'],
                            icon: pe['icon'],
                            checked: pe['checked'],
                            controller: widget.controller,
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
              SelectWidget(
                label: "Arquetipo", 
                options: arquetipos, 
                selected: selectedArquetipo,
                onChanged: selectArquetipo
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ButtonTextWidget(
                      type: "outline",
                      text: "Voltar",
                      textColor: AppColors.blue_500,
                      color: AppColors.blue_500,
                      width: 100,
                      action: widget.voltar,
                    ),
                    ButtonTextWidget(
                      text: "Definir",
                      textColor: AppColors.blue_500,
                      color: AppColors.green_300,
                      width: 100,
                      action: submitForm,
                    ),
                  ],
                ),
              ),
            ]
          )
        )
      ),
    );
  }

  @override
  void dispose() {
    // REMOVER LISTENER
    widget.controller.removeListener(() {});
    // DISPENSAR CONTROLLERS
    melhorPeController.dispose();
    arquetipoController.dispose();
    super.dispose();
  }
}