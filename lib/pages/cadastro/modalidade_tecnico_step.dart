import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/cadastro_controller.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_circular_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/pickers/picker_color_widget.dart';
import 'package:futzada/widget/pickers/picker_emblema_widget.dart';
import 'package:futzada/widget/pickers/picker_uniforme_widget.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ModalidadeTecnicoStep extends StatefulWidget {  
  const ModalidadeTecnicoStep({super.key});

  @override
  State<ModalidadeTecnicoStep> createState() => ModalidadeTecnicoStepStateState();
}

class ModalidadeTecnicoStepStateState extends State<ModalidadeTecnicoStep> {
  //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  //CONTROLADOR DOS INPUTS DO FORMULÁRIO
  final CadastroController controller = Get.put(CadastroController());
  //CONTROLADORES DE PICKER DE COR
  late Color primaria;
  late Color secundaria;
  bool selectedPrimaria = false;
  bool selectedSecundaria = false;
  String currentColor = "Primaria";
  String selectedColor = "";
  //CONTROLLADOR DO EMBLEMA
  late Map<String, Map<String, dynamic>> confEmblema = {};
  //VARIVAEL PARA ARMAZENAR EMBLEMAS EM FORMATO DE STRING
  Map<String, String> emblemas = {};
  //CONTROLLADOR DO CARROUSEL DE EMBELMAS
  late int indexEmblema;
  //CONTROLLADOR DO UNIFORME
  late Map<String, Map<String, dynamic>> confUniforme = {};
  //VARIAVEL PARA ARMAZERAR UNIFORME EM FORMATO DE STRING
  String uniforme = '';
  //VARIAVEL PARA VERIFICAR STATUS DE PROCESSAMENTO DOS SVGS
  late Future<void> svgIniti;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CORES
    primaria = controller.model.primaria != null 
              ? AppColors.colors[controller.model.primaria]! 
              : AppColors.green_300;
    secundaria = controller.model.secundaria != null 
              ? AppColors.colors[controller.model.secundaria]! 
              : AppColors.blue_500;
    //INICIALIZAR PERSONALIZAÇÃO DOS EMBLEMAS
    if(controller.model.emblema != null){
      //RESGATAR CONFIGURAÇÕES DE EMBLEMA SALVAS
      transformeMap(controller.model.emblema!, confEmblema);
      //RESGATAR CORES DAS ESTAMPAS APARTIR DAS CHAVES SALVAS
      getColorKey(confEmblema, 'inicializar');
      //RESGATAR INDEX DO EMBLEMA SELECIONADO PELO USUARIO
      var emblemaSelected = confEmblema['emblema']!['item'];
      emblemaSelected = emblemaSelected.split('_');
      indexEmblema = int.parse(emblemaSelected[1]) - 1;
    }else{
      //DEFINIR CONFIGURAÇÃO INICIAL DE EMBLEMA
      confEmblema = {
        'emblema' : {
          'item': 'emblema_1'
        },
        'bg': {
          'checked': true,
          'color': primaria,
        },
        'mt': {
          'checked': false,
          'color': null,
        },
        'mb': {
          'checked': false,
          'color': null,
        },
        'ml': {
          'checked': false,
          'color': null,
        },
        'mr': {
          'checked': false,
          'color': null,
        },
        'lv': {
          'checked': false,
          'color': null,
        },
        'lh': {
          'checked': false,
          'color': null,
        },
      };
      //DEFINIR QUE CARROUSEL INICIARÁ NO PRIMEIRO ITEM
      indexEmblema = 0;
    }
    //INICIALIZAR UNIFOME
    if(controller.model.uniforme != null){
      //RESGATAR CONFIGURAÇÕES DE EMBLEMA SALVAS
      transformeMap(controller.model.uniforme!, confUniforme);
      //RESGATAR CORES DAS ESTAMPAS APARTIR DAS CHAVES SALVAS
      getColorKey(confUniforme, 'inicializar');
    }else{
      //DEFINIR CONFIGURAÇÃO INICIAL DE EMBLEMA
      confUniforme = {
        'bg': {
          'checked': true,
          'color': primaria,
        },
        'mt': {
          'checked': false,
          'color': null,
        },
        'mb': {
          'checked': false,
          'color': null,
        },
        'ml': {
          'checked': false,
          'color': null,
        },
        'mr': {
          'checked': false,
          'color': null,
        },
        'lvc': {
          'checked': false,
          'color': null,
        },
        'lvl': {
          'checked': false,
          'color': null,
        },
        'lhc': {
          'checked': false,
          'color': null,
        },
        'lhl': {
          'checked': false,
          'color': null,
        },
        'mc': {
          'checked': false,
          'color': null,
        },
        'mm': {
          'checked': false,
          'color': null,
        },
        'mxl': {
          'checked': false,
          'color': null,
        },
      };
    }
    //CHAMAR FUNÇÃO ASSÍNCRONA PARA INICIALIZAR OS KITS
    svgIniti = _initializeSvg();
  }

  void transformeMap(map, conf){
    //DECODIFICAR CONFIGURAÇÕES SALVAS ANTERIORMENTE
    var decodedJson = jsonDecode(map!) as Map<String, dynamic>;
    //TIPAR MAP DECODIFICADO
    Map<String, Map<String, dynamic>> transformedMap = decodedJson.map((key, value) {
      return MapEntry(key, value as Map<String, dynamic>);
    });
    //REATRIBUIR CONFIGURAÇÕES DE ESTAMPA
    conf.addAll(transformedMap);
  }

  //FUNÇÃO PARA RESGATAR SVGS EM FORMATO DE STRING
  Future<Map<String, String>> mapSvgToString(Map<String, String> svgs) async {
    //NOVO MAP DE SVG EM FORMATO DE STRING
    final Map<String, String> svgStrings = {};
    //LOOP NOS SVGS
    for (final entry in svgs.entries) {
      //CONVERTER SVG TO STRING
      String svgString = await AppHelper.svgToString(entry.value);
      svgStrings[entry.key] = svgString;
    }
    //RETORNAR SVG COMO STRINGS
    return svgStrings;
  }

  // FUNÇÃO ASSÍNCRONA PARA INICIALIZAR OS SVGS
  Future<void> _initializeSvg() async {
    //TRANSFORMAR EMBLEMAS EM STRINGS
    emblemas = await mapSvgToString(AppIcones.emblemas);
    confEmblema.forEach((key, value) {
      //VERIFICAR SE CHAVE NÃO É O TIPO DE EMBLEMA
      if(key != 'emblema'){
        //ADICIONAR NULL NAS CORES DE ESTAMPAS NÃO HABILITADAS
        if(confEmblema[key]!['checked'] == true){
          //APLICAR COR NA ESTAMPA
          selectEstampaColor(key, confEmblema[key]!['color'], 'Emblema');
        }
      }
    });
    //TRANSFORMAR UNIFORME EM STRINGS
    uniforme = await AppHelper.svgToString(AppIcones.uniforme);
    confUniforme.forEach((key, value) {
      //ADICIONAR NULL NAS CORES DE ESTAMPAS NÃO HABILITADAS
      if(confUniforme[key]!['checked'] == true){
        //APLICAR COR NA ESTAMPA
        selectEstampaColor(key, confUniforme[key]!['color'], 'Uniforme');
      }
    });
    setState(() {});
  }

  void getColorKey(config, flag){
    if(flag == 'inicializar'){
      //ADICIONAR NULL NAS CORES PARA ESTAMPAS NÃO ATIVAS DO EMBLEMA
      config.forEach((key, value) {
        //VERIFICAR SE CHAVE NÃO E DO TIPO DE EMBLEMA
        if(key != 'emblema'){
          //ADICIONAR NULL NAS CORES DE ESTAMPAS NÃO HABILITADAS
          if(config[key]!['checked'] == true){
            //RESGATAR CHAVE DA COR DA ESTAMAPA
            var colorKey = config[key]!['color'];
            //VERIFICAR SE CHAVE NÃO ESTÁ VAZIA
            if (colorKey != null && colorKey is String) {
              //RESGATAR COR DA ESTAMAPA
              config[key]!['color'] = AppColors.colors[colorKey];
            }else{
              //RESGATAR COR DEFINIDA COMO PRIMÁRIA CASO NÃO ENCONTRE CHAVE
              config[key]!['color'] = primaria;
            }
          }else{
            //RESGATAR COR DEFINIDA COMO SECUNDÁRIA CASO NÃO ENCONTRE CHAVE
            config[key]!['color'] = secundaria;
          }
        }
      });
    }else{
      //ADICIONAR NULL NAS CORES PARA ESTAMPAS NÃO ATIVAS DO EMBLEMA
      config.forEach((key, value) {
        //VERIFICAR SE CHAVE NÃO É O TIPO DE EMBLEMA
        if(key != 'emblema'){
          //ADICIONAR NULL NAS CORES DE ESTAMPAS NÃO HABILITADAS
          if(config[key]!['checked'] == false){
            //DEFINIR COR COMO NULL
            config[key]!['color'] = null;
          }else{
            //RESGATAR COR SELECIONADA
            var color = config[key]!['color'];
            //RESGATAR CHAVE DA COR SELECIONADA
            config[key]!['color'] = AppColors.colors.entries.firstWhere((entry) => entry.value == color, orElse: () => const MapEntry('green_300', AppColors.green_300)).key;
          }
        }
      });
    }
  }

  //FUNÇÃO PARA ALTERNAR ENTRE CORES (PRIMARIA OU SECUNDARIA)
  void selectColor(String label, Color color, String? item){
    setState(() {
      //ALTERNAR ENTRE PICKERS
      if(label == 'Primária'){
        currentColor = "Primária";
        selectedPrimaria = true;
        selectedSecundaria = false;
      }else if(label == 'Secundária'){
        currentColor = "Secundária";
        selectedPrimaria = false;
        selectedSecundaria = true;
      }
      //ALTERAR CORES DO PICKER ATUAL
      if(currentColor == 'Primária'){
        primaria = color;
        controller.primariaController.text = label;
      }else{
        secundaria = color;
        controller.secundariaController.text = label;
      }
      //ALTERAR COR SELECIONADA
      selectedColor = label;
    });
  }

  //FUNÇÃO PARA ALTERAR CORES DA ESTAMPA SELECIONADA
  void selectEstampaColor(String estampa, Color color, String item){
    setState(() {
      if(item == 'Emblema'){
        //ALTERAR ESTADO DA ESTAMPA
        confEmblema[estampa]!['color'] = color;
        //LOOP NOS KITS
        for (final item in emblemas.entries) {
          //ALTERAR COR DOS KITS
          String newKit = AppHelper.alterSvgColor(item.value, estampa, confEmblema[estampa]!['checked'], color);
          //REATRIBUIR KIT
          emblemas[item.key] = newKit;
        }
      }else{
        //ALTERAR ESTADO DA ESTAMPA
        confUniforme[estampa]!['color'] = color;
        //ALTERAR COR DA ESTAMPA SELECIONADA NO EMBLEMA
        uniforme = AppHelper.alterSvgColor(uniforme, estampa, confUniforme[estampa]!['checked'], color);

      }
    });
  }

  //FUNÇÃO PARA SELECIONAR ESTAMPA
  void selectEstampa(String estampa, Color color, String item){
    //ALTERAR VALOR DE CHECKED DO ITEM SELECIONADO
    setState(() {
      if(item == 'Emblema'){
        //ALTERAR CHECKED DA ESTAMPA
        confEmblema[estampa]!['checked'] = !(confEmblema[estampa]!['checked'] as bool);
        //ALTERAR COR DA ESTAMPA
        confEmblema[estampa]!['color'] = confEmblema[estampa]!['checked'] ? color : null;
        //ALTERAR COR DA ESTAMPA SELECIONADA NO EMBLEMA
        selectEstampaColor(estampa, color, item);
      }else{
        //ALTERAR CHECKED DA ESTAMPA
        confUniforme[estampa]!['checked'] = !(confUniforme[estampa]!['checked'] as bool);
        //ALTERAR COR DA ESTAMPA
        confUniforme[estampa]!['color'] = confUniforme[estampa]!['checked'] ? color : null;
        //ALTERAR COR DA ESTAMPA SELECIONADA NO EMBLEMA
        uniforme = AppHelper.alterSvgColor(uniforme, estampa, confUniforme[estampa]!['checked'], color);
      }
    });
  }

  //FUNÇÃO PARA SELECIONAR O KIT
  void selectEmblema(emblema){
    //RESAGATAR EMBLEMA SELECIONADO
    controller.uniformeController.text = emblema;
    confEmblema['emblema']!['item'] = emblema;
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //AJUSTAR CORES SELECIONADAS PARA ESTAMPAS DE EMBLEMA E UNIFORMES
    getColorKey(confEmblema, 'salvar');
    getColorKey(confUniforme, 'salvar');
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      //SALVAR CORES E UNIFORME
      controller.onSaved({
        "primaria": AppColors.colors.entries.firstWhere((entry) => entry.value == primaria, orElse: () => const MapEntry('green_300', AppColors.green_300)).key,
        "secundaria": AppColors.colors.entries.firstWhere((entry) => entry.value == secundaria, orElse: () => const MapEntry('blue_500', AppColors.blue_500)).key,
        "emblema": jsonEncode(confEmblema),
        "uniforme": jsonEncode(confUniforme),
      });
      formData?.save();
      //AJUSTAR CORES PARA ESTAMPAS DE EMBLEMA E UNIFORMES
      getColorKey(confEmblema, 'inicializar');
      getColorKey(confUniforme, 'inicializar');
      //NAVEGAR PARA ROTA DE MODALIDADES
      Get.toNamed('/cadastro/modalidades');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    //LISTA DE CAMPOS
    final List<Map<String, dynamic>> inputs = [
      {
        'name':'equipe',
        'label': 'Equipe',
        'controller': controller.equipeController,
        'type': TextInputType.text
      },
      {
        'name': 'sigla',
        'label': 'Sigla',
        'controller': controller.siglaController,
        'type': TextInputType.text,
        'maxLength' : 3,
      },
    ];
    var dimensions = MediaQuery.of(context).size;
     
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Cadastro", 
        action: () => Get.toNamed('/cadastro/modalidades')
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "A modalidade técnico são para os usuários que desejam mostrar todo seu talento fora de campo escalando apenas os melhores para sua equipe.",
                      style: TextStyle(
                        color: AppColors.gray_500,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          'Técnico',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ButtonCircularWidget(
                            color: AppColors.green_300,
                            icon: AppIcones.clipboard_solid,
                            iconColor: AppColors.white,
                            iconSize: 70.0,
                            checked: true,
                            size: 130,
                            action: () => {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Defina o nome, a sigla, as cores, o emblema e o uniforme da sua futura equipe. Essas informações poderão ser alteradas a qualquer momento após o registro.",
                      style: TextStyle(
                        color: AppColors.gray_500,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  for(var input in inputs)
                    InputTextWidget(
                      name: input['name'],
                      label: input['label'],
                      textController: input['controller'],
                      controller: controller,
                      onSaved: controller.onSaved,
                      type: input['type'],
                      maxLength: input['maxLength']
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Cores:",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PickerColorWidget(
                                color: primaria,
                                id: "Primária",
                                label: "Primária",
                                checked: selectedPrimaria,
                                selectColor: selectColor,
                                tipo: 'Color',
                              ),
                              PickerColorWidget(
                                color: secundaria,
                                id: "Secundária",
                                label: "Secundária",
                                checked: selectedSecundaria,
                                selectColor: selectColor,
                                tipo: 'Color',
                              )
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Emblemas:",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        FutureBuilder<void>(
                          future: svgIniti,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Container(
                                width: double.maxFinite,
                                height: 250,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Não foi possível carregar os emblemas",
                                      style: TextStyle(
                                        color: AppColors.gray_300,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal
                                      ),
                                    ),
                                    Icon(
                                      LineAwesomeIcons.image,
                                      color: AppColors.gray_300,
                                    ),
                                  ],
                                )
                              );
                            } else {
                              return Wrap(
                                spacing: 50, 
                                runSpacing: 15,
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: 250,
                                      initialPage: indexEmblema,
                                      enableInfiniteScroll: true,
                                      autoPlay: false,
                                      enlargeCenterPage: true,
                                      enlargeFactor: 0.2,
                                      scrollDirection: Axis.horizontal,
                                      onPageChanged: (index, reason) {
                                        var key = 'emblema_${index + 1}';
                                        selectEmblema(key);
                                      },
                                    ),
                                    items: emblemas.entries.map((item) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.string(
                                                  item.value,
                                                  width: 200,
                                                  height: 200,
                                                ),
                                              ],
                                            )
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  PickerEmblemaWidget(
                                    selectEstampa: selectEstampa,
                                    selectColor: selectEstampaColor,
                                    primariaColor: primaria,
                                    secundariaColor: secundaria,
                                    confEstampa: confEmblema,
                                  ),
                                ],
                              );
                            }
                          }
                        ),
                      ]
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Uniforme:",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        FutureBuilder<void>(
                          future: svgIniti,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Container(
                                      width: double.maxFinite,
                                      height: 250,
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Não foi possível carregar o Uniforme",
                                            style: TextStyle(
                                              color: AppColors.gray_300,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal
                                            ),
                                          ),
                                          Icon(
                                            LineAwesomeIcons.image,
                                            color: AppColors.gray_300,
                                          ),
                                        ],
                                      )
                                    );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Container(
                                        width: dimensions.width,
                                        height: 300,
                                        child: SvgPicture.string(
                                          uniforme,
                                          width: 300,
                                          height: 300,
                                        ),
                                      ), 
                                    ),
                                    PickerUniformeWidget(
                                      selectEstampa: selectEstampa,
                                      selectColor: selectEstampaColor,
                                      primariaColor: primaria,
                                      secundariaColor: secundaria,
                                      confEstampa: confUniforme,
                                    ),
                                  ]
                                )
                              );
                            }
                          }
                        ),
                      ]
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ButtonOutlineWidget(
                        text: "Voltar",
                        width: 100,
                        action: () => Get.toNamed('/cadastro/modalidades')
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
            ),
          )
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}