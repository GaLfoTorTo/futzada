import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/utils/manager_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:futzada/presentation/controllers/register_controller.dart';
import 'package:futzada/presentation/widget/cards/card_info_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_loading_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_text_widget.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_circular_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_outline_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/pickers/picker_color_widget.dart';
import 'package:futzada/presentation/widget/pickers/picker_emblema_widget.dart';
import 'package:futzada/presentation/widget/pickers/picker_uniforme_widget.dart';

class ManagerModeStep extends StatefulWidget {  
  const ManagerModeStep({super.key});

  @override
  State<ManagerModeStep> createState() => ManagerModeStepStateState();
}

class ManagerModeStepStateState extends State<ManagerModeStep> {
  //CONTROLADORES
  final RegisterController registerController = RegisterController.instance;
  final GlobalKey<FormState> formKeyStep3Manager = GlobalKey<FormState>();
  //CONTROLADORES DE PICKER DE COR
  late Color primaryColor;
  late Color secondaryColor;
  bool selectedPrimary = false;
  bool selectedSecoundary = false;
  String currentColor = "Primary";
  String selectedColor = "";
  //ESTADOS - EMBLEMAS
  Map<String, String> emblemas = {};
  late int indexEmblema;
  //ESTADO - UNIFORME
  String uniform = '';
  late Future<void> initSvg;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CORES
    primaryColor = AppColors.colors[registerController.primaryController.text] ?? AppColors.green_300;
    secondaryColor = AppColors.colors[registerController.secondaryController.text] ?? AppColors.blue_500;
    registerController.primaryController.text = AppColors.colors.entries.firstWhere((c) => c.value == primaryColor).key;
    registerController.secondaryController.text = AppColors.colors.entries.firstWhere((c) => c.value == secondaryColor).key;
    //INICIALIZAR CONFIGURAÇÕES DE EMBLEMA
    registerController.configEmblem = registerController.configEmblem ?? ManagerUtils.configEmblem(primaryColor);
    registerController.configUniform = registerController.configUniform ?? ManagerUtils.configUniform(primaryColor);
    initConfig(registerController.configEmblem!, "Emblema");
    initConfig(registerController.configUniform!, "Uniforme");
    //RESGATAR INDEX DO EMBLEMA SELECIONADO PELO USUARIO
    indexEmblema = int.parse(registerController.emblem.split('_')[1]) - 1;
    registerController.emblemController.text = "emblema_$indexEmblema";
    //CHAMAR FUNÇÃO ASSÍNCRONA PARA INICIALIZAR OS KITS
    initSvg = initializeSvg();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // FUNÇÃO ASSÍNCRONA PARA INICIALIZAR OS SVGS
  Future<void> initializeSvg() async {
    //TRANSFORMAR EMBLEMAS EM STRINGS
    emblemas = await AppHelper.mapSvgToString();
    uniform = await AppHelper.svgToString(AppIcones.uniforme);
    //CONFIGURAR EMBLEMA DO USUARIO
    for(var entry in registerController.configEmblem!.entries){
      final key = entry.key;
      final item = entry.value;
      //ADICIONAR NULL NAS CORES DE ESTAMPAS NÃO HABILITADAS
      if(item['checked']){
        //APLICAR COR NA ESTAMPA
        selectEstampaColor(key, item['color'], 'Emblema');
      }
    };
    //CONFIGURAR UNIFORME DO USUARIO
    for(var entry in registerController.configUniform!.entries){
      final key = entry.key;
      final item = entry.value;
      //ADICIONAR NULL NAS CORES DE ESTAMPAS NÃO HABILITADAS
      if(item['checked'] == true){
        //APLICAR COR NA ESTAMPA
        selectEstampaColor(key, item['color'], 'Uniforme');
      }
    };
    setState(() {});
  }

  //FUNÇÃO PARA BUSCAR COR SELECIONADA NA ESTAMPA
  void initConfig(Map<String, Map<String, dynamic>> config, String opt){
    //LOOP NAS OPÇÕES DE ESTAMPA
    for(var entry in config.entries) {
      final key = entry.key;
      final item = entry.value;
      //ADICIONAR NULL NAS CORES DE ESTAMPAS NÃO HABILITADAS
      if(item['checked']){
        //ATUALIZAR ESTAMPAS
        selectEstampaColor(key, item["color"], opt);
      }
    }
  }

  //FUNÇÃO PARA ALTERNAR ENTRE CORES (PRIMARy OU SECUNDARIA)
  void selectColor(String label, Color color, String? item){
    setState(() {
      //ALTERNAR ENTRE PICKERS
      if(label == 'Primária'){
        currentColor = "Primária";
        selectedPrimary = true;
        selectedSecoundary = false;
      }else if(label == 'Secundária'){
        currentColor = "Secundária";
        selectedPrimary = false;
        selectedSecoundary = true;
      }
      //ALTERAR CORES DO PICKER ATUAL
      if(currentColor == 'Primária'){
        primaryColor = color;
        registerController.primaryController.text = AppColors.colors.entries.firstWhere((c) => c.value == primaryColor).key;
      }else{
        secondaryColor = color;
        registerController.secondaryController.text = AppColors.colors.entries.firstWhere((c) => c.value == secondaryColor).key;
      }
      //ALTERAR COR SELECIONADA
      selectedColor = label;
    });
  }

  //FUNÇÃO PARA SELECIONAR ESTAMPA (INDIVIDUAL)
  void selectEstampa(String estampa, Color color, String item){
    print(estampa);
    //ALTERAR VALOR DE CHECKED DO ITEM SELECIONADO
    setState(() {
      if(item == 'Emblema'){
        //ALTERAR CHECKED DA ESTAMPA
        registerController.configEmblem![estampa]!['checked'] = !(registerController.configEmblem![estampa]!['checked'] as bool);
      }else{
        //ALTERAR CHECKED DA ESTAMPA
        registerController.configUniform![estampa]!['checked'] = !(registerController.configUniform![estampa]!['checked'] as bool);
      }
      //ALTERAR COR DA ESTAMPA SELECIONADA NO EMBLEMA
      selectEstampaColor(estampa, color, item);
    });
  }

  //FUNÇÃO PARA ALTERAR CORES DA ESTAMPA SELECIONADA
  void selectEstampaColor(String estampa, Color color, String item){
    setState(() {
      if(item == 'Emblema'){
        //ALTERAR COR DA ESTAMPA
        registerController.configEmblem![estampa]!['color'] = registerController.configEmblem![estampa]!['checked'] ? color : null;
        //LOOP NOS KITS
        for(var entry in emblemas.entries){
          final key = entry.key;
          final emblem = entry.value;
          //ALTERAR COR DA ESTAMPA NO EMBLEMA
          String newEmblem = AppHelper.alterSvgColor(emblem, estampa, registerController.configEmblem![estampa]!['checked'], color);
          //REATRIBUIR KIT
          emblemas[key] = newEmblem;
        };
      }else{
        //ALTERAR COR DA ESTAMPA
        registerController.configUniform![estampa]!['color'] = registerController.configUniform![estampa]!['checked'] ? color : null;
        //ALTERAR COR DA ESTAMPA NO UNIFORM
        uniform = AppHelper.alterSvgColor(uniform, estampa, registerController.configUniform![estampa]!['checked'], color);
      }
    });
  }

  //VALIDAÇÃO DA ETAPA//VALIDAÇÃO DA ETAPA
  void submitForm(){
    //VALIDAR FORMULÁRIO
    if(
      formKeyStep3Manager.currentState?.validate() != null &&
      registerController.primaryController.text.isNotEmpty &&
      registerController.secondaryController.text.isNotEmpty &&
      registerController.emblemController.text.isNotEmpty &&
      registerController.configEmblem != null &&
      registerController.configUniform != null
    ){
      registerController.managerChecked = true;
      //RETORNAR PARA APRESENTAÇÃO DOS MODOS
      Get.offNamed("/register");
    }else{
      AppHelper.feedbackMessage(context, "Complete o cadastro de infromações de tecnico para continuar.");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //LISTA DE CAMPOS
    final List<Map<String, dynamic>> inputs = [
      {
        'name':'manager.team',
        'label': 'Equipe',
        'controller': registerController.teamController,
        'type': TextInputType.text,
        'validate' : (value) => registerController.validateEmpty(value, "Equipe")
      },
      {
        'name': 'manager.alias',
        'label': 'Sigla',
        'controller': registerController.aliasController,
        'type': TextInputType.text,
        'validate' : (value) => registerController.validateEmpty(value, "Sigla"),
        'maxLength' : 3,
      },
    ];
     
    return Scaffold(
      appBar: HeaderWidget(
        title: "Cadastro", 
        leftAction: () => Get.back()
      ),
      body: SafeArea(
        child: Form(
          key: formKeyStep3Manager,
          child: SingleChildScrollView(
            child: Container(
              width: dimensions.width,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Atuação Técnico',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "A modalidade técnico são para os usuários que desejam mostrar todo seu talento fora de campo escalando apenas os melhores para sua equipe.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey_500),
                    textAlign: TextAlign.center,
                  ),
                  ButtonCircularWidget(
                    color: AppColors.green_300,
                    icon: AppIcones.clipboard_solid,
                    iconColor: AppColors.white,
                    iconSize: 70.0,
                    checked: true,
                    size: 130,
                    action: () => {},
                  ),
                  const CardInfoWidget(description: "Defina o nome, a sigla, as cores, o emblema e o uniforme da sua futura equipe. Essas informações poderão ser alteradas a qualquer momento após o registro."),
                  const Divider(),
                  ...inputs.map((input){
                    return InputTextWidget(
                      name: input['name'],
                      label: input['label'],
                      textController: input['controller'],
                      type: input['type'],
                      maxLength: input['maxLength'],
                      onValidated: input["validate"],
                    );
                  }),
                  const Divider(),
                  Text(
                    "Cores da equipe",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PickerColorWidget(
                          color: primaryColor,
                          id: "Primária",
                          label: "Primária",
                          checked: selectedPrimary,
                          selectColor: selectColor,
                          tipo: 'Color',
                        ),
                        PickerColorWidget(
                          color: secondaryColor,
                          id: "Secundária",
                          label: "Secundária",
                          checked: selectedSecoundary,
                          selectColor: selectColor,
                          tipo: 'Color',
                        )
                      ]
                    ),
                  ),
                  FutureBuilder<void>(
                    future: initSvg,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const IndicatorLoadingWidget();
                      } else if (snapshot.hasError) {
                        return Container(
                          height: 250,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Não foi possível carregar os emblemas",
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: AppColors.grey_300
                                ),
                              ),
                              const Icon(
                                Icons.image,
                                color: AppColors.grey_300,
                              ),
                            ],
                          )
                        );
                      } else {
                        return Column(
                          spacing: 20,
                          children: [
                            const Divider(),
                            Text(
                              "Emblema da equipe",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 250,
                                initialPage: indexEmblema,
                                enableInfiniteScroll: true,
                                autoPlay: false,
                                enlargeCenterPage: true,
                                enlargeFactor: 0,
                                viewportFraction: 0.65,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  var key = 'emblema_${index + 1}';
                                  //RESAGATAR EMBLEMA SELECIONADO
                                  registerController.emblem = key;
                                  registerController.emblemController.text = key;
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
                              primaryColor: primaryColor,
                              secondaryColor: secondaryColor,
                              configEstampa: registerController.configEmblem!,
                            ),
                            const Divider(),
                            Text(
                              "Uniforme da equipe",
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: dimensions.width,
                              height: 300,
                              child: SvgPicture.string(
                                uniform,
                                width: 300,
                                height: 300,
                              ),
                            ),
                            PickerUniformeWidget(
                              selectEstampa: selectEstampa,
                              selectColor: selectEstampaColor,
                              primaryColor: primaryColor,
                              secondaryColor: secondaryColor,
                              configEstampa: registerController.configUniform!,
                            ),
                            const Divider(),
                          ],
                        );
                      }
                    }
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
}