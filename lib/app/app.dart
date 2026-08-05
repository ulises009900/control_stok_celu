import 'package:control_stok_celu/app/router.dart';
import 'package:flutter/material.dart';

class StockApp extends StatelessWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Control Stock Celu',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF005A52),
      ),
      routerConfig: appRouter,
    );
  }
}
