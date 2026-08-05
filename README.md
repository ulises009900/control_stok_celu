# Control Stok Celu

Aplicacion mobile offline-first para control de stock por lotes, reservas y ventas, con enfoque en consistencia transaccional y trazabilidad.

## Objetivo

- Gestionar inventario en Android e iOS sin depender de conectividad.
- Mantener integridad de stock por producto y por lote.
- Aplicar FIFO en reservas y ventas.
- Evitar calculos monetarios con float/double en operaciones criticas.
- Auditar operaciones sensibles dentro de la misma transaccion de negocio.

## Arquitectura

- UI: Flutter + Material 3.
- Navegacion: GoRouter.
- Estado/DI: Riverpod.
- Dominio: contratos y use cases en `lib/domain`.
- Datos: Drift + SQLite en `lib/data`.
- Core: errores, utilidades de dinero, impuestos y logging en `lib/core`.

## Stack

- Flutter / Dart
- SQLite
- Drift (ORM + migraciones)
- flutter_riverpod
- go_router
- fl_chart
- flutter_secure_storage

## Requisitos Minimos

- Android 7.0+ (minSdk 24)
- iOS 15.5+

## Estructura de Carpetas

- `lib/app`: bootstrap y router.
- `lib/core`: excepciones y utilidades transversales.
- `lib/domain`: modelos de entrada, repositorios y casos de uso.
- `lib/data/db`: esquema Drift y base local.
- `lib/data/repositories`: implementaciones transaccionales.
- `lib/features`: navegacion y pantallas.
- `test`: pruebas de reglas de negocio, hardening y persistencia.

## Instalacion

1. Obtener dependencias:

```powershell
C:\flutter-sdk\flutter\bin\flutter.bat pub get
```

2. Generar codigo Drift:

```powershell
C:\flutter-sdk\flutter\bin\dart.bat run build_runner build
```

## Ejecucion

```powershell
C:\flutter-sdk\flutter\bin\flutter.bat run
```

## Tests

```powershell
C:\flutter-sdk\flutter\bin\flutter.bat test
```

## Analisis Estatico

```powershell
C:\flutter-sdk\flutter\bin\flutter.bat analyze
```

## Migraciones

### Estado actual

- `schemaVersion = 1`.
- `PRAGMA foreign_keys = ON`.
- `PRAGMA journal_mode = WAL`.
- FTS5 en tabla virtual `products_fts`.

### Como agregar una nueva migracion

1. Incrementar `schemaVersion` en `lib/data/db/app_database.dart`.
2. Agregar logica en `MigrationStrategy.onUpgrade`.
3. Mantener migraciones aditivas y sin perdida de datos.
4. Agregar test de migracion/reapertura para validar persistencia.

## Principios Offline-First

- Todas las operaciones criticas se resuelven en DB local.
- Reglas de negocio ejecutadas en repositorio dentro de transacciones.
- El rollback revierte stock, movimientos y auditoria de forma atomica.

## Reglas Fundamentales de Stock

- `stock_total >= 0`
- `stock_reserved >= 0`
- `stock_reserved <= stock_total`
- `stock_available = stock_total - stock_reserved`

## FIFO por Lotes

- Reservas y ventas consumen lotes por `received_at` ascendente.
- Cada consumo queda trazado en `batch_allocations` y `stock_movements`.

## Convenciones Monetarias

- Valores monetarios en centavos enteros (`int`).
- IVA en basis points (`bps`), por ejemplo 2100 = 21.00%.
- Redondeos explicitos con `.round()` en puntos definidos.

## Auditoria Transaccional

Operaciones criticas registran en `audit_logs`:

- `entity_type`
- `entity_id`
- `action`
- `before_json`
- `after_json`
- `created_at`

La auditoria se escribe en la misma transaccion que el cambio de stock; si falla la operacion, no queda registro fantasma.

## Desarrollo Diario

Flujo recomendado:

1. `flutter pub get`
2. `dart run build_runner build` (si cambia Drift)
3. `flutter analyze`
4. `flutter test`

## Estado de Fase 1

- Base de datos relacional y FTS5 operativos.
- Reglas criticas de stock/reserva/venta con pruebas automatizadas.
- Hardening de duplicados, inexistentes, rollback y persistencia.
