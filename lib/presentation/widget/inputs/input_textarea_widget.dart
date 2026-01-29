import 'package:flutter/material.dart';

class InputTextAreaWidget extends StatelessWidget {
  final String name;
  final String? label;
  final String? hint;
  final String? placeholder;
  final Function? onSaved;
  final String? Function(String?)? onValidated;
  final TextEditingController textController;

  const InputTextAreaWidget({
    super.key,
    required this.name, 
    this.label,
    this.hint,
    this.placeholder,
    this.onSaved,
    this.onValidated,
    required this.textController, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: textController,
        keyboardType: TextInputType.text,
        minLines: 5,
        maxLines: null,
        maxLength: null,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
        ),
        onSaved: (value){
          if(onSaved != null){
            onSaved!({name:  value});
          }
        },
        validator: onValidated,
      ),
    );
  }
}