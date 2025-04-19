import 'dart:io';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/register_controller.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/inputs/input_radio_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class RegisterBasicStep extends StatefulWidget {
  
  const RegisterBasicStep({super.key});

  @override
  State<RegisterBasicStep> createState() => _RegisterBasicStepState();
}

class _RegisterBasicStepState extends State<RegisterBasicStep> {
  //FORMKEY PARA FORMULARIO DE CADASTRO
  final formKey = GlobalKey<FormState>();
  //CONTROLADOR DOS INPUTS DO FORMULÁRIO
  final RegisterController controller = Get.put(RegisterController());
  //INICIALIZAR IMAGE PICKER
  final ImagePicker imagePicker = ImagePicker();
  //VARIAVEL DE CONTROLE DE IMAGEM DO USUARIO
  File? imageFile;

  @override
  void initState() {
    super.initState();
    //VERIFICAR ALGUMA IMAGEM FOI SALVA PELO USUARIO
    if (controller.model.photo != null) {
      //CRIAR UM OBJETO FILE APARTIR DO CAMINHO SALVO
      imageFile = File(controller.model.photo!); 
    }
  }
  
  //FUNÇÃO PARA BUSCAR IMAGEM
  Future<void> getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    //VERIFICAR SE IMAGEM FOI SELECIONADA
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        controller.onSaved({'photo': image.path});
      });
    }
  }

  //SELECIONAR A VISIBILIDADE DO PERFIL
  void selectedVisibility(value){
    setState(() {
      var visibility = VisibilityPerfil.values.firstWhere((e) => e.name == value);
      controller.visibilityController.text = value;
      controller.onSaved({'visibility': visibility});
    });
  }


  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      //NAVEGAR PARA PROXIMA ETAPA
      Get.toNamed('/register/modos');
    }
  }

  @override
  Widget build(BuildContext context) {
    //LISTA DE CAMPOS
    final List<Map<String, dynamic>> inputs = [
      {
        'name':'firstName',
        'label': 'Nome',
        'prefixIcon' : AppIcones.user_outline,
        'controller': controller.firstNameController,
        'type': TextInputType.text
      },
      {
        'name': 'lastName',
        'label': 'Sobrenome',
        'prefixIcon' : AppIcones.user_outline,
        'controller': controller.lastNameController,
        'type': TextInputType.text
      },
      {
        'name': 'userName',
        'label': 'Nome de Usuário',
        'prefixIcon' : LineAwesomeIcons.at_solid,
        'controller': controller.userNameController,
        'type': TextInputType.text
      },
      {
        'name': 'email',
        'label': 'E-mail',
        'prefixIcon' : LineAwesomeIcons.envelope,
        'controller': controller.emailController,
        'type': TextInputType.emailAddress,
      },
      {
        'name': 'phone',
        'label': 'Telefone',
        'prefixIcon' : LineAwesomeIcons.phone_alt_solid,
        'controller': controller.phoneController,
        'type': TextInputType.phone,
      },
      {
        'name': 'bornDate',
        'label': 'Data de Nascimento',
        'prefixIcon' : AppIcones.calendar_outline,
        'controller': controller.bornDateController,
        'type': TextInputType.datetime,
      },
      {
        'name':'password',
        'label': 'Senha',
        'prefixIcon' : AppIcones.lock_outline,
        'sufixIcon' : Icons.visibility_off,
        'controller': controller.passwordController,
        'type': TextInputType.visiblePassword,
      },
    ];
    //LISTA DE INPUTS RADIO
    final List<Map<String, dynamic>> radios = [
      {
        'name': 'visibility',
        'placeholder' : 'Qualquer usuário pode visualizar suas informações.',
        'value': 'Publico',
        'icon' : AppIcones.door_open_solid,
        'controller': controller.visibilityController,
      },
      {
        'name': 'visibility',
        'placeholder' : 'Apenas você e seus amigos podem visualizar suas informações..',
        'value': 'Privado',
        'icon' : AppIcones.door_close_solid,
        'controller': controller.visibilityController,
      },
    ];

    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Cadastro", 
        leftAction: () => Get.toNamed('/register/apresentacao')
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
                      "Dados Básicos",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Certo então vamos começar! Informe-nos os seus dados básicos para começarmos a criar seu perfil.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Stack(
                    children:[ 
                      InkWell(
                        onTap: getImage,
                        enableFeedback: false,
                        child: Container(
                          width: 150,
                          height: 150,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageFile != null 
                                ? FileImage(imageFile!) as ImageProvider<Object>
                                : const AssetImage(AppImages.userDefault) ,
                              fit: BoxFit.cover
                            ),
                            color: AppColors.gray_300.withOpacity(0.5),
                            border: Border.all(
                              color: AppColors.gray_500,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 125,
                        left: 90,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.green_300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            AppIcones.camera_solid,
                            color: AppColors.blue_500,
                            size: 15,
                          ),
                        ),
                      ),
                    ]
                  ),
                  for(var input in inputs)
                    InputTextWidget(
                      name: input['name'],
                      label: input['label'],
                      prefixIcon: input['prefixIcon'],
                      sufixIcon: input['sufixIcon'],
                      textController: input['controller'],
                      controller: controller,
                      onSaved: controller.onSaved,
                      type: input['type'],
                      validator: input['validator'],
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Visibilidade do Perfil",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Defina quem poderá visualizar suas informações de usuário. Esta informação pode ser alterada a qualquer momento.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
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
      )
    );
  }

  @override
  void dispose() {
    //REMOVER LISTENER
    controller.removeListener((){});
    super.dispose();
  }
}