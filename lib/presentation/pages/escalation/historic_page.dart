import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';

class HistoricPage extends ConsumerWidget {
  const HistoricPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(escalationSessionProvider);

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Histórico',
        leftAction: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: session.escalations.map((entry) {
                return Container();
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
