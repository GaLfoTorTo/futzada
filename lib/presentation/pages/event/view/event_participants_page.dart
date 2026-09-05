import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/enum/enums.dart';
import 'package:esportly/presentation/pages/event/error/erro_participants_page.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/core/theme/app_size.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/core/providers/event/event_session_provider.dart';
import 'package:esportly/core/providers/event/event_participants_provider.dart';
import 'package:esportly/core/helpers/user_helper.dart';
import 'package:esportly/presentation/widget/images/img_circle_widget.dart';
import 'package:esportly/presentation/widget/badges/position_widget.dart';
import 'package:esportly/presentation/widget/inputs/input_text_widget.dart';
import 'package:go_router/go_router.dart';

class EventParticipantsPage extends ConsumerWidget {
  const EventParticipantsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dimensions = MediaQuery.of(context).size;
    final EventModel event = ref.watch(eventSessionProvider.select((s) => s.event!));
    final participantsState = ref.watch(eventParticipantsProvider);
    final participantsNotifier = ref.read(eventParticipantsProvider.notifier);

    // Inicializa participantes a partir do evento caso o provider ainda não tenha sido populado
    if (participantsState.participants.values.every((l) => l?.isEmpty ?? true)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        participantsNotifier.setParticipants(event.participants);
      });
    }

    IconData setRole(List<String>? roles) {
      if (roles != null) {
        if (roles.contains(Roles.Organizator.name)) return AppIcones.user_shield_solid;
        if (roles.contains(Roles.Colaborator.name)) return AppIcones.user_cog_solid;
        if (roles.contains(Roles.Player.name)) return AppIcones.foot_futebol_solid;
        if (roles.contains(Roles.Manager.name)) return AppIcones.clipboard_solid;
      }
      return AppIcones.user_solid;
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: dimensions.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.dark_700 : AppColors.white,
              padding: const EdgeInsets.all(10),
              child: InputTextWidget(
                name: 'search',
                hint: 'Pesquisa',
                backgroundColor: AppColors.grey_300.withAlpha(50),
                prefixIcon: AppIcones.search_solid,
                textController: participantsNotifier.pesquisaController,
                type: TextInputType.text,
              ),
            ),
            ...participantsState.participants.entries.map((item) {
              final String key = item.key;
              final participants = item.value;
              if (participants == null) return const ErroParticipantsPage();

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(key, style: Theme.of(context).textTheme.titleMedium),
                    ),
                    ...participants.map((user) {
                      final iconRole = setRole(UserHelper.getParticipant(user.participants, event.id!)?.role);
                      return TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.dark_300 : AppColors.white,
                          foregroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.dark_700 : AppColors.grey_300,
                          padding: const EdgeInsets.all(15),
                          elevation: 3
                        ),
                        onPressed: () => context.push('/profile', extra: {'id': user.id}),
                        child: Row(
                          children: [
                            ImgCircularWidget(
                              size: 60,
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
                                      UserHelper.getFullName(user),
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
                                        if (user.player!.getMainPosition(event.modality!.name) != null)
                                          PositionWidget(
                                            position: user.player!.getMainPosition(event.modality!.name)!.alias,
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
                                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.blue_500,
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
