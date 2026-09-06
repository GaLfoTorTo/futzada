import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/presentation/widget/buttons/button_outline_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';

class ErroEscalationPage extends ConsumerWidget {
  const ErroEscalationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(escalationSessionProvider);

    final String titulo;
    final String mensagem;
    final List<Widget> acoes;

    if (!session.canManager) {
      titulo = 'Você não está habilitado como técnico';
      mensagem = 'Configure seu perfil de técnico para poder escalar jogadores nas peladas que você participa.';
      acoes = [
        ButtonOutlineWidget(
          text: "Configurar Técnico",
          width: MediaQuery.of(context).size.width,
          icon: AppIcones.cog_solid,
          action: () {},
        ),
      ];
    } else if (session.events.isEmpty) {
      titulo = 'Você não está participando de nenhuma pelada';
      mensagem = 'Entre em uma pelada para poder montar sua escalação.';
      acoes = [
        ButtonTextWidget(
          text: "Buscar Pelada",
          width: MediaQuery.of(context).size.width,
          icon: Icons.sports,
          iconSize: 40,
          action: () => context.push('/explore/map'),
        ),
      ];
    } else {
      titulo = 'Algo deu errado';
      mensagem = 'Não foi possível carregar sua escalação. Tente novamente.';
      acoes = [
        ButtonTextWidget(
          text: "Tentar novamente",
          width: MediaQuery.of(context).size.width,
          icon: Icons.refresh,
          action: () => context.pop(),
        ),
      ];
    }

    final dimensions = MediaQuery.of(context).size;
    final backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark_500
        : AppColors.white;

    return Container(
      width: dimensions.width,
      height: dimensions.height * 0.90,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundColor.withAlpha(50), backgroundColor],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(titulo, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          const Icon(Icons.error_outline, size: 150),
          Text(mensagem, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          Column(spacing: 10, children: acoes),
        ],
      ),
    );
  }
}