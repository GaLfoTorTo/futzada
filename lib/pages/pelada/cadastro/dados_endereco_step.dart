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
import 'package:futzada/controllers/pelada_controller.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class DadosEnderecoStep extends StatefulWidget {  
  const DadosEnderecoStep({super.key});

  @override
  State<DadosEnderecoStep> createState() => DadosEnderecoStepState();
}

class DadosEnderecoStepState extends State<DadosEnderecoStep> {
  //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  //CONTROLLER DE REGISTRO DA PELADA
  final controller = PeladaController.instace;
  // Lista de endereços fictícios para demonstração
  final List<Map<String, String>> enderecos = [
    {"logradouro":"1234 Market St, San Francisco, CA","complemento":"endereco 1 St, San Francisco, CA Complemento de endereço"},
    {"logradouro":"5678 Mission St, San Francisco, CA","complemento":"endereco 2 St, San Francisco, CA Complemento de endereço"},
    {"logradouro":"9101 Union St, San Francisco, CA","complemento":"endereco 3 St, San Francisco, CA Complemento de endereço"},
    {"logradouro":"1123 Castro St, San Francisco, CA","complemento":"endereco 4 St, San Francisco, CA Complemento de endereço"},
  ];
  //DATA FIXA
  bool dataFixa = false;
  //LISTA DE DIAS DA SEMANA
  final List<Map<String, dynamic>> diasSemana = [
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

  @override
  void initState() {
    super.initState();
    categoria = controller.categoriaController.text;
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
              hint: 'Ex: Rua 5 lote 91...',
              textController: controller.enderecoController,
              prefixIcon: AppIcones.marker_solid,
              controller: controller,
              onSaved: controller.onSaved,
              type: TextInputType.text,
              showModal: openAdressSearch,
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: enderecos.asMap().entries.map((entry) {
                  //RESGATAR ENDEREÇO
                  Map<String, String> item = entry.value;
                  return ListTile(
                    leading: const Icon(AppIcones.marker_solid, color: AppColors.dark_300),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["logradouro"]!,
                          style: Theme.of(Get.context!).textTheme.titleSmall,
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
                      controller.enderecoController.text = item['logradouro']!;
                      //FECHAR BOTTOMSHEET
                      Get.back();
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  //SELECIONAR O MELHOR PÉ
  void selectTipoCampo(String value){
    setState(() {
      //ATUALIZAR VALOR DO CONTROLER
      controller.categoriaController.text = value;
      controller.onSaved({"tipoCampo": value});
      categoria = value;
      //SELECIONAR TIPO DE CAMPO
      if(value == 'Campo'){
        //DEFINIR VALOR PARA SLIDER
        controller.qtdJogadores = 11;
        controller.minJogadores =  9;
        controller.maxJogadores = 11;
        controller.divisions = 2;
      }else if(value == 'Society'){
        //DEFINIR VALOR PARA SLIDER
        controller.qtdJogadores = 6;
        controller.minJogadores = 4;
        controller.maxJogadores = 8;
        controller.divisions = 4;
      }else if(value == 'Quadra'){
        //DEFINIR VALOR PARA SLIDER
        controller.qtdJogadores = 5;
        controller.minJogadores = 4;
        controller.maxJogadores = 6;
        controller.divisions = 2;
      }
    });
  }

  //FUNÇÃO SELECIONAR DIA DA SEMANA
  void selectDaysWeek(String value){
    setState(() {
      if(controller.diasSemana.contains(value)){
        controller.diasSemana.remove(value);
      }else{
        controller.diasSemana.add(value);
      }
      //ENCONTRAR O DIA ESPECIFICO NO ARRAY
      final day = diasSemana.firstWhere((item) => item['dia'] == value);
      //ATUALIZAR O VALOR DE CHECKED
      day['checked'] = !(day['checked'] as bool);
      //ADICIONAR A MODEL DE PELADA
      controller.onSaved({"diasSemana": jsonEncode(controller.diasSemana)});
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
      controller.dataController.text = AppHelper.formatDate(dateSelected);
    }
  }

  //FUNÇÃO PARA PICKER DE HORAS
  Future<void> selectTime(BuildContext context, controller) async {
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
      //ATUALIZAR VALOR DO CONTROLER
      controller.text = timeSelected.toString();
    }
  }

  //FUNÇÃO PARA SELEICONAR QUANTIDADE DE JOGADORES
  void selectQtdJogadores(value){
    setState(() {
      controller.qtdJogadores = value;
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
      Get.toNamed('/pelada/cadastro/dados_participantes');
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
        'checked': controller.categoriaController.text == 'Campo' ? true : false,
        'quantidade' : 11
      },
      {
        'value': 'Society',
        'icon': AppIcones.foot_society_solid,
        'checked': controller.categoriaController.text == 'Society' ? true : false,
        'quantidade' : 8
      },
      {
        'value': 'Quadra',
        'icon': AppIcones.foot_futsal_solid,
        'checked': controller.categoriaController.text == 'Quadra' ? true : false,
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
                    textController: controller.enderecoController,
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
                            children: diasSemana.map<Widget>((item) {
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
                      textController: controller.dataController,
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
                            name: 'hora_inicio',
                            label: 'Hora de Início',
                            textController: controller.horaInicioController,
                            controller: controller,
                            onSaved: controller.onSaved,
                            showModal: () => selectTime(context, controller.horaInicioController),
                          ),
                        ),
                        Container(
                          width: dimensions.width / 2 - 20,
                          child: InputDateWidget(
                            name: 'hora_fim',
                            label: 'Hora de Fim',
                            textController: controller.horaFimController,
                            controller: controller,
                            onSaved: controller.onSaved,
                            showModal: () => selectTime(context, controller.horaFimController),
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
                            onChanged: selectTipoCampo,
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
                          value: controller.qtdJogadores,
                          min: controller.minJogadores,
                          max: controller.maxJogadores,
                          divisions: controller.divisions,
                          label: controller.qtdJogadores.toInt().toString(),
                          activeColor: AppColors.green_300,
                          inactiveColor: AppColors.white,
                          onChanged: (double newValue) => selectQtdJogadores(newValue),
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
                                  controller.qtdJogadores.toInt().toString(),
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
                          categoria: controller.categoriaController.text,
                          qtd: controller.qtdJogadores,
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
    super.dispose();
  }
}