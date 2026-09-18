enum CashSessionStatus { open, closed }

enum CashMovementType { income, expense }

CashSessionStatus cashSessionStatusFromDb(String value) {
  switch (value) {
    case 'closed':
      return CashSessionStatus.closed;
    case 'open':
    default:
      return CashSessionStatus.open;
  }
}

String cashSessionStatusToDb(CashSessionStatus status) {
  switch (status) {
    case CashSessionStatus.closed:
      return 'closed';
    case CashSessionStatus.open:
      return 'open';
  }
}

CashMovementType cashMovementTypeFromDb(String value) {
  switch (value) {
    case 'expense':
      return CashMovementType.expense;
    case 'income':
    default:
      return CashMovementType.income;
  }
}

String cashMovementTypeToDb(CashMovementType type) {
  switch (type) {
    case CashMovementType.income:
      return 'income';
    case CashMovementType.expense:
      return 'expense';
  }
}

/// Datos para abrir un nuevo turno de caja.
class OpenCashSessionInput {
  const OpenCashSessionInput({
    required this.id,
    required this.deviceId,
    required this.openingCents,
    required this.openedAt,
    this.userId,
    this.userName,
    this.notes,
  });

  final String id;
  final String deviceId;
  final int openingCents;
  final DateTime openedAt;
  final String? userId;
  final String? userName;
  final String? notes;
}

/// Datos para cerrar el turno de caja abierto.
class CloseCashSessionInput {
  const CloseCashSessionInput({
    required this.sessionId,
    required this.countedClosingCents,
    required this.closedAt,
    this.notes,
  });

  final String sessionId;
  final int countedClosingCents;
  final DateTime closedAt;
  final String? notes;
}

/// Datos para registrar un ingreso o egreso manual de efectivo.
class RegisterCashMovementInput {
  const RegisterCashMovementInput({
    required this.id,
    required this.sessionId,
    required this.type,
    required this.amountCents,
    required this.deviceId,
    this.description,
    this.paymentMethod = 'Efectivo',
    this.userId,
    this.createdAt,
  });

  final String id;
  final String sessionId;
  final CashMovementType type;
  final int amountCents;
  final String deviceId;
  final String? description;
  final String paymentMethod;
  final String? userId;
  final DateTime? createdAt;
}

/// Fila individual de un turno de caja para listados.
class CashSessionSummary {
  const CashSessionSummary({
    required this.id,
    required this.deviceId,
    required this.status,
    required this.openingCents,
    required this.openedAt,
    this.userName,
    this.closedAt,
    this.expectedClosingCents,
    this.countedClosingCents,
    this.differenceCents,
  });

  final String id;
  final String deviceId;
  final CashSessionStatus status;
  final int openingCents;
  final DateTime openedAt;
  final String? userName;
  final DateTime? closedAt;
  final int? expectedClosingCents;
  final int? countedClosingCents;
  final int? differenceCents;
}

/// Movimiento manual de efectivo dentro de un turno.
class CashMovementItem {
  const CashMovementItem({
    required this.id,
    required this.sessionId,
    required this.type,
    required this.amountCents,
    required this.createdAt,
    this.description,
    this.userId,
  });

  final String id;
  final String sessionId;
  final CashMovementType type;
  final int amountCents;
  final DateTime createdAt;
  final String? description;
  final String? userId;
}

/// Vista detallada de un turno de caja: incluye el arqueo automático
/// (ventas confirmadas + ingresos manuales - egresos manuales - gastos
/// activos registrados dentro de la ventana del turno) contrastado contra
/// lo efectivamente contado al cerrar.
///
/// Nota: el sistema asume que las ventas confirmadas se cobran en efectivo,
/// ya que hoy no existe una distinción de medio de pago en las ventas. Los
/// gastos sí se descuentan siempre del efectivo esperado.
class CashSessionDetail {
  const CashSessionDetail({
    required this.id,
    required this.deviceId,
    required this.status,
    required this.openingCents,
    required this.openedAt,
    required this.salesTotalCents,
    required this.salesCount,
    required this.expensesTotalCents,
    required this.expensesCount,
    required this.manualIncomeCents,
    required this.manualExpenseCents,
    required this.expectedClosingCents,
    required this.movements,
    this.userId,
    this.userName,
    this.closedAt,
    this.countedClosingCents,
    this.differenceCents,
    this.openingNotes,
    this.closingNotes,
    this.transferSalesCents = 0,
    this.cardSalesCents = 0,
    this.currentAccountSalesCents = 0,
  });

  final String id;
  final String deviceId;
  final CashSessionStatus status;
  final int openingCents;
  final DateTime openedAt;
  final int salesTotalCents;
  final int salesCount;
  final int expensesTotalCents;
  final int expensesCount;
  final int manualIncomeCents;
  final int manualExpenseCents;
  final int expectedClosingCents;
  final List<CashMovementItem> movements;
  final String? userId;
  final String? userName;
  final DateTime? closedAt;
  final int? countedClosingCents;
  final int? differenceCents;
  final String? openingNotes;
  final String? closingNotes;
  /// Totales informativos del turno. No integran el efectivo esperado.
  final int transferSalesCents;
  final int cardSalesCents;
  final int currentAccountSalesCents;
}

/// Resumen agregado de la actividad de caja en un período (todos los
/// dispositivos/usuarios), usado en Estadísticas y en Gastos/Ganancias.
class CashboxPeriodStats {
  const CashboxPeriodStats({
    required this.sessionsCount,
    required this.openSessionsCount,
    required this.closedSessionsCount,
    required this.manualIncomeCents,
    required this.manualExpenseCents,
    required this.totalDifferenceCents,
    required this.closedSessionsWithDifferenceCount,
  });

  final int sessionsCount;
  final int openSessionsCount;
  final int closedSessionsCount;
  final int manualIncomeCents;
  final int manualExpenseCents;
  final int totalDifferenceCents;
  final int closedSessionsWithDifferenceCount;

  int get netManualCents => manualIncomeCents - manualExpenseCents;
}
