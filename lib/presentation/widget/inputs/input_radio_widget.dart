import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';

class InputRadioWidget extends StatefulWidget {
  final String name;
  final String label;
  final String value;
  final IconData? icon;
  final String placeholder;
  final TextEditingController textController;
  final Function onChanged;

  const InputRadioWidget({
    super.key, 
    required this.name, 
    required this.label, 
    required this.value, 
    this.icon, 
    required this.placeholder, 
    required this.textController, 
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
        spacing: 10,
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
              fillColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.green_300;
                }
                return AppColors.grey_500;
              })
            ),
          ),
          if(widget.icon != null)...[
            Icon(
              widget.icon, 
              color: widget.value == widget.textController.text ? AppColors.green_300 : AppColors.grey_500,
            ),
          ],
          Text(
            widget.label,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: widget.value == widget.textController.text ? AppColors.green_300 : AppColors.grey_500,
            ),
            textAlign: TextAlign.end,
          ),
          Expanded(
            child: Text(
              widget.placeholder,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.start,
          ),
        )
        ],
      ),
    );
  }
}