import 'package:flutter/cupertino.dart';
import 'package:pinterestmobile/core/app_colors.dart';
import 'package:pinterestmobile/core/app_text_style.dart';

showAlertDialog(
    BuildContext context, {
      String? buttonCancelTitle,
      String? content,
      void Function()? onCancelPressed,
      bool? barrierDismissible,
      required void Function() onConfirmPressed,
    }) => showCupertinoDialog<void>(
  context: context,
  barrierDismissible: barrierDismissible ?? true,
  builder: (BuildContext context) => CupertinoAlertDialog(
    title: Text(title, style: AppTextStyle.style700.copyWith(fontSize: 15)),
    content: content != null ? Text(content, style: AppTextStyle.style500.copyWith(fontSize: 13)) : null,
    actions: <CupertinoDialogAction>[
      CupertinoDialogAction(
        onPressed: () => onCancelPressed ?? Navigator.of(context).pop(),
        child: Text(buttonCancelTitle ?? "Cancel", style: AppTextStyle.style500.copyWith(fontSize: 14, color: AppColors.red)),
      ),
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: onConfirmPressed,
        child: Text(buttonConfirmTitle, style: AppTextStyle.style500.copyWith(fontSize: 14, color: AppColors.primary)), 
      ),
    ],
  ),
);
