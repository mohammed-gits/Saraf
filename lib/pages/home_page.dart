import 'package:flutter/material.dart';
import '../core/rate_simulator.dart'; // formatThousands()
import '../api/exchange_rates.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Core values
  double currentRate = 90000; // LBP per 1 USD
  final TextEditingController rateCtrl = TextEditingController(text: '90,000');
  final TextEditingController amountCtrl = TextEditingController();

  String from = 'USD';
  String to   = 'LBP';
  String resultText = 'Enter an amount to convert';

  bool _isSyncing = false;
  String? _sourceNote; // attribution or error message

  @override
  void dispose() {
    rateCtrl.dispose();
    amountCtrl.dispose();
    super.dispose();
  }

  // --------------- helpers ----------------

  double? _parseNumber(String raw) {
    final s = raw.replaceAll(',', '').trim();
    return double.tryParse(s);
  }

  void _applyRateFromField() {
    final v = _parseNumber(rateCtrl.text);
    if (v == null || v <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid positive rate.')),
      );
      rateCtrl.text = formatThousands(currentRate);
      return;
    }
    setState(() {
      currentRate = v;
      rateCtrl.text = formatThousands(currentRate); // normalize format
      _recompute();
    });
  }

  void _swap() {
    setState(() {
      final tmp = from;
      from = to;
      to = tmp;
      _recompute();
    });
  }

  Future<void> _syncLiveRate() async {
    setState(() { _isSyncing = true; _sourceNote = null; });
    final v = await fetchUsdToLbp();
    setState(() {
      _isSyncing = false;
      if (v != null && v > 0) {
        currentRate = v;
        rateCtrl.text = formatThousands(currentRate);
        _sourceNote = 'Rate source: ExchangeRate-API';
        _recompute();
      } else {
        _sourceNote = 'Could not sync live rate.';
      }
    });
  }

  void _recompute() {
    final amount = _parseNumber(amountCtrl.text);
    if (amount == null) {
      resultText = 'Enter a valid amount';
      return;
    }
    if (from == to) {
      resultText = 'No conversion needed.';
      return;
    }

    if (from == 'USD' && to == 'LBP') {
      final res = amount * currentRate;
      resultText =
      '${_prettyAmount(amount, "USD")} ≈ ${formatThousands(res)} LBP @ ${formatThousands(currentRate)}';
    } else {
      final res = amount / currentRate;
      resultText =
      '${formatThousands(amount)} LBP ≈ ${res.toStringAsFixed(4)} USD @ ${formatThousands(currentRate)}';
    }
    setState(() {}); // update UI text
  }

  String _prettyAmount(double a, String currency) {
    if (currency == 'USD') {
      // keep USD input readable without forcing commas while typing
      // show raw if not whole number
      if (a == a.roundToDouble()) {
        return '${a.toInt()} USD';
      }
      return '$a USD';
    }
    return '${formatThousands(a)} $currency';
  }

  // --------------- UI ---------------------

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final rateLabel = '1 USD = ${formatThousands(currentRate)} LBP';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saraf — LBP Rate Simulator'),
        actions: [
          IconButton(
            tooltip: 'About',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const AboutPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ===== Header / Status =====
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.currency_exchange, color: cs.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(rateLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (_sourceNote != null)
                      Text(_sourceNote!, style: TextStyle(color: cs.secondary, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ===== Rate Card =====
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Set Current Rate (LBP per 1 USD)',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: rateCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: 'e.g. 95,000'),
                      onSubmitted: (_) => _applyRateFromField(),
                      onEditingComplete: _applyRateFromField,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton.icon(
                        onPressed: _isSyncing ? null : _syncLiveRate,
                        icon: const Icon(Icons.sync_rounded),
                        label: Text(_isSyncing ? 'Syncing…' : 'Sync Live Rate'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ===== Converter Card =====
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: amountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixText: from == 'USD' ? '\$ ' : 'LBP ',
                      ),
                      onChanged: (_) => _recompute(), // auto convert as you type
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
                            onChanged: (v) { from = v!; _recompute(); setState((){}); },
                            decoration: const InputDecoration(labelText: 'From'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Swap',
                          onPressed: _swap,
                          icon: const Icon(Icons.swap_horiz_rounded),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: to,
                            items: const [
                              DropdownMenuItem(value: 'LBP', child: Text('LBP')),
                              DropdownMenuItem(value: 'USD', child: Text('USD')),
                            ],
                            onChanged: (v) { to = v!; _recompute(); setState((){}); },
                            decoration: const InputDecoration(labelText: 'To'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              resultText,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
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
