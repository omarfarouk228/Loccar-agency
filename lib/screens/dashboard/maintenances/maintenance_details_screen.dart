import 'package:flutter/material.dart';
import 'package:loccar_agency/models/maintenance.dart';

class MaintenanceDetailsScreen extends StatefulWidget {
  final MaintenanceModel maintenance;
  const MaintenanceDetailsScreen({super.key, required this.maintenance});

  @override
  State<MaintenanceDetailsScreen> createState() =>
      _MaintenanceDetailsScreenState();
}

class _MaintenanceDetailsScreenState extends State<MaintenanceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Details de la maintenance")));
  }
}
