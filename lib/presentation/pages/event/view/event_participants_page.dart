import 'package:flutter/material.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/presentation/pages/erros/erro_participants_page.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/theme/app_size.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:futzada/core/utils/user_utils.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_text_widget.dart';
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
              color: Get.isDarkMode ? AppColors.dark_700 : AppColors.white,
              padding: const EdgeInsets.all(10),
              child: InputTextWidget(
                name: 'search',
                hint: 'Pesquisa',
                backgroundColor: AppColors.grey_300.withAlpha(50),
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
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        key,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ...participants.map((user){
                      //RESGATAR TIPO DE PARTICIPANT
                      var iconRole = setRole(UserUtils.getParticipant(user.participants, eventController.event.id!)?.role);
                      return TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Get.isDarkMode ? AppColors.dark_300 : AppColors.white,
                          foregroundColor: Get.isDarkMode ? AppColors.dark_700 : AppColors.grey_300,
                          padding: const EdgeInsets.all(15),
                          elevation: 3
                        ),
                        onPressed: () => Get.toNamed('/profile', arguments: {'id': user.id}),
                        child: Row(
                          children: [
                            ImgCircularWidget(
                              height: 60,
                              width: 60,
                              image: user.photo,
                              borderColor: AppColors.grey_500
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
                                      UserUtils.getFullName(user),
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                  SizedBox(
                                    width: (dimensions.width / 2) - 50,
                                    height: 25,
                                    child: Text(
                                      "@${user.userName}",
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(overflow: TextOverflow.ellipsis, color: AppColors.grey_300),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        PositionWidget(
                                          position: user.player!.mainPosition[eventController.event.modality!.name]!,
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
                                  color: Get.isDarkMode ? AppColors.white : AppColors.blue_500,
                                  size: iconRole == AppIcones.foot_futebol_solid ? 15 : 20,
                                ),
                              )
                            ),
                          ],
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