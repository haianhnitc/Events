import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final Color? fillColor;
  final bool filled;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.fillColor,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      autofocus: autofocus,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: Color(0xff64748B),
          fontSize: 14,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
        fillColor: fillColor ?? Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xffEF4444),
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
          color: Color(0xffEF4444),
          fontSize: 12,
        ),
      ),
    );
  }
}

class CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? labelText;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;

  const CustomDropdownField({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.labelText,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color(0xff64748B),
          fontSize: 14,
        ),
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffEF4444)),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      icon:
          Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600),
      style: const TextStyle(
        color: Color(0xff273143),
        fontSize: 14,
      ),
      dropdownColor: Colors.white,
      elevation: 2,
    );
  }
}
