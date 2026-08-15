import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/theme/app_colors.dart';

class BottomSheetEmblema extends StatelessWidget {
  final bool team;
  final String emblema;
  final void Function(String emblema) onSelected;

  const BottomSheetEmblema({
    super.key,
    required this.team,
    required this.emblema,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;
    List<String> emblemas = AppIcones.emblemas.values.toList();

    return Container(
      height: dimensions.height * 0.60,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const BackButton(),
              Padding(
                padding: const EdgeInsets.only(left: 100),
                child: Text(
                  'Emblemas',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              'Escolha um emblema para a equipe e personalize ainda mais a partida.',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey_500),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(color: AppColors.grey_300),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(emblemas.length, (key) {
                return InkWell(
                  onTap: () {
                    onSelected("emblema_${key + 1}");
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).brightness == Brightness.dark ? AppColors.dark_300 : AppColors.white,
                      boxShadow: [
                        if (emblema == emblemas[key]) ...[
                          BoxShadow(
                            color: AppColors.green_300.withAlpha(150),
                            spreadRadius: 8,
                            blurRadius: 1,
                            offset: const Offset(0, 0),
                          ),
                        ] else ...[
                          BoxShadow(
                            color: AppColors.dark_500.withAlpha(30),
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            offset: const Offset(2, 5),
                          ),
                        ],
                      ],
                    ),
                    child: SvgPicture.asset(
                      emblemas[key],
                      width: 80,
                      colorFilter: const ColorFilter.mode(AppColors.green_300, BlendMode.srcIn),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
