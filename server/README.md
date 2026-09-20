# Control Stok Celu — servidor de sincronización

API central para que los teléfonos de la tienda (2 vendedores + el jefe)
compartan un único catálogo de productos/stock, ventas, gastos y control de
caja, manteniendo cada teléfono 100% funcional offline (SQLite local) y
poniéndose al día solo cuando hay conexión.

- **Node.js + Express**: API HTTP.
- **PostgreSQL**: base de datos central, pensada para escuchar en el puerto
  **3433** (no el 5432 estándar, para no chocar con otra instancia de
  Postgres que ya tengas instalada).
- **JWT + roles**: `admin` (el jefe, ve y sincroniza todo) y `vendedor`
  (carga ventas/caja/stock, no ve gastos y en caja solo ve su propio turno).

## Opción recomendada: todo con Docker Compose (Postgres + API juntos)

Si tenés Docker instalado en tu servidor (Linux, Windows o Raspberry Pi),
`docker-compose.yml` levanta **Postgres y la API juntos** con un solo
comando, sin instalar Node.js ni PostgreSQL a mano.

```bash
cd server
cp .env.example .env
nano .env   # cambiá al menos JWT_SECRET y SEED_ADMIN_PASSWORD
docker compose up -d --build
```

Esto:

- Levanta Postgres en el puerto **3433** (`localhost:3433` desde el propio
  servidor), con los datos guardados en un volumen persistente (no se
  pierden si reiniciás el contenedor).
- Construye la imagen de la API y la levanta en el puerto **4000**,
  corriendo las migraciones automáticamente en cada arranque (son
  idempotentes) y creando el usuario admin inicial la primera vez.

Verificar que quedó todo arriba:

```bash
docker compose ps
curl http://localhost:4000/health
```

Para ver los logs en vivo: `docker compose logs -f api`.
Para detener todo: `docker compose down` (los datos de Postgres persisten;
para borrarlos también: `docker compose down -v`).

Como los servicios tienen `restart: unless-stopped`, si el servidor se
reinicia (corte de luz, reinicio manual, etc.) Docker los vuelve a levantar
solo, sin que tengas que correr nada de nuevo.

Con este camino podés saltar directo al paso **"Crear los usuarios de los
vendedores"** más abajo — no hace falta instalar Node.js en el servidor.

## Opción alternativa: Postgres con Docker + API con Node.js instalado a mano

Si preferís correr la API directamente con Node (por ejemplo para
desarrollarla o depurarla más fácil), seguí estos pasos:

### 1. Levantar solo PostgreSQL en el puerto 3433

```bash
cd server
docker compose up -d postgres
```

Esto crea un contenedor de Postgres 16 escuchando en `localhost:3433`, con
usuario `control_stok`, contraseña `control_stok_password` y base
`control_stok_celu` (ver `docker-compose.yml` para cambiarlos).

Si no tenés Docker, cualquier PostgreSQL que puedas configurar para
escuchar en el puerto 3433 sirve igual; solo ajustá `DATABASE_URL` en tu
`.env`.

### 2. Configurar variables de entorno

```bash
cd server
cp .env.example .env
```

Editá `.env` y como mínimo cambiá `JWT_SECRET` y las credenciales del admin
inicial (`SEED_ADMIN_USERNAME` / `SEED_ADMIN_PASSWORD`).

### 3. Instalar Node.js 20+, dependencias y migrar

En Debian/Ubuntu (incluye Raspberry Pi OS):

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

Luego:

```bash
cd server
npm install
npm run migrate
```

`npm run migrate` crea todas las tablas y, si todavía no existe ningún
usuario, crea automáticamente el usuario admin definido en `.env`.

## Crear los usuarios de los vendedores

Con Docker Compose (opción recomendada):

```bash
docker compose exec api node scripts/create_user.js vendedor1 "una-clave-segura" vendedor "Nombre del vendedor 1"
docker compose exec api node scripts/create_user.js vendedor2 "otra-clave-segura" vendedor "Nombre del vendedor 2"
```

Con Node.js instalado a mano:

```bash
npm run create-user -- vendedor1 "una-clave-segura" vendedor "Nombre del vendedor 1"
npm run create-user -- vendedor2 "otra-clave-segura" vendedor "Nombre del vendedor 2"
```

(El comando también sirve para crear otro admin o para resetear una
contraseña: es un upsert por `username`.)

## Levantar la API (solo si no usaste Docker Compose para todo)

```powershell
npm start
```

Por defecto escucha en el puerto 4000 (`API_PORT` en `.env`; no confundir
con el 3433 de Postgres). Para desarrollo con recarga automática:
`npm run dev`.

## Conectar los teléfonos

Primero asegurate de que los teléfonos puedan llegar al puerto 4000 del
servidor:

- **Averiguar la IP del servidor en la red local:**
  ```bash
  hostname -I
  # o
  ip addr show | grep "inet "
  ```
  Vas a ver algo como `192.168.0.10`.
- **Abrir el puerto 4000 en el firewall** (si usás `ufw`, típico en
  Debian/Ubuntu/Raspberry Pi OS):
  ```bash
  sudo ufw allow 4000/tcp
  ```
  (El puerto 3433 de Postgres NO hace falta abrirlo a la red: solo la API
  necesita hablar con Postgres, y eso pasa dentro del propio servidor / red
  interna de Docker.)
- Los teléfonos deben estar conectados **al mismo WiFi/red** que el
  servidor.

Al abrir la app por primera vez, va a pedir login obligatorio con:

- **URL del servidor**: por ejemplo `http://192.168.0.10:4000` (la IP del
  servidor donde corre la API, accesible desde la red local del negocio).
- **Usuario/contraseña**: los creados en "Crear los usuarios de los
  vendedores" (o el admin definido en tu `.env`).

Ese primer login necesita conexión (valida contra el servidor). Una vez
logueado, el teléfono queda con sesión iniciada hasta que alguien presione
"Cerrar sesión" manualmente (en Configuración) — cerrar y volver a abrir la
app NO vuelve a pedir el login. Además, ese mismo usuario/contraseña queda
recordado en el dispositivo (con un hash local, nunca en texto plano), así
que si el teléfono se queda sin conexión, esa misma persona puede volver a
iniciar sesión en ese dispositivo sin internet.

Los roles definen qué ve cada uno:

- **Administrador** (jefe): acceso total a todas las pantallas y datos.
- **Vendedor**: puede cargar ventas, reservas y su propia caja, y ve
  productos/clientes con lo básico (nombre, precio de venta, teléfono), pero
  no ve costos/ganancias, no gestiona proveedores/gastos/estadísticas ni
  puede crear/editar/eliminar productos o clientes.

Ya logueado, el botón "Sincronizar ahora" (en Configuración) sube los
cambios pendientes de ese teléfono y baja los cambios de los demás. Sin
conexión, la app sigue funcionando local y sincroniza sola la próxima vez
que el usuario presione "Sincronizar ahora" con conexión disponible.

## Endpoints

- `POST /auth/login` — `{ username, password }` → `{ token, user }`
- `GET /auth/me` — datos del usuario autenticado (requiere `Authorization: Bearer <token>` y `X-Device-Id`)
- `GET /sync/:table/pull?since=<ISO8601>` — cambios de esa tabla posteriores a `since`
- `POST /sync/:table/push` — `{ rows: [...] }`, upsert por `id` con resolución "última escritura gana"
- `GET|POST /sync/sales/pull|push` — igual que arriba pero cada venta viaja con su arreglo `items` (líneas de venta)
- `GET /health` — chequeo de vida (API + conexión a Postgres)

Todas las rutas de `/sync/*` requieren el header `X-Device-Id` (identifica
al teléfono, no al usuario) además del JWT.

## Tablas sincronizadas y roles

| Tabla                | admin | vendedor | Notas                                   |
|-----------------------|:-----:|:--------:|------------------------------------------|
| categories            |  ✅   |    ✅    |                                            |
| suppliers             |  ✅   |    ✅    |                                            |
| customers             |  ✅   |    ✅    |                                            |
| products              |  ✅   |    ✅    | incluye stock total/reservado             |
| stock_movements       |  ✅   |    ✅    | log de eventos, solo alta                 |
| sales (+ sale_items)  |  ✅   |    ✅    | cada venta viaja con sus líneas           |
| expense_categories    |  ✅   |    ❌    |                                            |
| expenses              |  ✅   |    ❌    |                                            |
| cash_sessions         |  ✅   |  ✅ (solo las propias) | el admin ve todas las cajas |
| cash_movements        |  ✅   |  ✅ (solo las propias) | el admin ve todas las cajas |

## Cómo agregar una tabla nueva al motor de sincronización

El motor es genérico: no hace falta escribir un endpoint a medida salvo que
la tabla necesite algo especial (como `sales`, que anida `sale_items`).

1. **Servidor**: agregá la tabla a la migración SQL (`src/db/migrations/`) y
   una entrada en `src/sync/registry.js` con su nombre, columna cursor
   (`updated_at` o `created_at`) y los roles permitidos.
2. **Cliente**: agregá la tabla al esquema de Drift
   (`lib/data/db/app_database.dart`, con una migración de `schemaVersion`) y
   una entrada en `lib/data/sync/sync_tables.dart` indicando sus columnas
   booleanas y de fecha (el resto de columnas se envían tal cual).

Con eso, `SyncEngine.syncAll()` (cliente) y el router genérico (servidor) ya
saben leer, enviar, recibir y aplicar esa tabla.

## Notas de seguridad

- Cambiá `JWT_SECRET` y las contraseñas por defecto antes de usar esto en
  producción.
- Este backend está pensado para un único negocio con varios dispositivos
  (no es multi-tenant): todos los usuarios comparten el mismo catálogo y la
  misma base de datos.
- Para exponerlo fuera de la red local (por ejemplo si los vendedores no
  están siempre en el mismo WiFi), hay que sumar HTTPS (por ejemplo con un
  proxy reverso) — el servidor no termina TLS por sí mismo.
## Remitos sin conexion

La app genera y numera los remitos localmente, sin exigir una actualizacion del
servidor ni una conexion activa. Cada celular mantiene su propia secuencia.
Los numeros previamente guardados se conservan al volver a emitir el PDF.
El endpoint central de numeracion se mantiene por compatibilidad con versiones
anteriores de la app; la emision actual no depende de ese endpoint.
