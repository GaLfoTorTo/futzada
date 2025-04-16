import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';

class InputTextWidget extends StatefulWidget {
  final String name;
  final String? label;
  final String? hint;
  final IconData? sufixIcon;
  final IconData? prefixIcon;
  final String? placeholder;
  final Function? onChanged;
  final Function? onSaved;
  final TextInputType? type;
  final int? maxLength;
  final Function? validator;
  final Function? showModal;
  final dynamic controller;
  final TextEditingController textController;

  const InputTextWidget({
    super.key,
    required this.name, 
    this.label,
    this.hint,
    this.sufixIcon,
    this.prefixIcon,
    this.placeholder,
    this.onChanged,
    this.onSaved,
    this.type,
    this.maxLength,
    this.validator,
    this.showModal,
    required this.textController, 
    required this.controller, 
  });

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
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
    //INICIALIZR VISIBILIDADE DE SENHA CASO EXISTA
    obscure = widget.type != null && widget.type == TextInputType.visiblePassword;
    visible = widget.type != null && widget.type == TextInputType.visiblePassword;
    //INICIALIZAR ICONS
    sufixIcon = widget.sufixIcon != null
      ? Icon(widget.sufixIcon) 
      : null;
    prefixIcon = widget.prefixIcon != null 
      ? Icon(widget.prefixIcon) 
      : null;
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
        keyboardType: widget.type,
        textCapitalization: widget.maxLength != null ? TextCapitalization.characters : TextCapitalization.none,
        obscureText: visible,
        maxLength: widget.maxLength ?? widget.maxLength,
        style: Theme.of(context).textTheme.labelLarge,
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,
          prefixIcon: prefixIcon,
          suffixIcon: sufixIcon != null 
            ? IconButton(
              icon: sufixIcon!,
              onPressed: () => showText(),
            )
            : null
        ),
        onChanged: (value){
          if(widget.onChanged != null){
            widget.onChanged!(value);
          }
        },
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
          //FOCAR INPUT 
          FocusScope.of(context).autofocus(FocusNode());
          //RETURNAR RESULTADO DA VALIDAÇÃO
          return result;
        },
        onTap: () {
          if(widget.type == TextInputType.streetAddress){
            //ABRE BOTTOMSHEET DE PESQUISA DE ENDEREÇO 
            widget.showModal!();
            //REMOVER FOCO DO BOTÃO
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
      ),
    );
  }
}