import 'package:flutter/material.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';

class SectionCategoriesWidget extends StatefulWidget {
  const SectionCategoriesWidget({super.key});

  @override
  State<SectionCategoriesWidget> createState() => _SectionCategoriesWidgetState();
}

class _SectionCategoriesWidgetState extends State<SectionCategoriesWidget> {
  final List<Map<String, dynamic>> categories = [
    {'category': 'Todos',        'icon': AppIcones.modality_solid,      'active': true,  'color': AppColors.green_500},
    {'category': 'Futebol',      'icon': AppIcones.futebol_ball_solid,  'active': false, 'color': AppColors.green_500},
    {'category': 'Fut7',         'icon': AppIcones.futebol_ball_solid,  'active': false, 'color': AppColors.green_300},
    {'category': 'Futsal',       'icon': Icons.sports_soccer,           'active': false, 'color': AppColors.blue_300},
    {'category': 'Volei',        'icon': AppIcones.volei_ball_solid,    'active': false, 'color': AppColors.yellow_300},
    {'category': 'Volei de praia','icon': Icons.sports_volleyball,      'active': false, 'color': AppColors.bege_500},
    {'category': 'Fut Volei',    'icon': AppIcones.volei_ball_solid,    'active': false, 'color': AppColors.bege_500},
    {'category': 'Basquete',     'icon': AppIcones.basquete_ball_solid, 'active': false, 'color': AppColors.orange_500},
    {'category': 'Streetball',   'icon': Icons.sports_basketball,       'active': false, 'color': AppColors.dark_300},
  ];

  void alterActive(String category) {
    setState(() {
      for (var item in categories) {
        item['active'] = item['category'] == category;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.dark_300 : AppColors.white;
    final textColor = isDark ? AppColors.white : AppColors.dark_300;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.only(top: 10.0),
        height: 120,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 10,
            children: categories.map((item) {
              String category = item['category'];
              bool active = item['active'];
              return Column(
                children: [
                  ButtonTextWidget(
                    action: () => alterActive(category),
                    width: 60,
                    height: 50,
                    icon: item['icon'],
                    iconSize: 30,
                    backgroundColor: active ? Theme.of(context).primaryColor : color,
                    textColor: active ? AppColors.blue_500 : textColor,
                    borderRadius: 15,
                    shadow: true,
                  ),
                  Container(
                    width: 60,
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      category,
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
