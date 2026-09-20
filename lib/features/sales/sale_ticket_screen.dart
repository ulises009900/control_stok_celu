import 'dart:typed_data';

import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/repositories/remito_number_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/sales/sale_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

class SaleTicketScreen extends ConsumerStatefulWidget {
  const SaleTicketScreen({required this.detail, super.key});

  final SaleDetailView detail;

  @override
  ConsumerState<SaleTicketScreen> createState() => _SaleTicketScreenState();
}

class _SaleTicketScreenState extends ConsumerState<SaleTicketScreen> {
  late Future<Uint8List> _pdf;
  int? _remitoNumber;
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  Future<Uint8List> _generate() async {
    final repository = RemitoNumberRepository(ref.read(appDatabaseProvider));
    final number = await repository.getOrCreate(widget.detail.sale.id);
    _remitoNumber = number;
    return buildSaleTicketPdf(widget.detail, remitoNumber: number);
  }

  Future<void> _share(Uint8List bytes, BuildContext buttonContext) async {
    if (_sharing) return;
    final box = buttonContext.findRenderObject()! as RenderBox;
    final bounds = box.localToGlobal(Offset.zero) & box.size;
    setState(() => _sharing = true);
    try {
      await Printing.sharePdf(
        bytes: bytes,
        filename: saleTicketFilename(_remitoNumber!),
        bounds: bounds,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo compartir el PDF. Volvé a intentarlo.'),
      ));
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Remito')),
        body: FutureBuilder<Uint8List>(
          future: _pdf,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      'No pudimos generar el remito. Volvé a intentarlo.',
                      textAlign: TextAlign.center),
                ),
                TextButton(
                  onPressed: () => setState(() => _pdf = _generate()),
                  child: const Text('Reintentar'),
                ),
              ]));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final bytes = snapshot.data!;
            return Column(children: [
              Expanded(
                  child: PdfPreview(
                build: (_) async => bytes,
                useActions: false,
                canDebug: false,
                canChangePageFormat: false,
                canChangeOrientation: false,
                onError: (_, __) => const Center(
                    child: Text(
                        'No se pudo mostrar la vista previa. Podés compartir el PDF.')),
              )),
              SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      const Text(
                          'Elegí WhatsApp en el menú para enviar el PDF como archivo.'),
                      const SizedBox(height: 8),
                      Builder(
                          builder: (buttonContext) => FilledButton.icon(
                                onPressed: _sharing
                                    ? null
                                    : () => _share(bytes, buttonContext),
                                icon: const Icon(Icons.share),
                                label: Text(
                                    _sharing ? 'Abriendo...' : 'Compartir PDF'),
                              )),
                    ]),
                  )),
            ]);
          },
        ),
      );
}
