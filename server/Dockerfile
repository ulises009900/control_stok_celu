# Imagen de la API de Control Stok Celu. Corre las migraciones (idempotentes)
# y luego levanta el servidor Express.
FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm install --omit=dev

COPY src ./src
COPY scripts ./scripts

EXPOSE 4000

# Cada arranque vuelve a correr las migraciones (son idempotentes: usan
# CREATE TABLE IF NOT EXISTS) antes de levantar el servidor. La creación del
# admin inicial solo ocurre la primera vez (cuando la tabla users está vacía).
CMD ["sh", "-c", "node src/db/migrate.js && node src/index.js"]
