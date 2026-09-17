import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/domain/cashbox/cashbox_models.dart';
import 'package:control_stok_celu/domain/cashbox/cashbox_repository.dart';
import 'package:drift/drift.dart';

class DriftCashboxRepository implements CashboxRepository {
  DriftCashboxRepository(this._db);

  final AppDatabase _db;
  static const String _statusOpen = 'open';
  static const String _statusClosed = 'closed';
  static const String _saleStatusSold = 'sold';

  @override
  Future<CashSessionSummary?> getOpenSession({String? deviceId}) async {
    final query = _db.select(_db.cashSessions)
      ..where((t) => t.status.equals(_statusOpen));
    if (deviceId != null) {
      query.where((t) => t.deviceId.equals(deviceId));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.openedAt)]);
    final row = await query.getSingleOrNull();
    return row == null ? null : _mapSummary(row);
  }

  @override
  Future<void> openSession(OpenCashSessionInput input) async {
    if (input.openingCents < 0) {
      throw ValidationException('El monto de apertura no puede ser negativo.');
    }
    await _db.transaction(() async {
      final existing = await (_db.select(_db.cashSessions)
            ..where((t) =>
                t.status.equals(_statusOpen) &
                t.deviceId.equals(input.deviceId)))
          .getSingleOrNull();
      if (existing != null) {
        throw ConflictException(
          'Ya hay una caja abierta en este dispositivo. Cerrala antes de abrir otra.',
        );
      }
      final now = DateTime.now().toUtc();
      await _db.into(_db.cashSessions).insert(
            CashSessionsCompanion.insert(
              id: input.id,
              deviceId: input.deviceId,
              userId: Value(input.userId),
              userName: Value(input.userName),
              status: const Value(_statusOpen),
              openingCents: Value(input.openingCents),
              openingNotes: Value(input.notes),
              openedAt: input.openedAt.toUtc(),
              createdAt: now,
              updatedAt: now,
            ),
          );
    });
  }

  @override
  Future<void> registerMovement(RegisterCashMovementInput input) async {
    if (input.amountCents <= 0) {
      throw ValidationException('El importe debe ser mayor a cero.');
    }
    await _db.transaction(() async {
      final session = await (_db.select(_db.cashSessions)
            ..where((t) => t.id.equals(input.sessionId)))
          .getSingleOrNull();
      if (session == null) {
        throw NotFoundException('El turno de caja no existe.');
      }
      if (session.status != _statusOpen) {
        throw ValidationException(
          'No se pueden registrar movimientos en un turno cerrado.',
        );
      }
      final now = DateTime.now().toUtc();
      await _db.into(_db.cashMovements).insert(
            CashMovementsCompanion.insert(
              id: input.id,
              sessionId: input.sessionId,
              type: cashMovementTypeToDb(input.type),
              amountCents: input.amountCents,
              description: Value(input.description),
              deviceId: input.deviceId,
              userId: Value(input.userId),
              createdAt: (input.createdAt ?? now).toUtc(),
              updatedAt: now,
            ),
          );
    });
  }

  @override
  Future<CashSessionDetail> closeSession(CloseCashSessionInput input) async {
    return _db.transaction(() async {
      final session = await (_db.select(_db.cashSessions)
            ..where((t) => t.id.equals(input.sessionId)))
          .getSingleOrNull();
      if (session == null) {
        throw NotFoundException('El turno de caja no existe.');
      }
      if (session.status != _statusOpen) {
        throw ValidationException('El turno de caja ya está cerrado.');
      }
      if (input.countedClosingCents < 0) {
        throw ValidationException('El monto contado no puede ser negativo.');
      }
      final closedAt = input.closedAt.toUtc();
      final arqueo = await _computeArqueo(
        session: session,
        windowEnd: closedAt,
      );
      final expected = arqueo.expectedClosingCents;
      final now = DateTime.now().toUtc();
      await (_db.update(_db.cashSessions)
            ..where((t) => t.id.equals(input.sessionId)))
          .write(
        CashSessionsCompanion(
          status: const Value(_statusClosed),
          closedAt: Value(closedAt),
          expectedClosingCents: Value(expected),
          countedClosingCents: Value(input.countedClosingCents),
          differenceCents: Value(input.countedClosingCents - expected),
          closingNotes: Value(input.notes),
          updatedAt: Value(now),
        ),
      );
      return getSessionDetail(input.sessionId);
    });
  }

  @override
  Future<CashSessionDetail> getSessionDetail(String sessionId) async {
    final session = await (_db.select(_db.cashSessions)
          ..where((t) => t.id.equals(sessionId)))
        .getSingleOrNull();
    if (session == null) {
      throw NotFoundException('El turno de caja no existe.');
    }
    final windowEnd = session.closedAt ?? DateTime.now().toUtc();
    final arqueo = await _computeArqueo(session: session, windowEnd: windowEnd);
    final movementRows = await (_db.select(_db.cashMovements)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return CashSessionDetail(
      id: session.id,
      deviceId: session.deviceId,
      status: cashSessionStatusFromDb(session.status),
      openingCents: session.openingCents,
      openedAt: session.openedAt,
      salesTotalCents: arqueo.salesTotalCents,
      salesCount: arqueo.salesCount,
      expensesTotalCents: arqueo.expensesTotalCents,
      expensesCount: arqueo.expensesCount,
      manualIncomeCents: arqueo.manualIncomeCents,
      manualExpenseCents: arqueo.manualExpenseCents,
      expectedClosingCents: arqueo.expectedClosingCents,
      movements: movementRows.map(_mapMovement).toList(),
      userId: session.userId,
      userName: session.userName,
      closedAt: session.closedAt,
      countedClosingCents: session.countedClosingCents,
      differenceCents: session.differenceCents,
      openingNotes: session.openingNotes,
      closingNotes: session.closingNotes,
    );
  }

  @override
  Future<List<CashSessionSummary>> listSessions({
    String? deviceId,
    int limit = 50,
  }) async {
    final query = _db.select(_db.cashSessions);
    if (deviceId != null) {
      query.where((t) => t.deviceId.equals(deviceId));
    }
    query
      ..orderBy([(t) => OrderingTerm.desc(t.openedAt)])
      ..limit(limit);
    final rows = await query.get();
    return rows.map(_mapSummary).toList();
  }

  Future<_ArqueoTotals> _computeArqueo({
    required CashSession session,
    required DateTime windowEnd,
  }) async {
    final salesRow = await _db.customSelect(
      '''
      SELECT COALESCE(SUM(total_cents), 0) AS total, COUNT(*) AS cnt
      FROM sales
      WHERE status = ?
        AND payment_method = 'cash'
        AND confirmed_at >= ? AND confirmed_at <= ?
      ''',
      variables: <Variable<Object>>[
        Variable<String>(_saleStatusSold),
        Variable<DateTime>(session.openedAt),
        Variable<DateTime>(windowEnd),
      ],
    ).getSingle();
    final expensesRow = await _db.customSelect(
      '''
      SELECT COALESCE(SUM(amount_cents + tax_cents), 0) AS total, COUNT(*) AS cnt
      FROM expenses
      WHERE is_active = 1 AND occurred_at >= ? AND occurred_at <= ?
      ''',
      variables: <Variable<Object>>[
        Variable<DateTime>(session.openedAt),
        Variable<DateTime>(windowEnd),
      ],
    ).getSingle();
    final movements = await (_db.select(_db.cashMovements)
          ..where((t) => t.sessionId.equals(session.id)))
        .get();
    final manualIncome = movements
        .where((m) => m.type == 'income')
        .fold<int>(0, (sum, m) => sum + m.amountCents);
    final manualExpense = movements
        .where((m) => m.type == 'expense')
        .fold<int>(0, (sum, m) => sum + m.amountCents);
    final salesTotal = salesRow.read<int>('total');
    final expensesTotal = expensesRow.read<int>('total');
    final expected = session.openingCents +
        salesTotal +
        manualIncome -
        manualExpense -
        expensesTotal;
    return _ArqueoTotals(
      salesTotalCents: salesTotal,
      salesCount: salesRow.read<int>('cnt'),
      expensesTotalCents: expensesTotal,
      expensesCount: expensesRow.read<int>('cnt'),
      manualIncomeCents: manualIncome,
      manualExpenseCents: manualExpense,
      expectedClosingCents: expected,
    );
  }

  CashSessionSummary _mapSummary(CashSession row) {
    return CashSessionSummary(
      id: row.id,
      deviceId: row.deviceId,
      status: cashSessionStatusFromDb(row.status),
      openingCents: row.openingCents,
      openedAt: row.openedAt,
      userName: row.userName,
      closedAt: row.closedAt,
      expectedClosingCents: row.expectedClosingCents,
      countedClosingCents: row.countedClosingCents,
      differenceCents: row.differenceCents,
    );
  }

  CashMovementItem _mapMovement(CashMovement row) {
    return CashMovementItem(
      id: row.id,
      sessionId: row.sessionId,
      type: cashMovementTypeFromDb(row.type),
      amountCents: row.amountCents,
      createdAt: row.createdAt,
      description: row.description,
      userId: row.userId,
    );
  }

  @override
  Future<CashboxPeriodStats> getPeriodStats({
    required DateTime from,
    required DateTime to,
  }) async {
    final fromUtc = from.toUtc();
    final toUtc = to.toUtc();

    final sessionsRow = await _db.customSelect(
      '''
      SELECT
        COUNT(*) AS total_count,
        COALESCE(SUM(CASE WHEN status = 'open' THEN 1 ELSE 0 END), 0) AS open_count,
        COALESCE(SUM(CASE WHEN status = 'closed' THEN 1 ELSE 0 END), 0) AS closed_count
      FROM cash_sessions
      WHERE opened_at >= ? AND opened_at <= ?
      ''',
      variables: <Variable<Object>>[
        Variable<DateTime>(fromUtc),
        Variable<DateTime>(toUtc),
      ],
    ).getSingle();

    final movementsRow = await _db.customSelect(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN type = 'income' THEN amount_cents ELSE 0 END), 0) AS income,
        COALESCE(SUM(CASE WHEN type = 'expense' THEN amount_cents ELSE 0 END), 0) AS expense
      FROM cash_movements
      WHERE created_at >= ? AND created_at <= ?
      ''',
      variables: <Variable<Object>>[
        Variable<DateTime>(fromUtc),
        Variable<DateTime>(toUtc),
      ],
    ).getSingle();

    final differenceRow = await _db.customSelect(
      '''
      SELECT
        COALESCE(SUM(difference_cents), 0) AS total_difference,
        COALESCE(SUM(CASE WHEN difference_cents != 0 THEN 1 ELSE 0 END), 0) AS with_difference_count
      FROM cash_sessions
      WHERE status = 'closed' AND closed_at >= ? AND closed_at <= ?
      ''',
      variables: <Variable<Object>>[
        Variable<DateTime>(fromUtc),
        Variable<DateTime>(toUtc),
      ],
    ).getSingle();

    return CashboxPeriodStats(
      sessionsCount: sessionsRow.read<int>('total_count'),
      openSessionsCount: sessionsRow.read<int>('open_count'),
      closedSessionsCount: sessionsRow.read<int>('closed_count'),
      manualIncomeCents: movementsRow.read<int>('income'),
      manualExpenseCents: movementsRow.read<int>('expense'),
      totalDifferenceCents: differenceRow.read<int>('total_difference'),
      closedSessionsWithDifferenceCount:
          differenceRow.read<int>('with_difference_count'),
    );
  }
}

class _ArqueoTotals {
  const _ArqueoTotals({
    required this.salesTotalCents,
    required this.salesCount,
    required this.expensesTotalCents,
    required this.expensesCount,
    required this.manualIncomeCents,
    required this.manualExpenseCents,
    required this.expectedClosingCents,
  });

  final int salesTotalCents;
  final int salesCount;
  final int expensesTotalCents;
  final int expensesCount;
  final int manualIncomeCents;
  final int manualExpenseCents;
  final int expectedClosingCents;
}
