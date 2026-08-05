import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('expenses module', () {
    late AppDatabase database;
    late DriftStockRepository repository;

    setUp(() {
      database = AppDatabase(executor: NativeDatabase.memory());
      repository = DriftStockRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('create, read, edit and logical delete expense', () async {
      await repository.createExpenseCategory(
        const ExpenseCategoryUpsertInput(id: 'exp-cat-1', name: 'Servicios'),
      );

      await repository.createExpense(
        const ExpenseUpsertInput(
          id: 'exp-1',
          description: 'Internet',
          categoryId: 'exp-cat-1',
          amountCents: 15000,
          occurredAt: '2026-08-01',
          notes: 'Mensual',
        ),
      );

      final detail = await repository.getExpenseDetail('exp-1');
      expect(detail.description, 'Internet');
      expect(detail.amountCents, 15000);

      await repository.updateExpense(
        const ExpenseUpsertInput(
          id: 'exp-1',
          description: 'Internet Premium',
          categoryId: 'exp-cat-1',
          amountCents: 17000,
          occurredAt: '2026-08-02',
          notes: 'Actualizado',
        ),
      );

      final updated = await repository.getExpenseDetail('exp-1');
      expect(updated.description, 'Internet Premium');
      expect(updated.amountCents, 17000);

      await repository.logicalDeleteExpense('exp-1');
      final summary = await repository.getExpenseSummary(
        const ExpenseQuery(period: ExpensePeriod.thisMonth),
      );
      expect(summary.totalAmountCents, 0);
      expect(summary.count, 0);
    });

    test('reject invalid category and amount', () async {
      await expectLater(
        () => repository.createExpense(
          const ExpenseUpsertInput(
            id: 'exp-invalid',
            description: 'Falla',
            categoryId: 'missing',
            amountCents: 0,
            occurredAt: '2026-08-01',
          ),
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('apply filters and persist across reopen', () async {
      await repository.createExpenseCategory(
        const ExpenseCategoryUpsertInput(id: 'exp-cat-2', name: 'Combustible'),
      );
      await repository.createExpense(
        const ExpenseUpsertInput(
          id: 'exp-2',
          description: 'Gasolina',
          categoryId: 'exp-cat-2',
          amountCents: 22000,
          occurredAt: '2026-08-10',
        ),
      );

      final filtered = await repository.listExpenses(
        const ExpenseQuery(
          period: ExpensePeriod.thisMonth,
          categoryId: 'exp-cat-2',
        ),
      );
      expect(filtered.any((expense) => expense.id == 'exp-2'), isTrue);

      await database.close();
      database = AppDatabase(executor: NativeDatabase.memory());
      repository = DriftStockRepository(database);
      final reopened = await repository.listExpenses(
        const ExpenseQuery(period: ExpensePeriod.thisMonth),
      );
      expect(reopened, isEmpty);
    });
  });
}
