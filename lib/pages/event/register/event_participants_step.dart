import 'package:futzada/models/user_model.dart';
import 'package:futzada/widget/dialogs/invite_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/controllers/event_controller.dart';

class EventParticipantsStep extends StatefulWidget {
  const EventParticipantsStep({super.key});

  @override
  State<EventParticipantsStep> createState() => _EventParticipantsStepState();
}

class _EventParticipantsStepState extends State<EventParticipantsStep> {
  //RESGATAR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;

  @override
  void initState() {
    super.initState();
  }

  //FUNÇÃO DE DEFINIÇÃO DE PREFERÊNCIAS DE CONVITE
  void openPreferencia(){
    Get.dialog(IniviteDialog(
      invite: eventController.invite,
    ));
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Participantes", 
        leftAction: () => Get.back(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: dimensions.width,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Adicionar Participantes",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Estamos quase lá! Agora so precisamos adicionar os participantes da pelada para começarmos a jogar.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.labelLarge,
                  decoration: const InputDecoration(
                    hintText: "Pesquisar...",
                    prefixIcon: Icon(
                      AppIcones.search_solid,
                      color: AppColors.gray_300,
                    ),
                  ),
                  onChanged: (value) {},
                  onTap: () => FocusScope.of(context).unfocus(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Seus Amigos',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      ButtonTextWidget(
                        text: "Preferências",
                        width: 130,
                        height: 20,
                        icon: AppIcones.cog_solid,
                        iconAfter: true,
                        textColor: AppColors.green_300,
                        backgroundColor: Colors.transparent,
                        action: () => openPreferencia(),
                      ),
                    ],
                  ),
                ),
                Obx((){
                  return Column(
                    children: eventController.friends.map((item){
                      //RESGATAR USUARIO TIPADO
                      final user = item['user'] as UserModel;
                      final invite = item['invite'] as RxMap<String, bool>;
                      final checked = item['checked'] as RxBool;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: TextButton(
                          onPressed: () => checked.toggle(),
                          onLongPress: () => Get.dialog(IniviteDialog(
                            invite: invite,
                          )),
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(AppColors.white),
                            padding: WidgetStatePropertyAll(EdgeInsets.all(15))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: ImgCircularWidget(
                                      height: 80,
                                      width: 80,
                                      image: user.photo,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${user.firstName?.capitalize} ${user.lastName?.capitalize}",
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                      Text(
                                        "@${user.userName}",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Transform.scale(
                                scale: 2,
                                child: Checkbox(
                                  value: checked.value,
                                  onChanged: (value) => checked.toggle(),
                                  activeColor: AppColors.green_300,
                                  side: const BorderSide(color: AppColors.gray_500, width: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ButtonOutlineWidget(
                        text: "Pular",
                        width: 100,
                        action: () => Get.back(),
                      ),
                      ButtonTextWidget(
                        text: "Convidar",
                        width: 100,
                        icon: AppIcones.paper_plane_solid,
                        action: (){},
                      ),
                    ],
                  ),
                ),
              ]
            )
          )
        )
      )
    );            
  }
}