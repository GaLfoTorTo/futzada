import 'package:flutter/material.dart';

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
    final textWidget = Text(
      widget.text,
      style: Theme.of(context).textTheme.bodySmall,
      maxLines: expanded ? null : 3,
      overflow: expanded ? TextOverflow.visible : TextOverflow.clip,
      textAlign: TextAlign.center,
    );

    return InkWell(
      onTap: () => setState(() => expanded = !expanded),
      child: expanded
        ? textWidget
        : ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
            },
            blendMode: BlendMode.dstIn,
            child: textWidget,
          ),
    );
  }
}
