import 'package:flutter/material.dart';

class FormHelper {
  //FUNÇÃO PARA PICKER DE HORAS
  static Future<String?> selectTime(BuildContext context, name) async {
    final TimeOfDay? timeSelected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
          ),
          child: child!,
        );
      },
    );
    return timeSelected?.format(context);
  }
}