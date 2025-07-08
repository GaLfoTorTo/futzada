import 'package:flutter/material.dart';

class InputDateWidget extends StatefulWidget {
  final String name;
  final String? label;
  final String? hint;
  final IconData? sufixIcon;
  final IconData? prefixIcon;
  final String? placeholder;
  final Function? onSaved;
  final int? maxLength;
  final Function showModal;
  final String? Function(String?)? onValidated;
  final TextEditingController textController;

  const InputDateWidget({
    super.key,
    required this.name, 
    this.label,
    this.hint,
    this.sufixIcon,
    this.prefixIcon,
    this.placeholder,
    this.onSaved,
    this.maxLength,
    this.onValidated,
    required this.showModal,
    required this.textController, 
  });

  @override
  State<InputDateWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputDateWidget> {
  //VARIAVEL PARA CONTROLAR EXIBIÇÃO ICONE NO FIM DO INPUT
  Icon? prefixIcon;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR SUFIXICON
    prefixIcon = widget.prefixIcon != null 
      ? Icon(widget.prefixIcon) 
      : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: widget.textController,
        keyboardType: TextInputType.datetime,
        style: Theme.of(context).textTheme.labelLarge,
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,
          prefixIcon: prefixIcon,
        ),
        onSaved: (value){
          if(widget.onSaved != null){
            widget.onSaved!({widget.name:  value});
          }
        },
        validator: widget.onValidated,
        onTap: () {
          FocusScope.of(context).unfocus();
          //REMOVE FOCU DO INPUT 
          FocusScope.of(context).unfocus();
          //ABRE BOTTOMSHEET DE PESQUISA DE ENDEREÇO 
          widget.showModal();
          //REMOVER FOCO DO BOTÃO
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
    );
  }
}