import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  String label;

  TextInputType keyboardType;

  TextEditingController controller;

  bool obscureText;

  String? Function(String?)? validator;

  CustomTextFormField({required this.label,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.obscureText = false,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(label),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                width: 3,
                color: Theme
                    .of(context)
                    .primaryColor
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                width: 3,
                color: Theme
                    .of(context)
                    .primaryColor
            ),
          ),
        ),
        keyboardType: keyboardType,
        controller: controller,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
