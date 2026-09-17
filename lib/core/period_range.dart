import 'package:control_stok_celu/domain/stock/stock_models.dart';

/// Rango de fechas UTC (inclusive) resuelto a partir de un período.
class DateRange {
  const DateRange(this.start, this.end);

  final DateTime start;
  final DateTime end;
}

/// Resuelve el mismo rango de fechas que usa el dashboard de Estadísticas
/// para un [DashboardPeriod], para poder cruzar datos de caja con el mismo
/// período mostrado en pantalla.
DateRange resolveDashboardPeriodRange(
  DashboardPeriod period, {
  DateTime? from,
  DateTime? to,
}) {
  final now = DateTime.now().toUtc();
  switch (period) {
    case DashboardPeriod.today:
      return DateRange(
        DateTime.utc(now.year, now.month, now.day),
        DateTime.utc(now.year, now.month, now.day + 1),
      );
    case DashboardPeriod.last7Days:
      return DateRange(
        DateTime.utc(now.year, now.month, now.day)
            .subtract(const Duration(days: 6)),
        DateTime.utc(now.year, now.month, now.day + 1),
      );
    case DashboardPeriod.thisWeek:
      return DateRange(
        now.subtract(Duration(days: now.weekday - 1)),
        now.add(const Duration(days: 1)),
      );
    case DashboardPeriod.thisMonth:
      return DateRange(
        DateTime.utc(now.year, now.month, 1),
        DateTime.utc(now.year, now.month + 1, 1),
      );
    case DashboardPeriod.previousMonth:
      final previousMonth = now.month == 1 ? 12 : now.month - 1;
      final previousYear = now.month == 1 ? now.year - 1 : now.year;
      return DateRange(
        DateTime.utc(previousYear, previousMonth, 1),
        DateTime.utc(now.year, now.month, 1),
      );
    case DashboardPeriod.thisYear:
      return DateRange(
        DateTime.utc(now.year, 1, 1),
        DateTime.utc(now.year + 1, 1, 1),
      );
    case DashboardPeriod.custom:
      return DateRange(
        (from ?? now).toUtc(),
        (to ?? now).toUtc().add(const Duration(days: 1)),
      );
  }
}

/// Resuelve el mismo rango de fechas que usa la pantalla de Gastos para un
/// [ExpensePeriod], para poder cruzar datos de caja con el mismo período
/// mostrado en pantalla.
DateRange resolveExpensePeriodRange(
  ExpensePeriod period, {
  DateTime? from,
  DateTime? to,
}) {
  final now = DateTime.now().toUtc();
  switch (period) {
    case ExpensePeriod.today:
      return DateRange(
        DateTime.utc(now.year, now.month, now.day),
        DateTime.utc(now.year, now.month, now.day + 1),
      );
    case ExpensePeriod.thisWeek:
      return DateRange(
        now.subtract(Duration(days: now.weekday - 1)),
        now.add(const Duration(days: 1)),
      );
    case ExpensePeriod.thisMonth:
      return DateRange(
        DateTime.utc(now.year, now.month, 1),
        DateTime.utc(now.year, now.month + 1, 1),
      );
    case ExpensePeriod.previousMonth:
      final previousMonth = now.month == 1 ? 12 : now.month - 1;
      final previousYear = now.month == 1 ? now.year - 1 : now.year;
      return DateRange(
        DateTime.utc(previousYear, previousMonth, 1),
        DateTime.utc(now.year, now.month, 1),
      );
    case ExpensePeriod.custom:
      return DateRange(
        (from ?? now).toUtc(),
        (to ?? now).toUtc().add(const Duration(days: 1)),
      );
  }
}
