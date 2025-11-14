import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/theme/styles.dart';

appLog(
  String msg, {
  StackTrace? stackTrace,
  Object? error,
  String name = "QLIQ",
  int level = 0,
  Zone? zone,
  int? sequenceNumber,
}) {
  if (!kDebugMode) return;
  log(
    "$name: $msg",
    stackTrace: stackTrace,
    error: error,
    name: name,
    time: DateTime.now(),
    level: level,
    zone: zone,
    sequenceNumber: sequenceNumber,
  );
}

showSnackBar({required BuildContext context, required SnackBar snackBar}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

SnackBar showErrorDialogue({
  required String errorMessage,
  Duration duration = const Duration(milliseconds: 2000),
}) {
  return SnackBar(
    elevation: 2,
    dismissDirection: DismissDirection.horizontal,
    backgroundColor: customColors().grey,
    duration: duration,
    content: Text(
      errorMessage,
      style: customTextStyle(
        fontStyle: FontStyle.BodyL_SemiBold,
        color: FontColor.red,
      ),
    ),
  );
}

SnackBar showWaringDialogue({
  required String errorMessage,
  Duration duration = const Duration(milliseconds: 2000),
}) {
  return SnackBar(
    backgroundColor: customColors().backgroundPrimary,
    duration: duration,
    content: Text(
      errorMessage,
      style: customTextStyle(
        fontStyle: FontStyle.BodyM_SemiBold,
        color: FontColor.White,
      ),
    ),
  );
}

SnackBar showSuccessDialogue({
  required String message,
  Duration duration = const Duration(milliseconds: 2000),
}) {
  return SnackBar(
    backgroundColor: customColors().backgroundPrimary,
    duration: duration,
    content: Text(
      message,
      style: customTextStyle(
        fontStyle: FontStyle.BodyM_SemiBold,
        color: FontColor.White,
      ),
    ),
  );
}
