import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;

  const ExpandableTextWidget({
    super.key, 
    required this.text
  });

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  //CONTROLADORES DE EXPANÇÃO
  bool expanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {    
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300),
          maxLines: expanded ? null : 3,
          overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: () => setState(() => expanded = !expanded),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.white),
            padding: WidgetStatePropertyAll(EdgeInsets.all(5)),
          ),
          child: Text(
            expanded ? 'Ver menos' : 'Ver mais',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300),
          ),
        ),
      ],
    );
  }
}
