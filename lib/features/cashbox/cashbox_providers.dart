import 'package:control_stok_celu/core/period_range.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/repositories/drift_cashbox_repository.dart';
import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:control_stok_celu/domain/cashbox/cashbox_models.dart';
import 'package:control_stok_celu/domain/cashbox/cashbox_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cashboxRepositoryProvider = Provider<CashboxRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftCashboxRepository(db);
});

/// Turno de caja abierto para este dispositivo (o nulo si no hay ninguno).
/// Invalidar este provider tras abrir/cerrar caja o registrar un movimiento
/// para refrescar el estado.
final currentOpenCashSessionProvider =
    FutureProvider.autoDispose<CashSessionSummary?>((ref) async {
  final deviceId = await ref.watch(deviceIdProvider.future);
  final repo = ref.watch(cashboxRepositoryProvider);
  return repo.getOpenSession(deviceId: deviceId);
});

/// Detalle (con arqueo) de un turno de caja puntual.
final cashSessionDetailProvider = FutureProvider.autoDispose
    .family<CashSessionDetail, String>((ref, sessionId) async {
  final repo = ref.watch(cashboxRepositoryProvider);
  return repo.getSessionDetail(sessionId);
});

/// Historial de turnos: el administrador ve los de todos los dispositivos
/// (una vez sincronizados) para poder controlar la caja de cada
/// vendedor; un vendedor solo ve los de su propio dispositivo.
class CashHistoryFilter {
  const CashHistoryFilter({this.employee, this.from, this.to});
  final String? employee;
  final DateTime? from;
  final DateTime? to;
}

final cashHistoryFilterProvider = StateProvider.autoDispose<CashHistoryFilter>((ref) => const CashHistoryFilter());

final cashSessionHistoryProvider =
    FutureProvider.autoDispose<List<CashSessionSummary>>((ref) async {
  final isAdmin = ref.watch(isAdminProvider);
  final repo = ref.watch(cashboxRepositoryProvider);
  final filter = ref.watch(cashHistoryFilterProvider);
  final deviceId = isAdmin ? null : await ref.watch(deviceIdProvider.future);
  return repo.listSessions(deviceId: deviceId, employeeSearch: filter.employee,
    from: filter.from, to: filter.to, limit: null);
});

/// Estadísticas agregadas de caja (todos los dispositivos/usuarios) para el
/// rango de fechas indicado. Usado desde Estadísticas y Gastos/Ganancias.
final cashboxPeriodStatsProvider = FutureProvider.autoDispose
    .family<CashboxPeriodStats, DateRange>((ref, range) async {
  final repo = ref.watch(cashboxRepositoryProvider);
  return repo.getPeriodStats(from: range.start, to: range.end);
});

/// Invalida los providers de caja que dependen del estado mutable (llamar
/// tras abrir/cerrar un turno o registrar un movimiento).
void invalidateCashboxProviders(WidgetRef ref) {
  ref.invalidate(currentOpenCashSessionProvider);
  ref.invalidate(cashSessionHistoryProvider);
}
