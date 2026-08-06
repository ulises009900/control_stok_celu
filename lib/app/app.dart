import 'package:control_stok_celu/app/router.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockApp extends ConsumerWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revision = ref.watch(appSessionRevisionProvider);
    return MaterialApp.router(
      key: ValueKey<int>(revision),
      title: 'Control Stock Celu',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF005A52),
      ),
      routerConfig: appRouter,
    );
  }
}
