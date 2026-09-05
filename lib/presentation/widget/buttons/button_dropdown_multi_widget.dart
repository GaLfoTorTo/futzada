import 'package:flutter/material.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_size.dart';
import 'package:esportly/presentation/widget/images/img_circle_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ButtonDropdownMultiWidget extends StatefulWidget {
  final List<dynamic> selectedItems;
  final List<dynamic> items;
  final Function(String) onChanged;
  final double? width;
  final double? height;
  final double? menuWidth;
  final double? textSize;
  final Color? textColor;
  final Color? color;
  final Color? borderColor;
  final bool showIcon;
  final double? iconSize;
  final String alignment;

  const ButtonDropdownMultiWidget({
    super.key,
    required this.selectedItems,
    required this.items,
    required this.onChanged,
    this.width = 150,
    this.height = 50,
    this.menuWidth = 170,
    this.textSize = AppSize.fontXs,
    this.textColor = AppColors.dark_500,
    this.color = AppColors.white,
    this.borderColor,
    this.showIcon = true,
    this.iconSize = 20,
    this.alignment = 'center',
  });

  @override
  State<ButtonDropdownMultiWidget> createState() => _ButtonDropdownMultiWidgetState();
}

class _ButtonDropdownMultiWidgetState extends State<ButtonDropdownMultiWidget> {
  bool _isMenuOpen = false;
  late List<dynamic> _localSelected;

  @override
  void initState() {
    super.initState();
    _localSelected = List.from(widget.selectedItems);
  }

  @override
  void didUpdateWidget(ButtonDropdownMultiWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isMenuOpen) {
      _localSelected = List.from(widget.selectedItems);
    }
  }

  void _toggle(String id, StateSetter menuSetState) {
    menuSetState(() {
      if (_localSelected.contains(id)) {
        _localSelected.remove(id);
      } else {
        _localSelected.add(id);
      }
    });
    widget.onChanged(id);
  }

  Map<String, dynamic>? get _firstSelectedItem {
    if (_localSelected.isEmpty) return null;
    try {
      return widget.items.firstWhere((item) => item['id'] == _localSelected[0]) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hint = _firstSelectedItem;

    return Container(
      width: widget.width,
      height: widget.height,
      alignment: widget.alignment == 'center' ? Alignment.center : null,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor ?? Colors.transparent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton2<String>(
        isExpanded: true,
        value: null,
        onChanged: (_) {},
        customButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              hint != null ? hint['title'] as String : 'Status',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: widget.textSize),
            ),
            if (hint != null && widget.showIcon && hint['icon'] != null)
              Icon(hint['icon'] as IconData, color: hint['color'] as Color?, size: widget.iconSize),
          ],
        ),
        onMenuStateChange: (isOpen) => setState(() => _isMenuOpen = isOpen),
        dropdownStyleData: DropdownStyleData(
          width: widget.menuWidth ?? widget.width,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
        ),
        iconStyleData: const IconStyleData(icon: SizedBox.shrink(), iconSize: 0),
        alignment: widget.alignment != 'center' ? Alignment.centerLeft : Alignment.center,
        underline: const SizedBox.shrink(),
        items: widget.items.map<DropdownMenuItem<String>>((rawItem) {
          final item = rawItem as Map<String, dynamic>;
          final id = item['id'] as String;
          final title = item['title'] as String;

          return DropdownMenuItem<String>(
            value: id,
            child: StatefulBuilder(
              builder: (context, menuSetState) {
                final isSelected = _localSelected.contains(id);
                return InkWell(
                  onTap: () => _toggle(id, menuSetState),
                  child: Row(
                    children: [
                      IgnorePointer(
                        child: Checkbox(
                          value: isSelected,
                          onChanged: null,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                            fontSize: widget.textSize,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      if (item.containsKey('photo'))
                        ImgCircularWidget(size: widget.iconSize!, image: item['photo'])
                      else if (item.containsKey('icon') && item['icon'] != null)
                        Icon(item['icon'] as IconData, color: item['color'] as Color?, size: widget.iconSize),
                    ],
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
