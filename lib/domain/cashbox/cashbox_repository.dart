import 'package:control_stok_celu/domain/cashbox/cashbox_models.dart';

abstract interface class CashboxRepository {
  /// Turno de caja abierto para un dispositivo (o global si [deviceId] es
  /// null), si existe.
  Future<CashSessionSummary?> getOpenSession({String? deviceId});

  /// Abre un nuevo turno de caja. Falla si ya hay uno abierto para el mismo
  /// dispositivo.
  Future<void> openSession(OpenCashSessionInput input);

  /// Cierra un turno de caja calculando el arqueo automático.
  Future<CashSessionDetail> closeSession(CloseCashSessionInput input);

  /// Registra un ingreso o egreso manual dentro de un turno abierto.
  Future<void> registerMovement(RegisterCashMovementInput input);

  /// Detalle completo de un turno (abierto o cerrado) con arqueo calculado.
  Future<CashSessionDetail> getSessionDetail(String sessionId);

  /// Historial de turnos, más recientes primero.
  Future<List<CashSessionSummary>> listSessions({
    String? deviceId,
    String? employeeSearch,
    DateTime? from,
    DateTime? to,
    int? limit = 50,
  });

  /// Estadísticas agregadas de caja (todos los dispositivos) para un
  /// período, usadas en Estadísticas y en Gastos/Ganancias.
  Future<CashboxPeriodStats> getPeriodStats({
    required DateTime from,
    required DateTime to,
  });
}
