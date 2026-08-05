import 'dart:convert';
import 'dart:io';

import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('real operational flow persists end to end', () async {
    final file =
        File('${Directory.systemTemp.path}/control_stok_full_flow.sqlite');
    if (file.existsSync()) {
      file.deleteSync();
    }

    var database = AppDatabase(executor: NativeDatabase(file));
    var repository = DriftStockRepository(database);
    final now = DateTime.now().toUtc();

    await repository.createCategory(
      const CategoryUpsertInput(id: 'cat-flow', name: 'Bebidas'),
    );
    await repository.createSupplier(
      const SupplierUpsertInput(id: 'sup-flow', name: 'Proveedor Flow'),
    );
    await repository.createCustomer(
      const CustomerUpsertInput(id: 'cus-flow', name: 'Cliente Flow'),
    );
    await repository.createProductProfile(
      const ProductUpsertInput(
        id: 'prod-flow',
        name: 'Producto Flow',
        internalCode: 'FLOW-001',
        categoryId: 'cat-flow',
        costCents: 1000,
        salePriceCents: 2000,
      ),
    );
    await repository.receiveStock(
      ReceiveStockInput(
        batchId: 'batch-flow-a',
        productId: 'prod-flow',
        quantity: 5,
        unitCostCents: 1000,
        supplierId: 'sup-flow',
        receivedAt: now,
      ),
    );
    await repository.receiveStock(
      ReceiveStockInput(
        batchId: 'batch-flow-b',
        productId: 'prod-flow',
        quantity: 5,
        unitCostCents: 1000,
        supplierId: 'sup-flow',
        receivedAt: now.add(const Duration(minutes: 1)),
      ),
    );

    await repository.saveSaleDraft(
      SaleDraftUpsertInput(
        saleId: 'sale-flow',
        createdAt: now,
        customerId: 'cus-flow',
        lines: const <SaleLineDraftInput>[
          SaleLineDraftInput(
            itemId: 'sale-line-flow',
            productId: 'prod-flow',
            quantity: 3,
            unitPriceCents: 2000,
            taxRateBps: 2100,
            discountCents: 100,
          ),
        ],
      ),
    );

    var stock = await repository.getProductStock('prod-flow');
    expect(stock.stockTotal, 10);
    expect(stock.stockReserved, 0);

    await repository.reserveSaleDraft(
        'sale-flow', now.add(const Duration(hours: 1)));
    stock = await repository.getProductStock('prod-flow');
    expect(stock.stockTotal, 10);
    expect(stock.stockReserved, 3);

    await repository.confirmReservationSale(
      ConfirmSaleInput(
        saleId: 'sale-flow',
        reservationId: 'sale-flow',
        confirmedAt: now.add(const Duration(hours: 2)),
      ),
    );
    stock = await repository.getProductStock('prod-flow');
    expect(stock.stockTotal, 7);
    expect(stock.stockReserved, 0);

    final saleDetail = await repository.getSaleDetail('sale-flow');
    expect(saleDetail.sale.taxCents, 1239);
    expect(saleDetail.sale.discountCents, 100);
    expect(saleDetail.sale.profitCents, 2900);

    await repository.createExpenseCategory(
      const ExpenseCategoryUpsertInput(id: 'exp-cat-flow', name: 'Servicios'),
    );
    await repository.createExpense(
      const ExpenseUpsertInput(
        id: 'exp-flow',
        description: 'Internet',
        categoryId: 'exp-cat-flow',
        amountCents: 500,
        occurredAt: '2026-08-04',
        supplierId: 'sup-flow',
      ),
    );

    final dashboard = await repository.getDashboardSummary(
      const DashboardQuery(period: DashboardPeriod.thisMonth),
    );
    expect(dashboard.salesCount, 1);
    expect(dashboard.expensesCents, 500);
    expect(dashboard.inventory.totalProducts, greaterThanOrEqualTo(1));

    await database.into(database.notes).insert(
          NotesCompanion.insert(
            id: 'note-flow',
            title: 'Nota Flow',
            content: 'Contenido',
            tagsJson: Value(jsonEncode(<String>['flow'])),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await database.into(database.reminders).insert(
          RemindersCompanion.insert(
            id: 'reminder-flow',
            title: 'Cobrar',
            dueAt: now,
          ),
        );
    await database.into(database.checklists).insert(
          ChecklistsCompanion.insert(
            id: 'check-flow',
            title: 'Checklist Flow',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await database.into(database.checklistItems).insert(
          ChecklistItemsCompanion.insert(
            id: 'check-item-flow',
            checklistId: 'check-flow',
            textValue: 'Paso 1',
          ),
        );
    await database.into(database.settings).insertOnConflictUpdate(
          SettingsCompanion.insert(
            key: 'business_name',
            valueJson: jsonEncode('Mi negocio'),
            updatedAt: now,
          ),
        );

    await database.close();

    database = AppDatabase(executor: NativeDatabase(file));
    repository = DriftStockRepository(database);

    stock = await repository.getProductStock('prod-flow');
    expect(stock.stockTotal, 7);
    expect(stock.stockReserved, 0);
    expect(await repository.getCustomerDetail('cus-flow'), isNotNull);
    expect((await database.select(database.notes).get()).length, 1);
    expect((await database.select(database.reminders).get()).length, 1);
    expect((await database.select(database.checklists).get()).length, 1);
    expect((await database.select(database.checklistItems).get()).length, 1);
    expect((await database.select(database.settings).get()).length, 1);

    await database.close();
    if (file.existsSync()) {
      file.deleteSync();
    }
  });
}
