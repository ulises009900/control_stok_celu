import 'dart:convert';
import 'dart:io';

import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/sales/sale_ticket.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  SaleDetailView detail(String status) => SaleDetailView(
        sale: SaleListItem(
          id: 'ticket-1',
          status: status,
          customerId: null,
          customerName: 'José & María',
          productCount: 1,
          unitsCount: 2,
          subtotalCents: 2000,
          taxCents: 399,
          discountCents: 100,
          totalCents: 2299,
          profitCents: 876,
          createdAt: DateTime(2026, 1, 2),
        ),
        notes: 'Nota interna privada',
        lines: const [
          SaleLineView(
            id: 'line-1',
            productId: 'product-1',
            productName: 'Café',
            productCode: 'ABC',
            quantity: 2,
            unitPriceCents: 1000,
            unitCostCents: 543,
            taxRateBps: 2100,
            taxCents: 399,
            discountCents: 100,
            lineTotalCents: 1900,
            lineProfitCents: 876,
          )
        ],
      );

  String pdfContent(List<int> bytes) {
    final raw = latin1.decode(bytes);
    final streams = RegExp(r'stream\r?\n([\s\S]*?)\r?\nendstream')
        .allMatches(raw)
        .map((match) {
      final stream = match.group(1)!;
      return stream.codeUnitAt(0) == 0x78
          ? latin1.decode(zlib.decode(latin1.encode(stream)))
          : stream;
    }).join();
    return RegExp(r'\(([^)]*)\)')
        .allMatches(streams)
        .map((match) => match.group(1)!)
        .join(' ');
  }

  test('PDF includes amounts but excludes costs and internal notes', () async {
    final content =
        pdfContent(await buildSaleTicketPdf(detail('sold'), remitoNumber: 12));
    expect(content, contains('ABC'));
    expect(content, contains('22,99'));
    expect(content, isNot(contains('5,43')));
    expect(content, isNot(contains('8,76')));
    expect(content, isNot(contains('Nota interna privada')));
  });

  test('all remitos have only a numeric number and no sale status', () async {
    for (final status in ['draft', 'sold', 'reserved']) {
      final content = pdfContent(
          await buildSaleTicketPdf(detail(status), remitoNumber: 12));
      expect(content, contains('REMITO'));
      expect(content, contains('000012'));
      for (final forbidden in [
        'ticket-1',
        'TICKET',
        'PRESUPUESTO',
        'BORRADOR',
        'Estado',
        'SIN CONFIRMAR',
        'Confirmada',
        'Reservada'
      ]) {
        expect(content, isNot(contains(forbidden)));
      }
    }
    expect(saleTicketFilename(12), 'remito-000012.pdf');
  });

  test('generates a real PDF for both drafts and confirmed sales', () async {
    for (final status in ['draft', 'sold']) {
      final bytes = await buildSaleTicketPdf(detail(status), remitoNumber: 12);
      final pdf = latin1.decode(bytes);
      expect(pdf, startsWith('%PDF-'));
      expect(pdf.trimRight(), endsWith('%%EOF'));
      expect(RegExp(r'/Type\s*/Page\b').allMatches(pdf), hasLength(1));
    }
  });

  test('long tickets paginate without dropping products', () async {
    final original = detail('sold');
    final longTicket = SaleDetailView(
      sale: original.sale,
      lines: List.generate(150, (_) => original.lines.single),
    );
    final bytes = await buildSaleTicketPdf(longTicket, remitoNumber: 12);
    final pdf = latin1.decode(bytes);
    expect('ABC'.allMatches(pdfContent(bytes)), hasLength(150));
    expect(RegExp(r'/Type\s*/Page\b').allMatches(pdf).length, greaterThan(1));
    expect(pdf.trimRight(), endsWith('%%EOF'));
  });
}
