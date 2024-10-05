import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/controllers/pelada_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';

class DadosParticipantesStep extends StatefulWidget {
  const DadosParticipantesStep({super.key});

  @override
  State<DadosParticipantesStep> createState() => _DadosParticipantesStepState();
}

class _DadosParticipantesStepState extends State<DadosParticipantesStep> {
  //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  //CONTROLLER DE REGISTRO DA PELADA
  final controller = PeladaController.instace;

  @override
  void initState() {
    super.initState();
    initPositions();
  }

  void initPositions() async{
    //LOOP NOS AMIGOS
    for(var item in controller.amigos){
      //RESGATAR POSIÇÃO PRINCIPAL DO AMIGO
      item['posicao'] = await AppHelper.mainPosition(AppIcones.posicao["mei"]);
      setState(() {});
    }
  }

  void searchParticipantes(String? value){
    print(value);
  }

  //FUNÇÃO DE DEFINIÇÃO DE PREFERENCIAS DE CONVITE
  void selectPreferencia(String name) {
    //BUSCAR ITEMS DO ARRAY DE CONVITE
    final item = controller.convite.firstWhere((item) => item['name'] == name);
    //ALTERAR VALOR
    item['checked'] = !(item['checked'] as bool);
    //NOTIFICAR MUDANÇA AO CONTROLLER
    controller.convite.refresh();
  }

  //FUNÇÃO DE RETORNO PARA HOME
  void openPreferencia(convites, flag) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Convite',
                  style: Get.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Determine o formato de ingresso dos participantes a pelada, as pré-definições aplicadas poderão ser alteradas posteriormente.',
                  style: Get.textTheme.bodySmall!.copyWith(color: AppColors.gray_500),
                  textAlign: TextAlign.center,
                ),
              ),
              Obx(() {
                return Column(
                  children: controller.convite.map((entry) {
                    //RESGATAR ITENS 
                    Map<String, dynamic> item = entry;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SwitchListTile(
                        value: item['checked'],
                        onChanged: (newValue) {
                          selectPreferencia(item['name']);
                        },
                        activeColor: AppColors.green_300,
                        inactiveTrackColor: AppColors.gray_300,
                        inactiveThumbColor: AppColors.gray_500,
                        title: Text(
                          item['label'],
                          style: Get.textTheme.bodyMedium!.copyWith(
                            color: item['checked'] ? AppColors.green_300 : AppColors.gray_500,
                          ),
                        ),
                        secondary: item['icon'] == AppIcones.foot_field_solid
                            ? Transform.rotate(
                                angle: -45 * 3.14159 / 200,
                                child: Icon(
                                  item['icon'],
                                  color: item['checked'] ? AppColors.green_300 : AppColors.gray_500,
                                  size: 18,
                                ),
                              )
                            : Icon(
                                item['icon'],
                                color: item['checked'] ? AppColors.green_300 : AppColors.gray_500,
                                size: 25,
                              ),
                      ),
                    );
                  }).toList(),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonTextWidget(
                    text: "Cancelar",
                    width: 70,
                    height: 20,
                    action: () => Get.back(),
                    backgroundColor: Colors.transparent,
                    textColor: AppColors.gray_500,
                  ),
                  ButtonTextWidget(
                    text: "Definir",
                    width: 50,
                    height: 20,
                    action: () => Get.back(),
                    backgroundColor: Colors.transparent,
                    textColor: AppColors.green_300,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      //NAVEGAR PARA CADASTRO DE ENDEREÇO
      Get.toNamed('/pelada/cadastro/dados_participantes');
    }
  }

  @override
  Widget build(BuildContext context) {
    //CONTROLLER DE BARRA NAVEGAÇÃO
    final navigationController = Get.find<NavigationController>();
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Cadastro Pelada", 
        leftAction: () => Get.back(),
        rightAction: () => navigationController.backHome(context),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const IndicatorFormWidget(
                    length: 3,
                    etapa: 2
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Adicionar Participantes",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),]
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Estamos quase lá! Agora so precisamos adicionar os participantes da pelada para começarmos a jogar.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.labelLarge,
                    decoration: const InputDecoration(
                      hintText: "Pesquisar...",
                      prefixIcon: Icon(AppIcones.search_outline),
                    ),
                    onChanged: (value) => searchParticipantes(value),
                    onTap: () => FocusScope.of(context).unfocus(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Seus Amigos',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        ButtonTextWidget(
                          text: "Preferências",
                          width: 130,
                          height: 20,
                          icon: AppIcones.cog_solid,
                          iconAfter: true,
                          textColor: AppColors.green_300,
                          backgroundColor: Colors.transparent,
                          action: () => openPreferencia(controller.convite, 'geral'),
                        ),
                      ],
                    ),
                  ),
                  for(var item in controller.amigos)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            item['checked'] = !item['checked'];
                          });
                        },
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(AppColors.white),
                          padding: WidgetStatePropertyAll(EdgeInsets.all(15))
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: ImgCircularWidget(
                                      height: 80,
                                      width: 80,
                                      image: item['foto'],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item['nome'],
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                      Text(
                                        "@"+item['userName'],
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300),
                                      ),
                                      if(item['posicao'] != null)                              
                                        SvgPicture.string(
                                          item['posicao'],
                                          width: 25,
                                          height: 25,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              Transform.scale(
                                scale: 2,
                                child: Checkbox(
                                  value: item['checked'],
                                  onChanged: (value) {
                                    setState(() {
                                      item['checked'] = !item['checked'];
                                    });
                                  },
                                  activeColor: AppColors.green_300,
                                  side: const BorderSide(color: AppColors.gray_500, width: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ButtonOutlineWidget(
                          text: "Voltar",
                          width: 100,
                          action: () => Get.back(),
                        ),
                        ButtonTextWidget(
                          text: "Salvar",
                          width: 100,
                          icon: AppIcones.save_solid,
                          action: submitForm,
                        ),
                      ],
                    ),
                  ),
                ]
              )
            )
          )
        )
      )
    );            
  }
}