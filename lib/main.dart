import 'package:flutter/material.dart';
import 'core/rate_simulator.dart';

void main() {
  runApp(const SarafApp());
}

class SarafApp extends StatelessWidget {
  const SarafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saraf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E), // teal-ish
          brightness: Brightness.dark,        // premium dark
        ),
        useMaterial3: true,
      ),
      home: const SarafHomePage(),
    );
  }
}

class SarafHomePage extends StatefulWidget {
  const SarafHomePage({super.key});

  @override
  State<SarafHomePage> createState() => _SarafHomePageState();
}

class _SarafHomePageState extends State<SarafHomePage> {
  final sim = RateSimulator(initial: 90000);
  final amountCtrl = TextEditingController();

  String from = 'USD';
  String to = 'LBP';
  String resultText = 'Enter an amount to convert';

  @override
  void dispose() {
    amountCtrl.dispose();
    super.dispose();
  }

  void _convert() {
    final amount = double.tryParse(amountCtrl.text);
    if (amount == null) {
      setState(() => resultText = 'Please enter a valid number');
      return;
    }
    if (from == to) {
      setState(() => resultText = 'No conversion needed.');
      return;
    }

    final rate = sim.current;
    if (from == 'USD' && to == 'LBP') {
      final res = amount * rate;
      setState(() => resultText =
      '$amount USD ≈ ${formatThousands(res)} LBP @ ${formatThousands(rate)}');
    } else {
      final res = amount / rate;
      setState(() => resultText =
      '${formatThousands(amount)} LBP ≈ ${res.toStringAsFixed(4)} USD @ ${formatThousands(rate)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final rateLabel = '1 USD = ${formatThousands(sim.current)} LBP';

    return Scaffold(
      appBar: AppBar(title: const Text('Saraf — LBP Rate Simulator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(rateLabel,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            TextField(
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _convert(),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: from,
                    items: const [
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                      DropdownMenuItem(value: 'LBP', child: Text('LBP')),
                    ],
                    onChanged: (v) => setState(() {
                      from = v!;
                      _convert();
                    }),
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: to,
                    items: const [
                      DropdownMenuItem(value: 'LBP', child: Text('LBP')),
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                    ],
                    onChanged: (v) => setState(() {
                      to = v!;
                      _convert();
                    }),
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            FilledButton(
              onPressed: _convert,
              child: const Text('Convert'),
            ),

            const SizedBox(height: 16),
            Text(resultText, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),

            const Text(
              'Disclaimer: Educational simulation only. Not financial advice.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
