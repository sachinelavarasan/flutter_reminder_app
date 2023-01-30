import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({
    Key? key,
    required this.placeholderText,
    required this.onChange,
    required this.isSearch,
  }) : super(key: key);

  final Function(String) onChange;
  final String placeholderText;
  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    return TextField(
        cursorColor: Colors.black,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: placeholderText,
          hintStyle: const TextStyle(
            color: Color(0xFFC7C3C3),
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: isSearch == true
              ? const Icon(
                  Icons.search,
                )
              : null,
        ),
        onChanged: onChange);
  }
}
