import 'package:flutter/material.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/pages/erros/erro_participants_page.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/badges/position_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:get/get.dart';

class EventParticipantsPage extends StatelessWidget {
  const EventParticipantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE RANK E EVENTO
    EventController eventController = EventController.instance;

    IconData setRole(List<String>? roles){
      //VERIFICAR SE PARTICIPANTE CONTEM ALGUMA DEFINIÇÃO DE ATUAÇÃO
      if(roles != null){
        //VERIFICAR SE PARTICIPANTE E O ORGANIZADOR
        if(roles.contains(Roles.Organizator.name)){
          return AppIcones.user_shield_solid;
        }
        //VERIFICAR SE PARTICIPANTE E COLABORADOR
        if(roles.contains(Roles.Colaborator.name)){
          return AppIcones.user_cog_solid;
        }
        //VERIFICAR SE PARTICIPANTE E JOGADOR
        if(roles.contains(Roles.Player.name)){
          return AppIcones.foot_futebol_solid;
        }
        //VERIFICAR SE PARTICIPANTE E TECNICO
        if(roles.contains(Roles.Manager.name)){
          return AppIcones.clipboard_solid;
        }
      }
      //RETORNO PADRÃO
      return AppIcones.user_solid;
    }

    return SingleChildScrollView(
      child: Container(
        width: dimensions.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(10),
              child: InputTextWidget(
                name: 'search',
                hint: 'Pesquisa',
                bgColor: AppColors.gray_300.withAlpha(50),
                prefixIcon: AppIcones.search_solid,
                textController: eventController.pesquisaController,
                type: TextInputType.text,
              ),
            ),
            ...eventController.participants.entries.map((item) {
              String key = item.key;
              var participants = item.value;
              //VERIFICAR SE PELADA CONTEM PARTICIPANTES
              if(participants == null){
                return const ErroParticipantsPage();
              }
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        key,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ...participants.map((participant){
                      var iconRole = setRole(participant.role);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.gray_500,
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: () => Get.toNamed('/profile', arguments: {'id': participant.user.id}),
                          child: Row(
                            children: [
                              ImgCircularWidget(
                                height: 60,
                                width: 60,
                                image: participant.user.photo,
                                borderColor: AppColors.gray_500
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (dimensions.width / 2) - 50,
                                      height: 25,
                                      child: Text(
                                        "${participant.user.firstName} ${participant.user.lastName}",
                                        style: Theme.of(context).textTheme.titleSmall!.copyWith(overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    SizedBox(
                                      width: (dimensions.width / 2) - 50,
                                      height: 25,
                                      child: Text(
                                        "@${participant.user.userName}",
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(overflow: TextOverflow.ellipsis, color: AppColors.gray_300),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          PositionWidget(
                                            position: participant.user.player!.mainPosition,
                                            mainPosition: true,
                                            width: 35,
                                            height: 25,
                                            textSide: AppSize.fontXs,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    iconRole,
                                    color: AppColors.blue_500,
                                    size: iconRole == AppIcones.foot_futebol_solid ? 15 : 20,
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                  ],
                ),
              );
            }).toList(),
          ]
        ),
      ),
    );
  }
}