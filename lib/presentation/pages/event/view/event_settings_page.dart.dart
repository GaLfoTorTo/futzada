import 'dart:io';
import 'package:futzada/core/helpers/event_helper.dart';
import 'package:futzada/core/helpers/form_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/widget/cards/card_colaborator.dart';
import 'package:futzada/presentation/widget/inputs/input_date_widget.dart';
import 'package:futzada/presentation/widget/inputs/select_days_week_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/img_helper.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_switch_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_radio_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_text_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_textarea_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';

class EventSettingsPage extends StatefulWidget {
  const EventSettingsPage({super.key});

  @override
  State<EventSettingsPage> createState() => _EventSettingsPageState();
}

class _EventSettingsPageState extends State<EventSettingsPage> {
  //DEFINIR CONTROLLERS
  EventController eventController = EventController.instance;
  late UserModel eventOrganizador;
  late List<UserModel?> eventCollaborators;
  File? imageFile;
  bool privacy = false;
  String privacyPlaceholder = 'Apenas os participantes podem visualizar as informações da pelada.';
  IconData privacyIcon = Icons.lock_outline_rounded;
  bool notification = true;


  @override
  void initState() {
    super.initState();
    eventController.initConfigTextControllers(eventController.event);
    imageFile = eventController.event.photo != null ? File(eventController.event.photo!) : null;
    eventOrganizador = EventHelper.getUserOrganizator(eventController.event);
    eventCollaborators = EventHelper.getCollaborators(eventController.event);
  }

  List<Map<String, dynamic>> settings = [
    {"menu": "Geral", "icon" : Icons.settings_rounded, "open": true},
    {"menu": "Endereço", "icon" : Icons.location_on, "open": false},
    {"menu": "Data e Hora", "icon" : Icons.calendar_month_rounded, "open": false},
    {"menu": "Notificações", "icon" : AppIcones.bell_solid, "open": false},
    {"menu": "Colaboradores", "icon" : AppIcones.user_cog_solid, "open": false},
    {"menu": "Participants", "icon" : Icons.people_alt_rounded, "open": false},
    {"menu": "Partidas", "icon" : Icons.sports, "open": false},
  ];

  //FUNÇÃO DE DEFNIÇÃO DE PRIVACIDADE
  void setPrivacy(bool value){
    setState(() {
      privacy = value;
      eventController.privacyController.text = value.toString();
      if(value){
        privacyPlaceholder = 'Qualquer usuário pode visualizar as informações da pelada.';
        privacyIcon = Icons.lock_open_rounded;
      }else{
        privacyPlaceholder = 'Apenas os participantes podem visualizar as informações da pelada.';
        privacyIcon = Icons.lock_outline_rounded;
      }
    });
  }
  
  List<Widget> _buildMenuOptions(menu){
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    switch (menu) {
      case "Geral":
        return [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 10,
              children: [
                const InputTextWidget(
                  label: "Titulo",
                ),
                const InputTextWidget(
                  label: "Bio",
                  textArea: true,
                ),
                InputSwitchWidget(
                  name: "privacy", 
                  label: "Privacidade", 
                  labelPosition: 'center',
                  subtitle: privacyPlaceholder,
                  prefixIcon: privacyIcon,
                  value: privacy,
                  textController: eventController.privacyController,
                  onChanged: (value) => setPrivacy(value),
                ),
              ],
            ),
          )
        ];
      case "Endereço":
        return [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 10,
              children: [
                const InputTextWidget(
                  label: "Nome do Local (Ex: Arena Sports)",
                ),
              ],
            ),
          )
        ];
      case "Data e Hora":
        return [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dias da Semana',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SelectDaysWeekWidget(
                  values: eventController.daysWeek,
                  onChanged: (value){
                    if (eventController.daysWeek.contains(value)) {
                      eventController.daysWeek.remove(value);
                    } else {
                      eventController.daysWeek.add(value);
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: dimensions.width / 2 - 25,
                      child: InputDateWidget(
                        name: 'horaInicio',
                        label: 'Hora de Início',
                        textController: eventController.startTimeController,
                        onValidated: (value) => eventController.apiService.validateEmpty(value, 'Hora de Início'),
                        showModal: () => FormHelper.selectTime(context, 'horaInicio'),
                      ),
                    ),
                    SizedBox(
                      width: dimensions.width / 2 - 25,
                      child: InputDateWidget(
                        name: 'horaFim',
                        label: 'Hora de Fim',
                        textController: eventController.endTimeController,
                        onValidated: (value) => eventController.apiService.validateEmpty(value, 'Hora de Fim'),
                        showModal: () => FormHelper.selectTime(context, 'horaFim'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ];
      case "Notificações":
        return [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                InputSwitchWidget(
                  name: "event", 
                  label: "Pelada", 
                  labelPosition: 'center',
                  subtitle: "Receber notificações sobre a pelada.",
                  prefixIcon: Icons.notifications,
                  value: notification,
                  textController: eventController.notificationController,
                  onChanged: (value){
                    setState(() {
                      notification = value;
                      eventController.notificationController.text = value.toString();
                    });
                  }
                ),
                InputSwitchWidget(
                  name: "game", 
                  label: "Partidas", 
                  labelPosition: 'center',
                  subtitle: "Receber notificações sobre eventos em partidas.",
                  prefixIcon: Icons.notifications,
                  value: notification,
                  textController: eventController.notificationController,
                  onChanged: (value){
                    setState(() {
                      notification = value;
                      eventController.notificationController.text = value.toString();
                    });
                  }
                ),
                InputSwitchWidget(
                  name: "schedule", 
                  label: "Agenda", 
                  labelPosition: 'center',
                  subtitle: "Receber notificações sobre agenda de partidas.",
                  prefixIcon: Icons.notifications,
                  value: notification,
                  textController: eventController.notificationController,
                  onChanged: (value){
                    setState(() {
                      notification = value;
                      eventController.notificationController.text = value.toString();
                    });
                  }
                ),
                InputSwitchWidget(
                  name: "rules", 
                  label: "Regras", 
                  labelPosition: 'center',
                  subtitle: "Receber notificações sobre atualizações das regras.",
                  prefixIcon: Icons.notifications,
                  value: notification,
                  textController: eventController.notificationController,
                  onChanged: (value){
                    setState(() {
                      notification = value;
                      eventController.notificationController.text = value.toString();
                    });
                  }
                ),
              ],
            ),
          )
        ];
      case "Colaboradores":
        return [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 10,
              children: [
                CardColaborator(
                  user: eventOrganizador,
                  role: 'Organizador',
                ),
                if(eventCollaborators.isNotEmpty)...[
                  ...eventCollaborators.take(3).map((colaborador){
                    return CardColaborator(
                      user: colaborador!,
                      role: 'Colaborator',
                    );
                  }),
                ],
                if(eventCollaborators.isNotEmpty && eventCollaborators.length > 3)...[
                  ButtonTextWidget(
                    text: "Mais ${eventCollaborators.length - 3}",
                    width: 100,
                    height: 20,
                    textColor: AppColors.green_300,
                    backgroundColor: AppColors.green_300.withAlpha(20),
                    action: () => {},
                  ),
                ],
                InkWell(
                  onTap: (){},
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.grey_500.withAlpha(50),
                        width: 2,
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_rounded,
                          color: AppColors.grey_500,
                          size: 30,
                        ),
                        Text(
                          "Adicionar Colaborador",
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.grey_500
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          )
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Configurações',
        leftAction: () => Get.back(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 20,
              children: [
                InkWell(
                  onTap: () async {
                    setState(() async{
                      imageFile = await ImgHelper().getImage();
                      eventController.photoController.text = imageFile?.path ?? "";
                    });
                  },
                  enableFeedback: false,
                  child: ImgHelper().capaImage(imageFile, dimensions)
                ),
                Text(
                  'Toque para alterar a foto de capa',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                ...settings.map((menu){
                  return ExpansionTile(
                    collapsedBackgroundColor: Theme.of(context).cardTheme.color!.withAlpha(20),
                    collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0, color: AppColors.grey_300.withAlpha(20)), 
                      borderRadius: BorderRadiusGeometry.circular(10)
                    ),
                    collapsedIconColor: AppColors.grey_500,
                    collapsedTextColor: AppColors.grey_500,
                    initiallyExpanded: menu["open"],
                    iconColor: Theme.of(context).textTheme.bodyLarge!.color,
                    textColor: Theme.of(context).textTheme.bodyLarge!.color,
                    title: Text(
                      menu["menu"],
                      style: Theme.of(context).textTheme.titleMedium!
                    ),
                    leading: Icon(
                      menu["icon"],
                      size: 25,
                    ),
                    children: _buildMenuOptions(menu["menu"])
                  );
                }),
                ButtonTextWidget(
                  width: dimensions.width,
                  backgroundColor: AppColors.red_300.withAlpha(50),
                  textColor: AppColors.red_300,
                  text: "Excluir Pelada",
                  icon: Icons.delete,
                  action: (){}
                )
              ]              
            ),
          ),
        ),
      ),
    );
  }
}
