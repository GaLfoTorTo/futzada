import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/providers/event/event_session_provider.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/theme/app_images.dart';
import 'package:esportly/presentation/pages/presentation_page.dart';

class EventLandingPage extends ConsumerStatefulWidget {
  const EventLandingPage({super.key});
  
  @override
  ConsumerState<EventLandingPage> createState() => EscalationListPageState();
}

class EscalationListPageState extends ConsumerState<EventLandingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = sl<UserModel>(instanceName: 'user');
      final events = sl<List<EventModel>>(instanceName: 'events');
      ref.read(eventSessionProvider.notifier).init(events, user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PresentationPageWidget(
      image: AppImages.capaEvent,
      route: 'Peladas',
      titulo: 'Nunca foi tão fácil organizar suas peladas',
      subTitulo: 'Sua pelada agora está na palma das suas mãos! Organize e gerencie suas peladas de forma simples e colaborativa.',
      buttonFirstText: 'Criar nova pelada',
      buttonFirstIcon: Icons.add_circle_rounded,
      buttonSecoundText: 'Minhas peladas',
      buttonSecoundIcon: Icons.list_rounded,
      buttonFirstAction: () => context.go('/event/register/basic'),
      buttonSecoundAction: () => context.go('/event/list'),
    );
  }
}
