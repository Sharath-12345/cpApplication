import 'package:flutter/material.dart';
import 'package:get/get.dart';


snackBarMsg(String title,
    {String? message,
    bool snackPostionTop = false,
    bool enableMsgBtn = false,
    String btnMsg = 'Undo',
    int animationDuration = 1,
    VoidCallback? onTap}) {
  Get.snackbar(title, message ?? '',
      colorText: Colors.white,
      backgroundColor: Color(0xffBDA1EF),
      margin: const EdgeInsets.all(10),
      duration: Duration(seconds: animationDuration),
      mainButton: enableMsgBtn
          ? TextButton(
              onPressed: onTap,
              child: Text(
                btnMsg,
              //  style: Get.theme.kSubTitle.copyWith(
                //    color: Get.theme.colorPrimaryDark,
                  //  decoration: TextDecoration.underline),
              )
      )
          : null,
      snackPosition:
          snackPostionTop ? SnackPosition.TOP : SnackPosition.BOTTOM);
}
