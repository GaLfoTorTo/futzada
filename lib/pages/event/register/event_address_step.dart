import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:futzada/widget/inputs/input_date_widget.dart';
import 'package:futzada/widget/inputs/select_days_week_widget.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
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
  //DATA FIXA
  bool dataFixa = false;
  //CATEGORIA
  String? categoria;
  //TIMER DE CONSULTA ENDEREÇO
  Timer? debounce;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  //FUNÇÃO SELECIONAR DIA DA SEMANA
  void selectDaysWeek(String key, bool value){
    setState(() {
      //ATUALIZAR VALOR DO DIA DA SEMANA
      eventController.daysOfWeek[key] = value;
    });
  }

  //FUNÇÃO PARA ALTERAR DATA FIXA
  void alterDataFixa(bool value){
    setState(() {
      dataFixa = ! dataFixa;
    });
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
      eventController.dateController.text = AppHelper.formatDate(dateSelected);
    }
  }

  //FUNÇÃO PARA PICKER DE HORAS
  Future<void> selectTime(BuildContext context, name) async {
    final TimeOfDay? timeSelected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
          ),
          child: child!,
        );
      },
    );
    if (timeSelected != null) {
      //VERIFICAR HORARAIO
      if(name == 'horaInicio'){
        //ATUALIZAR VALOR DO CONTROLER
        eventController.startTimeController.text =  timeSelected.toString();
      }else{
        //ATUALIZAR VALOR DO CONTROLER
        eventController.endTimeController.text = timeSelected.toString();
      }
    }
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      //NAVEGAR PARA CADASTRO DE ENDEREÇO
      Get.toNamed('/event/register/event_participants');
    }
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.light,
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
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const IndicatorFormWidget(
                    length: 3,
                    etapa: 1
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Endereço, Data e Hora",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),]
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  padding: EdgeInsets.only(right: 15),
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
                        )
                      ],
                    ),
                  ),
                  if(!dataFixa)...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child:Text(
                            "Dia da Semana",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ...eventController.daysOfWeek.entries.map<Widget>((item) {
                                final key = item.key;
                                final value = item.value;
                                return SelectDaysWeekWidget(
                                  value: key,
                                  checked: value,
                                  action: () => selectDaysWeek(key, value),
                                );
                              }),
                            ]
                          ),
                        ),
                      ],
                    ),
                  ]else...[
                    InputDateWidget(
                      name: 'data',
                      label: 'Data',
                      textController: eventController.dateController,
                      controller: eventController,
                      showModal: () => selectDate(context),
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ButtonTextWidget(
                          text: !dataFixa ? "Escolher Data" : "Data Fixa",
                          width: dimensions.width / 2 - 40,
                          height: 20,
                          icon: LineAwesomeIcons.exchange_alt_solid,
                          action: () => alterDataFixa(!dataFixa),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: dimensions.width / 2 - 20,
                          child: InputDateWidget(
                            name: 'horaInicio',
                            label: 'Hora de Início',
                            textController: eventController.startTimeController,
                            controller: eventController,
                            showModal: () => selectTime(context, 'horaInicio'),
                          ),
                        ),
                        Container(
                          width: dimensions.width / 2 - 20,
                          child: InputDateWidget(
                            name: 'horaFim',
                            label: 'Hora de Fim',
                            textController: eventController.endTimeController,
                            controller: eventController,
                            showModal: () => selectTime(context, 'horaFim'),
                          ),
                        ),
                      ],
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
                          text: "Próximo",
                          width: 100,
                          action: submitForm,
                        ),
                      ],
                    ),
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