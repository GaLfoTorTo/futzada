import 'dart:io';
import 'package:flutter/material.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/presentation/widget/cards/card_info_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/presentation/widget/inputs/input_radio_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_text_widget.dart';
import 'package:futzada/presentation/controllers/register_controller.dart';

class UserStep extends StatefulWidget {
  const UserStep({super.key});

  @override
  State<UserStep> createState() => _UserStepState();
}

class _UserStepState extends State<UserStep> {
  //CONTROLADOR DOS INPUTS DO FORMULÁRIO
  final RegisterController registerController = RegisterController.instance;
  final GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();
  //INICIALIZAR IMAGE PICKER
  final ImagePicker imagePicker = ImagePicker();
  //VARIAVEL DE CONTROLE DE IMAGEM DO USUARIO
  File? imageFile;

  @override
  void initState() {
    super.initState();
    //VERIFICAR ALGUMA IMAGEM FOI SALVA PELO USUARIO
    if (registerController.photoController.text.isNotEmpty) {
      //CRIAR UM OBJETO FILE APARTIR DO CAMINHO SALVO
      imageFile = File(registerController.photoController.text); 
    }
  }

  @override
  void dispose() {
    //REMOVER LISTENER
    registerController.removeListener((){});
    super.dispose();
  }
  
  //FUNÇÃO PARA BUSCAR IMAGEM
  Future<void> getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    //VERIFICAR SE IMAGEM FOI SELECIONADA
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        registerController.photoController.text = image.path;
      });
    }
  }

  //SELECIONAR A VISIBILIDADE DO PERFIL
  void selectedVisibility(value){
    setState(() {
      registerController.visibilityController.text = VisibilityProfile.values.firstWhere((e) => e.name == value).name;
    });
  }


  @override
  Widget build(BuildContext context) {
    //LISTA DE CAMPOS
    final List<Map<String, dynamic>> inputs = [
      {
        'name':'firstName',
        'label': 'Nome',
        'prefixIcon' : Icons.person,
        'controller': registerController.firstNameController,
        'type': TextInputType.text
      },
      {
        'name': 'lastName',
        'label': 'Sobrenome',
        'prefixIcon' : Icons.person,
        'controller': registerController.lastNameController,
        'type': TextInputType.text
      },
      {
        'name': 'userName',
        'label': 'Nome de Usuário',
        'prefixIcon' : Icons.alternate_email_rounded,
        'controller': registerController.userNameController,
        'type': TextInputType.text
      },
      {
        'name': 'email',
        'label': 'E-mail',
        'prefixIcon' : Icons.mail,
        'controller': registerController.emailController,
        'type': TextInputType.emailAddress,
      },
      {
        'name': 'phone',
        'label': 'Telefone',
        'prefixIcon' : Icons.phone,
        'controller': registerController.phoneController,
        'type': TextInputType.phone,
      },
      {
        'name': 'bornDate',
        'label': 'Data de Nascimento',
        'prefixIcon' : Icons.calendar_month,
        'controller': registerController.bornDateController,
        'type': TextInputType.datetime,
      },
      {
        'name':'password',
        'label': 'Senha',
        'prefixIcon' : Icons.lock,
        'sufixIcon' : Icons.visibility_off,
        'controller': registerController.passwordController,
        'type': TextInputType.visiblePassword,
      },
    ];
    //LISTA DE INPUTS RADIO
    final List<Map<String, dynamic>> radios = [
      {
        'name': 'visibility',
        'placeholder' : 'Qualquer usuário pode visualizar suas informações.',
        'value': 'Public',
        'label': 'Publico',
        'controller': registerController.visibilityController,
      },
      {
        'name': 'visibility',
        'placeholder' : 'Apenas você e seus amigos podem visualizar suas informações.',
        'value': 'Private',
        'label': 'Privado',
        'controller': registerController.visibilityController,
      },
    ];

    return Form(
      key: formKeyStep1,
      child: SingleChildScrollView(
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Dados Básicos",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              "Certo então vamos começar! Informe seus dados básicos para inicar coma a criação do seu perfil.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
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
                      color: AppColors.grey_300.withAlpha(50),
                      border: Border.all(
                        color: AppColors.grey_500,
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
                      Icons.camera_alt,
                      color: AppColors.blue_500,
                      size: 15,
                    ),
                  ),
                ),
              ]
            ),
            ...inputs.map((input) => 
              InputTextWidget(
                name: input['name'],
                label: input['label'],
                prefixIcon: input['prefixIcon'],
                sufixIcon: input['sufixIcon'],
                textController: input['controller'],
                type: input['type'],
                onValidated: input['validator'],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Visibilidade do Perfil",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const CardInfoWidget(description: "Defina quem poderá visualizar suas informações de usuário. Esta informação pode ser alterada a qualquer momento."),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: radios.map((radio) => 
                  InputRadioWidget(
                    name: radio['name'],
                    label: radio['label'],
                    value: radio['value'],
                    placeholder: radio['placeholder'],
                    textController: radio['controller'],
                    onChanged: selectedVisibility,
                  )
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}