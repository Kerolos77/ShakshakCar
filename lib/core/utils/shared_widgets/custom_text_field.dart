import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.hint,
    this.suffix,
    this.prefix,
    this.onchange,
    this.label,
    this.obscure = false,
    this.keyType,
    this.maxLiens = 1,
    this.borderColor = AppColors.secondaryColor,
    this.controller,
    this.onTap,
    this.initial,
    this.inputFormatters,
    this.borderRadius = 16,
    this.topPadding = 8,
    this.hintColor = AppColors.greyColor,
    this.validator,
    this.width,
    this.fill = true,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.isReadOnly = false,
    this.focusNode,
    this.errorBorderColor,
    this.errorTextColor,
  });

  final String? hint;
  final String? Function(String? value)? validator;
  final int? maxLiens;
  final Widget? suffix, prefix;
  final String? label;
  final bool obscure;

  final bool fill;

  final void Function(String?)? onchange;
  final TextInputType? keyType;
  final Color? borderColor, hintColor;
  final TextEditingController? controller;
  final String? initial;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final double topPadding;
  final double borderRadius;
  final double? width;
  final AutovalidateMode? autoValidateMode;
  final bool isReadOnly;
  final FocusNode? focusNode;
  final Color? errorBorderColor;
  final Color? errorTextColor;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Styles.textStyle16SemiBold(context)
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          6.ph,
        ],
        TextFormField(
          focusNode: widget.focusNode,
          readOnly: widget.isReadOnly,
          autovalidateMode: widget.autoValidateMode,
          obscuringCharacter: "*",
          initialValue: widget.initial,
          onTap: widget.onTap,
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onchange,
          obscureText: widget.obscure,
          maxLines: widget.maxLiens,
          keyboardType: widget.keyType,
          inputFormatters: widget.inputFormatters,
          cursorColor: AppColors.secondaryColor,
          decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.surface,
            filled: true,
            enabledBorder: buildOutlineInputBorder(widget.borderColor),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                borderSide: BorderSide(
                    color: widget.errorBorderColor ?? AppColors.redColor,
                    width: 1.0,
                    style: BorderStyle.solid)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                borderSide: BorderSide(
                    color: widget.errorBorderColor ?? AppColors.redColor,
                    width: 1.2,
                    style: BorderStyle.solid)),
            errorStyle: const TextStyle(fontSize: 0, height: 0),
            border: buildOutlineInputBorder(widget.borderColor),
            focusedBorder: buildOutlineInputBorder(widget.borderColor),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: widget.suffix,
            prefixIcon: widget.prefix,
            hintText: widget.hint,
            hintStyle: Styles.textStyle16Medium(context)
                .copyWith(color: Theme.of(context).hintColor),
            labelStyle: Styles.textStyle16SemiBold(context)
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          style: Styles.textStyle18SemiBold(context)
              .copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ],
    );
  }

  OutlineInputBorder buildOutlineInputBorder(Color? color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        borderSide: BorderSide(
            color: color ?? AppColors.secondaryColor,
            style: BorderStyle.solid));
  }
}
