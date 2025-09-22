import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/app_colors.dart';

class ToastService {
  // Success toast
  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: AppColors.primaryRed,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Error toast
  static void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: AppColors.errorColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Warning toast
  static void showWarning(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: AppColors.warningColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Info toast
  static void showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: AppColors.darkGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Custom toast with specific color
  static void showCustom(String message, Color backgroundColor, {Color? textColor}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: backgroundColor,
      textColor: textColor ?? Colors.white,
      fontSize: 16.0,
    );
  }

  // Cancel current toast
  static void cancelToast() {
    Fluttertoast.cancel();
  }
}
