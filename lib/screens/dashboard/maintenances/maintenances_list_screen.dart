import 'package:flutter/material.dart';

class MaintenancesListScreen extends StatefulWidget {
  const MaintenancesListScreen({super.key});

  @override
  State<MaintenancesListScreen> createState() => _MaintenancesListScreenState();
}

class _MaintenancesListScreenState extends State<MaintenancesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des maintenances"),
      ),
      body: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Aucune maintenance",
              style: TextStyle(color: Colors.black54, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
