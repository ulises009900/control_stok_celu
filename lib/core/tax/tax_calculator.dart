class TaxBreakdown {
  const TaxBreakdown({
    required this.netCents,
    required this.taxCents,
    required this.grossCents,
  });

  final int netCents;
  final int taxCents;
  final int grossCents;
}

class TaxCalculator {
  const TaxCalculator();

  TaxBreakdown fromNet({required int netCents, required int taxRateBps}) {
    final tax = ((netCents * taxRateBps) / 10000).round();
    return TaxBreakdown(
      netCents: netCents,
      taxCents: tax,
      grossCents: netCents + tax,
    );
  }

  TaxBreakdown fromGross({required int grossCents, required int taxRateBps}) {
    final divisor = 1 + (taxRateBps / 10000);
    final net = (grossCents / divisor).round();
    final tax = grossCents - net;
    return TaxBreakdown(
      netCents: net,
      taxCents: tax,
      grossCents: grossCents,
    );
  }
}
