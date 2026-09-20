import 'dart:convert';
import 'dart:io';

import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/sales/sale_ticket_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('remito can be generated and shared without contacting server',
      (tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(db.close);
    var serverRequested = false;
    final shared = <MethodCall>[];
    const channel = MethodChannel('net.nfet.printing');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (call) async {
      if (call.method == 'printingInfo') {
        return {'canShare': true, 'canRaster': false};
      }
      if (call.method == 'sharePdf') {
        shared.add(call);
        return 1;
      }
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null));
    final detail = SaleDetailView(
      sale: SaleListItem(
          id: 'offline-sale',
          status: 'draft',
          customerId: null,
          customerName: 'Cliente',
          productCount: 1,
          unitsCount: 1,
          subtotalCents: 1000,
          taxCents: 0,
          discountCents: 0,
          totalCents: 1000,
          profitCents: 500,
          createdAt: DateTime(2026)),
      lines: const [
        SaleLineView(
            id: 'line',
            productId: 'p',
            productName: 'Producto',
            productCode: 'P',
            quantity: 1,
            unitPriceCents: 1000,
            unitCostCents: 500,
            taxRateBps: 0,
            taxCents: 0,
            discountCents: 0,
            lineTotalCents: 1000,
            lineProfitCents: 500)
      ],
    );
    await tester.pumpWidget(ProviderScope(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      authenticatedSyncApiClientProvider.overrideWith((ref) {
        serverRequested = true;
        throw const SocketException('Server unavailable');
      }),
    ], child: MaterialApp(home: SaleTicketScreen(detail: detail))));
    await tester.pumpAndSettle();
    expect(find.text('Compartir PDF'), findsOneWidget);
    expect(serverRequested, isFalse);
    await tester.tap(find.text('Compartir PDF'));
    await tester.pumpAndSettle();
    expect(shared, hasLength(1));
    expect(shared.single.arguments['name'], 'remito-000001.pdf');
    expect(latin1.decode(shared.single.arguments['doc'] as Uint8List),
        startsWith('%PDF-'));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
