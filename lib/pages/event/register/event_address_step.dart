import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/widget/inputs/input_date_widget.dart';
import 'package:futzada/widget/inputs/select_days_week_widget.dart';
import 'package:futzada/widget/inputs/select_rounded_widget.dart';
import 'package:futzada/widget/others/campo_widget.dart';
import 'package:get/get.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class EventAddressStep extends StatefulWidget {  
  const EventAddressStep({super.key});

  @override
  State<EventAddressStep> createState() => EventAddressStepState();
}

class EventAddressStepState extends State<EventAddressStep> {
  //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  //CONTROLLER DE REGISTRO DA PELADA
  final controller = EventController.instace;
  //DATA FIXA
  bool dataFixa = false;
  //LISTA DE DIAS DA SEMANA
  final List<Map<String, dynamic>> daysOfWeek = [
    {'dia':'Dom', 'checked':false},
    {'dia':'Seg', 'checked':false},
    {'dia':'Ter', 'checked':false},
    {'dia':'Qua', 'checked':false},
    {'dia':'Qui', 'checked':false},
    {'dia':'Sex', 'checked':false},
    {'dia':'Sab', 'checked':false},
  ];
  //CATEGORIA
  String? categoria;
  //TIMER DE CONSULTA ENDEREÇO
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    categoria = controller.categoryController.text;
  }

  //FUNÇÃO PARA BUSCAR ENDEREÇO (VIA CEP)
  void searchAddress(value) {
    //ATUALIZAR ISSEARCHING
    controller.isSearching.value = true;
    controller.isSearching.refresh();
    //CANCELAR O TIMER ATUAL SE EXISTIR
    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }
    //VERIFICAR SE VALOR RECEBIDO NÃO ESTA VAZIO
    if (value.isNotEmpty) {
      //CRIAR UM NOVO TIMER DE 2 SEGUNDOS
      debounce = Timer(const Duration(seconds: 2), () async {
        //BUSCAR ENDEREÇO VIA CEP
        var endereco = await AppHelper.getAddress(value);
        //VERIFICAR SE FOI ENCONTRADO APENAS UM ENDEREÇO
        if(endereco is Map){
          //VERIFICAR SE OCORREU UM ERRO
          if(endereco.containsKey('error')){
            //ATUALIZAR MENSAGEM DE ERRO
            controller.enderecoMessage.value = endereco['error'];
            controller.enderecoMessage.refresh();
            //ATUALIZAR ISSEARCHING
            controller.enderecos.value = [];
            controller.enderecos.refresh();
          }else{
            //ATUALIZAR ENDEREÇOS
            controller.enderecos.value = [endereco as Map<String, dynamic> ];
            controller.enderecos.refresh();
          }
        }
        //VERIFICAR SE FOI ENCONTRADO MAIS DE UM ENDEREÇO
        if(endereco is List){
          //CONVERTER DADOS RECEBIDOS PARA O TIPO CORRETO (List<Map<String, dynamic>>)
          List<Map<String, dynamic>> listEnderecos = List<Map<String, dynamic>>.from(endereco.cast<Map<String, dynamic>>());
          //ATUALIZAR ENDEREÇOS
          controller.enderecos.value = listEnderecos;
          controller.enderecos.refresh();
        }
        //ATUALIZAR ISSEARCHING
        controller.isSearching.value = false;
        controller.isSearching.refresh();
      });
    }else{
      //ATUALIZAR ISSEARCHING
      controller.enderecos.value = [];
      controller.enderecos.refresh(); 
      //ATUALIZAR ISSEARCHING
      controller.isSearching.value = false;
      controller.isSearching.refresh();
    }
  }

  //FUNÇÃO PARA ABRIR BOTTOMSHEET
  void openAdressSearch() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
        ),
        child: Column(
          children: [
            Row(
              children: [
                const BackButton(),
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Text(
                    'Onde você joga?',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            InputTextWidget(
              name: 'search',
              hint: 'Ex: Campo de Futebol Divinéia - Núcleo Bandeirante, Brasília - DF',
              textController: controller.addressController,
              prefixIcon: AppIcones.marker_solid,
              controller: controller,
              onChanged: searchAddress,
              onSaved: controller.onSaved,
              type: TextInputType.text,
              showModal: openAdressSearch,
            ),
            const Divider(),
            Obx(() {
              return Expanded(
                child: controller.enderecos.isEmpty 
                ? Center(
                    child: controller.isSearching.value
                      ? const CircularProgressIndicator(
                          color: AppColors.green_300,
                        )
                      : Column(
                          children: [
                            Text(
                              controller.enderecoMessage.value,
                              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                                color: AppColors.gray_500,
                              )
                            ),
                            Text(
                              'Ex: Quadra Poliesportiva - Brasília - DF',
                              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                                color: AppColors.gray_500,
                              ),
                              textAlign: TextAlign.center
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Você também pode buscar o endereço pelo CEP',
                                style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                                  color: AppColors.gray_500,
                                ),
                                textAlign: TextAlign.center
                              ),
                            ),
                            Text(
                              'Caso o endereço estja correto mas não foi encontrado, prossiga com o cadastro normalmente',
                              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                                color: AppColors.gray_500,
                              ),
                              textAlign: TextAlign.center
                            ),
                          ],
                        ),
                  )
                : ListView(
                  children: controller.enderecos.asMap().entries.map((entry) {
                    //RESGATAR ENDEREÇO
                    Map<dynamic, dynamic> item = entry.value;
                    return ListTile(
                      leading: const Icon(AppIcones.marker_solid, color: AppColors.dark_300),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item["logradouro"]}, ${item['bairro']} - ${item['localidade']} - ${item['uf']}",
                            style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
                                overflow: TextOverflow.ellipsis
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              item["complemento"]!,
                              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                                color: AppColors.gray_500,
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        //SELECIONAR TEXTO
                        controller.addressController.text = "${item["logradouro"]}, ${item['bairro']} - ${item['localidade']} - ${item['uf']}";
                        //FECHAR BOTTOMSHEET
                        Get.back();
                      },
                    );
                  }).toList(),
                ),
              );
            }),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  //SELECIONAR O MELHOR PÉ
  void selectCategoria(String value){
    setState(() {
      //ATUALIZAR VALOR DO CONTROLER
      controller.categoryController.text = value;
      controller.onSaved({"categoria": value});
      categoria = value;
      //SELECIONAR TIPO DE CAMPO
      if(value == 'Campo'){
        //DEFINIR VALOR PARA SLIDER
        controller.qtdPlayers = 11;
        controller.minPlayers =  9;
        controller.maxPlayers = 11;
        controller.divisions = 2;
      }else if(value == 'Society'){
        //DEFINIR VALOR PARA SLIDER
        controller.qtdPlayers = 6;
        controller.minPlayers = 4;
        controller.maxPlayers = 8;
        controller.divisions = 4;
      }else if(value == 'Quadra'){
        //DEFINIR VALOR PARA SLIDER
        controller.qtdPlayers = 5;
        controller.minPlayers = 4;
        controller.maxPlayers = 6;
        controller.divisions = 2;
      }
    });
  }

  //FUNÇÃO SELECIONAR DIA DA SEMANA
  void selectDaysWeek(String value){
    setState(() {
      if(controller.daysOfWeek.contains(value)){
        controller.daysOfWeek.remove(value);
      }else{
        controller.daysOfWeek.add(value);
      } 
      //ENCONTRAR O DIA ESPECIFICO NO ARRAY
      final day = daysOfWeek.firstWhere((item) => item['dia'] == value);
      //ATUALIZAR O VALOR DE CHECKED
      day['checked'] = !(day['checked'] as bool);
      //ADICIONAR A MODEL DE PELADA
      controller.daysWeekController.text = jsonEncode(controller.daysOfWeek);
      controller.onSaved({"daysOfWeek": jsonEncode(controller.daysOfWeek)});
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
      controller.dateController.text = AppHelper.formatDate(dateSelected);
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
        controller.startTimeController.text =  timeSelected.toString();
      }else{
        //ATUALIZAR VALOR DO CONTROLER
        controller.endTimeController.text = timeSelected.toString();
      }
    }
  }

  //FUNÇÃO PARA SELEICONAR QUANTIDADE DE JOGADORES
  void selectqtdPlayers(value){
    setState(() {
      controller.qtdPlayers = value;
      controller.qtdPlayersController.text = value.toInt().toString();
      controller.onSaved({"qtdPlayers": value.toInt().toString()});
    });
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
    //CONTROLLER DE BARRA NAVEGAÇÃO
    final navigationController = Get.find<NavigationController>();
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //LISTA DE CATEGORIAS DE CAMPO
    final List<Map<String, dynamic>> categorias = [
      {
        'value': 'Campo',
        'icon': AppIcones.foot_field_solid,
        'checked': controller.categoryController.text == 'Campo' ? true : false,
        'quantidade' : 11
      },
      {
        'value': 'Society',
        'icon': AppIcones.foot_society_solid,
        'checked': controller.categoryController.text == 'Society' ? true : false,
        'quantidade' : 8
      },
      {
        'value': 'Quadra',
        'icon': AppIcones.foot_futsal_solid,
        'checked': controller.categoryController.text == 'Quadra' ? true : false,
        'quantidade' : 5
      },
    ];

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
                  InputTextWidget(
                    name: 'endereco',
                    label: 'Endereço',
                    textController: controller.addressController,
                    controller: controller,
                    onSaved: controller.onSaved,
                    type: TextInputType.streetAddress,
                    showModal: openAdressSearch,
                  ),
                  if(!dataFixa)
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
                            children: daysOfWeek.map<Widget>((item) {
                              return SelectDaysWeekWidget(
                                value: item['dia'],
                                checked: item['checked'],
                                action: selectDaysWeek,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  if(dataFixa)
                    InputDateWidget(
                      name: 'data',
                      label: 'Data',
                      textController: controller.dateController,
                      controller: controller,
                      onSaved: controller.onSaved,
                      showModal: () => selectDate(context),
                    ),
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
                            textController: controller.startTimeController,
                            controller: controller,
                            onSaved: controller.onSaved,
                            showModal: () => selectTime(context, 'horaInicio'),
                          ),
                        ),
                        Container(
                          width: dimensions.width / 2 - 20,
                          child: InputDateWidget(
                            name: 'horaFim',
                            label: 'Hora de Fim',
                            textController: controller.endTimeController,
                            controller: controller,
                            onSaved: controller.onSaved,
                            showModal: () => selectTime(context, 'horaFim'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:Text(
                      "Categoria",
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for(var item in categorias)
                          SelectRoundedWidget(
                            value: item['value'],
                            icon: item['icon'],
                            size: 120,
                            iconSize: 40,
                            checked: item['checked'],
                            controller: controller,
                            onChanged: selectCategoria,
                          )
                      ],
                    ),
                  ),
                  if(categoria!.contains("Campo") || categoria!.contains("Society") || categoria!.contains("Quadra"))
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child:Text(
                            "Quantidade de Jogadores",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Defina quantos jogadores atuaram em campo por cada equipe. Essa informação podera ser alterada a qualquer momento após o registro.",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Slider(
                          value: controller.qtdPlayers,
                          min: controller.minPlayers,
                          max: controller.maxPlayers,
                          divisions: controller.divisions,
                          label: controller.qtdPlayers.toInt().toString(),
                          activeColor: AppColors.green_300,
                          inactiveColor: AppColors.white,
                          onChanged: (double newValue) => selectqtdPlayers(newValue),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.green_300,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  controller.qtdPlayers.toInt().toString(),
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Icon(AppIcones.users_solid),
                              ),
                              Text(
                                "Jogadores por equipe",
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.blue_500),
                                textAlign: TextAlign.center,
                              ),
                            ]
                          ),
                        ),
                        CampoWidget(
                          categoria: controller.categoryController.text,
                          qtd: controller.qtdPlayers,
                        ),
                      ],
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

  @override
  void dispose() {
    //CANCELAR O TIMER
    debounce?.cancel(); 
    super.dispose();
  }
}