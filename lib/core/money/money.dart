class Money {
  const Money._(this.cents);

  final int cents;

  factory Money.fromCents(int cents) => Money._(cents);

  factory Money.fromDecimalString(String value) {
    final normalized = value.replaceAll(',', '.').trim();
    final parts = normalized.split('.');
    if (parts.length > 2) {
      throw const FormatException('Formato monetario inválido');
    }
    final whole = int.parse(parts[0]);
    final fractional = parts.length == 2
        ? (parts[1].padRight(2, '0').substring(0, 2))
        : '00';
    final fraction = int.parse(fractional);
    final sign = whole < 0 ? -1 : 1;
    return Money._((whole.abs() * 100 + fraction) * sign);
  }

  Money operator +(Money other) => Money._(cents + other.cents);
  Money operator -(Money other) => Money._(cents - other.cents);

  static int applyPercentBps({required int baseCents, required int rateBps}) {
    // rateBps: 2100 -> 21.00%
    return ((baseCents * rateBps) / 10000).round();
  }
}
