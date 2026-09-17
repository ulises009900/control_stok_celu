# Control Stok Celu

Aplicación Flutter offline-first para gestión diaria de stock, lotes, reservas, ventas, gastos, caja y contabilidad operativa, con sincronización opcional multi-dispositivo contra un servidor central.

## Principios del producto

- Offline-first: SQLite + Drift es la fuente de verdad en cada teléfono.
- Sincronización opcional: si se configura un servidor (ver `server/`), los cambios se envían/reciben en segundo plano; sin conexión, la app sigue funcionando 100% local y se pone al día sola cuando vuelve la señal.
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
- Persistencia local: SQLite + Drift
- Sincronización: `lib/data/sync` (motor genérico) + API en `server/` (Node/Express + PostgreSQL)
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
- Caja (apertura/cierre de turno, ingresos/egresos manuales, arqueo automático)
- Dashboard
- Reportes operativos
- Notas
- Recordatorios y checklist
- Configuración (incluye conexión/sincronización con el servidor)
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
- `schemaVersion = 5`
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

El backup es local y manual, independiente de la sincronización con el servidor.

## Caja

Módulo de control de caja (`lib/features/cashbox`, `lib/domain/cashbox`):

- Apertura de turno con monto inicial en efectivo, por dispositivo.
- Registro de ingresos y egresos manuales durante el turno.
- Cierre de turno con arqueo automático: compara lo contado contra
  `apertura + ventas confirmadas + ingresos manuales − egresos manuales − gastos activos`
  del período del turno, mostrando sobrante/faltante.
- Historial de turnos y detalle con el desglose completo del arqueo.

Nota: como las ventas todavía no distinguen medio de pago, el arqueo asume que las ventas confirmadas se cobran en efectivo. Los gastos sí se descuentan siempre.

## Login y roles

Al abrir la app por primera vez, pide iniciar sesión (usuario/contraseña del
servidor de sincronización). Una vez logueado, la sesión queda activa hasta
que alguien presione "Cerrar sesión" en Configuración; ese mismo usuario
queda recordado en el dispositivo (hash local) para poder volver a entrar
sin conexión.

Dos roles (`lib/domain/auth/user_role.dart`):

- **Administrador**: acceso total.
- **Vendedor/Empleado**: carga ventas, reservas y su propia caja; ve
  productos y clientes con lo básico (nombre, precio de venta, teléfono),
  sin costos/ganancias ni permisos para crear/editar/eliminar, y sin acceso
  a proveedores, gastos, estadísticas, reportes ni configuración del
  negocio/backup.

El control de acceso se aplica en dos capas: el router (`lib/app/router.dart`)
bloquea la navegación a rutas de administrador para el rol vendedor, y cada
pantalla oculta además los botones/datos correspondientes.

## Sincronización multi-dispositivo (opcional)

Ver [server/README.md](server/README.md) para el detalle completo del backend. Resumen:

- Backend en `server/`: Node.js + Express + PostgreSQL (puerto 3433 vía `docker-compose.yml`), con login JWT y dos roles (`admin`/jefe y `vendedor`).
- Cada teléfono sigue usando SQLite localmente (offline-first); el login inicial (obligatorio) es contra ese mismo servidor, y desde ahí la app sincroniza en segundo plano (botón "Sincronizar ahora" en Configuración): sube los cambios locales pendientes y baja los cambios de otros dispositivos.
- Motor genérico (`lib/data/sync/sync_engine.dart` + `server/src/sync`): agregar una tabla nueva al sync no requiere un endpoint a medida, solo una entrada de configuración en ambos lados (ver comentarios en `lib/data/sync/sync_tables.dart` y `server/src/sync/registry.js`).
- Tablas sincronizadas hoy: categorías, proveedores, clientes, productos (con su stock), movimientos de stock, ventas (con sus líneas), gastos y categorías de gasto (solo el rol admin), y caja (turnos y movimientos, cada vendedor ve solo los suyos; el admin ve todos).
- Reservas, lotes/FIFO, compras, notas y tareas todavía no sincronizan: quedan como próximo paso siguiendo el mismo patrón.
- Resolución de conflictos: "última escritura gana" comparando `updated_at`.

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

No incluye (todavía):

- AFIP
- Facturación electrónica
- Sincronización de reservas, lotes/FIFO, compras, notas y tareas (solo catálogo/stock, ventas, gastos y caja por ahora)
- Multi-tenant (el servidor está pensado para un único negocio con varios dispositivos, no para alojar varios comercios independientes)

