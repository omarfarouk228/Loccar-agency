import 'package:flutter/material.dart';

class AccidentsListScreen extends StatefulWidget {
  const AccidentsListScreen({super.key});

  @override
  State<AccidentsListScreen> createState() => _AccidentsListScreenState();
}

class _AccidentsListScreenState extends State<AccidentsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des accidents"),
      ),
      body: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Aucun accident",
              style: TextStyle(color: Colors.black54, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
