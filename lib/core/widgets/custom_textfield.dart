import 'package:flutter/material.dart';




class CustomTextFormFields extends StatefulWidget {
  const CustomTextFormFields({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.suffixIcon, required this.valid, required this.prefixIcon, this.hintText, required this.name,
  });

  final TextEditingController controller;
  final String labelText;
  final String name;
  final String?hintText;
  final String valid;
  final Widget prefixIcon;
  final bool isPassword;
  final Widget? suffixIcon;

  @override
  State<CustomTextFormFields> createState() => _CustomTextFormFieldsState();
}

class _CustomTextFormFieldsState extends State<CustomTextFormFields> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.name,
            style: TextStyle(fontSize: 20),),
        ),
        TextFormField(
          validator:(value) {
            if (value == null || value.trim().isEmpty) {
              return widget.valid;
            }
            return null;
          } ,
          controller: widget.controller,
          obscureText: widget.isPassword && !_isPasswordVisible,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            labelText: widget.labelText,
            labelStyle: const TextStyle(color: Colors.black87),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black87, width: 2),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
               color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
