/// Simple thousands formatter without packages: 92350 → "92,350"
String formatThousands(num x) {
  final s = x.toInt().toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final remaining = s.length - i - 1;
    buf.write(s[i]);
    if (remaining > 0 && remaining % 3 == 0) buf.write(',');
  }
  return buf.toString();
}
