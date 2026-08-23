import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/theme/app_images.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/presentation/pages/presentation_page.dart';

class EscalationLandingPage extends StatelessWidget {
  const EscalationLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PresentationPageWidget(
      image: AppImages.capaEscalacao,
      route: 'Escalação',
      titulo: 'Monte a sua equipe ideal',
      subTitulo: 'Escale os melhores jogadores da pelada para sua equipe e fique no topo dos rankings da pelada.',
      buttonFirstText: 'Escalação',
      buttonFirstIcon: AppIcones.clipboard_solid,
      buttonSecoundText: 'Estatísticas',
      buttonSecoundIcon: Icons.add_chart,
      buttonFirstAction: () => context.go('/escalation/team'),
      buttonSecoundAction: () => context.go('/escalation/statistics'),
    );
  }
}
