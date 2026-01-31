import 'dart:io';
import 'package:futzada/presentation/widget/inputs/input_switch_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:image_picker/image_picker.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_checkbox_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_textarea_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_radio_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_text_widget.dart';
import 'package:futzada/presentation/controllers/navigation_controller.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';

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
  //CONTROLADOR DE VALIDAÇÃO
  bool isValid = true;
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
        //RESGTAR CAMINHO DA IMAGEM
        imageFile = File(image.path);
        eventController.photoController.text = image.path;
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
              color: AppColors.grey_500,
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
              color: AppColors.grey_700,
              border: Border.all(
                color: AppColors.grey_500,
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
      //ENCONTRAR A PERMISSÃO NO MAP
      eventController.permissions.update(name,(value) => !value);
    });
  }

  //FUNÇÃO PARA VALIDAR FORMULÁRIO
  void validForm(){
    setState(() {  
      //VERIFICAR SE VISIBILIDADE FOI SELECIONADA
      if(eventController.privacyController.text.isEmpty){
        isValid = false;
      }
      //VERIFICAR SE COLABORADORES ESTÃO ATIVADOS
      if(bool.parse(eventController.allowCollaboratorsController.text)){
        //VERIFICAR SE PERMISSÕES FORAM DEFINIDAS
        if(!eventController.permissions.containsValue(true)){
          isValid = false;
        }
      }
      //RESGATAR O FORMULÁRIO
      var formData = formKey.currentState;
      //VERIFIAR SE CAMPOS DE TEXTO FORAM PREENCHIDOS
      if(formData?.validate() ?? false){
        isValid = true;
        return;
      }
      isValid = false;
      return;
    });
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //VALIDAR FORMULÁRIO
    validForm();
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (isValid) {
      //NAVEGAR PARA CADASTRO DE ENDEREÇO
      Get.toNamed('/event/register/address');
    }
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    //LISTA DE INPUTS RADIO
    final List<Map<String, dynamic>> radios = [
      {
        'name': 'privacy',
        'placeholder' : 'Qualquer usuário pode visualizar as informações.',
        'label': 'Publico',
        'value': Privacy.Public.name,
        'icon' : AppIcones.door_open_solid,
        'controller': eventController.privacyController,
      },
      {
        'name': 'privacy',
        'placeholder' : 'Apenas os participantes podem visualizar as informações.',
        'label': 'Privado',
        'value': Privacy.Private.name,
        'icon' : AppIcones.door_close_solid,
        'controller': eventController.privacyController,
      },
    ];

    return Scaffold(
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
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey_500),
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
                    onValidated: (value) => eventController.apiService.validateEmpty(value, 'titulo'),
                    type: TextInputType.text,
                  ),
                  InputTextWidget(
                    name: 'bio',
                    label: 'Bio',
                    hint: 'Ex: Melhor Pelada do Brasil',
                    textController: eventController.bioController,
                    textArea: true,
                    onValidated: (value) => eventController.apiService.validateEmpty(value, 'titulo'),
                    type: TextInputType.text,
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
                          label: radio['label'],
                          value: radio['value'],
                          icon: radio['icon'],
                          placeholder: radio['placeholder'],
                          textController: radio['controller'],
                          onChanged: (value){
                            setState(() {
                              eventController.privacyController.text = value;
                            });
                          },
                        );
                      }),
                      //VALIDAÇÃO DE VISIBILIDADE
                      if(!isValid && eventController.privacyController.text.isEmpty)...[
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'A visibilidade deve ser informada!',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ]
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
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  InputSwitchWidget(
                    name: "colaboradors", 
                    label: "Colaboradores", 
                    prefixIcon: AppIcones.users_solid,
                    value: bool.parse(eventController.allowCollaboratorsController.text), 
                    textController: eventController.allowCollaboratorsController,
                    onChanged: (value){
                      setState(() {
                        eventController.allowCollaboratorsController.text = value.toString();
                      });
                    },
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
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey_500),
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
                        //VALIDAÇÃO DE COLABORADORES
                        if(bool.parse(eventController.allowCollaboratorsController.text))...[
                          if(!isValid && !eventController.permissions.containsValue(true))...[
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Ao menos 1 opção de permissão deve ser selecionada!',
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          ]
                        ]
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