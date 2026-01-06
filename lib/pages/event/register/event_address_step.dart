import 'dart:async';
import 'package:futzada/utils/form_utils.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/inputs/input_date_widget.dart';
import 'package:futzada/widget/inputs/select_days_week_widget.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/navigation_controller.dart';

class EventAddressStep extends StatefulWidget {  
  const EventAddressStep({super.key});

  @override
  State<EventAddressStep> createState() => EventAddressStepState();
}

class EventAddressStepState extends State<EventAddressStep> {
  //RESGATAR CONTROLLER DE NAVEGAÇÃO
  NavigationController navigationController = NavigationController.instance;
  //RESGATAR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
  //DEFINIR FORMKEY
  final formKey = GlobalKey<FormState>();
  //CONTROLADOR DE VALIDAÇÃO
  bool isValid = true;
  //DEFINIR ESTADO DE EXIBIÇÃO DE DATA
  bool isWeekDay = true;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  //FUNÇÃO PARA PICKER DE DATA
  Future<void> selectDate(BuildContext context) async {
    final DateTime? dateSelected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      cancelText: "Cancelar",
    );
    if (dateSelected != null) {
      //ATUALIZAR VALOR DO CONTROLER
      eventController.dateController.text = DateFormat("dd/MM/yyyy").format(dateSelected);
    }
  }
  
  //FUNÇÃO PARA VALIDAR FORMULÁRIO
  void validForm(){
    setState(() {
      //VERIFICAR SE ENDEREÇO FOI SELECIONADO
      if(eventController.addressEvent.street == null){
        isValid = false;
      }
      //VERIFICAR SE DATA FOI DEFINIDA
      if(isWeekDay){
        if(!eventController.daysOfWeek.containsValue(true)){
          isValid = false;
        }
      }
      //RESGATAR O FORMULÁRIO
      var formData = formKey.currentState;
      //VERIFIAR SE CAMPOS DE TEXTO FORAM PREENCHIDOS
      if(formData?.validate() ?? false){
        isValid = true;
        return;
      }
      isValid = false;
      return;
    });
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //VALIDAR FORMULÁRIO
    validForm();
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (isValid) {
      //NAVEGAR PARA CADASTRO DE ENDEREÇO
      Get.toNamed('/event/register/config_games');
    }
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      appBar: HeaderWidget(
        title: "Registro", 
        leftAction: () => Get.back(),
        rightAction: () => navigationController.backHome(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: dimensions.width,
              height: dimensions.height * 0.90,
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        const IndicatorFormWidget(
                          length: 3,
                          etapa: 1
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "Endereço, Data e Hora",
                                style: Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Onde vamos jogar ? Informe os dados de endereço, categoria, data e horário de sua pelada.",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child:Text(
                            "Endereço",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed('/explore/map/picker'), 
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.white,
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: SizedBox(
                            width: dimensions.width,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Icon(
                                    AppIcones.marker_solid,
                                    color: eventController.addressEvent.street != null 
                                      ? AppColors.dark_300
                                      : AppColors.gray_300,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${eventController.addressText}",
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: eventController.addressEvent.street != null 
                                        ? AppColors.dark_300
                                        : AppColors.gray_300,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //VALIDAÇÃO DE ENDEREÇO
                        if(!isValid && eventController.addressEvent.street == null)...[
                          const Padding(
                            padding: EdgeInsets.only(top: 10, left: 8.0),
                            child: Text(
                              'O endereço deve ser informado!',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ],
                        Text(
                          eventController.labelDate.value,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SelectDaysWeekWidget(
                          values: eventController.daysWeek,
                          onChanged: (value){
                            if (eventController.daysWeek.contains(value)) {
                              eventController.daysWeek.remove(value);
                            } else {
                              eventController.daysWeek.add(value);
                            }
                          },
                        ),
                        //VALIDAÇÃO DE DIAS DA SEMANA
                        if(!isValid && !eventController.daysOfWeek.containsValue(true))...[
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Selecione os dias da semana ou defina uma data fixa!',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ],
                        Text(
                          'Horários',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: dimensions.width / 2 - 20,
                              child: InputDateWidget(
                                name: 'horaInicio',
                                label: 'Hora de Início',
                                textController: eventController.startTimeController,
                                onValidated: (value) => eventController.formService.validateEmpty(value, 'Hora de Início'),
                                showModal: () => FormUtils.selectTime(context, 'horaInicio'),
                              ),
                            ),
                            SizedBox(
                              width: dimensions.width / 2 - 20,
                              child: InputDateWidget(
                                name: 'horaFim',
                                label: 'Hora de Fim',
                                textController: eventController.endTimeController,
                                onValidated: (value) => eventController.formService.validateEmpty(value, 'Hora de Fim'),
                                showModal: () => FormUtils.selectTime(context, 'horaFim'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ButtonOutlineWidget(
                        text: "Voltar",
                        width: 100,
                        action: () => Get.back(),
                      ),
                      ButtonTextWidget(
                        text: "Próximo",
                        width: 100,
                        action: submitForm,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}