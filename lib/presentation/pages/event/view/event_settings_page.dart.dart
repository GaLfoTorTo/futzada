import 'dart:io';
import 'package:futzada/presentation/widget/inputs/input_switch_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/img_helper.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_radio_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_text_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_textarea_widget.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';

class EventSettingsPage extends StatefulWidget {
  const EventSettingsPage({super.key});

  @override
  State<EventSettingsPage> createState() => _EventSettingsPageState();
}

class _EventSettingsPageState extends State<EventSettingsPage> {
  //DEFINIR CONTROLLERS
  EventController eventController = EventController.instance;
  File? imageFile;
  bool privacy = false;
  String privacyPlaceholder = 'Qualquer usuário pode visualizar as informações da pelada.';
  IconData privacyIcon = Icons.lock_outline_rounded;
  bool notification = true;


  @override
  void initState() {
    super.initState();
    eventController.initConfigTextControllers(eventController.event);
    imageFile = eventController.event.photo != null ? File(eventController.event.photo!) : null;
  }

  List<Map<String, dynamic>> settings = [
    {"menu": "Geral", "icon" : Icons.settings_rounded, "open": true},
    {"menu": "Endereço", "icon" : Icons.location_on, "open": false},
    {"menu": "Data e Hora", "icon" : Icons.calendar_month_rounded, "open": false},
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
        privacyIcon = Icons.lock_outline_rounded;
      }else{
        privacyPlaceholder = 'Apenas os participantes podem visualizar as informações da pelada.';
        privacyIcon = Icons.lock_open_rounded;
      }
    });
  }
  
  List<Widget> _buildMenuOptions(menu){
    switch (menu) {
      case "Geral":
        return [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 10,
              children: [
                InputTextWidget(
                  label: "Titulo",
                ),
                InputTextWidget(
                  label: "Bio",
                  textArea: true,
                ),
                InputSwitchWidget(
                  name: "privacy", 
                  label: "Privacidade", 
                  prefixIcon: privacyIcon,
                  value: privacy,
                  textController: eventController.privacyController,
                  onChanged: (value) => setPrivacy(value),
                ),
                Text(
                  privacyPlaceholder,
                  style: Theme.of(context).textTheme.displayMedium,
                )
              ],
            ),
          )
        ];
      case "Notificações":
        return [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 10,
              children: [
                InputSwitchWidget(
                  name: "notification", 
                  label: "Notificações", 
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
                Text(
                  "Receber notificações no aplicativo sobre atualizações da pelada.",
                  style: Theme.of(context).textTheme.displayMedium,
                )
              ],
            ),
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
              spacing: 15,
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
                ...settings.map((menu){
                  return ExpansionTile(
                    collapsedBackgroundColor: Theme.of(context).cardTheme.color,
                    collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0, color: AppColors.grey_300.withAlpha(50)), 
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
