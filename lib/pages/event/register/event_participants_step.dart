import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futzada/theme/app_animations.dart';
import 'package:get/get.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:lottie/lottie.dart';

class EventParticipantsStep extends StatefulWidget {
  const EventParticipantsStep({super.key});

  @override
  State<EventParticipantsStep> createState() => _EventParticipantsStepState();
}

class _EventParticipantsStepState extends State<EventParticipantsStep> {
  //RESGATAR CONTROLLER DE NAVEGAÇÃO
  NavigationController navigationController = NavigationController.instance;
  //RESGATAR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
  /* //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  //CONTROLLER DE REGISTRO DA PELADA
  final controller = EventController.instance;
  //TITULO DA PÁGINA
  String titulo = 'Cadastro Pelada';
  //MENSAGEM DE ERRO
  String? errorMessage;

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

  //FUNÇÃO DE DEFINIÇÃO DE PREFERENCIAS DE invite
  void selectPreferencia(String name) {
    //BUSCAR ITEMS DO ARRAY DE invite
    final item = controller.invite.firstWhere((item) => item['name'] == name);
    //ALTERAR VALOR
    item['checked'] = !(item['checked'] as bool);
    //NOTIFICAR MUDANÇA AO CONTROLLER
    controller.invite.refresh();
  }

  void selectParticipante(id){
    setState(() {
      //RESGATAR QUANTIDADE DE PARTICIPANTES SELECIONADOS
      int count = 0;
      //LOOP NOS PARTICIPANTES
      controller.amigos.asMap().forEach((key, item){
        //VERIFICAR SE ITEM RECEBIDO É IGUAL A
        if(item['id'] == id){
          //SELECIONAR PARTICIPANTE
          item['checked'] = !item['checked'];
          //VERIFICAR SE PARTICIPANTE JA FOI CONVIDADO 
          if(item['checked']){
            //ADICIONAR PARTICIPANTE AO ARRAY DE CONVIDADOS
            controller.participantes.add({'id':item['id']});
          }else{
            //ADICIONAR PARTICIPANTE AO ARRAY DE CONVIDADOS
            controller.participantes.removeWhere((participante) => participante['id'] == item['id']);
          }
        }
        //VERIFICAR SE PARTICIPANTE FOI SELECIONADO E INCREMENTAR CONTADOR
        if(item['checked'] == true){
          //INCREMENTAR CONTADOR
          count ++;
        }
      });
      //VERIFICAR QUANTIDADE DE PARTICIPANTES SELECIONADOS
      if(count > 0){
        //ALTERAR TITULO DA PAGINA
        titulo = "$count selecionados";
      }else{
        //ALTERAR TITULO DA PAGINA
        titulo = "Cadastro Pelada";
      }
      //NOTIFICAR MUDANÇA AO CONTROLLER
      controller.amigos.refresh();
      //ADICIONAR A MODEL DE PELADA
      controller.participantsController.text = jsonEncode(controller.participantes);
      controller.onSaved({"participantes": jsonEncode(controller.participantes)});
    });
  }

  //FUNÇÃO DE CALLBACK DE RETORNO DO SERVIDOR
  void onCompleteAnimation(statusRequest) async {
    //ESPERAR 5 SEGUNDOS
    await Future.delayed(Duration(seconds: 5));
    //VERIRICAR SE HOUVE ERRO NO ENVIO DOS DADOS
    if(statusRequest == true){
      //NAVEGAR PARA HOME
      Get.toNamed('/home');
    }else{
      Get.back();
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.feedbackMessage(context, errorMessage);
    }
  }

  //FUNÇÃO DE RETORNO PARA HOME
  void openPreferencia(invites, flag) {
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
                  'invite',
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
                  children: controller.invite.map((entry) {
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

  //FUNÇÃO DE ENVIO DE DADOS PARA BACKEND
  void registerEvent() async{
    var response = controller.registerEvent();
    //MODAL DE STATUS DE REGISTRO DO USUARIO
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 1,
          child: FutureBuilder<Map<String, dynamic>>(
            future: response,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 300,
                  height: 300,
                  child: Center(
                    child: Lottie.asset(
                      AppAnimations.loading,
                      fit: BoxFit.contain,
                    ),
                  )
                );
              }else if(snapshot.hasError) {
                //ADICIONAR MENSAGEM DE ERRO
                errorMessage = 'Erro desconhecido';
                if (snapshot.error is Map<String, dynamic>) {
                  errorMessage = (snapshot.error as Map<String, dynamic>)['message'] ?? 'Erro desconhecido';
                }
                return Container(
                  width: 300,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Lottie.asset(
                        AppAnimations.checkError,
                        fit: BoxFit.contain,
                        onLoaded: (composition) {
                          //REMOVER MODAL
                          onCompleteAnimation(false);
                        },
                      ),
                    ],
                  )
                );
              }else if(snapshot.hasData) {
                //RESGATAR MENSAGEM
                var data = snapshot.data!;
                //VERIFICAR SE OPERAÇÃO FOI BEM SUCEDIDA
                if (data['status'] == 200) {
                  return Container(
                    width: 300,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset(
                          AppAnimations.checkSuccess,
                          fit: BoxFit.contain,
                          onLoaded: (composition) {
                            //REMOVER MODAL
                            onCompleteAnimation(true);
                          },
                        ),
                      ],
                    )
                  );
                }else{
                  //ADICIONAR MENSAGEM DE ERRO
                  errorMessage = data['message'];
                  return Container(
                    width: 300,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset(
                          AppAnimations.checkError,
                          fit: BoxFit.contain,
                          onLoaded: (composition) {
                            //REMOVER MODAL
                            onCompleteAnimation(false);
                          },
                        ),
                      ],
                    )
                  );
                }
              }
              return Container(
                width: 300,
                height: 300,
              );
            }
          )
        );
      },
    );
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      //REGISTRAR PELADA
      registerEvent();
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
        title: titulo, 
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Adicionar Participantes",
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]
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
                          action: () => openPreferencia(controller.invite, 'geral'),
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
                                  onChanged: (value) => selectParticipante(item['id']),
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
  } */
}