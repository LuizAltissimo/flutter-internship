import 'package:atv1/pages/internship_list_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const InternshipApp());
}

class InternshipApp extends StatelessWidget {
  const InternshipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Estagios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const InternshipListPage(),
    );
  }
}
