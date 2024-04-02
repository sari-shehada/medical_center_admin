import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.leadingIcon,
    this.hintText,
    this.label,
    this.color,
    this.textSize,
    this.obscureText = false,
    this.isDense = false,
    this.suffixIcon,
    this.maxLength,
    this.keyboardType,
    this.inputAction,
    this.textDirection,
    this.suffixIconOnTap,
    this.onSubmitted,
  });

  final IconData? leadingIcon;
  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final Color? color;
  final double? textSize;
  final IconData? suffixIcon;
  final bool? isDense;
  final VoidCallback? suffixIconOnTap;
  final int? maxLength;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final TextDirection? textDirection;
  final void Function(String)? onSubmitted;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: color, fontSize: textSize),
      textDirection: textDirection,
      decoration: InputDecoration(
        fillColor: const Color(0xFFDFE9ED),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        isDense: isDense,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: textSize,
        ),
        label: label != null
            ? Text(
                label!,
                style: TextStyle(color: color, fontSize: textSize),
              )
            : null,
        prefixIcon: Icon(
          leadingIcon,
          color: color,
        ),
        contentPadding: EdgeInsets.zero,
        prefixIconColor: MaterialStateColor.resolveWith(
          (state) {
            if (state.isEmpty) {
              return CupertinoColors.systemGrey;
            }
            if (state.first == MaterialState.focused) {
              return color ?? Theme.of(context).colorScheme.primary;
            }
            return CupertinoColors.systemGrey;
          },
        ),
        suffixIcon: InkWell(
          onTap: suffixIconOnTap,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              suffixIcon,
              color: color,
            ),
          ),
        ),
      ),
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: inputAction,
      onSubmitted: onSubmitted,
    );
  }
}
