
import 'package:flutter/material.dart';

class UtilsColors {
  String value;

  UtilsColors({required this.value});

  toColor() {
    var hexColor = value.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    } else{
      return Colors.grey;
    }
  }
}

class Utils {
  static void showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(label: 'Undo', onPressed: scaffold.hideCurrentSnackBar),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}