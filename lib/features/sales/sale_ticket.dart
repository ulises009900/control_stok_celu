import 'dart:typed_data';

import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

String saleStatusLabel(String status) => switch (status) {
      'draft' => 'Borrador',
      'sold' => 'Confirmada',
      'reserved' => 'Reservada',
      'cancelled' => 'Cancelada',
      'deleted' => 'Eliminada',
      _ => status,
    };

String ticketMoney(int cents) =>
    '${cents < 0 ? '-' : ''}\$${cents.abs() ~/ 100},${(cents.abs() % 100).toString().padLeft(2, '0')}';

String remitoNumberLabel(int number) {
  if (number < 1) throw ArgumentError.value(number, 'number');
  return number.toString().padLeft(6, '0');
}

String saleTicketFilename(int number) =>
    'remito-${remitoNumberLabel(number)}.pdf';

Future<Uint8List> buildSaleTicketPdf(SaleDetailView detail,
    {required int remitoNumber}) async {
  final sale = detail.sale;
  final date = (sale.confirmedAt ?? sale.createdAt).toLocal();
  final number = remitoNumberLabel(remitoNumber);
  final document = pw.Document(
    title: 'Remito $number',
    author: 'Control Stok',
  );
  document.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(32),
    // Built-in fonts keep PDF creation available offline.
    theme: pw.ThemeData.withFont(
        base: pw.Font.helvetica(), bold: pw.Font.helveticaBold()),
    maxPages: 1000,
    header: (_) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('REMITO',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text('N°: $number'),
        pw.Text(
            'Fecha: ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'),
        pw.Text('Cliente: ${sale.customerName ?? 'Consumidor final'}'),
        pw.SizedBox(height: 16),
      ],
    ),
    footer: (context) => pw.Padding(
      padding: const pw.EdgeInsets.only(top: 12),
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Comprobante no fiscal.',
                style: const pw.TextStyle(fontSize: 9)),
            pw.Text('Página ${context.pageNumber} de ${context.pagesCount}',
                style: const pw.TextStyle(fontSize: 9)),
          ]),
    ),
    build: (_) => [
      pw.TableHelper.fromTextArray(
        headers: [
          'Producto / Código',
          'Cant.',
          'Unitario',
          'Desc.',
          'IVA',
          'Importe'
        ],
        data: detail.lines
            .map((line) => [
                  '${line.productName}\n${line.productCode}',
                  '${line.quantity}',
                  ticketMoney(line.unitPriceCents),
                  ticketMoney(line.discountCents),
                  ticketMoney(line.taxCents),
                  ticketMoney(line.lineTotalCents + line.taxCents),
                ])
            .toList(),
        headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
        cellStyle: const pw.TextStyle(fontSize: 9),
        cellPadding: const pw.EdgeInsets.all(6),
        columnWidths: {
          0: const pw.FlexColumnWidth(3),
          1: const pw.FlexColumnWidth(0.6)
        },
        cellAlignment: pw.Alignment.centerRight,
        cellAlignments: {0: pw.Alignment.centerLeft},
      ),
      pw.SizedBox(height: 16),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child:
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text('Subtotal: ${ticketMoney(sale.subtotalCents)}'),
          pw.Text('Descuento: ${ticketMoney(sale.discountCents)}'),
          pw.Text('IVA: ${ticketMoney(sale.taxCents)}'),
          pw.SizedBox(height: 6),
          pw.Text('TOTAL: ${ticketMoney(sale.totalCents)}',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        ]),
      ),
    ],
  ));
  return document.save();
}
