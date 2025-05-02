import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class ButtonDropdownWidget extends StatelessWidget {
  final int selectedEvent;
  final List<Map<String, dynamic>> itens;
  final Function onChange;
  const ButtonDropdownWidget({
    super.key,
    required this.selectedEvent,
    required this.itens,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedEvent,
      onChanged: (int? newValue) => onChange(newValue),
      style: const TextStyle(
        color: AppColors.dark_500,
        fontSize: 10
      ),
      underline: Container(
        height: 0,
      ),
      dropdownColor: AppColors.white,
      items: itens.map<DropdownMenuItem<int>>((item) {
        return DropdownMenuItem<int>(
          value: item['id'],
          child: Row(
            children: [
              const ImgCircularWidget(
                width: 20, 
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  item['title'],
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}