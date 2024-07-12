import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';

class InputTextWidget extends StatefulWidget {
  final String name;
  final String label;
  final String? icon;
  final String? placeholder;
  final TextEditingController textController;
  final dynamic controller;
  final Function? onSaved;
  final TextInputType? type;
  final Function? validator;
  final int? maxLength;

  const InputTextWidget({
    super.key,
    required this.name, 
    required this.label,
    this.icon,
    this.placeholder,
    required this.textController, 
    required this.controller, 
    this.onSaved,
    this.type,
    this.validator,
    this.maxLength,
  });

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  //VARIAVEL DE EXIBIÇÃO DE SENHA
  bool visible = false;
  //VARIAVEL DE EXIBIÇÃO DE BOTÃO DE VISIBILIDADE DE SENHA
  bool obscure = false;
  //VARIAVEL PARA EXIBIÇÃO DE LABEL OU PLACEHOLDER
  bool hint = false;

  @override
  void initState() {
    super.initState();
    //INICIALIZR VISIBILIDADE DE SENHA CASO EXISTA
    obscure = widget.type != null && widget.type == TextInputType.visiblePassword;
    visible = widget.type != null && widget.type == TextInputType.visiblePassword;
    //VARIAVEL DE EXIBIÇÃO DE PLACEHOLDER
    hint = widget.name == 'user' || widget.name == 'password' ? true : false;
  }

  //ALTERAR A EXIBIÇÃO DE SENHA
  void toggleVisibility() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        key: GlobalKey(),
        controller: widget.textController,
        keyboardType: widget.type,
        textCapitalization: widget.maxLength != null ? TextCapitalization.characters : TextCapitalization.none,
        obscureText: visible,
        maxLength: widget.maxLength ?? widget.maxLength,
        style: const TextStyle(
          color: AppColors.dark_300,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.green_300),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: hint ? widget.label : null,
          hintStyle: const TextStyle(
            color: AppColors.gray_500,
            fontSize: 15,
          ),
          labelText: !hint ? widget.label : null,
          labelStyle: const TextStyle(
            color: AppColors.gray_500,
            fontSize: 15,
          ),
          floatingLabelStyle: const TextStyle(
            color: AppColors.dark_500,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          prefixIcon: widget.icon != null
          ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: SvgPicture.asset(
              widget.icon!,
              width: 25,
              height: 25,
              color: AppColors.gray_700,
            ),
          )
          : null,
          suffixIcon: obscure 
          ? IconButton(
              icon: Icon(
                visible ? Icons.visibility_off : Icons.visibility,
                color: AppColors.gray_300,
              ),
              onPressed: () => toggleVisibility() 
            )
          : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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