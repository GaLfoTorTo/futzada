import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';

class InputTextAreaWidget extends StatefulWidget {
  final String name;
  final String? label;
  final String? hint;
  final String? placeholder;
  final Function? onSaved;
  final Function? validator;
  final dynamic controller;
  final TextEditingController textController;

  const InputTextAreaWidget({
    super.key,
    required this.name, 
    this.label,
    this.hint,
    this.placeholder,
    this.onSaved,
    this.validator,
    required this.textController, 
    required this.controller, 
  });

  @override
  State<InputTextAreaWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextAreaWidget> {
  //VARIAVEL DE EXIBIÇÃO DE SENHA
  bool visible = false;
  //VARIAVEL DE EXIBIÇÃO DE BOTÃO DE VISIBILIDADE DE SENHA
  bool obscure = false;
  //VARIAVEL PARA CONTROLAR EXIBIÇÃO ICONE NO FIM DO INPUT
  Icon? sufixIcon;
  //VARIAVEL PARA CONTROLAR EXIBIÇÃO ICONE NO FIM DO INPUT
  Icon? prefixIcon;

  @override
  void initState() {
    super.initState();
  }

  void showText(){
    setState(() {
      visible = AppHelper.toggleVisibility(visible);
      sufixIcon = visible
       ? Icon(Icons.visibility_off) 
       : Icon(Icons.visibility);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: widget.textController,
        keyboardType: TextInputType.text,
        obscureText: visible,
        minLines: 3,
        maxLines: null,
        maxLength: null,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,

        ),
        onSaved: (value){
          if(widget.onSaved != null){
            widget.onSaved!({widget.name:  value});
          }
        },
        validator: (value) {
          //DEFINIR VARIAVEL DE RESULTADO DA VALIDAÇÃO
          String? result;
          //VERIFICAR SE SERÁ USADA FUNÇÃO PERSOLNIZADA DE VALIDAÇÃO
          if(widget.validator != null){
            result = widget.validator!();
          }else{
            result = widget.controller.validateEmpty(value, widget.label);
          }
          //RETURNAR RESULTADO DA VALIDAÇÃO
          return result;
        }
      ),
    );
  }
}