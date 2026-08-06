# Control Stok Celu

Aplicación Flutter offline-first para gestión diaria de stock, lotes, reservas, ventas, gastos y contabilidad operativa local.

## Principios del producto

- 100% offline.
- SQLite + Drift como fuente de verdad.
- Sin backend, sin cloud y sin sincronización.
- Dinero en centavos enteros.
- Auditoría transaccional para operaciones críticas.
- Backup y restore local manual.

## Plataformas objetivo

- Android 7.0+ (`minSdk 24`)
- iOS 15.5+

## Arquitectura

- UI: Flutter + Material 3
- Navegación: GoRouter
- Estado: Riverpod
- Persistencia: SQLite + Drift
- Dominio: `lib/domain`
- Datos: `lib/data`
- Features: `lib/features`

## Módulos principales

- Productos
- Inventario
- Lotes y FIFO
- Proveedores
- Clientes
- Ventas
- Reservas
- Gastos
- Dashboard
- Reportes operativos
- Notas
- Recordatorios y checklist
- Configuración
- Backup/restore local

## Desarrollo local

### Dependencias

```powershell
flutter pub get
```

### Generar código Drift

```powershell
dart run build_runner build
```

### Ejecutar la app

```powershell
flutter run
```

### Análisis estático

```powershell
flutter analyze
```

### Tests

```powershell
flutter test
```

## Base de datos

- Archivo principal: `control_stok_celu.sqlite`
- `schemaVersion = 4`
- `PRAGMA foreign_keys = ON`
- `PRAGMA journal_mode = WAL`
- Búsqueda FTS5 en productos

## Reglas críticas de stock

- `stock_total >= 0`
- `stock_reserved >= 0`
- `stock_reserved <= stock_total`
- `stock_available = stock_total - stock_reserved`

## Convenciones monetarias

- Todos los importes se guardan en centavos (`int`)
- IVA en basis points (`bps`)
- Sin `double` para dinero persistido

## Auditoría

Las operaciones críticas escriben en `audit_logs` dentro de la misma transacción:

- `entity_type`
- `entity_id`
- `action`
- `before_json`
- `after_json`
- `created_at`

## Backup local

Desde Configuración se puede:

- Exportar una copia local manual de la base
- Validar integridad antes del backup
- Restaurar un backup local validado
- Crear automáticamente un backup de seguridad antes del restore

El backup es local y manual. No usa nube ni Internet.

## Migraciones

Las migraciones son defensivas y se prueban en tests. No deben asumir que una tabla antigua existe o que una columna previa está presente.

## Android release

Flujo recomendado:

```powershell
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

Si el NDK local está corrupto, eliminar la carpeta dañada y permitir que Gradle la vuelva a descargar.

## iOS

Configuración verificada en código:

- Display name: `Control Stok Celu`
- Deployment target: iOS 15.5+

La compilación final de iOS requiere validación en macOS/Xcode.

## Limitaciones deliberadas

No incluye:

- AFIP
- Facturación electrónica
- Backend
- Sincronización
- Nube
- Multiusuario
- Multi-dispositivo
