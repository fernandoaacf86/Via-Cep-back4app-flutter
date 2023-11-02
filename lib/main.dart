import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:via_cep/repository/back4app_repository.dart';
import 'package:via_cep/via_cep_app.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    ChangeNotifierProvider(
      create: (context) => Back4AppRepository(),
      child: const ViaCepApp(),
    ),
  );
}
