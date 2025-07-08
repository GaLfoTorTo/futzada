import 'package:flutter/material.dart';
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
  final TextInputType? type;
  final int? maxLength;
  final VoidCallback? suffixFunction;
  final bool disabled;
  final TextEditingController? textController;
  final Function(String)? onSaved;
  final Function(String)? onChanged;
  final String? Function(String?)? onValidated;

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
    this.type,
    this.maxLength,
    this.suffixFunction,
    this.textController,
    this.disabled = false,
    this.onSaved,
    this.onChanged,
    this.onValidated,
  });

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  late bool _visible;
  late Icon? _sufixIcon;
  late Icon? _prefixIcon;
  late Color _bgColor;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR PARAMETROS DO INPUT
    _focusNode = FocusNode();
    _visible = widget.type == TextInputType.visiblePassword;
    _sufixIcon = widget.sufixIcon != null ? Icon(widget.sufixIcon) : null;
    _prefixIcon = widget.prefixIcon != null ? Icon(widget.prefixIcon) : null;
    _bgColor = widget.disabled ? Colors.white60 : widget.bgColor ?? AppColors.white;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  //FUNÇÃO PARA EXIBIR TEXTO
  void _showText() {
    setState(() {
      _visible = !_visible;
      _sufixIcon = _visible 
        ? const Icon(Icons.visibility_off) 
        : const Icon(Icons.visibility);
    });
  }
  
  //FUNÇÃO DE CONSTRUÇÃO DE SUFIX ICON
  Widget? _buildSuffixIcon() {
    if (_sufixIcon == null){
      return null;
    } else{
      if(widget.suffixFunction != null){
        return IconButton(
          icon: _sufixIcon!,
          onPressed: () =>_showText(),
        );
      }
      return _sufixIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        style: Theme.of(context).textTheme.labelLarge,
        focusNode: _focusNode,
        initialValue: widget.initialValue,
        controller: widget.textController,
        keyboardType: widget.type,
        obscureText: _visible,
        maxLength: widget.maxLength,
        textCapitalization: widget.maxLength != null 
          ? TextCapitalization.characters 
          : TextCapitalization.none,
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,
          prefixIcon: _prefixIcon,
          fillColor: _bgColor,
          enabledBorder: OutlineInputBorder(
            borderSide: widget.borderColor == true 
              ? const BorderSide(color: AppColors.gray_300) 
              : BorderSide.none,
          ),
          suffixIcon: _buildSuffixIcon(),
        ),
        onChanged: (value) => widget.onChanged,
        onSaved: (value) => widget.onSaved,
        validator: widget.onValidated,
        readOnly: widget.disabled,
      ),
    );
  }
}