import 'dart:convert';
import 'package:http/http.dart' as http;

/// Returns USD→LBP rate from open.er-api.com (no API key).
Future<double?> fetchUsdToLbp() async {
  final uri = Uri.parse('https://open.er-api.com/v6/latest/USD');
  final res = await http.get(uri).timeout(const Duration(seconds: 8));
  if (res.statusCode != 200) return null;

  final data = json.decode(res.body) as Map<String, dynamic>;
  if (data['result'] != 'success') return null;
  final rates = data['rates'] as Map<String, dynamic>;
  final lbp = rates['LBP'];
  if (lbp is num) return lbp.toDouble();
  return null;
}
