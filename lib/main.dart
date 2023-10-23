import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:via_cep/via_cep_app.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(ViaCepApp());
}
