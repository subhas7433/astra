import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_text_field.dart';

class PasswordField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final RxBool? visibilityState;
  final VoidCallback? onToggleVisibility;
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  const PasswordField({
    super.key,
    this.label = 'Password',
    this.hint,
    this.controller,
    this.visibilityState,
    this.onToggleVisibility,
    this.errorText,
    this.textInputAction,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Use provided state or create a local one if not provided (for simple cases)
    final RxBool isObscured = visibilityState ?? true.obs;

    return Obx(
      () => AppTextField(
        label: label,
        hint: hint,
        controller: controller,
        obscureText: isObscured.value,
        prefixIcon: Icons.lock_outline,
        errorText: errorText,
        textInputAction: textInputAction,
        onChanged: onChanged,
        maxLines: 1,
        suffixIcon: IconButton(
          icon: Icon(
            isObscured.value
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: onToggleVisibility ?? () => isObscured.toggle(),
        ),
      ),
    );
  }
}
