-- Separate from sales: an offline draft can request its number before syncing.
-- Numbers remain reserved even if a sale is later deleted.
CREATE TABLE IF NOT EXISTS remito_counter (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  last_number BIGINT NOT NULL DEFAULT 0
);
INSERT INTO remito_counter(id, last_number) VALUES (1, 0)
ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS remito_numbers (
  sale_id TEXT PRIMARY KEY,
  number BIGINT NOT NULL UNIQUE CHECK (number > 0)
);
