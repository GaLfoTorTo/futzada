import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/data/models/game_event_model.dart';
import 'package:futzada/data/models/team_model.dart';
import 'package:futzada/data/services/game_event_service.dart';
import 'package:futzada/core/providers/game/game_session_provider.dart';
import 'package:futzada/core/providers/game/game_match_provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class GameTimelinePage extends ConsumerWidget {
  const GameTimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(gameSessionProvider);
    final match = ref.watch(gameMatchProvider);
    final gameEventService = GameEventService();

    if (session.currentGame == null) {
      return const SizedBox.shrink();
    }

    final TeamModel teamA = session.currentGame!.teams!.first;
    final TeamModel teamB = session.currentGame!.teams!.last;

    Widget buildTimelineTile(GameEventModel event) {
      return TimelineTile(
        alignment: TimelineAlign.center,
        lineXY: 0.2,
        beforeLineStyle: const LineStyle(color: AppColors.grey_300, thickness: 1),
        afterLineStyle: const LineStyle(color: AppColors.grey_300, thickness: 1),
        indicatorStyle: IndicatorStyle(
          height: 30,
          width: 30,
          padding: const EdgeInsets.symmetric(vertical: 5),
          indicator: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.grey_300),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              "${event.minute}'",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: AppColors.grey_300),
            ),
          ),
        ),
        startChild: teamA.id == event.teamId
            ? ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2,
                    children: [
                      Expanded(
                        child: Text(
                          gameEventService.getActionGameEvent(event.type)['title'],
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Icon(
                        gameEventService.getActionGameEvent(event.type)['icon'],
                        size: 25,
                        color: event.type?.name == "YellowCard"
                            ? AppColors.yellow_300
                            : event.type?.name == "RedCard"
                                ? AppColors.red_300
                                : AppColors.grey_500,
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  event.description!,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              )
            : null,
        endChild: teamB.id == event.teamId
            ? ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2,
                    children: [
                      Icon(
                        gameEventService.getActionGameEvent(event.type)['icon'],
                        size: 25,
                        color: event.type?.name == "YellowCard"
                            ? AppColors.yellow_300
                            : event.type?.name == "RedCard"
                                ? AppColors.red_300
                                : AppColors.grey_500,
                      ),
                      Expanded(
                        child: Text(
                          gameEventService.getActionGameEvent(event.type)['title'],
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  event.description!,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              )
            : null,
      );
    }

    Widget buildTimeLineStartEnd(GameEventModel event) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.dark_500
              : AppColors.white,
          border: Border.all(color: AppColors.grey_300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            const Icon(Icons.timer_outlined, size: 25, color: AppColors.grey_300),
            Text(
              gameEventService.getActionGameEvent(event.type)['title'],
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.grey_300),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.dark_500
              : AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.dark_500.withAlpha(30),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: match.gameEvents.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text(
                      "A Timeline da partida será exibida assim que a partida for iniciada!",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const Icon(Icons.sports, size: 50),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: match.gameEvents.length,
                itemBuilder: (context, index) {
                  final event = match.gameEvents[index];
                  if (event.type?.name == 'StartGame' ||
                      event.type?.name == 'EndGame' ||
                      event.type?.name == 'HalfTimeStart' ||
                      event.type?.name == 'HalfTimeEnd' ||
                      event.type?.name == 'ExtraTime' ||
                      event.type?.name == 'ExtraTimeStart' ||
                      event.type?.name == 'ExtraTimeEnd') {
                    return buildTimeLineStartEnd(event);
                  }
                  return buildTimelineTile(event);
                },
              ),
      ),
    );
  }
}
