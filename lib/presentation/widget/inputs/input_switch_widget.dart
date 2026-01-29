import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:get/get.dart';

class InputSwitchWidget extends StatefulWidget {
  final String name;
  final String label;
  final bool value;
  final IconData prefixIcon;
  final bool enable;
  final TextEditingController textController;
  final Function(bool)? onChanged;
  final String? Function(String?)? onValidated;

  const InputSwitchWidget({
    super.key,
    required this.name,
    required this.label,
    required this.value,
    required this.prefixIcon,
    required this.textController,
    this.enable = true,
    this.onChanged,
    this.onValidated,
  });

  @override
  State<InputSwitchWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputSwitchWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR PARAMETROS DO INPUT
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? AppColors.dark_300 : AppColors.white,
            borderRadius: BorderRadius.circular(5)
          ),
          child: SwitchListTile(
            value: widget.value,
            onChanged: widget.onChanged,
            activeThumbColor: AppColors.green_300,
            inactiveTrackColor: AppColors.grey_300,
            inactiveThumbColor: AppColors.grey_500,
            secondary: Icon(
              widget.prefixIcon,
              color: Get.isDarkMode ? AppColors.white : AppColors.grey_500,
              size: 25,
            ),
          ),
        ),
        Positioned(
          left: 20,
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ]
    );
  }
}