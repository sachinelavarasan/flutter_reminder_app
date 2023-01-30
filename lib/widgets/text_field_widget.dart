import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    this.label,
    required this.controller,
    required this.placeholderText,
    required this.onChange,
  }) : super(key: key);

  final Function(String) onChange;
  final String? label;
  final String placeholderText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Text(
            label!,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
            controller: controller,
            cursorColor: Colors.black,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: placeholderText,
              hintStyle: const TextStyle(
                color: Color(0xFFC7C3C3),
                fontWeight: FontWeight.w500,
              ),
            ),
            onChanged: onChange),
      ],
    );
  }
}
