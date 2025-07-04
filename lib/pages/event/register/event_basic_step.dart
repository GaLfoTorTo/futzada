import 'dart:convert';
import 'dart:io';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/helpers/app_helper.dart';
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
import 'package:futzada/controllers/event_controller.dart';

class EventBasicStep extends StatefulWidget {  
  const EventBasicStep({super.key});

  @override
  State<EventBasicStep> createState() => EventBasicStepState();
}

class EventBasicStepState extends State<EventBasicStep> {
  //RESGATAR CONTROLLER DE NAVEGAÇÃO
  NavigationController navigationController = NavigationController.instance;
  //RESGATAR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
  //DEFINIR FORMKEY
  final formKey = GlobalKey<FormState>();
  //DEFINIR ARMAZENAMENTO DA IMAGEM
  File? imageFile;
  //INICIALIZAR IMAGE PICKER
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE EVENTO
    eventController.initTextControllers();
  }

  //FUNÇÃO PARA BUSCAR IMAGEM DE CAPA
  Future<void> getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    //VERIFICAR SE IMAGEM FOI SELECIONADA
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        //eventController.onSaved({'photo': image.path});
      });
    }
  }

  //FUNÇÃO DE EXIBIÇÃO DE CAPA
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

  //FUNÇÃO PARA SELECIONAR PERMISSÇOES DE COLABORADORES
  void selectedPermissions(String name){
    setState(() {
      //ENCONTRAR O DIA ESPECIFICO NO ARRAY
      eventController.permissions.update(name,(value) => !value);
      //ADICIONAR A MODEL DE PELADA
      eventController.permissionsController.text = jsonEncode(eventController.permissions);
      //eventController.onSaved({"permissions": jsonEncode(eventController.permissions)});
    });
  }

  //FUNÇÃO PARA VALIDAR FORMULÁRIO
  bool validForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFIAR SE CAMPOS DE TEXTO FORAM PREENCHIDOS
    if(formData?.validate() ?? false){
      //VERIFICAR SE VISIBILIDADE FOI SELECIONADA
      if(eventController.visibilityController.text.isNotEmpty){
        return true;
      }
      AppHelper.feedbackMessage(context, 'Selecione a visibilidade da pelada.', type: 'error');
    }
    return false;
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (validForm()) {
      //NAVEGAR PARA CADASTRO DE ENDEREÇO
      Get.toNamed('/event/register/config_games');
    }
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    //LISTA DE INPUTS RADIO
    final List<Map<String, dynamic>> radios = [
      {
        'name': 'visibility',
        'placeholder' : 'Qualquer usuário pode visualizar as informações.',
        'value': VisibilityPerfil.Public.name,
        'icon' : AppIcones.door_open_solid,
        'controller': eventController.visibilityController,
      },
      {
        'name': 'visibility',
        'placeholder' : 'Apenas os participantes podem visualizar as informações.',
        'value': VisibilityPerfil.Private.name,
        'icon' : AppIcones.door_close_solid,
        'controller': eventController.visibilityController,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Registro ", 
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
                      "Certo, vamos lá! Informe o Nome, a Bio e defina uma Imagem para capa da sua pelada. Você também pode definir as configurações de visibilidade e se sua pelada contará com colaboradores.",
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
                    name: 'title',
                    label: 'Titulo',
                    textController: eventController.titleController,
                    controller: eventController,
                    type: TextInputType.text,
                  ),
                  InputTextAreaWidget(
                    name: 'bio',
                    label: 'Bio',
                    hint: 'Ex: Melhor Pelada do Brasil',
                    textController: eventController.bioController,
                    controller: eventController,
                    validator: (){},
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
                      ...radios.map((radio){
                        return InputRadioWidget(
                          name: radio['name'],
                          value: radio['value'],
                          icon: radio['icon'],
                          placeholder: radio['placeholder'],
                          textController: radio['controller'],
                          controller: eventController,
                          onChanged: (value){
                            setState(() {
                              eventController.visibilityController.text = value;
                            });
                          },
                        );
                      })
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
                      "Defina se sua pelada contará com o auxilio de colaboradores. Os colaboradores da pelada serão os participantes que contribuiram na organização da pelada.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: SwitchListTile(
                      value: bool.parse(eventController.allowCollaboratorsController.text),
                      onChanged: (value){
                        setState(() {
                          eventController.allowCollaboratorsController.text = value.toString();
                        });
                      },
                      activeColor: AppColors.green_300,
                      inactiveTrackColor: AppColors.gray_300,
                      inactiveThumbColor: AppColors.gray_500,
                      title: Text(
                        'Colaboradores',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.dark_300),
                      ),
                      secondary: const Icon(
                        AppIcones.users_solid,
                        color: AppColors.gray_500,
                        size: 25,
                      ),
                    ),
                  ),
                  if(bool.parse(eventController.allowCollaboratorsController.text))...[
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
                              ...eventController.permissions.entries.map((permissao){
                                return InputCheckBoxWidget(
                                  name: permissao.key,
                                  value: permissao.value,
                                  onChanged: selectedPermissions,
                                );
                              })
                            ]
                          ),
                        ),
                      ],
                    ),
                  ],
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
}