import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/expenses/expenses_screen.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  Future<void> pumpExpensesApp(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ExpensesScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('open expenses screen and show empty state',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await pumpExpensesApp(tester, db);
    expect(find.text('Gastos'), findsOneWidget);
    expect(find.text('No hay gastos para mostrar.'), findsOneWidget);
    await db.close();
  });

  testWidgets('create expense from form and show summary',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createExpenseCategory(
      const ExpenseCategoryUpsertInput(id: 'exp-cat-ui', name: 'Servicios'),
    );

    await pumpExpensesApp(tester, db);

    await tester.tap(find.byTooltip('Nuevo gasto'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Descripción *'), 'Hosting');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Importe *'), '12000');
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar gasto'));
    await tester.pumpAndSettle();

    expect(find.text('Hosting'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);

    await db.close();
  });
}
