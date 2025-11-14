// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String name;
  Color bgColor;
  Color textColor;
  CustomButton(
      {super.key,
      required this.name,
      required this.bgColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          color: bgColor,
        ),
        alignment: Alignment.center,
        child: Center(
            child: Text(
          name,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            fontFamily: "Poppins",
          ),
        )),
      ),
    );
  }
}
