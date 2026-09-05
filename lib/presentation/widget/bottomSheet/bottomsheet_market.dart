import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/enum/enums.dart';
import 'package:esportly/core/theme/app_size.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/core/providers/escalation/escalation_market_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/presentation/widget/badges/position_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';
import 'package:esportly/presentation/widget/inputs/select_rounded_widget.dart';

const _positionsByModality = {
  Modality.Football: ['GOL', 'ZAG', 'LAT', 'MEI', 'ATA'],
  Modality.Basketball: ['ARM', 'ALA', 'ALM', 'ALP', 'PIV'],
  Modality.Volleyball: ['LEV', 'OPO', 'CEN', 'PON', 'LIB', 'ARM', 'ALA'],
};

class BottomSheetMarket extends ConsumerWidget {
  const BottomSheetMarket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dimensions = MediaQuery.of(context).size;
    final market = ref.watch(escalationMarketProvider);
    final session = ref.watch(escalationSessionProvider);
    final modality = session.event?.modality;
    final positions = _positionsByModality[modality] ?? _positionsByModality[Modality.Football]!;
    final selectedPositions = List<String>.from(market.filtrosMarket['positions'] as List);
    final isFootball = modality == Modality.Football;
    final primary = Theme.of(context).primaryColor;

    void selectFilter(String name, dynamic newValue) {
      final notifier = ref.read(escalationMarketProvider.notifier);
      notifier.setFilter(name, newValue);
      final event = ref.read(escalationSessionProvider).event;
      notifier.updatePlayersFiltered(notifier.filterMarketPlayers(event!));
    }

    // Grupos de métricas: cada item tem label + as opções (excluindo o id='')
    final List<Map<String, dynamic>> metricGroups = [
      {
        'name': 'price',
        'label': 'Preço',
        'selected': market.filtrosMarket['price'],
        'options': (market.filterOptions['price'] as List).where((o) => o['id'] != '').toList(),
      },
      {
        'name': 'media',
        'label': 'Média',
        'selected': market.filtrosMarket['media'],
        'options': (market.filterOptions['media'] as List).where((o) => o['id'] != '').toList(),
      },
      {
        'name': 'games',
        'label': 'Jogos',
        'selected': market.filtrosMarket['game'],
        'options': (market.filterOptions['games'] as List).where((o) => o['id'] != '').toList(),
      },
      {
        'name': 'lastPontuation',
        'label': 'Pontuação',
        'selected': market.filtrosMarket['lastPontuation'],
        'options': (market.filterOptions['lastPontuation'] as List).where((o) => o['id'] != '').toList(),
      },
      {
        'name': 'valorization',
        'label': 'Valorização',
        'selected': market.filtrosMarket['valorization'],
        'options': (market.filterOptions['valorization'] as List).where((o) => o['id'] != '').toList(),
      },
      {
        'name': 'nome',
        'label': 'Ordenar',
        'selected': market.filtrosMarket['nome'],
        'options': (market.filterPlayerOptions['nome'] as List).where((o) => o['id'] != '').toList(),
      },
    ];

    final statusOptions = market.filterOptions['status'] as List<dynamic>;
    final selectedStatus = List<String>.from(market.filtrosMarket['status'] as List);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center( 
            child: Text(
              'Filtros', 
              style: Theme.of(context).textTheme.headlineLarge
            )
          ),
          ...metricGroups.map((group) {
            final selectedId = group['selected'] as String;
            final options = group['options'] as List;
            
            return Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group['label'] as String,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: options.map<Widget>((opt) {
                    final id = opt['id'] as String;
                    final title = opt['title'] as String;
                    final icon = opt['icon'] as IconData?;
                    final color = opt['color'] as Color?;
                    final isSelected = selectedId == id;
                    return _OptionChip(
                      label: title,
                      width: dimensions.width * 0.45,
                      icon: icon,
                      iconColor: color,
                      isSelected: isSelected,
                      primaryColor: primary,
                      onTap: () => selectFilter(
                        group['name'] as String,
                        isSelected ? '' : id,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
          const Divider(),
          Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: statusOptions.map<Widget>((opt) {
                  final id = opt['id'] as String;
                  final title = opt['title'] as String;
                  final icon = opt['icon'] as IconData?;
                  final color = opt['color'] as Color?;
                  final isSelected = selectedStatus.contains(id);
                  return _OptionChip(
                    label: title,
                    width: dimensions.width * 0.22,
                    icon: icon,
                    iconColor: color,
                    isSelected: isSelected,
                    primaryColor: primary,
                    onTap: () => selectFilter('status', id),
                  );
                }).toList(),
              ),
            ],
          ),
          const Divider(),
          Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Posições',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: positions.map((alias) {
                  final isSelected = selectedPositions.contains(alias);
                  return GestureDetector(
                    onTap: () => selectFilter('positions', alias),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: PositionWidget(
                        position: alias,
                        mainPosition: false,
                        width: 44,
                        height: 32,
                        textSide: AppSize.fontSm,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ]
          ),
          if (isFootball) ...[
            const Divider(),
            Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Posições',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectRoundedWidget(
                      size: 90,
                      iconSize: 55,
                      label: 'Esquerda',
                      value: 'Esquerda',
                      icon: AppIcones.foot_left_solid,
                      checked: market.filtrosMarket['bestSide'] == 'Esquerda',
                      onChanged: (v) => selectFilter('bestSide', v),
                    ),
                    SelectRoundedWidget(
                      size: 90,
                      iconSize: 55,
                      label: 'Direita',
                      value: 'Direita',
                      icon: AppIcones.foot_right_solid,
                      checked: market.filtrosMarket['bestSide'] == 'Direita',
                      onChanged: (v) => selectFilter('bestSide', v),
                    ),
                  ],
                ),
              ]
            )
          ],
          const Divider(),
          Row(
            children: [
              Expanded(
                child: ButtonTextWidget(
                  text: 'Limpar',
                  width: dimensions.width * 0.4,
                  height: 30,
                  backgroundColor: AppColors.red_300,
                  textColor: AppColors.white,
                  action: () {
                    final notifier = ref.read(escalationMarketProvider.notifier);
                    notifier.resetFilter();
                    final event = ref.read(escalationSessionProvider).event;
                    notifier.updatePlayersFiltered(notifier.filterMarketPlayers(event!));
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ButtonTextWidget(
                  text: 'Aplicar',
                  width: dimensions.width * 0.4,
                  height: 30,
                  backgroundColor: primary,
                  textColor: AppColors.blue_500,
                  action: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final double width;
  final IconData? icon;
  final Color? iconColor;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _OptionChip({
    required this.label,
    required this.width,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isSelected ? primaryColor : AppColors.grey_300;
    final bgColor = isSelected
        ? primaryColor.withAlpha(20)
        : (isDark ? AppColors.dark_300 : AppColors.white);
    final textColor = isSelected
        ? primaryColor
        : Theme.of(context).textTheme.bodySmall!.color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: width,
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSize.fontSm, color: isSelected ? primaryColor : iconColor),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
