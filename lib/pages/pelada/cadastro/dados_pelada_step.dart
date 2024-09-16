import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/inputs/input_checkbox_widget.dart';
import 'package:futzada/widget/inputs/input_textarea_widget.dart';
import 'package:futzada/widget/inputs/input_radio_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/controllers/pelada_controller.dart';

class DadosPeladaStep extends StatefulWidget {  
  const DadosPeladaStep({super.key});

  @override
  State<DadosPeladaStep> createState() => DadosPeladaStepState();
}

class DadosPeladaStepState extends State<DadosPeladaStep> {
  //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  //CONTROLLER DE REGISTRO DA PELADA
  final controller = Get.put(PeladaController());
  //DEFINIR ARMAZENAMENTO DA IMAGEM
  File? imageFile;
  //INICIALIZAR IMAGE PICKER
  final ImagePicker imagePicker = ImagePicker();
  //LISTA DE INPUTS CHECKBOX
  final List<Map<String, dynamic>> permissoes = [
    {
      'name': 'Adicionar',
      'value': false,
    },
    {
      'name': 'Editar',
      'value': false,
    },
    {
      'name': 'Remover',
      'value': false,
    },
  ];
  //DEFINIR VARIAVEL DE CONTROLE DE COLABORADORES
  late bool activeColaboradores = false;

  @override
  void initState() {
    super.initState();
    activeColaboradores = controller.activeColaboradores;
  }

  //FUNÇÃO PARA BUSCAR IMAGEM
  Future<void> getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    //VERIFICAR SE IMAGEM FOI SELECIONADA
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        controller.onSaved({'foto': image.path});
      });
    }
  }

  //FUNÇÃO DE EXIBIÇÃO DE CAPA DA PELADA
  dynamic capaImage(imageFile, dimensions){
    if(imageFile != null){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          width: dimensions.width,
          height: dimensions.width - 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(imageFile!) as ImageProvider<Object>,
              fit: BoxFit.cover
            ),
            border: Border.all(
              color: AppColors.gray_500,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }else{
      return Opacity(
        opacity: 0.3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            width: dimensions.width,
            height: dimensions.width - 100,
            decoration: BoxDecoration(
              color: AppColors.gray_700,
              border: Border.all(
                color: AppColors.gray_500,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              AppIcones.camera_solid,
              color: AppColors.blue_500,
              size: 50,
            ),
          ),
        ),
      );
    }
  }

  //SELECIONAR A VISIBILIDADE
  void selectedVisibility(value){
    setState(() {
      controller.visibilidadeController.text = value;
      controller.onSaved({'visibilidade': value});
    });
  }
  //ATIVAR COLABORADORES
  void selectColaboradores(){
    setState(() {
      activeColaboradores = !activeColaboradores;
      controller.activeColaboradores = !activeColaboradores;
    });
  }

  //SELECIONAR A VISIBILIDADE
  void selectedPermissao(name){
    setState(() {
      //ENCONTRAR O DIA ESPECIFICO NO ARRAY
      final permissao = permissoes.firstWhere((item) => item['name'] == name);
      //ATUALIZAR O VALOR DE CHECKED
      permissao['value'] = !(permissao['value'] as bool);
      //ADICIONAR A MODEL DE PELADA
      controller.onSaved({"permissoes": jsonEncode(controller.permissoes)});
    });
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    Get.toNamed('/pelada/cadastro/dados_endereco');

    /* //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      //NAVEGAR PARA CADASTRO DE ENDEREÇO
      Get.toNamed('/pelada/cadastro/dados_endereco');
    } */
  }

  @override
  Widget build(BuildContext context) {
    //LISTA DE INPUTS RADIO
    final List<Map<String, dynamic>> radios = [
      {
        'name': 'visibilidade',
        'placeholder' : 'Qualquer usuário pode visualizar as informações.',
        'value': 'Publico',
        'icon' : AppIcones.door_open_solid,
        'controller': controller.visibilidadeController,
      },
      {
        'name': 'visibilidade',
        'placeholder' : 'Apenas os participantes podem visualizar as informações.',
        'value': 'Privado',
        'icon' : AppIcones.door_close_solid,
        'controller': controller.visibilidadeController,
      },
    ];

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
                children: [
                  const IndicatorFormWidget(
                    length: 3,
                    etapa: 0
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Dados da Pelada",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Certo então vamos lá! Informe o Nome, a Bio, a Imagem de capa e a Visibilidade da pelada. Você também pode definir as configurações de colaboradores da pelada.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  InkWell(
                    onTap: getImage,
                    enableFeedback: false,
                    child: capaImage(imageFile, dimensions)
                  ),
                  if(imageFile != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: (){
                            setState(() {
                              imageFile = null;
                            });
                          }, 
                          icon: const Icon(AppIcones.trash_solid, color: AppColors.white,),
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(AppColors.red_300)
                          ),
                        )
                      ],
                    ),
                  InputTextWidget(
                    name: 'nome',
                    label: 'Nome',
                    textController: controller.nomeController,
                    controller: controller,
                    onSaved: controller.onSaved,
                    type: TextInputType.text,
                  ),
                  InputTextAreaWidget(
                    name: 'bio',
                    label: 'Bio',
                    hint: 'Ex: Melhor Pelada do Brasil',
                    textController: controller.bioController,
                    controller: controller,
                    onSaved: controller.onSaved,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          "Visibilidade",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for(var radio in radios)
                        InputRadioWidget(
                          name: radio['name'],
                          value: radio['value'],
                          icon: radio['icon'],
                          placeholder: radio['placeholder'],
                          textController: radio['controller'],
                          controller: controller,
                          onChanged: selectedVisibility,
                        ),
                    ]
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          "Colaboradores",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Defina se sua pelada contará con o auxilio de colaboradores. Colaboradores da pelada serão os participantes que contribuiram na organização da pelada.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SwitchListTile(
                      value: activeColaboradores,
                      onChanged: (value) => selectColaboradores(),
                      activeColor: AppColors.green_300,
                      inactiveTrackColor: AppColors.gray_300,
                      inactiveThumbColor: AppColors.gray_500,
                      title: Text(
                        'Ativar Colaboradores',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.dark_300),
                      ),
                      secondary: const Icon(
                        AppIcones.users_solid,
                        color: AppColors.dark_300,
                      ),

                    ),
                  ),
                  if(activeColaboradores)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                "Permissões",
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Com as permissões ativadas, Defina o que os colaboradores estarão autorizados a fazer para ajudar a organizar a pelada.",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for(var permissao in permissoes)
                                InputCheckBoxWidget(
                                  name: permissao['name'],
                                  value: permissao['value'],
                                  onChanged: selectedPermissao,
                                ),
                            ]
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ButtonTextWidget(
                      text: "Próximo",
                      width: double.infinity,
                      action: submitForm
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