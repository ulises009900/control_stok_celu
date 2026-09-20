import 'dart:async';
import 'package:control_stok_celu/app/router.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockApp extends ConsumerStatefulWidget {
  const StockApp({super.key});

  @override
  ConsumerState<StockApp> createState() => _StockAppState();
}

class _StockAppState extends ConsumerState<StockApp>
    with WidgetsBindingObserver {
  Timer? _expiryTimer;
  bool _expiring = false;
  Future<void> _expireReservations() async {
    if (_expiring || !mounted) return;
    _expiring = true;
    try {
      await ref.read(stockRepositoryProvider).expireReservations(DateTime.now().toUtc());
    } catch (error) {
      debugPrint('No se pudieron vencer reservas: $error');
    } finally {
      _expiring = false;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _expireReservations());
    _expiryTimer = Timer.periodic(const Duration(minutes: 1), (_) => _expireReservations());
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Sincroniza también al volver a primer plano, además del disparador
    // periódico automático (ver kAutoSyncInterval), para que los datos de
    // todos los usuarios (caja, ventas, etc.) estén al día lo antes posible.
    if (state == AppLifecycleState.resumed) {
      _expireReservations();
      ref.read(syncControllerProvider.notifier).syncNow(silent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mantiene vivo el controlador de sincronización desde el arranque de la
    // app para que la sincronización automática en segundo plano funcione
    // aunque el usuario nunca visite la pantalla de configuración.
    ref.watch(syncControllerProvider);
    final revision = ref.watch(appSessionRevisionProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      key: ValueKey<int>(revision),
      title: 'Control Stock Celu',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF005A52),
      ),
      routerConfig: router,
    );
  }
}
