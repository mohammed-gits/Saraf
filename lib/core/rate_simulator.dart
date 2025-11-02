import 'dart:math';

/// Mean-reverting USD→LBP rate simulator.
///
/// next = current + theta*(mu - current) + sigma*epsilon
/// epsilon ~ N(0,1)
class RateSimulator {
  final double mu;     // long-term mean, e.g., 90000
  final double theta;  // pull strength toward mean (0..1)
  final double minV;   // lower clamp
  final double maxV;   // upper clamp

  double current;
  final Random _rng;

  RateSimulator({
    this.mu = 90000,
    this.theta = 0.05,
    this.minV = 60000,
    this.maxV = 120000,
    double? initial,
    Random? rng,
  })  : current = initial ?? 90000,
        _rng = rng ?? Random();

  /// Advance one step given volatility (sigma).
  double step(double sigma) {
    final eps = _gaussian(_rng);
    var next = current + theta * (mu - current) + sigma * eps;
    next = next.clamp(minV, maxV);
    current = next;
    return current;
  }
}

/// Box–Muller transform to sample N(0,1)
double _gaussian(Random r) {
  var u1 = r.nextDouble();
  var u2 = r.nextDouble();
  if (u1 == 0) u1 = 1e-12;
  return sqrt(-2.0 * log(u1)) * cos(2 * pi * u2);
}

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
