import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/theme/styles.dart';
import '../../utils/utils.dart';



class CustomTextFormField extends StatefulWidget {
  final BuildContext context;
  final bool enabled;
  final dynamic textCapitalization;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatter;
  final Color? bordercolor;
  final Color? bgColor;
  final String fieldName;
  final String? hintText;
  final String defaultErrorMessage;

  final Widget? maxLengthEnforcement;
  final TextInputType? keyboardType;
  // final ValueChanged<String>? onchangedAction;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Validator? validator;
  final int? width;
  final double? height;
  final double? labelBottomPadding;
  final bool obscureTextStatus;
  final bool readonlyState;
  final Function? keyboardAction;
  final bool isInputaction;
  final bool autoFocus;
  final bool obscureIcon;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final Widget? topEndWidget;
  final Widget? bottomStartWidget;
  final Widget? bottomEndWidget;
  final Function(String)? onFieldSubmit;
  final Function(String)? onChange;
  final Function(String)? onErrorCallBack;
  final int? maxLines;
  final FocusNode? focusNode;
  final Color? focusedColor;
  final String? suffixtext;
  final Widget? prefixWidget;
  final int? minimumValueLimit;
  final double? minimumDecimalValueLimit;
  final TextAlign textAlign;
  final Widget? sufixWidget;
  final String? keystring;

  const CustomTextFormField({
    Key? key,
    required this.context,
    this.autoFocus = false,
    this.enabled = true,
    this.obscureIcon = false,
    this.textCapitalization = TextCapitalization.none,
    this.onErrorCallBack,
    required this.controller,
    this.inputFormatter,
    this.bordercolor,
    this.focusedColor,
    this.bgColor,
    required this.fieldName,
    this.hintText = " ",
    this.defaultErrorMessage = "Please fill valid data",
    this.maxLength,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureTextStatus = false,
    this.width,
    this.height = 50,
    this.maxLengthEnforcement,
    this.keyboardType,
    // this.onchangedAction,
    this.readonlyState = false,
    this.labelBottomPadding,
    this.keyboardAction,
    this.isInputaction = false,
    this.textInputAction,
    this.fillColor,
    this.topEndWidget,
    this.bottomStartWidget,
    this.bottomEndWidget,
    this.onFieldSubmit,
    this.onChange,
    this.focusNode,
    this.maxLines,
    this.suffixtext,
    this.prefixWidget,
    this.minimumValueLimit,
    this.minimumDecimalValueLimit,
    this.textAlign = TextAlign.start,
    this.sufixWidget,
    this.keystring,
  }) : super(key: key);
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool contentVisibility = false;
  @override
  void initState() {
    contentVisibility = widget.obscureTextStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.fieldName != "")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 350,
                child: Text(
                  widget.fieldName,
                  style: customTextStyle(
                    fontStyle: FontStyle.HeaderXS_SemiBold,
                    color: FontColor.FontPrimary,
                  ),
                ),
              ),
              widget.topEndWidget ?? Container(),
            ],
          ),
        Padding(
          padding: EdgeInsets.only(top: widget.labelBottomPadding ?? 8.0),
          child: TextFormField(
            key: Key(widget.keystring ?? "InputField"),
            readOnly: widget.readonlyState,
            textAlign: widget.textAlign,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: widget.keyboardType,
            minLines: widget.maxLines ?? 1,
            maxLines: widget.maxLines ?? 1,
            maxLength: widget.maxLength,
            cursorRadius: const Radius.circular(4.0),
            showCursor: true,
            onFieldSubmitted: widget.onFieldSubmit,
            onChanged: widget.onChange,
            obscureText: contentVisibility,
            obscuringCharacter: "●",
            autofocus: widget.autoFocus,
            textCapitalization: widget.textCapitalization,
            textAlignVertical: TextAlignVertical.center,
            controller: widget.controller,
            focusNode: widget.focusNode,
            inputFormatters: widget.inputFormatter,
            cursorColor: customColors().fontPrimary,
            validator: (value) {
              return customValidate(context, value.toString());
            },
            enabled: widget.enabled,
            style: customTextStyle(
              fontStyle: FontStyle.BodyL_SemiBold,
              color: FontColor.FontPrimary,
            ),
            decoration: InputDecoration(
              prefixIconConstraints: const BoxConstraints(
                minWidth: 35,
                minHeight: 20,
              ),
              prefixIcon: widget.prefixIcon,
              prefix: widget.prefixWidget,
              filled: true,
              helperText: "",
              helperStyle: const TextStyle(fontSize: 0),
              errorStyle: const TextStyle(fontSize: 0),
              suffix: widget.sufixWidget,
              suffixText: widget.suffixtext,
              fillColor: widget.enabled
                  ? widget.fillColor ?? customColors().backgroundPrimary
                  : widget.fillColor ?? customColors().backgroundPrimary,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.bordercolor ?? customColors().fontPrimary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              hintText: widget.hintText,
              hintStyle: customTextStyle(
                fontStyle: FontStyle.BodyL_SemiBold,
                color: FontColor.FontPrimary,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      widget.focusedColor ??
                      widget.bordercolor ??
                      customColors().fontPrimary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.bordercolor ?? customColors().fontPrimary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: customColors().fontPrimary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: customColors().fontPrimary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: customColors().fontPrimary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              suffixIcon:
                  widget.suffixIcon ??
                  ((widget.obscureIcon)
                      ? GestureDetector(
                          key: const Key("ChangePasswordInputboxEyeIconOntap"),
                          onTap: () {
                            setState(() {
                              contentVisibility = !contentVisibility;
                            });
                          },
                          child: contentVisibility
                              ? Image.asset('assets/eye_icon.png')
                              : Image.asset('assets/eye_icon.png'),
                        )
                      : null),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.bottomStartWidget ?? Container(),
            widget.bottomEndWidget ?? Container(),
          ],
        ),
      ],
    );
  }

  String? customValidate(BuildContext context, String value) {
    String? error;
    switch (widget.validator) {
      case Validator.defaultValidator:
        error = emptyValidation(value, widget.defaultErrorMessage);
        break;

      case Validator.password:
        error = passwordValidation(value);
        break;

      default:
        error = emptyValidation(
          widget.controller.value.toString(),
          widget.defaultErrorMessage,
        );
    }
    if (error != null) {
      showSnackBar(
        context: context,
        snackBar: showErrorDialogue(errorMessage: error),
      );
      if (widget.onErrorCallBack != null) {
        widget.onErrorCallBack!(error);
      }
    }
    return error;
  }
}

dynamic emptyValidation(String value, String errorString) {
  if (value.isEmpty || value == "") {
    return errorString;
  }
  return null;
}

dynamic passwordValidation(String value) {
  if (value == "") {
    return "Password required";
  }
  // else if (value != "admin") {
  //   return "Incorrect Password";
  // }
}

dynamic upiValidation(String value) {
  if (value.isEmpty) {
    return "UPI ID Required";
  }
}

dynamic priceValidation(String value) {
  if (value.isEmpty) {
    return "";
  }
}

dynamic changePassValidation(String value, String errorString) {
  if (value.isEmpty) {
    return errorString;
  }
}

enum Validator { none, defaultValidator, password }

class UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text != newValue.text.toUpperCase()) {
      return TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
    }
    return newValue;
  }
}
