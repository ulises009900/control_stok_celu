-- Esquema inicial de Control Stok Celu (servidor central).
-- Los ids son TEXT (UUID generado en el cliente) para que cada teléfono
-- pueda crear filas offline sin coordinarse con el servidor.

CREATE TABLE IF NOT EXISTS users (
  id            TEXT PRIMARY KEY,
  username      TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  display_name  TEXT,
  role          TEXT NOT NULL CHECK (role IN ('admin', 'vendedor')),
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS categories (
  id         TEXT PRIMARY KEY,
  name       TEXT NOT NULL,
  parent_id  TEXT,
  is_active  BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_categories_updated_at ON categories (updated_at);

CREATE TABLE IF NOT EXISTS suppliers (
  id          TEXT PRIMARY KEY,
  name        TEXT NOT NULL,
  legal_name  TEXT,
  cuit        TEXT,
  phone       TEXT,
  email       TEXT,
  address     TEXT,
  notes       TEXT,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ NOT NULL,
  updated_at  TIMESTAMPTZ NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_suppliers_updated_at ON suppliers (updated_at);

CREATE TABLE IF NOT EXISTS customers (
  id          TEXT PRIMARY KEY,
  name        TEXT NOT NULL,
  phone       TEXT,
  email       TEXT,
  document    TEXT,
  address     TEXT,
  notes       TEXT,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ NOT NULL,
  updated_at  TIMESTAMPTZ NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_customers_updated_at ON customers (updated_at);

CREATE TABLE IF NOT EXISTS products (
  id               TEXT PRIMARY KEY,
  internal_code    TEXT NOT NULL,
  barcode          TEXT,
  name             TEXT NOT NULL,
  category_id      TEXT,
  subcategory      TEXT,
  brand            TEXT,
  description      TEXT,
  attributes_json  TEXT,
  unit             TEXT NOT NULL DEFAULT 'unit',
  units_per_pack   INTEGER NOT NULL DEFAULT 1,
  stock_total      INTEGER NOT NULL DEFAULT 0,
  stock_reserved   INTEGER NOT NULL DEFAULT 0,
  stock_min        INTEGER NOT NULL DEFAULT 0,
  stock_max        INTEGER,
  cost_cents       INTEGER NOT NULL DEFAULT 0,
  sale_price_cents INTEGER NOT NULL DEFAULT 0,
  tax_profile_id   TEXT,
  is_active        BOOLEAN NOT NULL DEFAULT TRUE,
  created_at       TIMESTAMPTZ NOT NULL,
  updated_at       TIMESTAMPTZ NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_products_updated_at ON products (updated_at);
CREATE INDEX IF NOT EXISTS idx_products_internal_code ON products (internal_code);

CREATE TABLE IF NOT EXISTS stock_movements (
  id             TEXT PRIMARY KEY,
  product_id     TEXT NOT NULL,
  batch_id       TEXT,
  movement_type  TEXT NOT NULL,
  quantity       INTEGER NOT NULL,
  stock_before   INTEGER NOT NULL,
  stock_after    INTEGER NOT NULL,
  reference_type TEXT,
  reference_id   TEXT,
  reason         TEXT,
  observations   TEXT,
  created_at     TIMESTAMPTZ NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_stock_movements_created_at ON stock_movements (created_at);
CREATE INDEX IF NOT EXISTS idx_stock_movements_product ON stock_movements (product_id, created_at);

CREATE TABLE IF NOT EXISTS sales (
  id                       TEXT PRIMARY KEY,
  customer_id              TEXT,
  reservation_id           TEXT,
  status                   TEXT NOT NULL DEFAULT 'draft',
  subtotal_cents           INTEGER NOT NULL DEFAULT 0,
  tax_cents                INTEGER NOT NULL DEFAULT 0,
  discount_cents           INTEGER NOT NULL DEFAULT 0,
  total_cents              INTEGER NOT NULL DEFAULT 0,
  estimated_profit_cents   INTEGER NOT NULL DEFAULT 0,
  notes                    TEXT,
  payment_method           TEXT NOT NULL DEFAULT 'cash',
  seller_id                TEXT,
  seller_name              TEXT,
  created_at               TIMESTAMPTZ NOT NULL,
  updated_at               TIMESTAMPTZ NOT NULL,
  confirmed_at             TIMESTAMPTZ,
  canceled_at              TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_sales_updated_at ON sales (updated_at);

CREATE TABLE IF NOT EXISTS sale_items (
  id                 TEXT PRIMARY KEY,
  sale_id            TEXT NOT NULL REFERENCES sales (id) ON DELETE CASCADE,
  product_id         TEXT NOT NULL,
  quantity           INTEGER NOT NULL,
  unit_price_cents   INTEGER NOT NULL,
  unit_cost_cents    INTEGER NOT NULL,
  tax_rate_bps       INTEGER NOT NULL DEFAULT 0,
  discount_cents     INTEGER NOT NULL DEFAULT 0,
  tax_cents          INTEGER NOT NULL DEFAULT 0,
  line_total_cents   INTEGER NOT NULL,
  line_profit_cents  INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_sale_items_sale ON sale_items (sale_id);

CREATE TABLE IF NOT EXISTS expense_categories (
  id         TEXT PRIMARY KEY,
  name       TEXT NOT NULL,
  is_active  BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_expense_categories_updated_at ON expense_categories (updated_at);

CREATE TABLE IF NOT EXISTS expenses (
  id             TEXT PRIMARY KEY,
  name           TEXT NOT NULL,
  category_id    TEXT,
  supplier_id    TEXT,
  description    TEXT,
  amount_cents   INTEGER NOT NULL,
  tax_cents      INTEGER NOT NULL DEFAULT 0,
  payment_method TEXT,
  notes          TEXT,
  is_active      BOOLEAN NOT NULL DEFAULT TRUE,
  occurred_at    TIMESTAMPTZ NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL,
  updated_at     TIMESTAMPTZ NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_expenses_updated_at ON expenses (updated_at);

CREATE TABLE IF NOT EXISTS cash_sessions (
  id                       TEXT PRIMARY KEY,
  device_id                TEXT NOT NULL,
  user_id                  TEXT,
  user_name                TEXT,
  status                   TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'closed')),
  opening_cents            INTEGER NOT NULL DEFAULT 0,
  expected_closing_cents   INTEGER,
  counted_closing_cents    INTEGER,
  difference_cents         INTEGER,
  opening_notes            TEXT,
  closing_notes            TEXT,
  opened_at                TIMESTAMPTZ NOT NULL,
  closed_at                TIMESTAMPTZ,
  created_at               TIMESTAMPTZ NOT NULL,
  updated_at               TIMESTAMPTZ NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_cash_sessions_updated_at ON cash_sessions (updated_at);
CREATE INDEX IF NOT EXISTS idx_cash_sessions_device ON cash_sessions (device_id, status);

CREATE TABLE IF NOT EXISTS cash_movements (
  id          TEXT PRIMARY KEY,
  session_id  TEXT NOT NULL REFERENCES cash_sessions (id) ON DELETE CASCADE,
  type        TEXT NOT NULL CHECK (type IN ('income', 'expense')),
  amount_cents INTEGER NOT NULL,
  description TEXT,
  device_id   TEXT NOT NULL,
  user_id     TEXT,
  created_at  TIMESTAMPTZ NOT NULL,
  updated_at  TIMESTAMPTZ NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_cash_movements_updated_at ON cash_movements (updated_at);
CREATE INDEX IF NOT EXISTS idx_cash_movements_session ON cash_movements (session_id);
