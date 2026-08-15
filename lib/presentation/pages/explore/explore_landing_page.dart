import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/presentation/pages/presentation_page.dart';

class ExploreLandingPage extends StatelessWidget {
  const ExploreLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PresentationPageWidget(
      image: AppImages.capaExplore,
      route: 'Explore',
      titulo: 'Encontre a pelada certa para você',
      subTitulo: 'Buscando por uma pelada? Encontre peladas próximas de você ou explore os eventos que ocorrem em sua redondeza.',
      buttonFirstText: 'Ver no Mapa',
      buttonFirstIcon: Icons.map_rounded,
      buttonSecoundText: 'Pesquisar',
      buttonSecoundIcon: Icons.manage_search_rounded,
      buttonFirstAction: () => context.go('/explore/map'),
      buttonSecoundAction: () => context.go('/explore/search'),
    );
  }
}
