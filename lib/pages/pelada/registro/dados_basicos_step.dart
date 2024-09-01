import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:futzada/controllers/pelada_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/inputs/input_radio_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class DadosBasicosStep extends StatefulWidget {
  final VoidCallback proximo;
  final int etapa;
  final PeladaController controller;
  
  const DadosBasicosStep({
    super.key, 
    required this.proximo, 
    required this.etapa,
    required this.controller
  });

  @override
  State<DadosBasicosStep> createState() => _DadosBasicosStepState();
}

class _DadosBasicosStepState extends State<DadosBasicosStep> {
  //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  // CONTROLLERS DE CADA CAMPO
  late final TextEditingController nomeController;
  late final TextEditingController bioController;
  late final TextEditingController visibilidadeController;
  late final TextEditingController fotoController;
  //DEFINIR ARMAZENAMENTO DA IMAGEM
  File? imageFile;
  //INICIALIZAR IMAGE PICKER
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    //INICIALIZAR LISTENER
    widget.controller.addListener((){});
    //INICIALIZAÇÃO DE CONTROLLERS
    nomeController = TextEditingController(text: widget.controller.model.nome);
    bioController = TextEditingController(text: widget.controller.model.bio);
    visibilidadeController = TextEditingController(text: widget.controller.model.visibilidade);
    fotoController = TextEditingController(text: widget.controller.model.foto);
  }

  //FUNÇÃO PARA BUSCAR IMAGEM
  Future<void> _getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    //VERIFICAR SE IMAGEM FOI SELECIONADA
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        widget.controller.onSaved({'foto': image.path});
      });
    }
  }

  //SELECIONAR A VISIBILIDADE
  void selectedVisibility(value){
    setState(() {
      visibilidadeController.text = value;
      widget.controller.onSaved({'visibilidade': value});
    });
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      widget.proximo();
    }
  }

  @override
  Widget build(BuildContext context) {
    //LISTA DE CAMPOS
    final List<Map<String, dynamic>> inputs = [
      {
        'name':'nome',
        'label': 'Nome',
        'controller': nomeController,
        'type': TextInputType.text
      },
      {
        'name':'bio',
        'label': 'Bio',
        'controller': bioController,
        'type': TextInputType.text
      },
    ];
    //LISTA DE INPUTS RADIO
    final List<Map<String, dynamic>> radios = [
      {
        'name': 'visibilidade',
        'placeholder' : 'Qualquer usuário pode visualizar as informações.',
        'value': 'Publico',
        'icon' : LineAwesomeIcons.door_open_solid,
        'controller': visibilidadeController,
      },
      {
        'name': 'visibilidade',
        'placeholder' : 'Apenas os participantes podem visualizar as informações.',
        'value': 'Privado',
        'icon' : LineAwesomeIcons.door_closed_solid,
        'controller': visibilidadeController,
      },
    ];

    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Cadastro", 
        action: () => Get.toNamed('/cadastro/apresentacao')
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
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Dados Básicos",
                      style: TextStyle(
                        color: AppColors.dark_500,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Certo então vamos começar! Informe-nos os seus dados básicos para começarmos a criar seu perfil.",
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
                      controller: widget.controller,
                      onSaved: widget.controller.onSaved,
                      type: input['type'],
                      validator: input['validator'],
                    ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          "Visibilidade da Pelada",
                          style: Theme.of(context).textTheme.labelLarge,
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
                          controller: widget.controller,
                          onChanged: selectedVisibility,
                        ),
                    ]
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "Foto",
                            style: TextStyle(
                              color: AppColors.dark_500,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ]
                    ),
                  ),
                  if (imageFile != null)
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:  FileImage(
                            imageFile!,
                          ),
                          fit: BoxFit.cover
                        ),
                        color: AppColors.green_300,
                        border: Border.all(
                          color: AppColors.gray_500,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(100),
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
    //DISPOSE DOS CONTROLLERS
    nomeController.dispose();
    bioController.dispose();
    //REMOVER LISTENER
    widget.controller.removeListener((){});
    super.dispose();
  }
}