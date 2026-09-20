import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('old pending drafts stay visible and support pagination and search',
      () async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(db.close);
    final repository = DriftStockRepository(db);
    await repository.createProductProfile(const ProductUpsertInput(
      id: 'p',
      name: 'Producto',
      internalCode: 'P',
      salePriceCents: 1000,
      costCents: 500,
    ));
    for (final id in ['old-a', 'old-b']) {
      await repository.saveSaleDraft(SaleDraftUpsertInput(
        saleId: id,
        createdAt: DateTime.utc(2020),
        lines: [
          SaleLineDraftInput(
              itemId: 'line-$id',
              productId: 'p',
              quantity: 1,
              unitPriceCents: 1000,
              taxRateBps: 0,
              discountCents: 0),
        ],
      ));
    }
    final first = await repository
        .listSales(const SaleQuery(status: SaleStatusFilter.draft, limit: 1));
    final second = await repository.listSales(
        const SaleQuery(status: SaleStatusFilter.draft, limit: 1, offset: 1));
    expect(first, hasLength(1));
    expect(second, hasLength(1));
    expect(first.single.id, isNot(second.single.id));
    final found = await repository.listSales(
        const SaleQuery(status: SaleStatusFilter.draft, search: 'old-a'));
    expect(found.single.id, 'old-a');
    expect(
        await repository
            .listSales(const SaleQuery(status: SaleStatusFilter.sold)),
        isEmpty);
  });
}
