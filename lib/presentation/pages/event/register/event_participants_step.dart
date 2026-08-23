import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/presentation/widget/dialogs/dialog_invite.dart';
import 'package:flutter/material.dart';
import 'package:esportly/core/extensions/string_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_outline_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';
import 'package:esportly/presentation/widget/images/img_circle_widget.dart';
import 'package:esportly/presentation/controllers/event_controller.dart';

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
    showDialog(context: context, builder: (_) => DialogInvite(
      invite: eventController.invite,
    ));
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      appBar: HeaderWidget(
        title: "Participantes", 
        leftAction: () => context.pop(),
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
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey_500),
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
                      color: AppColors.grey_300,
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
                ListenableBuilder(listenable: eventController, builder: (_, __){
                  return Column(
                    children: eventController.friends.map((item){
                      //RESGATAR USUARIO TIPADO
                      final user = item['user'] as UserModel;
                      final invite = item['invite'] as Map<String, bool>;
                      final checked = item['checked'] as bool;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: TextButton(
                          onPressed: () => eventController.toggleFriend(item),
                          onLongPress: () => showDialog(context: context, builder: (_) => DialogInvite(
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
                                      size: 80,
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
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey_300),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Transform.scale(
                                scale: 2,
                                child: Checkbox(
                                  value: checked,
                                  onChanged: (value) => eventController.toggleFriend(item),
                                  activeColor: AppColors.green_300,
                                  side: const BorderSide(color: AppColors.grey_500, width: 1),
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
                        action: () => context.pop(),
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