import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/presentation/pages/presentation_page.dart';

class EventLandingPage extends StatelessWidget {
  const EventLandingPage({super.key});

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
