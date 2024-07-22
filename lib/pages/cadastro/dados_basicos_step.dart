import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:futzada/controllers/cadastro_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/inputs/input_radio_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:image_picker/image_picker.dart';

class DadosBasicosStep extends StatefulWidget {
  final VoidCallback proximo;
  final int etapa;
  final CadastroController controller;
  
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
  late final TextEditingController sobreNomeController;
  late final MaskedTextController userNameController;
  late final TextEditingController emailController;
  late final MaskedTextController telefoneController;
  late final MaskedTextController dataNascimentoController;
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
    sobreNomeController = TextEditingController(text: widget.controller.model.sobrenome);
    userNameController = MaskedTextController(text: widget.controller.model.userName, mask: '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', translator: {"@": RegExp(r'[@\w]')});
    emailController = TextEditingController(text: widget.controller.model.email);
    telefoneController = MaskedTextController(text: widget.controller.model.telefone, mask: "(00) 00000-0000");
    dataNascimentoController = MaskedTextController(text: widget.controller.model.dataNascimento, mask: "00/00/0000");
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
        'name': 'sobrenome',
        'label': 'Sobrenome',
        'controller': sobreNomeController,
        'type': TextInputType.text
      },
      {
        'name': 'userName',
        'label': 'Nome de Usuário',
        'controller': userNameController,
        'type': TextInputType.text
      },
      {
        'name': 'email',
        'label': 'E-mail',
        'controller': emailController,
        'type': TextInputType.emailAddress,
      },
      {
        'name': 'telefone',
        'label': 'Telefone',
        'controller': telefoneController,
        'type': TextInputType.phone,
        'validator':(){}
      },
      {
        'name': 'dataNascimento',
        'label': 'Data de Nascimento',
        'controller': dataNascimentoController,
        'type': TextInputType.datetime,
        'validator':(){}
      },
    ];
    //LISTA DE INPUTS RADIO
    final List<Map<String, dynamic>> radios = [
      {
        'name': 'visibilidade',
        'placeholder' : 'Qualquer usuário pode visualizar suas informações.',
        'value': 'Publico',
        'icon' : AppIcones.door_open['fas'],
        'controller': visibilidadeController,
      },
      {
        'name': 'visibilidade',
        'placeholder' : 'Apenas você e seus amigos podem visualizar suas informações..',
        'value': 'Privado',
        'icon' : AppIcones.door_close['fas'],
        'controller': visibilidadeController,
      },
    ];

    var dimensions = MediaQuery.of(context).size;

    return SingleChildScrollView(
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
              IndicatorFormWidget(etapa: widget.etapa),
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
              const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "Visibilidade do Perfil",
                      style: TextStyle(
                        color: AppColors.dark_500,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
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
                        "Foto de Perfil",
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ButtonTextWidget(
                  type: "outline",
                  text: "Foto",
                  icon: AppIcones.camera['fas'],
                  textColor: AppColors.blue_500,
                  color: AppColors.blue_500,
                  width: double.infinity,
                  action: _getImage,
                ),
              ),
              ButtonTextWidget(
                text: "Próximo",
                textColor: AppColors.blue_500,
                color: AppColors.green_300,
                width: double.infinity,
                action: submitForm
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //DISPOSE DOS CONTROLLERS
    nomeController.dispose();
    sobreNomeController.dispose();
    userNameController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    dataNascimentoController.dispose();
    //REMOVER LISTENER
    widget.controller.removeListener((){});
    super.dispose();
  }
}