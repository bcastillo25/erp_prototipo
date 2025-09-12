import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {

  final String? label;
  final String? hint;
  final String? labeltext;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final IconButton? icon;
  final Icon? prefix;
  final TextAlign? textAlign;
  final TextEditingController? controller;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatter;
  final bool enable;
  

  const CustomTextFormField({
    super.key, 
    this.label, 
    this.hint, 
    this.labeltext,
    this.errorMessage, 
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged, 
    this.onFieldSubmitted,
    this.validator, 
    this.icon,
    this.prefix,
    this.textAlign,
    this.controller,
    this.readOnly = false,
    this.inputFormatter,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10),
    );

    const borderRadius = Radius.circular(10);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: borderRadius, topRight: borderRadius, bottomLeft: borderRadius, bottomRight: borderRadius),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black54,
            blurRadius: 10,
            offset: const Offset(0, 5)
          )
        ]
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        inputFormatters: inputFormatter,
        obscureText: obscureText,
        enabled: enable,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 20, color: readOnly ? Colors.grey.shade700 : Colors.black),
        readOnly: readOnly,
        decoration: InputDecoration(
          floatingLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith(borderSide: BorderSide(color: Colors.transparent)),
          focusedErrorBorder: border.copyWith(borderSide: BorderSide(color: Colors.transparent)),
          isDense: true,
          labelText: label != null ? (label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          suffix: icon,
          prefixIcon: prefix,
          filled: readOnly,
          fillColor: Colors.grey.shade200
        ),

      ),
    );
  }
}