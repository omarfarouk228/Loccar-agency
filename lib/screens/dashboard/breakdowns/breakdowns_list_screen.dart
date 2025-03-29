import 'package:flutter/material.dart';

class BreakdownsListScreen extends StatefulWidget {
  const BreakdownsListScreen({super.key});

  @override
  State<BreakdownsListScreen> createState() => _BreakdownsListScreenState();
}

class _BreakdownsListScreenState extends State<BreakdownsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des pannes"),
      ),
      body: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Aucune panne",
              style: TextStyle(color: Colors.black54, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
