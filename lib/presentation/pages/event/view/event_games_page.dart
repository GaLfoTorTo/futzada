import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futzada/core/providers/game/game_schedule_provider.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/date_helper.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:futzada/presentation/widget/cards/card_game_widget.dart';
import 'package:futzada/presentation/widget/cards/card_game_live_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_live_widget.dart';
import 'package:futzada/presentation/widget/skeletons/skeleton_games_widget.dart';
import 'package:futzada/presentation/pages/erros/erro_game_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EventGamesPage extends ConsumerStatefulWidget {
  const EventGamesPage({super.key});

  @override
  ConsumerState<EventGamesPage> createState() => _EventGamesPageState();
}

class _EventGamesPageState extends ConsumerState<EventGamesPage> {
  EventController eventController = EventController.instance;
  late PageController inProgressController;
  late EventModel event;
  late String eventDate;
  late Color modalityColor;
  late Color modalityTextColor;

  @override
  void initState() {
    super.initState();
    event = eventController.event;
    modalityColor = ModalityHelper.getEventModalityColor(event.gameConfig?.category ?? event.modality!.name)['color'];
    modalityTextColor = ModalityHelper.getEventModalityColor(event.gameConfig?.category ?? event.modality!.name)['textColor'];
    inProgressController = PageController();
    eventDate = DateHelper.getDateLabel(ref.read(gameScheduleProvider).eventDate!);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final schedule = ref.read(gameScheduleProvider);
      if (schedule.nextGames.isEmpty && schedule.finishedGames.isEmpty) {
        await ref.read(gameScheduleProvider.notifier).setGamesEvent(event);
        await ref.read(gameScheduleProvider.notifier).getHistoricGames(event);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;
    final schedule = ref.watch(gameScheduleProvider);
    final isToday = ref.read(gameScheduleProvider.notifier).isToday();

    return SingleChildScrollView(
      child: Container(
        width: dimensions.width,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          spacing: 10,
          children: [
            Text(
              "Agenda",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Explore a agenda completa das partidas da pelada. A quantidade de partidas e calculada a partir das informações de duração e horários de início e fim da pelada definidos pelo organizador.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            Builder(builder: (_) {
              List<Widget> listGames = [];

              if (!schedule.loadGames) {
                return const SkeletonGamesWidget();
              }

              if (!schedule.hasGames) {
                return ErroGamePage(
                  function: () async {
                    await ref.read(gameScheduleProvider.notifier).setGamesEvent(event);
                  },
                );
              }

              if (schedule.eventDate != null && isToday) {
                if (schedule.inProgressGames.isNotEmpty) {
                  listGames.addAll([
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.red_300,
                            ),
                            child: const IndicatorLiveWidget(size: 15, color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: dimensions.width,
                      child: PageView(
                        controller: inProgressController,
                        children: [
                          ...schedule.inProgressGames.take(3).map((game) {
                            return CardGameLiveWidget(event: event, game: game!);
                          }),
                        ],
                      ),
                    ),
                    if (schedule.inProgressGames.length > 1) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SmoothPageIndicator(
                          controller: inProgressController,
                          count: schedule.inProgressGames.length < 3 ? schedule.inProgressGames.length : 3,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: AppColors.blue_500,
                            dotColor: AppColors.grey_300,
                            expansionFactor: 2,
                          ),
                        ),
                      ),
                    ],
                  ]);
                }

                if (schedule.nextGames.isNotEmpty) {
                  listGames.addAll([
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Próximas partidas  - $eventDate',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      spacing: 20,
                      children: schedule.nextGames.asMap().entries.take(5).map((item) {
                        final key = item.key;
                        final game = item.value;
                        return CardGameWidget(
                          width: dimensions.width - 10,
                          event: event,
                          game: game!,
                          gameDate: eventDate,
                          navigate: key < 1,
                          active: key < 1,
                        );
                      }).toList(),
                    ),
                    ButtonTextWidget(
                      text: "Ver Mais ${schedule.nextGames.length}",
                      width: 120,
                      height: 20,
                      textColor: modalityColor,
                      backgroundColor: modalityColor.withAlpha(20),
                      action: () => {},
                    ),
                  ]);
                }
              }

              if (schedule.scheduledGames.isNotEmpty && schedule.scheduledGames.length < 4) {
                if (schedule.scheduledGames.isEmpty) return const SizedBox.shrink();
                eventDate = DateHelper.getDateLabel(schedule.scheduledGames.first!.startTime!);
                listGames.addAll([
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Partidas Agendadas - $eventDate',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    spacing: 20,
                    children: [
                      ...schedule.scheduledGames.take(10).map((game) {
                        return CardGameWidget(
                          width: dimensions.width - 10,
                          event: event,
                          game: game!,
                          gameDate: eventDate,
                          active: false,
                        );
                      }),
                    ],
                  ),
                  ButtonTextWidget(
                    text: "Ver Mais ${schedule.scheduledGames.length}",
                    width: 100,
                    height: 20,
                    textColor: AppColors.green_300,
                    backgroundColor: AppColors.green_300.withAlpha(20),
                    action: () => {},
                  ),
                ]);
              }

              return listGames.isNotEmpty
                  ? Column(children: listGames)
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
