import 'package:esportly/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/presentation/pages/escalation/error/erro_escalation_page.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';
import 'package:esportly/presentation/widget/cards/card_escalation_event_widget.dart';
import 'package:esportly/presentation/widget/indicators/indicator_loading_widget.dart';

class EscalationListPage extends ConsumerStatefulWidget {
  const EscalationListPage({super.key});
  
  @override
  ConsumerState<EscalationListPage> createState() => EscalationListPageState();
}

class EscalationListPageState extends ConsumerState<EscalationListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = sl<UserModel>(instanceName: 'user');
      final events = sl<List<EventModel>>(instanceName: 'events');
      ref.read(escalationSessionProvider.notifier).init(events, user);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR INICIALIZAÇÃO DE PROVIDER DE ESCALAÇÃO
    final managerSession = ref.watch(escalationSessionProvider);

    return Scaffold(
      appBar: HeaderWidget(
        title: "Minhas Peladas",
        leftAction: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Builder(builder: (_) {
            if (managerSession.isLoading) {
              return const Center(child: IndicatorLoadingWidget());
            }
            if (managerSession.hasError) {
              return const ErroEscalationPage();
            }
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: managerSession.events.map((event) {
                  return InkWell(
                    onTap: () async {
                      //DEFINIR EVENTO ATUAL NO PROVIDER E NAVEGAR
                      await ref.read(escalationSessionProvider.notifier).setEvent(event);
                      context.go('/escalation/team');
                    },
                    child: CardEscalationEventWidget(event: event)
                  );
                }).toList()),
            );
            }
          ),
        ),
      ),
    );
  }
}
