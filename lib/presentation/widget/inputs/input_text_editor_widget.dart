import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:futzada/core/theme/app_colors.dart';

class InputTextEditorWidget extends StatelessWidget {
  final String name;
  final String label;
  final Color? bgColor;
  final QuillController textController;
  const InputTextEditorWidget({
    super.key,
    required this.name,
    required this.label,
    required this.textController,
    this.bgColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //CONTROLADORES DE FOCO E SCROLL
    final FocusNode focusNode = FocusNode();
    final ScrollController scrollController = ScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const Divider(),
        Container(
          width: dimensions.width,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: QuillSimpleToolbar(
            controller: textController,
            config: const QuillSimpleToolbarConfig(
              //OPÇÕES HABILITADAS
              showBoldButton: true,
              showItalicButton: true,
              showListBullets: true,
              showListNumbers: true,
              showAlignmentButtons: true,
              showJustifyAlignment: true,
              showLeftAlignment: true,
              showCenterAlignment: true,
              showRightAlignment: true,
              showClearFormat: true,
              //OPÇÕES DESABILITADAS
              showListCheck: false,
              showFontFamily: false,
              showFontSize: false,
              showUndo: false,
              showRedo: false,
              showCodeBlock: false,
              showQuote: false,
              showInlineCode: false,
              showLink: false,
              showHeaderStyle: false,
              showIndent: false,
              showStrikeThrough: false,
              showUnderLineButton: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showSubscript: false,
              showSuperscript: false,
              showDirection: false,
              showSearchButton: false,
              showClipboardCut: false,
              showClipboardCopy: false,
              showClipboardPaste: false,
            ),
          ),
        ),
        Container(
          width: dimensions.width,
          height: dimensions.height * 0.40,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(5),
            border: focusNode.hasFocus
              ? Border.all(color: AppColors.green_300, width: 1)
              : null,
          ),
          child: QuillEditor.basic(
            controller: textController,
            focusNode: focusNode,
            scrollController: scrollController,
            config: QuillEditorConfig(
              padding: const EdgeInsets.all(5),
              maxHeight: dimensions.height * 0.40
            ),
          ),
        ),
      ],
    );
  }
}