import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/presentation/controllers/showcase_controller.dart';
import 'package:esportly/presentation/widget/showcase/wizard_widget.dart';
import 'package:esportly/presentation/pages/escalation/error/erro_escalation_page.dart';
import 'package:esportly/presentation/widget/buttons/float_button_escalation_widget.dart';
import 'package:esportly/presentation/widget/indicators/indicator_loading_widget.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';
import 'package:esportly/presentation/widget/text/price_indicator_widget.dart';
import 'package:esportly/presentation/widget/lists/escalation_list_widget.dart';
import 'package:esportly/presentation/widget/others/escalation_widget.dart';
import 'package:esportly/presentation/widget/others/reserve_bank_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_icon_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_dropdown_icon_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_formation_widget.dart';

class EscalationPage extends ConsumerStatefulWidget {
  const EscalationPage({super.key});

  @override
  ConsumerState<EscalationPage> createState() => EscalationPageState();
}

class EscalationPageState extends ConsumerState<EscalationPage> {
  ShowcaseController showcaseController = ShowcaseController.instance;
  String viewType = 'escalation';
  late UserModel user;
  List<EventModel> events = [];
  bool showCap = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      user = sl<UserModel>(instanceName: 'user');
      events = sl<List<EventModel>>(instanceName: 'events');
      ref.read(escalationSessionProvider.notifier).init(events, user);
    });
    showcaseController.addListener(_onShowcaseUpdate);
  }

  @override
  void dispose() {
    showcaseController.removeListener(_onShowcaseUpdate);
    super.dispose();
  }

  //FUNÇÃO DE EXIBIÇÃO DE PAGINA NO SHOWCASE
  void _onShowcaseUpdate() => setState(() {});

  //FUNÇÃO DE SELEÇÃO DE EVENTO
  void selectEvent(id) => ref.read(escalationSessionProvider.notifier).setEvent(id);

  //FUNÇÃO DE SELEÇÃO DE VISUALIZAÇÃO
  void selectView(type) => setState(() => viewType = type);

  //FUNÇÃO DE SELEÇÃO DE FORMAÇÃO DA EQUIPE
  void selectFormation(newValue) => ref.read(escalationSessionProvider.notifier).setFormation(newValue);

  @override
  Widget build(BuildContext context) {
    //RESGATAR INICIALIZAÇÃO DE PROVIDER DE ESCALAÇÃO
    final managerSession = ref.watch(escalationSessionProvider);
    //ESTADOS - ESTILIZAÇÃO
    final dimensions = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.dark_300 : AppColors.white;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Escalação',
        leftAction: () => context.pop(),
        rightAction: events.isNotEmpty ? () => context.push('/escalation/market') : null,
        rightIcon: events.isNotEmpty ? Icons.shopping_cart : null,
        extraAction: events.isNotEmpty ? () => context.push('/escalation/historic') : null,
        extraIcon: events.isNotEmpty ? Icons.history : null,
        shadow: false,
      ),
      body: SafeArea(
        child: Builder(builder: (_) {
          if (managerSession.isLoading) {
            return const Center(child: IndicatorLoadingWidget());
          }
          if (managerSession.hasError) {
            return const ErroEscalationPage();
          }
          
          return SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                Container(
                  width: dimensions.width,
                  height: 70,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.dark_500 : AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dark_500.withAlpha(30),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: const Offset(2, 5),
                      ),
                    ],
                  ),
                  child: managerSession.isReady
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: dimensions.width * 0.25,
                          child: ButtonDropdownIconWidget<EventModel>(
                            selectedItem: managerSession.event!,
                            items: events,
                            onChange: selectEvent,
                            labelBuilder: (e) => e.title ?? '',
                            iconAfter: false,
                            backgroundColor: isDark ? AppColors.dark_300 : AppColors.white,
                          ),
                        ),
                        SizedBox(
                          width: dimensions.width * 0.22,
                          child: PriceIndicatorWidget(
                            title: 'Preço da Equipe',
                            value: '${managerSession.price}',
                          ),
                        ),
                        SizedBox(
                          width: dimensions.width * 0.22,
                          child: Row(
                            children: [
                              PriceIndicatorWidget(
                                value: '${managerSession.patrimony}',
                                title: 'FutCoins',
                              ),
                              if (managerSession.valuation != 0.0) ...[
                                Icon(
                                  AppHelper.setColorPontuation(managerSession.valuation)['icon'],
                                  size: 20,
                                  color: AppHelper.setColorPontuation(managerSession.valuation)['color'],
                                ),
                              ]
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
                ),
                Container(
                  width: dimensions.width,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: (dimensions.width / 2) - 10,
                        child: ButtonFormationWidget(
                          selectedFormation: managerSession.formation,
                          formations: managerSession.formations,
                          onChange: selectFormation,
                        ),
                      ),
                      SizedBox(
                        width: (dimensions.width / 2) - 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10,
                          children: [
                            WizardWidget(
                              elementKey: 'escalation',
                              child: ButtonIconWidget(
                                padding: 20,
                                iconSize: 20,
                                icon: AppIcones.escalacao_outline,
                                iconColor: viewType == 'escalation'
                                    ? AppColors.blue_500
                                    : AppColors.grey_500,
                                backgroundColor:
                                    viewType == 'escalation' ? AppColors.green_300 : color,
                                action: () => selectView('escalation'),
                              ),
                            ),
                            ButtonIconWidget(
                              padding: 20,
                              iconSize: 20,
                              icon: AppIcones.clipboard_outline,
                              iconColor: viewType == 'list' ? AppColors.blue_500 : AppColors.grey_500,
                              backgroundColor: viewType == 'list' ? AppColors.green_300 : color,
                              action: () => selectView('list'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (viewType == 'escalation') ...[
                  EscalationWidget(
                    width: dimensions.width - 80,
                    height: (dimensions.height / 2) + 50,
                    category: managerSession.category,
                    formation: managerSession.formation,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Reservas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ReserveBankWidget(category: managerSession.category),
                ] else ...[
                  const EscalationListWidget(title: 'Titulares', occupation: 'starters'),
                  const SizedBox(height: 20),
                  const EscalationListWidget(title: 'Reservas', occupation: 'reserves'),
                ],
              ],
            ),
          );
        }),
      ),
      floatingActionButton: const FloatButtonEscalationWidget(),
    );
  }
}
