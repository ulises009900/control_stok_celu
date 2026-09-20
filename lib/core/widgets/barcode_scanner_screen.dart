import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final _controller = MobileScannerController();
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Escanear código de barras')),
    body: Column(children: [
      const Padding(padding: EdgeInsets.all(16), child: Text('Apuntá la cámara al código de barras del producto.')),
      Expanded(child: MobileScanner(
        controller: _controller,
        errorBuilder: (_, __) => const Center(child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No se pudo abrir la cámara. Revisá el permiso de cámara o ingresá el código en el buscador.', textAlign: TextAlign.center),
        )),
        onDetect: (capture) {
          if (_handled) return;
          final value = capture.barcodes.map((b) => b.rawValue?.trim() ?? '').firstWhere((s) => s.isNotEmpty, orElse: () => '');
          if (value.isEmpty) return;
          _handled = true;
          Navigator.pop(context, value);
        },
      )),
    ]),
  );
}
