import 'package:flutter/material.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/core/theme/app_colors.dart';

class PlayerIndicatorWidget extends StatelessWidget {
  final String? title;
  final dynamic value;
  final IconData? iconLabel;
  final bool price;

  const PlayerIndicatorWidget({
    super.key,
    this.title,
    required this.value,
    this.iconLabel,
    this.price = false,
  });

  @override
  Widget build(BuildContext context) {
    print(title);
    //RESGATAR COR PARA INDICADOR
    var color = title != 'Status' ? AppHelper.setColorPontuation(value)['color'] : AppHelper.setStatusPlayer(value)['color'];
    //RESGATAR ICONE PARA INDICADOR
    var icon = title != 'Status' ? AppHelper.setColorPontuation(value)['icon'] : AppHelper.setStatusPlayer(value)['icon'];

    return Row(
      children: [
        if(iconLabel != null)...[
          Icon(
            iconLabel,
            size: 20,
            color: AppColors.dark_300,
          ),
        ],
        if(title != null)...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "${title}:",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.dark_300,
              ),
            ),
          ),
        ],
        if(price)...[
          const Text(
            "Fz\$",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: AppColors.grey_300,
            ),
          ),
        ],
        if(value != null && value is double)...[
          Text(
            "${value}",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
        Icon(
          icon,
          size: 20,
          color: color,
        )
      ],
    );
  }
}