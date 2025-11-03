import 'package:flutter/material.dart';
import '../core/rate_simulator.dart';

class HistoryPage extends StatelessWidget {
  final List<double> history;
  const HistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulation History')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final rate = history[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.trending_up),
              title: Text('1 USD = ${formatThousands(rate)} LBP'),
            ),
          );
        },
      ),
    );
  }
}
