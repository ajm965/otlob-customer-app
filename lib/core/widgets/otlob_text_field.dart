import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtlobTextField extends StatelessWidget {
  const OtlobTextField({
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.semanticLabel,
    this.prefixIcon,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    super.key,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final String? semanticLabel;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: semanticLabel,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: helperText,
          errorText: errorText,
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
          suffixIcon: suffix,
        ),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        autofillHints: autofillHints,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTap: onTap,
        enabled: enabled,
        readOnly: readOnly,
        obscureText: obscureText,
        maxLines: obscureText ? 1 : maxLines,
      ),
    );
  }
}

class OtlobSearchField extends StatelessWidget {
  const OtlobSearchField({
    this.controller,
    this.focusNode,
    this.hint,
    this.semanticLabel,
    this.clearSemanticLabel,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onClear,
    this.enabled = true,
    this.readOnly = false,
    super.key,
  }) : assert(
         onClear == null || clearSemanticLabel != null,
         'A clearSemanticLabel is required when onClear is provided.',
       );

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final String? semanticLabel;
  final String? clearSemanticLabel;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool enabled;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return OtlobTextField(
      controller: controller,
      focusNode: focusNode,
      hint: hint,
      semanticLabel: semanticLabel,
      prefixIcon: Icons.search,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      enabled: enabled,
      readOnly: readOnly,
      suffix: onClear == null
          ? null
          : IconButton(
              onPressed: onClear,
              tooltip: clearSemanticLabel,
              icon: const Icon(Icons.clear),
            ),
    );
  }
}
