import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

const String kAppDatabaseFileName = 'control_stok_celu.sqlite';

Future<File> resolveAppDatabaseFile() async {
  final Directory dbFolder = await getApplicationDocumentsDirectory();
  return File(p.join(dbFolder.path, kAppDatabaseFileName));
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable().references(Categories, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TaxProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get rateBps => integer().withDefault(const Constant(0))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Suppliers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get legalName => text().nullable()();
  TextColumn get cuit => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get document => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get internalCode => text()();
  TextColumn get barcode => text().nullable()();
  TextColumn get name => text()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get subcategory => text().nullable()();
  TextColumn get brand => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get attributesJson => text().nullable()();
  TextColumn get unit => text().withDefault(const Constant('unit'))();
  IntColumn get unitsPerPack => integer().withDefault(const Constant(1))();
  IntColumn get stockTotal => integer().withDefault(const Constant(0))();
  IntColumn get stockReserved => integer().withDefault(const Constant(0))();
  IntColumn get stockMin => integer().withDefault(const Constant(0))();
  IntColumn get stockMax => integer().nullable()();
  IntColumn get costCents => integer().withDefault(const Constant(0))();
  IntColumn get salePriceCents => integer().withDefault(const Constant(0))();
  TextColumn get taxProfileId =>
      text().nullable().references(TaxProfiles, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
        'CHECK (stock_total >= 0)',
        'CHECK (stock_reserved >= 0)',
        'CHECK (stock_reserved <= stock_total)',
        'CHECK (units_per_pack > 0)',
      ];

  List<Index> get indexes => [
        Index('idx_products_code',
            'CREATE INDEX idx_products_code ON products (internal_code)'),
        Index('idx_products_barcode',
            'CREATE INDEX idx_products_barcode ON products (barcode)'),
        Index('idx_products_name',
            'CREATE INDEX idx_products_name ON products (name)'),
      ];
}

class ProductBatches extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get batchCode => text().nullable()();
  TextColumn get supplierId => text().nullable().references(Suppliers, #id)();
  DateTimeColumn get receivedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  IntColumn get quantityTotal => integer()();
  IntColumn get quantityReserved => integer().withDefault(const Constant(0))();
  IntColumn get unitCostCents => integer()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
        'CHECK (quantity_total >= 0)',
        'CHECK (quantity_reserved >= 0)',
        'CHECK (quantity_reserved <= quantity_total)',
      ];

  List<Index> get indexes => [
        Index(
          'idx_batches_fifo',
          'CREATE INDEX idx_batches_fifo ON product_batches (product_id, received_at)',
        ),
      ];
}

class Purchases extends Table {
  TextColumn get id => text()();
  TextColumn get supplierId => text().nullable().references(Suppliers, #id)();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  IntColumn get subtotalCents => integer().withDefault(const Constant(0))();
  IntColumn get taxCents => integer().withDefault(const Constant(0))();
  IntColumn get totalCents => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PurchaseItems extends Table {
  TextColumn get id => text()();
  TextColumn get purchaseId => text().references(Purchases, #id)();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get quantity => integer()();
  IntColumn get unitCostCents => integer()();
  IntColumn get taxRateBps => integer().withDefault(const Constant(0))();
  IntColumn get lineTotalCents => integer().withDefault(const Constant(0))();
  TextColumn get batchId => text().nullable().references(ProductBatches, #id)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Reservations extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get canceledAt => dateTime().nullable()();
  DateTimeColumn get confirmedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ReservationItems extends Table {
  TextColumn get id => text()();
  TextColumn get reservationId => text().references(Reservations, #id)();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get quantity => integer()();
  IntColumn get unitPriceCents => integer().withDefault(const Constant(0))();
  IntColumn get unitCostCents => integer().withDefault(const Constant(0))();
  IntColumn get taxRateBps => integer().withDefault(const Constant(0))();
  IntColumn get discountCents => integer().withDefault(const Constant(0))();
  IntColumn get lineTotalCents => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Sales extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get reservationId =>
      text().nullable().references(Reservations, #id)();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  IntColumn get subtotalCents => integer().withDefault(const Constant(0))();
  IntColumn get taxCents => integer().withDefault(const Constant(0))();
  IntColumn get discountCents => integer().withDefault(const Constant(0))();
  IntColumn get totalCents => integer().withDefault(const Constant(0))();
  IntColumn get estimatedProfitCents =>
      integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get confirmedAt => dateTime().nullable()();
  DateTimeColumn get canceledAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SaleItems extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text().references(Sales, #id)();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get quantity => integer()();
  IntColumn get unitPriceCents => integer()();
  IntColumn get unitCostCents => integer()();
  IntColumn get taxRateBps => integer().withDefault(const Constant(0))();
  IntColumn get discountCents => integer().withDefault(const Constant(0))();
  IntColumn get taxCents => integer().withDefault(const Constant(0))();
  IntColumn get lineTotalCents => integer()();
  IntColumn get lineProfitCents => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class BatchAllocations extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get batchId => text().references(ProductBatches, #id)();
  TextColumn get reservationItemId =>
      text().nullable().references(ReservationItems, #id)();
  TextColumn get saleItemId => text().nullable().references(SaleItems, #id)();
  IntColumn get quantity => integer()();
  IntColumn get quantityReserved => integer().withDefault(const Constant(0))();
  IntColumn get quantitySold => integer().withDefault(const Constant(0))();
  TextColumn get state => text().withDefault(const Constant('reserved'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
        'CHECK (quantity > 0)',
        'CHECK (quantity_reserved >= 0)',
        'CHECK (quantity_sold >= 0)',
        'CHECK (quantity_reserved + quantity_sold <= quantity)',
      ];
}

class StockMovements extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get batchId => text().nullable().references(ProductBatches, #id)();
  TextColumn get movementType => text()();
  IntColumn get quantity => integer()();
  IntColumn get stockBefore => integer()();
  IntColumn get stockAfter => integer()();
  TextColumn get referenceType => text().nullable()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get reason => text().nullable()();
  TextColumn get observations => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  List<Index> get indexes => [
        Index(
          'idx_movements_product_time',
          'CREATE INDEX idx_movements_product_time ON stock_movements (product_id, created_at)',
        ),
      ];
}

class Returns extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text().references(Sales, #id)();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get reason => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ReturnItems extends Table {
  TextColumn get id => text()();
  TextColumn get returnId => text().references(Returns, #id)();
  TextColumn get saleItemId => text().references(SaleItems, #id)();
  TextColumn get batchId => text().references(ProductBatches, #id)();
  IntColumn get quantity => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ExpenseCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get categoryId =>
      text().nullable().references(ExpenseCategories, #id)();
  TextColumn get supplierId => text().nullable().references(Suppliers, #id)();
  TextColumn get description => text().nullable()();
  IntColumn get amountCents => integer()();
  IntColumn get taxCents => integer().withDefault(const Constant(0))();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PriceHistory extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get costCents => integer()();
  IntColumn get salePriceCents => integer()();
  IntColumn get taxRateBps => integer().withDefault(const Constant(0))();
  TextColumn get reason => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ProductOffers extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get offerType => text()();
  IntColumn get value => integer()();
  DateTimeColumn get startAt => dateTime()();
  DateTimeColumn get endAt => dateTime().nullable()();
  TextColumn get conditionsJson => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ProductDiscounts extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get discountType => text()();
  IntColumn get value => integer()();
  DateTimeColumn get startAt => dateTime()();
  DateTimeColumn get endAt => dateTime().nullable()();
  TextColumn get conditionsJson => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get tagsJson => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueAt => dateTime()();
  TextColumn get priority => text().withDefault(const Constant('normal'))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Checklists extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ChecklistItems extends Table {
  TextColumn get id => text()();
  TextColumn get checklistId => text().references(Checklists, #id)();
  TextColumn get textValue => text().named('text_value')();
  IntColumn get position => integer().withDefault(const Constant(0))();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get valueJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class AuditLogs extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get action => text()();
  TextColumn get beforeJson => text().nullable()();
  TextColumn get afterJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get userId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: <Type>[
    Categories,
    TaxProfiles,
    Suppliers,
    Customers,
    Products,
    ProductBatches,
    Purchases,
    PurchaseItems,
    Reservations,
    ReservationItems,
    Sales,
    SaleItems,
    BatchAllocations,
    StockMovements,
    Returns,
    ReturnItems,
    ExpenseCategories,
    Expenses,
    PriceHistory,
    ProductOffers,
    ProductDiscounts,
    Notes,
    Reminders,
    Checklists,
    ChecklistItems,
    Settings,
    AuditLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor}) : super(executor ?? _openConnection());

  static const int currentSchemaVersion = 4;

  @override
  int get schemaVersion => currentSchemaVersion;

  Future<void> _ensureExpensesSchema() async {
    final tableExists = await customSelect(
      "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = 'expenses' LIMIT 1",
    ).get();

    if (tableExists.isEmpty) {
      await customStatement('''
        CREATE TABLE IF NOT EXISTS expenses (
          id TEXT PRIMARY KEY NOT NULL,
          name TEXT NOT NULL,
          category_id TEXT,
          supplier_id TEXT,
          description TEXT,
          amount_cents INTEGER NOT NULL,
          tax_cents INTEGER NOT NULL DEFAULT 0,
          payment_method TEXT,
          notes TEXT,
          is_active INTEGER NOT NULL DEFAULT 1,
          occurred_at INTEGER NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER
        );
      ''');
    }

    final columns = await customSelect('PRAGMA table_info(expenses);').get();
    final columnNames = columns.map((row) => row.read<String>('name')).toSet();

    if (!columnNames.contains('supplier_id')) {
      await customStatement(
          'ALTER TABLE expenses ADD COLUMN supplier_id TEXT;');
    }
    if (!columnNames.contains('is_active')) {
      await customStatement(
        'ALTER TABLE expenses ADD COLUMN is_active INTEGER NOT NULL DEFAULT 1;',
      );
    }
    if (!columnNames.contains('updated_at')) {
      await customStatement(
          'ALTER TABLE expenses ADD COLUMN updated_at INTEGER;');
    }
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_products_code ON products (internal_code);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_products_barcode ON products (barcode);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_products_name ON products (name);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_batches_fifo ON product_batches (product_id, received_at);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_movements_product_time ON stock_movements (product_id, created_at);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_suppliers_name ON suppliers (name);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_suppliers_cuit ON suppliers (cuit);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_customers_name ON customers (name);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_customers_document ON customers (document);',
          );
          await customStatement('''
            CREATE VIRTUAL TABLE IF NOT EXISTS products_fts USING fts5(
              product_id UNINDEXED,
              name,
              brand,
              description,
              internal_code,
              barcode
            );
          ''');
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await customStatement(
              'ALTER TABLE suppliers ADD COLUMN legal_name TEXT;',
            );
            await customStatement(
              'ALTER TABLE suppliers ADD COLUMN cuit TEXT;',
            );
            await customStatement(
              'ALTER TABLE suppliers ADD COLUMN address TEXT;',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_suppliers_name ON suppliers (name);',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_suppliers_cuit ON suppliers (cuit);',
            );
          }
          if (from < 3) {
            await customStatement(
              'ALTER TABLE customers ADD COLUMN email TEXT;',
            );
            await customStatement(
              'ALTER TABLE customers ADD COLUMN document TEXT;',
            );
            await customStatement(
              'ALTER TABLE customers ADD COLUMN address TEXT;',
            );
            await customStatement(
              'ALTER TABLE reservations ADD COLUMN deleted_at INTEGER NULL;',
            );
            await customStatement(
              'ALTER TABLE batch_allocations ADD COLUMN quantity_reserved INTEGER NOT NULL DEFAULT 0;',
            );
            await customStatement(
              'ALTER TABLE batch_allocations ADD COLUMN quantity_sold INTEGER NOT NULL DEFAULT 0;',
            );
            await customStatement('''
              UPDATE batch_allocations
              SET
                quantity_reserved = CASE WHEN state = 'reserved' THEN quantity ELSE 0 END,
                quantity_sold = CASE WHEN state = 'sold' THEN quantity ELSE 0 END
              WHERE quantity_reserved = 0 AND quantity_sold = 0
            ''');
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_customers_name ON customers (name);',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_customers_document ON customers (document);',
            );
          }
          if (from < 4) {
            await _ensureExpensesSchema();
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
          await customStatement('PRAGMA journal_mode = WAL;');
        },
      );

  Future<void> upsertProductFts({
    required String productId,
    required String name,
    String? brand,
    String? description,
    required String internalCode,
    String? barcode,
  }) async {
    await customStatement(
      'INSERT OR REPLACE INTO products_fts(product_id, name, brand, description, internal_code, barcode) VALUES(?, ?, ?, ?, ?, ?)',
      <Object?>[productId, name, brand, description, internalCode, barcode],
    );
  }

  Future<List<QueryRow>> searchProducts(String term) {
    return customSelect(
      '''
        SELECT p.*
        FROM products_fts f
        JOIN products p ON p.id = f.product_id
        WHERE products_fts MATCH ?
        ORDER BY rank
        LIMIT 50
      ''',
      variables: <Variable<Object>>[Variable<Object>(term)],
    ).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final File file = await resolveAppDatabaseFile();
    return NativeDatabase.createInBackground(file);
  });
}
