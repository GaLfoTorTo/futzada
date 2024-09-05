import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class SelectDaysWeekWidget extends StatelessWidget {
  final String value;
  final bool checked;
  final Function action;
  const SelectDaysWeekWidget({
    super.key,
    required this.value,
    required this.checked,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => action(value),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: checked ? AppColors.green_300 : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (checked)
              BoxShadow(
                color: AppColors.green_300.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 1,
                offset: Offset(0,0),
              ),
          ],
        ),
        child: Text(
          value,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: checked ? AppColors.white : AppColors.dark_500,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}