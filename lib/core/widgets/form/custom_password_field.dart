import 'package:flutter/material.dart';
import '../../utils/validators.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const CustomPasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;  // ← State: true = ●●●●, false = abc123

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,  // ← Pakai state
      validator: widget.validator ?? Validators.validatePassword,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,  
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;  
            });
          },
        ),
        // Sisanya ikut AppTheme.inputDecorationTheme!
      ),
    );
  }
}
