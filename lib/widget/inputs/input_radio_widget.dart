import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/cadastro_controller.dart';
import 'package:futzada/theme/app_colors.dart';

class InputRadioWidget extends StatefulWidget {
  final String name;
  final String value;
  final String icon;
  final String placeholder;
  final TextEditingController textController;
  final CadastroController controller;
  final Function onChanged;

  InputRadioWidget({
    super.key, 
    required this.name, 
    required this.value, 
    required this.icon, 
    required this.placeholder, 
    required this.textController, 
    required this.controller, 
    required this.onChanged
  });

  @override
  State<InputRadioWidget> createState() => _InputRadioWidgetState();
}

class _InputRadioWidgetState extends State<InputRadioWidget> {

  @override 
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.5,
            child: Radio(
              value: widget.value,
              groupValue: widget.textController.text,
              onChanged: (value) {
                widget.onChanged(value!);
              },
              activeColor: AppColors.green_300,
              fillColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.green_300;
                }
                return AppColors.gray_500;
              })
            ),
          ),
          Row(
            children: [
              SvgPicture.asset(
                widget.icon,
                width: 25,
                height: 25,
                color: widget.value == widget.textController.text ? AppColors.green_300 : AppColors.gray_500,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  widget.value,
                  style: TextStyle(
                    color: widget.value == widget.textController.text ? AppColors.green_300 : AppColors.gray_500,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                width: dimensions.width - 180,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    widget.placeholder,
                    style: const TextStyle(
                      color: AppColors.dark_500,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}