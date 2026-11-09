import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../theme/raay_colors.dart';

/// Raay Design System Text Field component.
///
/// Features semantic typography, helper/error states, high-DPI crisp border
/// rendering with [BorderSide.strokeAlignInside], and extensive form control options.
class RaayTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final String? initialValue;
  final IconData? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final Widget? suffix;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;

  const RaayTextField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.initialValue,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = RaayColors.of(context);
    final effectiveRadius = BorderRadius.circular(AppTheme.radiusInput);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          focusNode: focusNode,
          enabled: enabled,
          readOnly: readOnly,
          obscureText: obscureText,
          maxLines: obscureText ? 1 : maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          autofillHints: autofillHints,
          validator: validator,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          style: TextStyle(
            color: enabled ? colors.textPrimary : colors.textMuted,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colors.textMuted, fontSize: 14),
            helperText: helperText,
            helperStyle: TextStyle(color: colors.textMuted, fontSize: 12),
            errorText: errorText,
            errorStyle: TextStyle(color: colors.errorText, fontSize: 12),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: colors.textSecondary)
                : null,
            prefix: prefix,
            suffixIcon: suffixIcon,
            suffix: suffix,
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            filled: true,
            fillColor: colors.elevated,
            border: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(
                color: colors.border,
                width: 1.2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(
                color: colors.border,
                width: 1.2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.8,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(
                color: colors.error,
                width: 1.2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(
                color: colors.error,
                width: 1.8,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(
                color: colors.border.withValues(alpha: 0.5),
                width: 1.0,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
