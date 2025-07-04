import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';

class InputTextWidget extends StatefulWidget {
  final String? name;
  final String? label;
  final String? hint;
  final String? initialValue;
  final IconData? sufixIcon;
  final IconData? prefixIcon;
  final Color? bgColor;
  final bool? borderColor;
  final String? placeholder;
  final Function? onChanged;
  final Function? onSaved;
  final TextInputType? type;
  final int? maxLength;
  final Function? validator;
  final Function? showModal;
  final Function? suffixFunction;
  final bool? disabled;
  final dynamic controller;
  final TextEditingController? textController;

  const InputTextWidget({
    super.key,
    this.name, 
    this.label,
    this.hint,
    this.initialValue,
    this.sufixIcon,
    this.prefixIcon,
    this.bgColor,
    this.borderColor = false,
    this.placeholder,
    this.onChanged,
    this.onSaved,
    this.type,
    this.maxLength,
    this.validator,
    this.showModal,
    this.suffixFunction,
    this.controller, 
    this.textController, 
    this.disabled = false,
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
  //DEFINIR COR DO INPUT
  Color bgColor = AppColors.white;

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
    //VERIFICAR SE INPUT ESTA DESABILITADO E AJUSTAR BG
    if(widget.disabled == true){
      bgColor = Colors.white60;
    }
    //VERIFICAR SE FOI DEFINIDA COR DE BG PARA INPUT
    if(widget.bgColor != null){
      bgColor = widget.bgColor!;
    }
  }

  //FUNÇÃO DE EXIBIÇÃO OU OCULTAÇÃO DE TEXTO NO INPUT
  void showText(){
    setState(() {
      visible = AppHelper.toggleVisibility(visible);
      sufixIcon = visible
       ? Icon(Icons.visibility_off) 
       : Icon(Icons.visibility);
    });
  }

  //FUNÇÃO DE DEFINIDÇÃO DE WIDGET DE SUFIXO DO INPUT
  Widget? setSuffix(){
    //VERIFICAR SE FOI DEFINIDO ICONE DE SUFIXO
    if(sufixIcon != null){
      //VERIFICAR SE FOI DEFINIDA FUNÇÃO DE SUFIXO
      if(widget.suffixFunction != null){
        return IconButton(
          icon: sufixIcon!,
          onPressed: (){
            //VERIFICAR SE FUNÇÃO DE SUFIXO FOI DEFINIDA
            if(widget.suffixFunction != null){
              showText();
            }
          }
        );
      }
      return sufixIcon;
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        //REMOVER FOCO DO INPUT AO CLICAR FORA OU FECHAR O TECLADO
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          initialValue: widget.initialValue,
          controller: widget.textController ?? null,
          keyboardType: widget.type,
          textCapitalization: widget.maxLength != null ? TextCapitalization.characters : TextCapitalization.none,
          obscureText: visible,
          maxLength: widget.maxLength ?? widget.maxLength,
          style: Theme.of(context).textTheme.labelLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            labelText: widget.label,
            prefixIcon: prefixIcon,
            fillColor: bgColor,
            enabledBorder: OutlineInputBorder(
              borderSide: widget.borderColor != null && widget.borderColor == true ? const BorderSide(color: AppColors.gray_300) : BorderSide.none,
            ),
            suffixIcon: setSuffix()
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
          readOnly: widget.disabled ?? true,
        ),
      ),
    );
  }
}