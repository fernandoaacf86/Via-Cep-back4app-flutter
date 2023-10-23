import 'package:flutter/material.dart';
import 'package:via_cep/pages/home_page.dart';

class ViaCepApp extends StatelessWidget {
  const ViaCepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: HomePage(),
    );
  }
}
