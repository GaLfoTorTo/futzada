import 'package:flutter/material.dart';
import 'package:futzada/controllers/cadastro_controller.dart';
import 'package:futzada/theme/app_colors.dart';

class SelectRoundedWidget extends StatelessWidget {
  final String value;
  final IconData icon;
  final bool checked;
  final CadastroController controller;
  final Function onChanged;

  const SelectRoundedWidget({
    super.key,
    required this.value,
    required this.icon,
    required this.checked,
    required this.controller,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Column(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: checked == true ? AppColors.green_300 : AppColors.gray_300,
              borderRadius: BorderRadius.circular(80),
              boxShadow: [
                if (checked == true )
                  BoxShadow(
                    color: AppColors.green_300.withOpacity(0.2),
                    spreadRadius: 8,
                    blurRadius: 1,
                    offset: Offset(0,0),
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 100,
              ), 
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "${value}",
              style: TextStyle(
                color: checked == true ? AppColors.blue_500 : AppColors.gray_500,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}