import 'dart:io';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/widget/inputs/input_textarea_widget.dart';
import 'package:get/get.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/controllers/pelada_controller.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/inputs/input_radio_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:image_picker/image_picker.dart';

class DadosPeladaStep extends StatefulWidget {  
  const DadosPeladaStep({super.key});

  @override
  State<DadosPeladaStep> createState() => DadosPeladaStepState();
}

class DadosPeladaStepState extends State<DadosPeladaStep> {
  //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  //CONTROLLER DE NAVEGAÇÃO DE HOME
  final controller = Get.put(PeladaController());
  //DEFINIR ARMAZENAMENTO DA IMAGEM
  File? imageFile;
  //INICIALIZAR IMAGE PICKER
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
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
  dynamic capaImage(imageFile){
    if(imageFile != null){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          width: double.infinity,
          height: 150,
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
            width: double.infinity,
            height: 150,
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
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  InkWell(
                    onTap: getImage,
                    enableFeedback: false,
                    child: capaImage(imageFile)
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
                  ButtonTextWidget(
                    text: "Próximo",
                    width: double.infinity,
                    action: submitForm
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