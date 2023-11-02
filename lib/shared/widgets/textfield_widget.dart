import 'package:flutter/material.dart';

class TextFieldCEPWidget extends StatelessWidget {
  final TextEditingController cepController;
  const TextFieldCEPWidget({
    super.key,
    required this.cepController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 8,
      keyboardType: TextInputType.number,
      controller: cepController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Ex: 11000111",
      ),
    );
  }
}
