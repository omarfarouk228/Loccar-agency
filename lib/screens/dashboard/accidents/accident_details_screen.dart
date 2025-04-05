import 'package:flutter/material.dart';
import 'package:loccar_agency/models/accident.dart';

class AccidentDetailsScreen extends StatefulWidget {
  final AccidentModel accident;
  const AccidentDetailsScreen({super.key, required this.accident});

  @override
  State<AccidentDetailsScreen> createState() => _AccidentDetailsScreenState();
}

class _AccidentDetailsScreenState extends State<AccidentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Details de l'accident")));
  }
}
