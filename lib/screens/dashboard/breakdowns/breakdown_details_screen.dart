import 'package:flutter/material.dart';
import 'package:loccar_agency/models/breakdown.dart';

class BreakdownDetailsScreen extends StatefulWidget {
  final BreakdownModel breakdown;
  const BreakdownDetailsScreen({super.key, required this.breakdown});

  @override
  State<BreakdownDetailsScreen> createState() => _BreakdownDetailsScreenState();
}

class _BreakdownDetailsScreenState extends State<BreakdownDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Details de la panne")));
  }
}
