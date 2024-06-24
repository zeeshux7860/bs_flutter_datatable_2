import 'package:bs_flutter_datatable_2/bs_flutter_datatable.dart';

import 'package:flutter/material.dart';

enum BsPaginationButtons { firstPage, previous, button, input, next, lastPage }

class BsPaginationButton extends StatelessWidget {
  const BsPaginationButton({
    Key? key,
    this.disabled = false,
    this.active = false,
    this.onPressed,
    this.margin,
    this.style = const BsPaginationButtonStyle(),
    required this.label,
  }) : super(key: key);

  final VoidCallback? onPressed;

  final bool disabled;

  final bool active;

  final EdgeInsetsGeometry? margin;

  final String label;

  final BsPaginationButtonStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: style.borderRadius,
          child: Container(
            padding: style.padding,
            decoration: active ? style.activeDecoration : style.decoration,
            child: Text(label,
                style: TextStyle(fontSize: 12.0, color: disabled ? Colors.grey : Theme.of(context).textTheme.bodySmall!.color)
                    .merge(active ? style.textStyleActive : style.textStyle)),
          ),
        ),
      ),
    );
  }
}
