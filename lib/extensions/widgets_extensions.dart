import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget wrapInkWell({
    required GestureTapCallback onTap,
    bool wrap = true,
  }) {
    if (!wrap) return this;

    return InkWell(
      onTap: onTap,
      child: this,
    );
  }

  Widget wrapSizedBox({
    bool wrap = true,
    double? width,
    double? height,
  }) {
    if (!wrap) {
      return this;
    }
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  Widget wrapPadding({
    double? left,
    double? right,
    double? top,
    double? bottom,
    double? all,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: all ?? bottom ?? 0,
        top: all ?? top ?? 0,
        right: all ?? right ?? 0,
        left: all ?? left ?? 0,
      ),
      child: this,
    );
  }

  Widget wrapCard({Color? color, String? key}) {
    return Card(
      key: key != null ? Key(key) : null,
      color: color,
      child: this,
    );
  }

  Widget wrapExpanded({bool wrap = true}) {
    if (!wrap) return this;
    return Expanded(child: this);
  }

  Widget wrapTooltip({String? message}) => Tooltip(
        message: message,
        child: this,
      );

  Future<T?> showInPopup<T>(BuildContext context, {String? title}) {
    return showDialog<T>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Dialog(child: this),
    );
  }
}

extension ArrayExtension on List<Widget> {
  Widget row({
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
  }) =>
      Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisSize: mainAxisSize ?? MainAxisSize.max,
        children: this,
      );

  Widget column({
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
  }) =>
      Column(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisSize: mainAxisSize ?? MainAxisSize.max,
        children: this,
      );

  Widget stack() => Stack(children: this);

  Widget wrap({
    WrapCrossAlignment? crossAxisAlignment,
    double? spacing,
    double? runSpacing,
  }) =>
      Wrap(
        runSpacing: runSpacing ?? 0,
        spacing: spacing ?? 0,
        crossAxisAlignment: crossAxisAlignment ?? WrapCrossAlignment.start,
        children: this,
      );
}
