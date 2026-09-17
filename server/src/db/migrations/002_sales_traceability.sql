-- Idempotente para instalaciones ya creadas con la migración inicial.
ALTER TABLE sales ADD COLUMN IF NOT EXISTS payment_method TEXT NOT NULL DEFAULT 'cash';
ALTER TABLE sales ADD COLUMN IF NOT EXISTS seller_id TEXT;
ALTER TABLE sales ADD COLUMN IF NOT EXISTS seller_name TEXT;
CREATE INDEX IF NOT EXISTS idx_sales_seller_updated ON sales (seller_id, updated_at);
