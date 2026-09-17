/// Medios de pago persistidos en `sales.payment_method` y cobros de CC.
class PaymentMethod {
  static const String cash = 'cash';
  static const String transfer = 'transfer';
  static const String card = 'card';
  static const String currentAccount = 'current_account';

  static const List<String> all = <String>[
    cash,
    transfer,
    card,
    currentAccount,
  ];

  static String label(String value) {
    switch (value) {
      case cash:
        return 'Efectivo';
      case transfer:
        return 'Transferencia';
      case card:
        return 'Tarjeta';
      case currentAccount:
        return 'Cuenta corriente';
      default:
        return value;
    }
  }

  static bool countsInCashClose(String value) => value == cash;

  static String normalize(String? value) {
    if (value == null || value.isEmpty) {
      return cash;
    }
    return all.contains(value) ? value : cash;
  }
}
