import 'dart:convert';

import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/domain/stock/stock_repository.dart';
import 'package:drift/drift.dart';

class DriftStockRepository implements StockRepository {
  DriftStockRepository(this._db);

  final AppDatabase _db;
  static const String _statusDraft = 'draft';
  static const String _statusReserved = 'reserved';
  static const String _statusSold = 'sold';
  static const String _statusCancelled = 'cancelled';
  static const String _statusDeleted = 'deleted';

  @override
  Future<void> createProduct(CreateProductInput input) async {
    final now = DateTime.now().toUtc();
    await _db.into(_db.products).insert(
          ProductsCompanion.insert(
            id: input.id,
            internalCode: input.internalCode,
            name: input.name,
            barcode: Value(input.barcode),
            categoryId: Value(input.categoryId),
            brand: Value(input.brand),
            description: Value(input.description),
            unit: Value(input.unit),
            unitsPerPack: Value(input.unitsPerPack),
            costCents: Value(input.costCents),
            salePriceCents: Value(input.salePriceCents),
            taxProfileId: Value(input.taxProfileId),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _db.upsertProductFts(
      productId: input.id,
      name: input.name,
      brand: input.brand,
      description: input.description,
      internalCode: input.internalCode,
      barcode: input.barcode,
    );
  }

  @override
  Future<void> createProductProfile(ProductUpsertInput input) async {
    await _db.transaction(() async {
      _validateProductInput(input);
      await _assertUniqueProductIdentity(
        internalCode: input.internalCode,
        barcode: input.barcode,
      );
      await _assertCategoryIsAssignable(input.categoryId);

      final now = DateTime.now().toUtc();
      await _db.into(_db.products).insert(
            ProductsCompanion.insert(
              id: input.id,
              internalCode: input.internalCode,
              barcode: Value(input.barcode),
              name: input.name,
              categoryId: Value(input.categoryId),
              subcategory: Value(input.subcategory),
              brand: Value(input.brand),
              description: Value(input.description),
              attributesJson: Value(_encodeProductAttributes(input)),
              unit: Value(input.unit),
              unitsPerPack: Value(input.unitsPerPack),
              stockMin: Value(input.stockMin),
              stockMax: Value(input.stockMax),
              costCents: Value(input.costCents),
              salePriceCents: Value(input.salePriceCents),
              isActive: Value(input.isActive),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await _db.upsertProductFts(
        productId: input.id,
        name: input.name,
        brand: input.brand,
        description: _buildFtsDescription(input),
        internalCode: input.internalCode,
        barcode: input.barcode,
      );

      await _db.into(_db.priceHistory).insert(
            PriceHistoryCompanion.insert(
              id: 'price_${input.id}_${now.microsecondsSinceEpoch}',
              productId: input.id,
              costCents: input.costCents,
              salePriceCents: input.salePriceCents,
              taxRateBps: Value(input.taxRateBps),
              reason: const Value('create_product'),
              createdAt: now,
            ),
          );
    });
  }

  @override
  Future<void> updateProductProfile(ProductUpsertInput input) async {
    await _db.transaction(() async {
      _validateProductInput(input);
      final existing = await _requireProduct(input.id);
      await _assertUniqueProductIdentity(
        internalCode: input.internalCode,
        barcode: input.barcode,
        excludeProductId: input.id,
      );
      await _assertCategoryIsAssignable(input.categoryId);

      final previousAttributes = _decodeAttributes(existing.attributesJson);
      final previousTaxRate =
          _readIntAttribute(previousAttributes, 'tax_rate_bps');
      final changedPrice = existing.costCents != input.costCents ||
          existing.salePriceCents != input.salePriceCents ||
          previousTaxRate != input.taxRateBps;

      final now = DateTime.now().toUtc();
      await (_db.update(_db.products)..where((t) => t.id.equals(input.id)))
          .write(
        ProductsCompanion(
          internalCode: Value(input.internalCode),
          barcode: Value(input.barcode),
          name: Value(input.name),
          categoryId: Value(input.categoryId),
          subcategory: Value(input.subcategory),
          brand: Value(input.brand),
          description: Value(input.description),
          attributesJson: Value(_encodeProductAttributes(input)),
          unit: Value(input.unit),
          unitsPerPack: Value(input.unitsPerPack),
          stockMin: Value(input.stockMin),
          stockMax: Value(input.stockMax),
          costCents: Value(input.costCents),
          salePriceCents: Value(input.salePriceCents),
          isActive: Value(input.isActive),
          updatedAt: Value(now),
        ),
      );

      await _db.upsertProductFts(
        productId: input.id,
        name: input.name,
        brand: input.brand,
        description: _buildFtsDescription(input),
        internalCode: input.internalCode,
        barcode: input.barcode,
      );

      if (changedPrice) {
        await _db.into(_db.priceHistory).insert(
              PriceHistoryCompanion.insert(
                id: 'price_${input.id}_${now.microsecondsSinceEpoch}',
                productId: input.id,
                costCents: input.costCents,
                salePriceCents: input.salePriceCents,
                taxRateBps: Value(input.taxRateBps),
                reason: const Value('update_product_prices'),
                createdAt: now,
              ),
            );
      }

      await _insertAudit(
        entityType: 'product',
        entityId: input.id,
        action: 'product_update',
        before: <String, Object?>{
          'internal_code': existing.internalCode,
          'barcode': existing.barcode,
          'name': existing.name,
          'cost_cents': existing.costCents,
          'sale_price_cents': existing.salePriceCents,
        },
        after: <String, Object?>{
          'internal_code': input.internalCode,
          'barcode': input.barcode,
          'name': input.name,
          'cost_cents': input.costCents,
          'sale_price_cents': input.salePriceCents,
          'tax_rate_bps': input.taxRateBps,
        },
        createdAt: now,
      );
    });
  }

  @override
  Future<void> setProductActive(String productId, bool isActive) async {
    final product = await _requireProduct(productId);
    final now = DateTime.now().toUtc();
    await (_db.update(_db.products)..where((t) => t.id.equals(productId)))
        .write(
      ProductsCompanion(
        isActive: Value(isActive),
        updatedAt: Value(now),
      ),
    );

    await _insertAudit(
      entityType: 'product',
      entityId: productId,
      action: isActive ? 'product_reactivate' : 'product_deactivate',
      before: <String, Object?>{'is_active': product.isActive},
      after: <String, Object?>{'is_active': isActive},
      createdAt: now,
    );
  }

  @override
  Future<void> logicalDeleteProduct(String productId) async {
    final product = await _requireProduct(productId);
    final attributes = _decodeAttributes(product.attributesJson);
    attributes['deleted_at'] = DateTime.now().toUtc().toIso8601String();
    await (_db.update(_db.products)..where((t) => t.id.equals(productId)))
        .write(
      ProductsCompanion(
        isActive: const Value(false),
        attributesJson: Value(jsonEncode(attributes)),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<List<ProductSummaryItem>> listProducts(ProductQuery query) async {
    final where = <String>[];
    final values = <Object>[];

    where.add('1=1');

    if (query.status == ProductStatusFilter.active) {
      where.add('p.is_active = 1');
    } else if (query.status == ProductStatusFilter.inactive) {
      where.add('p.is_active = 0');
    }

    if (query.categoryId != null && query.categoryId!.trim().isNotEmpty) {
      where.add('p.category_id = ?');
      values.add(query.categoryId!.trim());
    }

    if (query.subcategory != null && query.subcategory!.trim().isNotEmpty) {
      where.add("LOWER(IFNULL(p.subcategory, '')) = ?");
      values.add(query.subcategory!.trim().toLowerCase());
    }

    if (query.stock == ProductStockFilter.lowStock) {
      where.add('(p.stock_total - p.stock_reserved) <= p.stock_min');
      where.add('(p.stock_total - p.stock_reserved) > 0');
    } else if (query.stock == ProductStockFilter.noStock) {
      where.add('(p.stock_total - p.stock_reserved) <= 0');
    }

    if (query.onlyOffer == true) {
      where.add("LOWER(IFNULL(p.attributes_json, '')) LIKE ?");
      values.add('%"is_offer":true%');
    }
    if (query.onlyClearance == true) {
      where.add("LOWER(IFNULL(p.attributes_json, '')) LIKE ?");
      values.add('%"is_clearance":true%');
    }

    if (query.nearExpiryDays != null && query.nearExpiryDays! >= 0) {
      where.add(
          'EXISTS (SELECT 1 FROM product_batches b WHERE b.product_id = p.id AND b.quantity_total > 0 AND b.expires_at IS NOT NULL AND b.expires_at <= ?)');
      values.add(
          DateTime.now().toUtc().add(Duration(days: query.nearExpiryDays!)));
    }

    final normalizedSearch = _normalizeSearch(query.search);
    final hasSearch = normalizedSearch != null && normalizedSearch.isNotEmpty;
    final ftsMatchQuery =
        hasSearch ? _buildFtsMatchQuery(normalizedSearch) : null;
    final normalizedInternalCode = _sqlNormalize('p.internal_code');
    final normalizedBarcode = _sqlNormalize("IFNULL(p.barcode, '')");
    final normalizedName = _sqlNormalize('p.name');
    final normalizedBrand = _sqlNormalize("IFNULL(p.brand, '')");
    final normalizedDescription = _sqlNormalize("IFNULL(p.description, '')");
    final normalizedAttributes = _sqlNormalize("IFNULL(p.attributes_json, '')");

    final rankExpression = hasSearch
        ? '''
            CASE
              WHEN $normalizedInternalCode = ? THEN 1
              WHEN $normalizedBarcode = ? THEN 2
              WHEN $normalizedName LIKE ? THEN 3
              WHEN $normalizedName LIKE ? THEN 4
              WHEN $normalizedBrand LIKE ? THEN 5
              WHEN $normalizedDescription LIKE ? THEN 6
              WHEN $normalizedAttributes LIKE ? THEN 7
              ELSE 20
            END
          '''
        : '99';

    if (hasSearch) {
      final search = normalizedSearch;
      final prefix = '$search%';
      final partial = '%$search%';
      final ftsCondition = ftsMatchQuery == null
          ? ''
          : '''
          OR p.id IN (
            SELECT product_id
            FROM products_fts
            WHERE products_fts MATCH ?
          )
          ''';
      where.add('''
        (
          $normalizedInternalCode = ?
          OR $normalizedBarcode = ?
          OR $normalizedName LIKE ?
          OR $normalizedName LIKE ?
          OR $normalizedBrand LIKE ?
          OR $normalizedDescription LIKE ?
          OR $normalizedAttributes LIKE ?
          $ftsCondition
        )
      ''');
      final searchValues = <Object>[
        search,
        search,
        prefix,
        partial,
        partial,
        partial,
        partial,
      ];
      if (ftsMatchQuery != null) {
        searchValues.add(ftsMatchQuery);
      }
      values.addAll(searchValues);
    }

    final orderSql = _productSortSql(query.sortBy, query.descending);
    final sql = '''
      SELECT
        p.id,
        p.name,
        p.internal_code,
        p.barcode,
        p.brand,
        p.category_id,
        p.subcategory,
        p.stock_total,
        p.stock_reserved,
        p.stock_min,
        p.cost_cents,
        p.sale_price_cents,
        p.is_active,
        p.created_at,
        p.updated_at,
        p.attributes_json,
        EXISTS (
          SELECT 1
          FROM product_batches b
          WHERE b.product_id = p.id
            AND b.quantity_total > 0
            AND b.expires_at IS NOT NULL
            AND b.expires_at <= ?
        ) AS has_near_expiry,
        $rankExpression AS rank_value
      FROM products p
      WHERE ${where.join(' AND ')}
      ORDER BY rank_value ASC, $orderSql
      LIMIT ? OFFSET ?
    ''';

    final rankingValues = <Object>[];
    if (hasSearch) {
      final search = normalizedSearch;
      rankingValues.addAll(<Object>[
        search,
        search,
        '$search%',
        '%$search%',
        '%$search%',
        '%$search%',
        '%$search%',
      ]);
    }

    final rows = await _db.customSelect(
      sql,
      variables: <Variable<Object>>[
        ...rankingValues.map(_asVariable),
        _asVariable(DateTime.now().toUtc().add(const Duration(days: 30))),
        ...values.map(_asVariable),
        _asVariable(query.limit),
        _asVariable(query.offset),
      ],
    ).get();

    return rows.map(_mapProductSummary).toList();
  }

  @override
  Future<InventorySummaryView> getInventorySummary(InventoryQuery query) async {
    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);
    final nearExpiryLimit = now.add(Duration(days: query.nearExpiryDays));

    final where = <String>['1=1'];
    final values = <Object>[];

    if (!query.includeInactive) {
      where.add('p.is_active = 1');
    }

    _appendProductSearchWhere(
      where: where,
      values: values,
      rawSearch: query.search,
      productAlias: 'p',
    );

    final sql = '''
      SELECT
        COUNT(*) AS total_products,
        SUM(CASE WHEN inv.stock_available <= 0 THEN 1 ELSE 0 END) AS no_stock_count,
        SUM(CASE WHEN inv.stock_available > 0 AND inv.stock_available <= inv.stock_min THEN 1 ELSE 0 END) AS low_stock_count,
        SUM(CASE WHEN inv.stock_max IS NOT NULL AND inv.stock_available > inv.stock_max THEN 1 ELSE 0 END) AS over_stock_count,
        SUM(CASE WHEN inv.next_relevant_expiry IS NOT NULL AND inv.next_relevant_expiry < ? THEN 1 ELSE 0 END) AS expired_count,
        SUM(CASE WHEN inv.next_relevant_expiry IS NOT NULL AND inv.next_relevant_expiry >= ? AND inv.next_relevant_expiry <= ? THEN 1 ELSE 0 END) AS near_expiry_count
      FROM (
        SELECT
          p.id,
          (p.stock_total - p.stock_reserved) AS stock_available,
          p.stock_min AS stock_min,
          p.stock_max AS stock_max,
          MIN(
            CASE
              WHEN b.quantity_total > b.quantity_reserved
                   AND b.expires_at IS NOT NULL
              THEN b.expires_at
            END
          ) AS next_relevant_expiry
        FROM products p
        LEFT JOIN product_batches b ON b.product_id = p.id
        WHERE ${where.join(' AND ')}
        GROUP BY p.id
      ) inv
    ''';

    final row = await _db.customSelect(
      sql,
      variables: <Variable<Object>>[
        _asVariable(todayStart),
        _asVariable(todayStart),
        _asVariable(nearExpiryLimit),
        ...values.map(_asVariable),
      ],
    ).getSingle();

    return InventorySummaryView(
      totalProducts: row.read<int>('total_products'),
      noStockCount: row.read<int>('no_stock_count'),
      lowStockCount: row.read<int>('low_stock_count'),
      nearExpiryCount: row.read<int>('near_expiry_count'),
      expiredCount: row.read<int>('expired_count'),
      overStockCount: row.read<int>('over_stock_count'),
    );
  }

  @override
  Future<List<InventoryListItem>> listInventory(InventoryQuery query) async {
    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));
    final nearExpiryLimit = now.add(Duration(days: query.nearExpiryDays));

    final where = <String>['1=1'];
    final values = <Object>[];

    if (!query.includeInactive) {
      where.add('p.is_active = 1');
    }

    switch (query.filter) {
      case InventoryFilter.all:
        break;
      case InventoryFilter.noStock:
        where.add('(p.stock_total - p.stock_reserved) <= 0');
        break;
      case InventoryFilter.lowStock:
        where.add('(p.stock_total - p.stock_reserved) > 0');
        where.add('(p.stock_total - p.stock_reserved) <= p.stock_min');
        break;
      case InventoryFilter.normal:
        where.add('(p.stock_total - p.stock_reserved) > p.stock_min');
        where.add(
            '(p.stock_max IS NULL OR (p.stock_total - p.stock_reserved) <= p.stock_max)');
        break;
      case InventoryFilter.overStock:
        where.add('p.stock_max IS NOT NULL');
        where.add('(p.stock_total - p.stock_reserved) > p.stock_max');
        break;
      case InventoryFilter.nearExpiry:
        where.add('''
          EXISTS (
            SELECT 1
            FROM product_batches b_near
            WHERE b_near.product_id = p.id
              AND b_near.quantity_total > b_near.quantity_reserved
              AND b_near.expires_at IS NOT NULL
              AND b_near.expires_at >= ?
              AND b_near.expires_at <= ?
          )
        ''');
        values.add(todayStart);
        values.add(nearExpiryLimit);
        break;
      case InventoryFilter.expired:
        where.add('''
          EXISTS (
            SELECT 1
            FROM product_batches b_exp
            WHERE b_exp.product_id = p.id
              AND b_exp.quantity_total > b_exp.quantity_reserved
              AND b_exp.expires_at IS NOT NULL
              AND b_exp.expires_at < ?
          )
        ''');
        values.add(todayStart);
        break;
    }

    _appendProductSearchWhere(
      where: where,
      values: values,
      rawSearch: query.search,
      productAlias: 'p',
    );

    final orderSql = _inventorySortSql(query.sortBy, query.descending);
    final sql = '''
      SELECT
        p.id,
        p.name,
        p.internal_code,
        p.barcode,
        c.name AS category_name,
        p.stock_total,
        p.stock_reserved,
        p.stock_min,
        p.stock_max,
        p.updated_at,
        MIN(
          CASE
            WHEN b.quantity_total > b.quantity_reserved
                 AND b.expires_at IS NOT NULL
            THEN b.expires_at
          END
        ) AS next_relevant_expiry
      FROM products p
      LEFT JOIN categories c ON c.id = p.category_id
      LEFT JOIN product_batches b ON b.product_id = p.id
      WHERE ${where.join(' AND ')}
      GROUP BY
        p.id,
        p.name,
        p.internal_code,
        p.barcode,
        c.name,
        p.stock_total,
        p.stock_reserved,
        p.stock_min,
        p.stock_max,
        p.updated_at
      ORDER BY $orderSql
      LIMIT ? OFFSET ?
    ''';

    final rows = await _db.customSelect(
      sql,
      variables: <Variable<Object>>[
        ...values.map(_asVariable),
        _asVariable(query.limit),
        _asVariable(query.offset),
      ],
    ).get();

    return rows.map((row) {
      final stockTotal = row.read<int>('stock_total');
      final stockReserved = row.read<int>('stock_reserved');
      final stockMin = row.read<int>('stock_min');
      final stockMax = row.readNullable<int>('stock_max');
      final nextExpiry =
          _readNullableDateTimeFromRow(row, 'next_relevant_expiry');

      return InventoryListItem(
        id: row.read<String>('id'),
        name: row.read<String>('name'),
        internalCode: row.read<String>('internal_code'),
        barcode: row.readNullable<String>('barcode'),
        categoryName: row.readNullable<String>('category_name'),
        stockTotal: stockTotal,
        stockReserved: stockReserved,
        stockMin: stockMin,
        stockMax: stockMax,
        stockState: _resolveInventoryStockState(
          stockTotal: stockTotal,
          stockReserved: stockReserved,
          stockMin: stockMin,
          stockMax: stockMax,
        ),
        expiryState: _resolveInventoryExpiryState(
          nextExpiry: nextExpiry,
          todayStart: todayStart,
          tomorrowStart: tomorrowStart,
          nearExpiryLimit: nearExpiryLimit,
        ),
        nextRelevantExpiry: nextExpiry,
        updatedAt: _readDateTimeFromRow(row, 'updated_at'),
      );
    }).toList();
  }

  @override
  Future<ProductDetailView> getProductDetail(String productId) async {
    final product = await _requireProduct(productId);
    final categoryName = await _readCategoryName(product.categoryId);
    final attributes = _decodeAttributes(product.attributesJson);

    final batchRows = await (_db.select(_db.productBatches)
          ..where((t) => t.productId.equals(productId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.receivedAt, mode: OrderingMode.desc)
          ]))
        .get();

    final movementRows = await (_db.select(_db.stockMovements)
          ..where((t) => t.productId.equals(productId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .get();

    final summary = ProductSummaryItem(
      id: product.id,
      name: product.name,
      internalCode: product.internalCode,
      barcode: product.barcode,
      brand: product.brand,
      categoryId: product.categoryId,
      subcategory: product.subcategory,
      stockTotal: product.stockTotal,
      stockReserved: product.stockReserved,
      stockMin: product.stockMin,
      costCents: product.costCents,
      salePriceCents: product.salePriceCents,
      isActive: product.isActive,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      isOffer: _readBoolAttribute(attributes, 'is_offer'),
      isClearance: _readBoolAttribute(attributes, 'is_clearance'),
      hasNearExpiry: batchRows.any(
        (batch) =>
            batch.quantityTotal > 0 &&
            batch.expiresAt != null &&
            !batch.expiresAt!
                .toUtc()
                .isAfter(DateTime.now().toUtc().add(const Duration(days: 30))),
      ),
    );

    return ProductDetailView(
      product: summary,
      categoryName: categoryName,
      description: product.description,
      unit: product.unit,
      unitsPerPack: product.unitsPerPack,
      stockMax: product.stockMax,
      characteristics: _readStringAttribute(attributes, 'characteristics'),
      details: _readStringAttribute(attributes, 'details'),
      location: _readStringAttribute(attributes, 'location'),
      taxRateBps: _readIntAttribute(attributes, 'tax_rate_bps'),
      defaultDiscountBps: _readIntAttribute(attributes, 'default_discount_bps'),
      notes: _readStringAttribute(attributes, 'notes'),
      supplierId: _readStringAttribute(attributes, 'supplier_id'),
      batches: batchRows
          .map(
            (batch) => ProductBatchView(
              id: batch.id,
              batchCode: batch.batchCode,
              receivedAt: batch.receivedAt,
              expiresAt: batch.expiresAt,
              quantityTotal: batch.quantityTotal,
              quantityReserved: batch.quantityReserved,
              unitCostCents: batch.unitCostCents,
            ),
          )
          .toList(),
      movements: movementRows
          .map(
            (movement) => ProductMovementView(
              id: movement.id,
              movementType: movement.movementType,
              quantity: movement.quantity,
              stockBefore: movement.stockBefore,
              stockAfter: movement.stockAfter,
              batchId: movement.batchId,
              referenceType: movement.referenceType,
              referenceId: movement.referenceId,
              reason: movement.reason,
              createdAt: movement.createdAt,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> createCategory(CategoryUpsertInput input) async {
    if (input.name.trim().isEmpty) {
      throw ValidationException('La categoría requiere nombre.');
    }
    final now = DateTime.now().toUtc();
    await _assertCategoryParent(input.parentId, input.id);
    await _db.into(_db.categories).insert(
          CategoriesCompanion.insert(
            id: input.id,
            name: input.name.trim(),
            parentId: Value(input.parentId),
            isActive: Value(input.isActive),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  @override
  Future<void> updateCategory(CategoryUpsertInput input) async {
    if (input.name.trim().isEmpty) {
      throw ValidationException('La categoría requiere nombre.');
    }
    final existing = await (_db.select(_db.categories)
          ..where((t) => t.id.equals(input.id)))
        .getSingleOrNull();
    if (existing == null) {
      throw NotFoundException('La categoría no existe.');
    }
    await _assertCategoryParent(input.parentId, input.id);
    await (_db.update(_db.categories)..where((t) => t.id.equals(input.id)))
        .write(
      CategoriesCompanion(
        name: Value(input.name.trim()),
        parentId: Value(input.parentId),
        isActive: Value(input.isActive),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> setCategoryActive(String categoryId, bool isActive) async {
    final category = await (_db.select(_db.categories)
          ..where((t) => t.id.equals(categoryId)))
        .getSingleOrNull();
    if (category == null) {
      throw NotFoundException('La categoría no existe.');
    }
    await (_db.update(_db.categories)..where((t) => t.id.equals(categoryId)))
        .write(
      CategoriesCompanion(
        isActive: Value(isActive),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<List<CategoryListItem>> listCategories({
    String? search,
    bool includeInactive = true,
    String? parentId,
  }) async {
    final where = <String>['1=1'];
    final values = <Object>[];
    if (!includeInactive) {
      where.add('c.is_active = 1');
    }
    if (parentId != null) {
      where.add('c.parent_id = ?');
      values.add(parentId);
    }
    final normalized = search?.trim().toLowerCase();
    if (normalized != null && normalized.isNotEmpty) {
      where.add('LOWER(c.name) LIKE ?');
      values.add('%$normalized%');
    }

    final rows = await _db.customSelect(
      '''
      SELECT
        c.id,
        c.name,
        c.parent_id,
        c.is_active,
        COUNT(p.id) AS product_count
      FROM categories c
      LEFT JOIN products p ON p.category_id = c.id
      WHERE ${where.join(' AND ')}
      GROUP BY c.id
      ORDER BY LOWER(c.name) ASC
      ''',
      variables: values.map(_asVariable).toList(),
    ).get();

    return rows
        .map(
          (row) => CategoryListItem(
            id: row.read<String>('id'),
            name: row.read<String>('name'),
            parentId: row.readNullable<String>('parent_id'),
            isActive: row.read<int>('is_active') == 1,
            productCount: row.read<int>('product_count'),
          ),
        )
        .toList();
  }

  @override
  Future<void> createSupplier(SupplierUpsertInput input) async {
    if (input.name.trim().isEmpty) {
      throw ValidationException('El proveedor requiere nombre.');
    }
    if (input.cuit != null && input.cuit!.trim().isNotEmpty) {
      await _assertUniqueSupplierCuit(input.cuit!.trim());
    }
    final now = DateTime.now().toUtc();
    await _db.into(_db.suppliers).insert(
          SuppliersCompanion.insert(
            id: input.id,
            name: input.name.trim(),
            legalName: Value(_normalizeOptional(input.legalName)),
            cuit: Value(_normalizeOptional(input.cuit)),
            phone: Value(_normalizeOptional(input.phone)),
            email: Value(_normalizeOptional(input.email)),
            address: Value(_normalizeOptional(input.address)),
            notes: Value(_normalizeOptional(input.notes)),
            isActive: Value(input.isActive),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  @override
  Future<void> updateSupplier(SupplierUpsertInput input) async {
    if (input.name.trim().isEmpty) {
      throw ValidationException('El proveedor requiere nombre.');
    }
    final existing = await (_db.select(_db.suppliers)
          ..where((t) => t.id.equals(input.id)))
        .getSingleOrNull();
    if (existing == null) {
      throw NotFoundException('El proveedor no existe.');
    }
    if (input.cuit != null && input.cuit!.trim().isNotEmpty) {
      await _assertUniqueSupplierCuit(
        input.cuit!.trim(),
        excludeSupplierId: input.id,
      );
    }
    await (_db.update(_db.suppliers)..where((t) => t.id.equals(input.id)))
        .write(
      SuppliersCompanion(
        name: Value(input.name.trim()),
        legalName: Value(_normalizeOptional(input.legalName)),
        cuit: Value(_normalizeOptional(input.cuit)),
        phone: Value(_normalizeOptional(input.phone)),
        email: Value(_normalizeOptional(input.email)),
        address: Value(_normalizeOptional(input.address)),
        notes: Value(_normalizeOptional(input.notes)),
        isActive: Value(input.isActive),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> setSupplierActive(String supplierId, bool isActive) async {
    final existing = await (_db.select(_db.suppliers)
          ..where((t) => t.id.equals(supplierId)))
        .getSingleOrNull();
    if (existing == null) {
      throw NotFoundException('El proveedor no existe.');
    }
    await (_db.update(_db.suppliers)..where((t) => t.id.equals(supplierId)))
        .write(
      SuppliersCompanion(
        isActive: Value(isActive),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<List<SupplierListItem>> listSuppliers({
    String? search,
    bool includeInactive = true,
  }) async {
    final where = <String>['1=1'];
    final values = <Object>[];
    if (!includeInactive) {
      where.add('s.is_active = 1');
    }
    final normalized = search?.trim().toLowerCase();
    if (normalized != null && normalized.isNotEmpty) {
      where.add('''
        (
          LOWER(s.name) LIKE ?
          OR LOWER(IFNULL(s.legal_name, '')) LIKE ?
          OR LOWER(IFNULL(s.cuit, '')) LIKE ?
          OR LOWER(IFNULL(s.phone, '')) LIKE ?
          OR LOWER(IFNULL(s.email, '')) LIKE ?
        )
      ''');
      values.add('%$normalized%');
      values.add('%$normalized%');
      values.add('%$normalized%');
      values.add('%$normalized%');
      values.add('%$normalized%');
    }

    final rows = await _db.customSelect(
      '''
      SELECT
        s.id,
        s.name,
        s.legal_name,
        s.cuit,
        s.phone,
        s.email,
        s.address,
        s.notes,
        s.is_active,
        COUNT(b.id) AS batch_count
      FROM suppliers s
      LEFT JOIN product_batches b ON b.supplier_id = s.id
      WHERE ${where.join(' AND ')}
      GROUP BY s.id
      ORDER BY LOWER(s.name) ASC
      ''',
      variables: values.map(_asVariable).toList(),
    ).get();

    return rows
        .map(
          (row) => SupplierListItem(
            id: row.read<String>('id'),
            name: row.read<String>('name'),
            legalName: row.readNullable<String>('legal_name'),
            cuit: row.readNullable<String>('cuit'),
            phone: row.readNullable<String>('phone'),
            email: row.readNullable<String>('email'),
            address: row.readNullable<String>('address'),
            notes: row.readNullable<String>('notes'),
            isActive: row.read<int>('is_active') == 1,
            productBatchCount: row.read<int>('batch_count'),
          ),
        )
        .toList();
  }

  @override
  Future<SupplierDetailView> getSupplierDetail(String supplierId) async {
    final row = await _db.customSelect(
      '''
      SELECT
        s.id,
        s.name,
        s.legal_name,
        s.cuit,
        s.phone,
        s.email,
        s.address,
        s.notes,
        s.is_active,
        COUNT(b.id) AS income_count,
        COUNT(DISTINCT b.product_id) AS products_count,
        MAX(b.received_at) AS last_income_at
      FROM suppliers s
      LEFT JOIN product_batches b ON b.supplier_id = s.id
      WHERE s.id = ?
      GROUP BY s.id
      ''',
      variables: <Variable<Object>>[_asVariable(supplierId)],
    ).getSingleOrNull();

    if (row == null) {
      throw NotFoundException('El proveedor no existe.');
    }

    return SupplierDetailView(
      id: row.read<String>('id'),
      name: row.read<String>('name'),
      legalName: row.readNullable<String>('legal_name'),
      cuit: row.readNullable<String>('cuit'),
      phone: row.readNullable<String>('phone'),
      email: row.readNullable<String>('email'),
      address: row.readNullable<String>('address'),
      notes: row.readNullable<String>('notes'),
      isActive: row.read<int>('is_active') == 1,
      incomeCount: row.read<int>('income_count'),
      associatedProductsCount: row.read<int>('products_count'),
      lastIncomeAt: _readNullableDateTimeFromRow(row, 'last_income_at'),
    );
  }

  @override
  Future<void> createCustomer(CustomerUpsertInput input) async {
    if (input.name.trim().isEmpty) {
      throw ValidationException('El cliente requiere nombre.');
    }
    final now = DateTime.now().toUtc();
    await _db.into(_db.customers).insert(
          CustomersCompanion.insert(
            id: input.id,
            name: input.name.trim(),
            phone: Value(_normalizeOptional(input.phone)),
            email: Value(_normalizeOptional(input.email)),
            document: Value(_normalizeOptional(input.document)),
            address: Value(_normalizeOptional(input.address)),
            notes: Value(_normalizeOptional(input.notes)),
            isActive: Value(input.isActive),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  @override
  Future<void> updateCustomer(CustomerUpsertInput input) async {
    if (input.name.trim().isEmpty) {
      throw ValidationException('El cliente requiere nombre.');
    }
    final existing = await (_db.select(_db.customers)
          ..where((t) => t.id.equals(input.id)))
        .getSingleOrNull();
    if (existing == null) {
      throw NotFoundException('El cliente no existe.');
    }
    await (_db.update(_db.customers)..where((t) => t.id.equals(input.id)))
        .write(
      CustomersCompanion(
        name: Value(input.name.trim()),
        phone: Value(_normalizeOptional(input.phone)),
        email: Value(_normalizeOptional(input.email)),
        document: Value(_normalizeOptional(input.document)),
        address: Value(_normalizeOptional(input.address)),
        notes: Value(_normalizeOptional(input.notes)),
        isActive: Value(input.isActive),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> setCustomerActive(String customerId, bool isActive) async {
    final existing = await (_db.select(_db.customers)
          ..where((t) => t.id.equals(customerId)))
        .getSingleOrNull();
    if (existing == null) {
      throw NotFoundException('El cliente no existe.');
    }
    await (_db.update(_db.customers)..where((t) => t.id.equals(customerId)))
        .write(
      CustomersCompanion(
        isActive: Value(isActive),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<List<CustomerListItem>> listCustomers({
    String? search,
    bool includeInactive = true,
  }) async {
    final where = <String>['1=1'];
    final values = <Object>[];
    if (!includeInactive) {
      where.add('c.is_active = 1');
    }
    final normalized = search?.trim().toLowerCase();
    if (normalized != null && normalized.isNotEmpty) {
      where.add('''
        (
          LOWER(c.name) LIKE ?
          OR LOWER(IFNULL(c.phone, '')) LIKE ?
          OR LOWER(IFNULL(c.email, '')) LIKE ?
          OR LOWER(IFNULL(c.document, '')) LIKE ?
        )
      ''');
      values.add('%$normalized%');
      values.add('%$normalized%');
      values.add('%$normalized%');
      values.add('%$normalized%');
    }

    final rows = await _db.customSelect(
      '''
      SELECT
        c.id,
        c.name,
        c.phone,
        c.email,
        c.document,
        c.address,
        c.notes,
        c.is_active
      FROM customers c
      WHERE ${where.join(' AND ')}
      ORDER BY LOWER(c.name) ASC
      ''',
      variables: values.map(_asVariable).toList(),
    ).get();

    return rows
        .map(
          (row) => CustomerListItem(
            id: row.read<String>('id'),
            name: row.read<String>('name'),
            phone: row.readNullable<String>('phone'),
            email: row.readNullable<String>('email'),
            document: row.readNullable<String>('document'),
            address: row.readNullable<String>('address'),
            notes: row.readNullable<String>('notes'),
            isActive: row.read<int>('is_active') == 1,
          ),
        )
        .toList();
  }

  @override
  Future<CustomerDetailView> getCustomerDetail(String customerId) async {
    final customer = await (_db.select(_db.customers)
          ..where((t) => t.id.equals(customerId)))
        .getSingleOrNull();
    if (customer == null) {
      throw NotFoundException('El cliente no existe.');
    }

    final salesRow = await _db.customSelect(
      '''
      SELECT
        COUNT(*) AS sales_count,
        COALESCE(SUM(total_cents), 0) AS revenue_cents
      FROM sales
      WHERE customer_id = ?
        AND status = 'sold'
        AND confirmed_at IS NOT NULL
      ''',
      variables: <Variable<Object>>[_asVariable(customerId)],
    ).getSingle();

    final reservationsRow = await _db.customSelect(
      '''
      SELECT COUNT(*) AS reservations_count
      FROM reservations
      WHERE customer_id = ?
      ''',
      variables: <Variable<Object>>[_asVariable(customerId)],
    ).getSingle();

    final history = await _db.customSelect(
      '''
      SELECT id, 'sale' AS reference_type, status, total_cents AS amount_cents, COALESCE(confirmed_at, created_at) AS created_at
      FROM sales
      WHERE customer_id = ?
      UNION ALL
      SELECT id, 'reservation' AS reference_type, status,
             COALESCE((
               SELECT SUM(ri.line_total_cents + CAST(ROUND((ri.line_total_cents * ri.tax_rate_bps) / 10000.0) AS INTEGER))
               FROM reservation_items ri
               WHERE ri.reservation_id = reservations.id
             ), 0) AS amount_cents,
             created_at
      FROM reservations
      WHERE customer_id = ?
      ORDER BY created_at DESC
      LIMIT 20
      ''',
      variables: <Variable<Object>>[
        _asVariable(customerId),
        _asVariable(customerId),
      ],
    ).get();

    final salesCount = salesRow.read<int>('sales_count');
    final revenueCents = salesRow.read<int>('revenue_cents');

    return CustomerDetailView(
      customer: CustomerListItem(
        id: customer.id,
        name: customer.name,
        phone: customer.phone,
        email: customer.email,
        document: customer.document,
        address: customer.address,
        notes: customer.notes,
        isActive: customer.isActive,
      ),
      salesCount: salesCount,
      reservationsCount: reservationsRow.read<int>('reservations_count'),
      revenueCents: revenueCents,
      averageTicketCents: salesCount > 0 ? revenueCents ~/ salesCount : 0,
      history: history
          .map(
            (row) => CustomerHistoryItem(
              id: row.read<String>('id'),
              referenceType: row.read<String>('reference_type'),
              status: row.read<String>('status'),
              amountCents: row.read<int>('amount_cents'),
              createdAt: _readDateTimeFromRow(row, 'created_at'),
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> saveSaleDraft(SaleDraftUpsertInput input) async {
    if (input.lines.isEmpty) {
      throw ValidationException('La venta debe incluir productos.');
    }

    await _db.transaction(() async {
      final existing = await (_db.select(_db.sales)
            ..where((t) => t.id.equals(input.saleId)))
          .getSingleOrNull();

      if (existing != null && existing.status != _statusDraft) {
        throw ConflictException('Solo se puede editar una venta en borrador.');
      }

      final now = DateTime.now().toUtc();
      var subtotalCents = 0;
      var totalTaxCents = 0;
      var discountCents = 0;
      var estimatedProfitCents = 0;

      if (existing == null) {
        await _db.into(_db.sales).insert(
              SalesCompanion.insert(
                id: input.saleId,
                customerId: Value(input.customerId),
                status: const Value(_statusDraft),
                notes: Value(input.notes),
                createdAt: input.createdAt.toUtc(),
                updatedAt: now,
              ),
            );
      } else {
        await (_db.update(_db.sales)..where((t) => t.id.equals(input.saleId)))
            .write(
          SalesCompanion(
            customerId: Value(input.customerId),
            notes: Value(input.notes),
            updatedAt: Value(now),
          ),
        );
        await (_db.delete(_db.saleItems)
              ..where((t) => t.saleId.equals(input.saleId)))
            .go();
      }

      for (final line in input.lines) {
        if (line.quantity <= 0) {
          throw ValidationException('La cantidad debe ser mayor a cero.');
        }
        final product = await _requireProduct(line.productId);
        if (!product.isActive) {
          throw ConflictException(
              'No se puede usar un producto inactivo en la venta.');
        }
        final lineSubtotal =
            (line.unitPriceCents * line.quantity) - line.discountCents;
        final lineTax = ((lineSubtotal * line.taxRateBps) / 10000).round();
        final lineProfit =
            ((line.unitPriceCents - product.costCents) * line.quantity) -
                line.discountCents;

        subtotalCents += lineSubtotal;
        totalTaxCents += lineTax;
        discountCents += line.discountCents;
        estimatedProfitCents += lineProfit;

        await _db.into(_db.saleItems).insert(
              SaleItemsCompanion.insert(
                id: line.itemId,
                saleId: input.saleId,
                productId: line.productId,
                quantity: line.quantity,
                unitPriceCents: line.unitPriceCents,
                unitCostCents: product.costCents,
                taxRateBps: Value(line.taxRateBps),
                discountCents: Value(line.discountCents),
                taxCents: Value(lineTax),
                lineTotalCents: lineSubtotal,
                lineProfitCents: Value(lineProfit),
              ),
            );
      }

      await (_db.update(_db.sales)..where((t) => t.id.equals(input.saleId)))
          .write(
        SalesCompanion(
          subtotalCents: Value(subtotalCents),
          taxCents: Value(totalTaxCents),
          discountCents: Value(discountCents),
          totalCents: Value(subtotalCents + totalTaxCents),
          estimatedProfitCents: Value(estimatedProfitCents),
          updatedAt: Value(now),
        ),
      );
    });
  }

  @override
  Future<void> deleteSaleDraft(String saleId) async {
    await _db.transaction(() async {
      final sale = await (_db.select(_db.sales)
            ..where((t) => t.id.equals(saleId)))
          .getSingleOrNull();
      if (sale == null) {
        throw NotFoundException('La venta no existe.');
      }
      if (sale.status != _statusDraft) {
        throw ConflictException(
            'Solo se puede eliminar una venta en borrador.');
      }
      await (_db.delete(_db.saleItems)..where((t) => t.saleId.equals(saleId)))
          .go();
      await (_db.delete(_db.sales)..where((t) => t.id.equals(saleId))).go();
    });
  }

  @override
  Future<List<SaleListItem>> listSales(SaleQuery query) async {
    final where = <String>['1=1'];
    final values = <Object>[];
    final normalized = query.search?.trim().toLowerCase();
    if (normalized != null && normalized.isNotEmpty) {
      where.add('''
        (
          LOWER(s.id) LIKE ?
          OR LOWER(IFNULL(c.name, '')) LIKE ?
        )
      ''');
      values.add('%$normalized%');
      values.add('%$normalized%');
    }
    if (query.customerId != null && query.customerId!.isNotEmpty) {
      where.add('s.customer_id = ?');
      values.add(query.customerId!);
    }
    if (query.status != SaleStatusFilter.all) {
      where.add('s.status = ?');
      values.add(_saleStatusFilterValue(query.status));
    }
    final start = _dashboardPeriodStart(query.period, query.from, query.to);
    final end = _dashboardPeriodEnd(query.period, query.from, query.to);
    if (start != null) {
      where.add('COALESCE(s.confirmed_at, s.created_at) >= ?');
      values.add(start.toUtc());
    }
    if (end != null) {
      where.add('COALESCE(s.confirmed_at, s.created_at) < ?');
      values.add(end.toUtc());
    }

    final rows = await _db.customSelect(
      '''
      SELECT
        s.id,
        s.status,
        s.customer_id,
        c.name AS customer_name,
        COUNT(si.id) AS product_count,
        COALESCE(SUM(si.quantity), 0) AS units_count,
        s.subtotal_cents,
        s.tax_cents,
        s.discount_cents,
        s.total_cents,
        s.estimated_profit_cents,
        s.created_at,
        s.updated_at,
        s.confirmed_at
      FROM sales s
      LEFT JOIN customers c ON c.id = s.customer_id
      LEFT JOIN sale_items si ON si.sale_id = s.id
      WHERE ${where.join(' AND ')}
      GROUP BY s.id, c.name
      ORDER BY COALESCE(s.confirmed_at, s.created_at) DESC, s.created_at DESC
      LIMIT ? OFFSET ?
      ''',
      variables: <Variable<Object>>[
        ...values.map(_asVariable),
        _asVariable(query.limit),
        _asVariable(query.offset),
      ],
    ).get();

    return rows.map(_mapSaleListItem).toList();
  }

  @override
  Future<SaleDetailView> getSaleDetail(String saleId) async {
    final saleRow = await _db.customSelect(
      '''
      SELECT
        s.id,
        s.status,
        s.customer_id,
        c.name AS customer_name,
        COUNT(si.id) AS product_count,
        COALESCE(SUM(si.quantity), 0) AS units_count,
        s.subtotal_cents,
        s.tax_cents,
        s.discount_cents,
        s.total_cents,
        s.estimated_profit_cents,
        s.created_at,
        s.updated_at,
        s.confirmed_at,
        s.notes,
        s.reservation_id
      FROM sales s
      LEFT JOIN customers c ON c.id = s.customer_id
      LEFT JOIN sale_items si ON si.sale_id = s.id
      WHERE s.id = ?
      GROUP BY s.id, c.name
      ''',
      variables: <Variable<Object>>[_asVariable(saleId)],
    ).getSingleOrNull();
    if (saleRow == null) {
      throw NotFoundException('La venta no existe.');
    }

    final lines = await _db.customSelect(
      '''
      SELECT
        si.id,
        si.product_id,
        p.name AS product_name,
        p.internal_code AS product_code,
        si.quantity,
        si.unit_price_cents,
        si.unit_cost_cents,
        si.tax_rate_bps,
        si.tax_cents,
        si.discount_cents,
        si.line_total_cents,
        si.line_profit_cents
      FROM sale_items si
      JOIN products p ON p.id = si.product_id
      WHERE si.sale_id = ?
      ORDER BY p.name ASC
      ''',
      variables: <Variable<Object>>[_asVariable(saleId)],
    ).get();

    return SaleDetailView(
      sale: _mapSaleListItem(saleRow),
      lines: lines
          .map(
            (row) => SaleLineView(
              id: row.read<String>('id'),
              productId: row.read<String>('product_id'),
              productName: row.read<String>('product_name'),
              productCode: row.read<String>('product_code'),
              quantity: row.read<int>('quantity'),
              unitPriceCents: row.read<int>('unit_price_cents'),
              unitCostCents: row.read<int>('unit_cost_cents'),
              taxRateBps: row.read<int>('tax_rate_bps'),
              taxCents: row.read<int>('tax_cents'),
              discountCents: row.read<int>('discount_cents'),
              lineTotalCents: row.read<int>('line_total_cents'),
              lineProfitCents: row.read<int>('line_profit_cents'),
            ),
          )
          .toList(),
      notes: saleRow.readNullable<String>('notes'),
      reservationId: saleRow.readNullable<String>('reservation_id'),
    );
  }

  @override
  Future<List<ReservationListItem>> listReservations(
      ReservationQuery query) async {
    final where = <String>['1=1'];
    final values = <Object>[];
    final normalized = query.search?.trim().toLowerCase();
    if (normalized != null && normalized.isNotEmpty) {
      where.add('''
        (
          LOWER(r.id) LIKE ?
          OR LOWER(IFNULL(c.name, '')) LIKE ?
        )
      ''');
      values.add('%$normalized%');
      values.add('%$normalized%');
    }
    if (query.customerId != null && query.customerId!.isNotEmpty) {
      where.add('r.customer_id = ?');
      values.add(query.customerId!);
    }
    if (query.status != ReservationStatusFilter.all) {
      where.add('r.status = ?');
      values.add(_reservationStatusFilterValue(query.status));
    }
    final start = _dashboardPeriodStart(query.period, query.from, query.to);
    final end = _dashboardPeriodEnd(query.period, query.from, query.to);
    if (start != null) {
      where.add('r.created_at >= ?');
      values.add(start.toUtc());
    }
    if (end != null) {
      where.add('r.created_at < ?');
      values.add(end.toUtc());
    }

    final rows = await _db.customSelect(
      '''
      SELECT
        r.id,
        r.status,
        r.customer_id,
        c.name AS customer_name,
        COUNT(ri.id) AS product_count,
        COALESCE(SUM(ri.quantity), 0) AS units_count,
        COALESCE(SUM(ri.line_total_cents), 0) AS subtotal_cents,
        COALESCE(SUM(CAST(ROUND((ri.line_total_cents * ri.tax_rate_bps) / 10000.0) AS INTEGER)), 0) AS tax_cents,
        COALESCE(SUM(ri.discount_cents), 0) AS discount_cents,
        COALESCE(SUM(ri.line_total_cents + CAST(ROUND((ri.line_total_cents * ri.tax_rate_bps) / 10000.0) AS INTEGER)), 0) AS total_cents,
        r.created_at,
        r.updated_at,
        r.confirmed_at,
        r.canceled_at,
        r.deleted_at
      FROM reservations r
      LEFT JOIN customers c ON c.id = r.customer_id
      LEFT JOIN reservation_items ri ON ri.reservation_id = r.id
      WHERE ${where.join(' AND ')}
      GROUP BY r.id, c.name
      ORDER BY r.created_at DESC
      LIMIT ? OFFSET ?
      ''',
      variables: <Variable<Object>>[
        ...values.map(_asVariable),
        _asVariable(query.limit),
        _asVariable(query.offset),
      ],
    ).get();

    return rows.map(_mapReservationListItem).toList();
  }

  @override
  Future<ReservationDetailView> getReservationDetail(
      String reservationId) async {
    final reservationRow = await _db.customSelect(
      '''
      SELECT
        r.id,
        r.status,
        r.customer_id,
        c.name AS customer_name,
        COUNT(ri.id) AS product_count,
        COALESCE(SUM(ri.quantity), 0) AS units_count,
        COALESCE(SUM(ri.line_total_cents), 0) AS subtotal_cents,
        COALESCE(SUM(CAST(ROUND((ri.line_total_cents * ri.tax_rate_bps) / 10000.0) AS INTEGER)), 0) AS tax_cents,
        COALESCE(SUM(ri.discount_cents), 0) AS discount_cents,
        COALESCE(SUM(ri.line_total_cents + CAST(ROUND((ri.line_total_cents * ri.tax_rate_bps) / 10000.0) AS INTEGER)), 0) AS total_cents,
        r.created_at,
        r.updated_at,
        r.confirmed_at,
        r.canceled_at,
        r.deleted_at,
        r.notes
      FROM reservations r
      LEFT JOIN customers c ON c.id = r.customer_id
      LEFT JOIN reservation_items ri ON ri.reservation_id = r.id
      WHERE r.id = ?
      GROUP BY r.id, c.name
      ''',
      variables: <Variable<Object>>[_asVariable(reservationId)],
    ).getSingleOrNull();
    if (reservationRow == null) {
      throw NotFoundException('La reserva no existe.');
    }

    final lines = await _db.customSelect(
      '''
      SELECT
        ri.id,
        ri.product_id,
        p.name AS product_name,
        p.internal_code AS product_code,
        ri.quantity,
        ri.unit_price_cents,
        ri.unit_cost_cents,
        ri.tax_rate_bps,
        ri.discount_cents,
        ri.line_total_cents
      FROM reservation_items ri
      JOIN products p ON p.id = ri.product_id
      WHERE ri.reservation_id = ?
      ORDER BY p.name ASC
      ''',
      variables: <Variable<Object>>[_asVariable(reservationId)],
    ).get();

    return ReservationDetailView(
      reservation: _mapReservationListItem(reservationRow),
      lines: lines
          .map(
            (row) => ReservationLineView(
              id: row.read<String>('id'),
              productId: row.read<String>('product_id'),
              productName: row.read<String>('product_name'),
              productCode: row.read<String>('product_code'),
              quantity: row.read<int>('quantity'),
              unitPriceCents: row.read<int>('unit_price_cents'),
              unitCostCents: row.read<int>('unit_cost_cents'),
              taxRateBps: row.read<int>('tax_rate_bps'),
              discountCents: row.read<int>('discount_cents'),
              lineTotalCents: row.read<int>('line_total_cents'),
            ),
          )
          .toList(),
      notes: reservationRow.readNullable<String>('notes'),
    );
  }

  @override
  Future<void> createReservationDraft(CreateReservationDraftInput input) async {
    await _db.transaction(() async {
      final existingReservation = await (_db.select(_db.reservations)
            ..where((t) => t.id.equals(input.reservationId)))
          .getSingleOrNull();
      if (existingReservation != null) {
        throw ConflictException(
            'La reserva ya existe y no puede crearse de nuevo.');
      }
      if (input.lines.isEmpty) {
        throw ValidationException('El borrador debe incluir productos.');
      }

      await _db.into(_db.reservations).insert(
            ReservationsCompanion.insert(
              id: input.reservationId,
              customerId: Value(input.customerId),
              status: const Value(_statusDraft),
              notes: Value(input.notes),
              createdAt: input.createdAt.toUtc(),
              updatedAt: input.createdAt.toUtc(),
            ),
          );

      for (final line in input.lines) {
        if (line.quantity <= 0) {
          throw ValidationException(
              'La cantidad del borrador debe ser mayor a cero.');
        }
        final product = await _requireProduct(line.productId);
        if (!product.isActive) {
          throw ConflictException(
              'No se puede agregar un producto inactivo al borrador.');
        }
        final lineTotal =
            (line.unitPriceCents * line.quantity) - line.discountCents;
        await _db.into(_db.reservationItems).insert(
              ReservationItemsCompanion.insert(
                id: line.itemId,
                reservationId: input.reservationId,
                productId: line.productId,
                quantity: line.quantity,
                unitPriceCents: Value(line.unitPriceCents),
                unitCostCents: Value(product.costCents),
                taxRateBps: Value(line.taxRateBps),
                discountCents: Value(line.discountCents),
                lineTotalCents: Value(lineTotal),
              ),
            );
      }

      await _insertAudit(
        entityType: 'reservation',
        entityId: input.reservationId,
        action: 'reservation_draft_create',
        before: <String, Object?>{'reservation_status': null},
        after: <String, Object?>{
          'reservation_status': _statusDraft,
          'customer_id': input.customerId,
          'lines_count': input.lines.length,
        },
        createdAt: input.createdAt.toUtc(),
      );
    });
  }

  @override
  Future<void> saveReservationDraft(CreateReservationDraftInput input) async {
    await _db.transaction(() async {
      final existing = await (_db.select(_db.reservations)
            ..where((t) => t.id.equals(input.reservationId)))
          .getSingleOrNull();
      if (existing == null) {
        await createReservationDraft(input);
        return;
      }
      if (existing.status != _statusDraft) {
        throw ConflictException(
            'Solo se puede editar una reserva en borrador.');
      }
      if (input.lines.isEmpty) {
        throw ValidationException('La reserva debe incluir productos.');
      }

      await (_db.update(_db.reservations)
            ..where((t) => t.id.equals(input.reservationId)))
          .write(
        ReservationsCompanion(
          customerId: Value(input.customerId),
          notes: Value(input.notes),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      await (_db.delete(_db.reservationItems)
            ..where((t) => t.reservationId.equals(input.reservationId)))
          .go();

      for (final line in input.lines) {
        if (line.quantity <= 0) {
          throw ValidationException(
              'La cantidad del borrador debe ser mayor a cero.');
        }
        final product = await _requireProduct(line.productId);
        if (!product.isActive) {
          throw ConflictException(
              'No se puede agregar un producto inactivo al borrador.');
        }
        final lineTotal =
            (line.unitPriceCents * line.quantity) - line.discountCents;
        await _db.into(_db.reservationItems).insert(
              ReservationItemsCompanion.insert(
                id: line.itemId,
                reservationId: input.reservationId,
                productId: line.productId,
                quantity: line.quantity,
                unitPriceCents: Value(line.unitPriceCents),
                unitCostCents: Value(product.costCents),
                taxRateBps: Value(line.taxRateBps),
                discountCents: Value(line.discountCents),
                lineTotalCents: Value(lineTotal),
              ),
            );
      }
    });
  }

  @override
  Future<void> reserveDraftReservation(
    String reservationId,
    DateTime reservedAt,
  ) async {
    await _db.transaction(() async {
      final reservation = await (_db.select(_db.reservations)
            ..where((t) => t.id.equals(reservationId)))
          .getSingleOrNull();
      if (reservation == null) {
        throw NotFoundException('La reserva no existe.');
      }
      _assertCanTransition(
        reservation.status,
        CommercialStatus.reserved,
      );

      final items = await (_db.select(_db.reservationItems)
            ..where((t) => t.reservationId.equals(reservationId)))
          .get();
      if (items.isEmpty) {
        throw ValidationException(
            'La reserva en borrador debe tener al menos un item.');
      }

      final beforeProducts = <String, Map<String, Object?>>{};
      for (final item in items) {
        final product = await _requireProduct(item.productId);
        if (!product.isActive) {
          throw ConflictException('No se puede reservar un producto inactivo.');
        }
        beforeProducts[item.productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };

        final available = product.stockTotal - product.stockReserved;
        if (item.quantity > available) {
          throw ConflictException(
              'No hay stock disponible suficiente para reservar.');
        }
        final allocations = await _allocateBatches(
          productId: item.productId,
          quantity: item.quantity,
          mode: _AllocationMode.reserve,
        );
        final weightedCost = _weightedUnitCost(allocations, item.quantity);

        await (_db.update(_db.reservationItems)
              ..where((t) => t.id.equals(item.id)))
            .write(
          ReservationItemsCompanion(unitCostCents: Value(weightedCost)),
        );

        for (final allocation in allocations) {
          await _db.into(_db.batchAllocations).insert(
                BatchAllocationsCompanion.insert(
                  id: allocation.id,
                  productId: item.productId,
                  batchId: allocation.batchId,
                  reservationItemId: Value(item.id),
                  quantity: allocation.quantity,
                  quantityReserved: Value(allocation.quantity),
                  quantitySold: const Value(0),
                  state: const Value(_statusReserved),
                  createdAt: reservedAt.toUtc(),
                ),
              );
        }

        final nextReserved = product.stockReserved + item.quantity;
        await (_db.update(_db.products)
              ..where((tbl) => tbl.id.equals(item.productId)))
            .write(
          ProductsCompanion(
            stockReserved: Value(nextReserved),
            updatedAt: Value(reservedAt.toUtc()),
          ),
        );

        await _insertMovement(
          productId: item.productId,
          batchId: allocations.first.batchId,
          movementType: 'reservation_create',
          quantity: item.quantity,
          stockBefore: product.stockTotal - product.stockReserved,
          stockAfter: product.stockTotal - nextReserved,
          referenceType: 'reservation',
          referenceId: reservationId,
          createdAt: reservedAt.toUtc(),
        );
      }

      await (_db.update(_db.reservations)
            ..where((t) => t.id.equals(reservationId)))
          .write(
        ReservationsCompanion(
          status: const Value(_statusReserved),
          updatedAt: Value(reservedAt.toUtc()),
        ),
      );

      final afterProducts = <String, Map<String, Object?>>{};
      for (final productId in beforeProducts.keys) {
        final product = await _requireProduct(productId);
        afterProducts[productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
      }

      await _insertAudit(
        entityType: 'reservation',
        entityId: reservationId,
        action: 'reservation_confirm',
        before: <String, Object?>{
          'reservation_status': reservation.status,
          'products': beforeProducts,
        },
        after: <String, Object?>{
          'reservation_status': _statusReserved,
          'products': afterProducts,
        },
        createdAt: reservedAt.toUtc(),
      );
    });
  }

  @override
  Future<void> deleteReservation(
      String reservationId, DateTime deletedAt) async {
    await _db.transaction(() async {
      final reservation = await (_db.select(_db.reservations)
            ..where((t) => t.id.equals(reservationId)))
          .getSingleOrNull();
      if (reservation == null) {
        throw NotFoundException('La reserva no existe.');
      }
      _assertCanTransition(
        reservation.status,
        CommercialStatus.deleted,
      );

      final beforeProducts = <String, Map<String, Object?>>{};
      if (commercialStatusFromDb(reservation.status) ==
          CommercialStatus.reserved) {
        final items = await (_db.select(_db.reservationItems)
              ..where((t) => t.reservationId.equals(reservationId)))
            .get();
        for (final item in items) {
          final product = await _requireProduct(item.productId);
          beforeProducts[item.productId] = <String, Object?>{
            'stock_total': product.stockTotal,
            'stock_reserved': product.stockReserved,
          };

          final allocations = await (_db.select(_db.batchAllocations)
                ..where((t) =>
                    t.reservationItemId.equals(item.id) &
                    t.state.equals(_statusReserved)))
              .get();
          for (final allocation in allocations) {
            final batch = await (_db.select(_db.productBatches)
                  ..where((t) => t.id.equals(allocation.batchId)))
                .getSingle();
            final nextBatchReserved =
                batch.quantityReserved - allocation.quantityReserved;
            if (nextBatchReserved < 0) {
              throw ConflictException(
                  'La reserva del lote quedó inconsistente al eliminar.');
            }
            await (_db.update(_db.productBatches)
                  ..where((t) => t.id.equals(batch.id)))
                .write(
              ProductBatchesCompanion(
                quantityReserved: Value(nextBatchReserved),
                updatedAt: Value(deletedAt.toUtc()),
              ),
            );
            await (_db.update(_db.batchAllocations)
                  ..where((t) => t.id.equals(allocation.id)))
                .write(
              const BatchAllocationsCompanion(
                state: Value('deleted'),
                quantityReserved: Value(0),
              ),
            );
          }

          final nextReserved = product.stockReserved - item.quantity;
          if (nextReserved < 0) {
            throw ConflictException(
                'El stock reservado quedó negativo al eliminar la reserva.');
          }
          await (_db.update(_db.products)
                ..where((tbl) => tbl.id.equals(item.productId)))
              .write(
            ProductsCompanion(
              stockReserved: Value(nextReserved),
              updatedAt: Value(deletedAt.toUtc()),
            ),
          );

          await _insertMovement(
            productId: item.productId,
            movementType: 'reservation_delete',
            quantity: item.quantity,
            stockBefore: product.stockTotal - product.stockReserved,
            stockAfter: product.stockTotal - nextReserved,
            referenceType: 'reservation',
            referenceId: reservationId,
            createdAt: deletedAt.toUtc(),
          );
        }
      }

      await (_db.update(_db.reservations)
            ..where((t) => t.id.equals(reservationId)))
          .write(
        ReservationsCompanion(
          status: const Value(_statusDeleted),
          deletedAt: Value(deletedAt.toUtc()),
          updatedAt: Value(deletedAt.toUtc()),
        ),
      );

      final afterProducts = <String, Map<String, Object?>>{};
      for (final productId in beforeProducts.keys) {
        final product = await _requireProduct(productId);
        afterProducts[productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
      }
      await _insertAudit(
        entityType: 'reservation',
        entityId: reservationId,
        action: 'reservation_delete',
        before: <String, Object?>{
          'reservation_status': reservation.status,
          'products': beforeProducts,
        },
        after: <String, Object?>{
          'reservation_status': _statusDeleted,
          'products': afterProducts,
        },
        createdAt: deletedAt.toUtc(),
      );
    });
  }

  @override
  Future<void> confirmDraftReservationSale(ConfirmSaleInput input) async {
    if (input.reservationId == null) {
      throw ValidationException(
          'La confirmación de venta requiere una reserva previa.');
    }
    await _db.transaction(() async {
      final existingSale = await (_db.select(_db.sales)
            ..where((t) => t.id.equals(input.saleId)))
          .getSingleOrNull();
      if (existingSale != null) {
        throw ConflictException(
            'La venta ya fue creada y no puede confirmarse nuevamente.');
      }

      final reservation = await (_db.select(_db.reservations)
            ..where((t) => t.id.equals(input.reservationId!)))
          .getSingleOrNull();
      if (reservation == null) {
        throw NotFoundException('La reserva no existe.');
      }
      _assertCanTransition(reservation.status, CommercialStatus.sold);

      final reservationItems = await (_db.select(_db.reservationItems)
            ..where((t) => t.reservationId.equals(reservation.id)))
          .get();
      if (reservationItems.isEmpty) {
        throw ValidationException(
            'La reserva en borrador debe tener al menos un item.');
      }

      final beforeProducts = <String, Map<String, Object?>>{};
      var subtotalCents = 0;
      var taxCents = 0;
      var discountCents = 0;
      var profitCents = 0;

      await _db.into(_db.sales).insert(
            SalesCompanion.insert(
              id: input.saleId,
              customerId: Value(input.customerId ?? reservation.customerId),
              reservationId: Value(reservation.id),
              status: const Value(_statusSold),
              notes: Value(input.notes ?? reservation.notes),
              createdAt: reservation.createdAt,
              updatedAt: input.confirmedAt.toUtc(),
              confirmedAt: Value(input.confirmedAt.toUtc()),
            ),
          );

      for (final item in reservationItems) {
        final product = await _requireProduct(item.productId);
        if (!product.isActive) {
          throw ConflictException('No se puede vender un producto inactivo.');
        }
        beforeProducts[item.productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
        final available = product.stockTotal - product.stockReserved;
        if (item.quantity > available) {
          throw ConflictException(
              'No hay stock disponible suficiente para vender el borrador.');
        }

        final allocations = await _allocateBatches(
          productId: item.productId,
          quantity: item.quantity,
          mode: _AllocationMode.sale,
        );
        final weightedCost = _weightedUnitCost(allocations, item.quantity);
        final lineTotal =
            (item.unitPriceCents * item.quantity) - item.discountCents;
        final lineTax = ((lineTotal * item.taxRateBps) / 10000).round();
        final lineProfit =
            ((item.unitPriceCents - weightedCost) * item.quantity) -
                item.discountCents;

        subtotalCents += lineTotal;
        taxCents += lineTax;
        discountCents += item.discountCents;
        profitCents += lineProfit;

        await _db.into(_db.saleItems).insert(
              SaleItemsCompanion.insert(
                id: item.id,
                saleId: input.saleId,
                productId: item.productId,
                quantity: item.quantity,
                unitPriceCents: item.unitPriceCents,
                unitCostCents: weightedCost,
                taxRateBps: Value(item.taxRateBps),
                discountCents: Value(item.discountCents),
                taxCents: Value(lineTax),
                lineTotalCents: lineTotal,
                lineProfitCents: Value(lineProfit),
              ),
            );

        for (final allocation in allocations) {
          await _db.into(_db.batchAllocations).insert(
                BatchAllocationsCompanion.insert(
                  id: allocation.id,
                  productId: item.productId,
                  batchId: allocation.batchId,
                  reservationItemId: Value(item.id),
                  saleItemId: Value(item.id),
                  quantity: allocation.quantity,
                  quantityReserved: const Value(0),
                  quantitySold: Value(allocation.quantity),
                  state: const Value(_statusSold),
                  createdAt: input.confirmedAt.toUtc(),
                ),
              );
        }

        final nextTotal = product.stockTotal - item.quantity;
        if (nextTotal < 0) {
          throw ConflictException('La venta dejaría stock inválido.');
        }
        await (_db.update(_db.products)
              ..where((tbl) => tbl.id.equals(item.productId)))
            .write(
          ProductsCompanion(
            stockTotal: Value(nextTotal),
            updatedAt: Value(input.confirmedAt.toUtc()),
          ),
        );

        await _insertMovement(
          productId: item.productId,
          movementType: 'sale_from_draft',
          quantity: item.quantity,
          stockBefore: product.stockTotal,
          stockAfter: nextTotal,
          referenceType: 'sale',
          referenceId: input.saleId,
          createdAt: input.confirmedAt.toUtc(),
        );
      }

      await (_db.update(_db.sales)..where((t) => t.id.equals(input.saleId)))
          .write(
        SalesCompanion(
          subtotalCents: Value(subtotalCents),
          taxCents: Value(taxCents),
          discountCents: Value(discountCents),
          totalCents: Value(subtotalCents + taxCents),
          estimatedProfitCents: Value(profitCents),
        ),
      );

      await (_db.update(_db.reservations)
            ..where((t) => t.id.equals(reservation.id)))
          .write(
        ReservationsCompanion(
          status: const Value(_statusSold),
          confirmedAt: Value(input.confirmedAt.toUtc()),
          updatedAt: Value(input.confirmedAt.toUtc()),
        ),
      );

      final afterProducts = <String, Map<String, Object?>>{};
      for (final productId in beforeProducts.keys) {
        final product = await _requireProduct(productId);
        afterProducts[productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
      }

      await _insertAudit(
        entityType: 'sale',
        entityId: input.saleId,
        action: 'sale_confirm_from_draft',
        before: <String, Object?>{
          'reservation_id': reservation.id,
          'reservation_status': reservation.status,
          'products': beforeProducts,
        },
        after: <String, Object?>{
          'reservation_id': reservation.id,
          'reservation_status': _statusSold,
          'sale_status': _statusSold,
          'products': afterProducts,
        },
        createdAt: input.confirmedAt.toUtc(),
      );
    });
  }

  @override
  Future<void> receiveStock(ReceiveStockInput input) async {
    if (input.quantity <= 0) {
      throw ValidationException('La cantidad ingresada debe ser mayor a cero.');
    }
    if (input.unitCostCents < 0) {
      throw ValidationException('El costo unitario no puede ser negativo.');
    }
    await _db.transaction(() async {
      final product = await _requireProduct(input.productId);
      await _assertSupplierIsAssignable(input.supplierId);
      final existingBatch = await (_db.select(_db.productBatches)
            ..where((t) => t.id.equals(input.batchId)))
          .getSingleOrNull();
      if (existingBatch != null) {
        throw ConflictException(
            'El lote ya existe para este ingreso de stock.');
      }
      final now = DateTime.now().toUtc();
      final before = <String, Object?>{
        'product_id': product.id,
        'stock_total': product.stockTotal,
        'stock_reserved': product.stockReserved,
      };
      await _db.into(_db.productBatches).insert(
            ProductBatchesCompanion.insert(
              id: input.batchId,
              productId: input.productId,
              batchCode: Value(input.batchCode),
              supplierId: Value(input.supplierId),
              receivedAt: input.receivedAt.toUtc(),
              expiresAt: Value(input.expiresAt?.toUtc()),
              quantityTotal: input.quantity,
              unitCostCents: input.unitCostCents,
              notes: Value(input.notes),
              createdAt: now,
              updatedAt: now,
            ),
          );

      final nextTotal = product.stockTotal + input.quantity;
      await (_db.update(_db.products)
            ..where((tbl) => tbl.id.equals(input.productId)))
          .write(
        ProductsCompanion(
          stockTotal: Value(nextTotal),
          costCents: Value(input.unitCostCents),
          updatedAt: Value(now),
        ),
      );

      await _insertMovement(
        productId: input.productId,
        batchId: input.batchId,
        movementType: 'stock_in',
        quantity: input.quantity,
        stockBefore: product.stockTotal,
        stockAfter: nextTotal,
        referenceType: 'batch',
        referenceId: input.batchId,
        createdAt: now,
      );

      await _insertAudit(
        entityType: 'stock',
        entityId: input.productId,
        action: 'stock_in',
        before: before,
        after: <String, Object?>{
          ...before,
          'stock_total': nextTotal,
          'batch_id': input.batchId,
          'quantity': input.quantity,
        },
        createdAt: now,
      );
    });
  }

  @override
  Future<void> adjustStock(StockAdjustmentInput input) async {
    if (input.deltaQuantity == 0) {
      throw ValidationException('El ajuste de stock no puede ser cero.');
    }
    await _db.transaction(() async {
      final product = await _requireProduct(input.productId);
      final createdAt = input.createdAt.toUtc();
      final nextTotal = product.stockTotal + input.deltaQuantity;
      if (nextTotal < 0 || product.stockReserved > nextTotal) {
        throw ConflictException('El ajuste dejaría stock inconsistente.');
      }

      ProductBatche? batch;
      if (input.batchId != null) {
        batch = await _requireBatch(input.batchId!);
        if (batch.productId != input.productId) {
          throw ConflictException('El lote no pertenece al producto indicado.');
        }
        final nextBatchTotal = batch.quantityTotal + input.deltaQuantity;
        if (nextBatchTotal < 0 || batch.quantityReserved > nextBatchTotal) {
          throw ConflictException('El ajuste dejaría el lote inconsistente.');
        }
        await (_db.update(_db.productBatches)
              ..where((t) => t.id.equals(batch!.id)))
            .write(
          ProductBatchesCompanion(
            quantityTotal: Value(nextBatchTotal),
            updatedAt: Value(createdAt),
          ),
        );
      }

      await (_db.update(_db.products)
            ..where((tbl) => tbl.id.equals(product.id)))
          .write(
        ProductsCompanion(
          stockTotal: Value(nextTotal),
          updatedAt: Value(createdAt),
        ),
      );

      await _insertMovement(
        productId: input.productId,
        batchId: input.batchId,
        movementType: 'stock_adjustment',
        quantity: input.deltaQuantity,
        stockBefore: product.stockTotal,
        stockAfter: nextTotal,
        referenceType: 'adjustment',
        referenceId: input.adjustmentId,
        reason: input.reason,
        observations: input.observations,
        createdAt: createdAt,
      );

      await _insertAudit(
        entityType: 'stock_adjustment',
        entityId: input.adjustmentId,
        action: 'stock_adjustment',
        before: <String, Object?>{
          'product_id': product.id,
          'batch_id': input.batchId,
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
          'batch_quantity_total': batch?.quantityTotal,
          'batch_quantity_reserved': batch?.quantityReserved,
        },
        after: <String, Object?>{
          'product_id': product.id,
          'batch_id': input.batchId,
          'stock_total': nextTotal,
          'stock_reserved': product.stockReserved,
          'batch_quantity_total':
              batch == null ? null : batch.quantityTotal + input.deltaQuantity,
          'batch_quantity_reserved': batch?.quantityReserved,
          'delta_quantity': input.deltaQuantity,
          'reason': input.reason,
        },
        createdAt: createdAt,
      );
    });
  }

  @override
  Future<void> createReservation(CreateReservationInput input) async {
    if (input.lines.isEmpty) {
      throw ValidationException('La reserva debe incluir productos.');
    }
    await _db.transaction(() async {
      final existingReservation = await (_db.select(_db.reservations)
            ..where((t) => t.id.equals(input.reservationId)))
          .getSingleOrNull();
      if (existingReservation != null) {
        throw ConflictException(
            'La reserva ya existe y no puede crearse de nuevo.');
      }

      final beforeProducts = <String, Map<String, Object?>>{};
      await _db.into(_db.reservations).insert(
            ReservationsCompanion.insert(
              id: input.reservationId,
              customerId: Value(input.customerId),
              status: const Value(_statusReserved),
              notes: Value(input.notes),
              createdAt: input.createdAt.toUtc(),
              updatedAt: input.createdAt.toUtc(),
            ),
          );

      for (final line in input.lines) {
        if (line.quantity <= 0) {
          throw ValidationException(
              'La cantidad reservada debe ser mayor a cero.');
        }
        final product = await _requireProduct(line.productId);
        if (!product.isActive) {
          throw ConflictException('No se puede reservar un producto inactivo.');
        }
        beforeProducts[line.productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
        final available = product.stockTotal - product.stockReserved;
        if (line.quantity > available) {
          throw ConflictException(
              'No hay stock disponible suficiente para reservar.');
        }
        final allocations = await _allocateBatches(
          productId: line.productId,
          quantity: line.quantity,
          mode: _AllocationMode.reserve,
        );
        final weightedCost = _weightedUnitCost(allocations, line.quantity);
        final lineTotal =
            (line.unitPriceCents * line.quantity) - line.discountCents;

        await _db.into(_db.reservationItems).insert(
              ReservationItemsCompanion.insert(
                id: line.itemId,
                reservationId: input.reservationId,
                productId: line.productId,
                quantity: line.quantity,
                unitPriceCents: Value(line.unitPriceCents),
                unitCostCents: Value(weightedCost),
                taxRateBps: Value(line.taxRateBps),
                discountCents: Value(line.discountCents),
                lineTotalCents: Value(lineTotal),
              ),
            );

        for (final allocation in allocations) {
          await _db.into(_db.batchAllocations).insert(
                BatchAllocationsCompanion.insert(
                  id: allocation.id,
                  productId: line.productId,
                  batchId: allocation.batchId,
                  reservationItemId: Value(line.itemId),
                  quantity: allocation.quantity,
                  quantityReserved: Value(allocation.quantity),
                  quantitySold: const Value(0),
                  state: const Value(_statusReserved),
                  createdAt: input.createdAt.toUtc(),
                ),
              );
        }

        final nextReserved = product.stockReserved + line.quantity;
        await (_db.update(_db.products)
              ..where((tbl) => tbl.id.equals(line.productId)))
            .write(
          ProductsCompanion(
            stockReserved: Value(nextReserved),
            updatedAt: Value(input.createdAt.toUtc()),
          ),
        );

        await _insertMovement(
          productId: line.productId,
          batchId: allocations.first.batchId,
          movementType: 'reservation_create',
          quantity: line.quantity,
          stockBefore: product.stockTotal - product.stockReserved,
          stockAfter: product.stockTotal - nextReserved,
          referenceType: 'reservation',
          referenceId: input.reservationId,
          createdAt: input.createdAt.toUtc(),
        );
      }

      final afterProducts = <String, Map<String, Object?>>{};
      for (final productId in beforeProducts.keys) {
        final product = await _requireProduct(productId);
        afterProducts[productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
      }
      await _insertAudit(
        entityType: 'reservation',
        entityId: input.reservationId,
        action: 'reservation_create',
        before: <String, Object?>{
          'reservation_status': null,
          'products': beforeProducts,
        },
        after: <String, Object?>{
          'reservation_status': _statusReserved,
          'products': afterProducts,
          'lines': input.lines
              .map(
                (line) => <String, Object?>{
                  'item_id': line.itemId,
                  'product_id': line.productId,
                  'quantity': line.quantity,
                },
              )
              .toList(),
        },
        createdAt: input.createdAt.toUtc(),
      );
    });
  }

  @override
  Future<void> cancelReservation(
      String reservationId, DateTime canceledAt) async {
    await _db.transaction(() async {
      final reservation = await (_db.select(_db.reservations)
            ..where((t) => t.id.equals(reservationId)))
          .getSingleOrNull();
      if (reservation == null) {
        throw NotFoundException('La reserva no existe.');
      }
      _assertCanTransition(
        reservation.status,
        CommercialStatus.cancelled,
      );

      final beforeProducts = <String, Map<String, Object?>>{};

      final items = await (_db.select(_db.reservationItems)
            ..where((t) => t.reservationId.equals(reservationId)))
          .get();
      for (final item in items) {
        final product = await _requireProduct(item.productId);
        beforeProducts[item.productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
        final allocations = await (_db.select(_db.batchAllocations)
              ..where((t) =>
                  t.reservationItemId.equals(item.id) &
                  t.state.equals(_statusReserved)))
            .get();

        for (final allocation in allocations) {
          final batch = await (_db.select(_db.productBatches)
                ..where((t) => t.id.equals(allocation.batchId)))
              .getSingle();
          final nextBatchReserved =
              batch.quantityReserved - allocation.quantity;
          if (nextBatchReserved < 0) {
            throw ConflictException(
                'La reserva del lote quedó inconsistente al cancelar.');
          }
          await (_db.update(_db.productBatches)
                ..where((t) => t.id.equals(batch.id)))
              .write(
            ProductBatchesCompanion(
              quantityReserved: Value(nextBatchReserved),
              updatedAt: Value(canceledAt.toUtc()),
            ),
          );
          await (_db.update(_db.batchAllocations)
                ..where((t) => t.id.equals(allocation.id)))
              .write(
            const BatchAllocationsCompanion(
              state: Value('released'),
              quantityReserved: Value(0),
            ),
          );
        }

        final nextReserved = product.stockReserved - item.quantity;
        if (nextReserved < 0) {
          throw ConflictException(
              'El stock reservado quedó negativo al cancelar la reserva.');
        }
        await (_db.update(_db.products)
              ..where((tbl) => tbl.id.equals(item.productId)))
            .write(
          ProductsCompanion(
            stockReserved: Value(nextReserved),
            updatedAt: Value(canceledAt.toUtc()),
          ),
        );

        await _insertMovement(
          productId: item.productId,
          movementType: 'reservation_cancel',
          quantity: item.quantity,
          stockBefore: product.stockTotal - product.stockReserved,
          stockAfter: product.stockTotal - nextReserved,
          referenceType: 'reservation',
          referenceId: reservationId,
          createdAt: canceledAt.toUtc(),
        );
      }

      await (_db.update(_db.reservations)
            ..where((t) => t.id.equals(reservationId)))
          .write(
        ReservationsCompanion(
          status: const Value(_statusCancelled),
          canceledAt: Value(canceledAt.toUtc()),
          updatedAt: Value(canceledAt.toUtc()),
        ),
      );

      final afterProducts = <String, Map<String, Object?>>{};
      for (final productId in beforeProducts.keys) {
        final product = await _requireProduct(productId);
        afterProducts[productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
      }

      await _insertAudit(
        entityType: 'reservation',
        entityId: reservationId,
        action: 'reservation_cancel',
        before: <String, Object?>{
          'reservation_status': reservation.status,
          'products': beforeProducts,
        },
        after: <String, Object?>{
          'reservation_status': _statusCancelled,
          'products': afterProducts,
        },
        createdAt: canceledAt.toUtc(),
      );
    });
  }

  @override
  Future<void> reserveSaleDraft(String saleId, DateTime reservedAt) async {
    final draft = await getSaleDetail(saleId);
    if (draft.sale.status != _statusDraft) {
      throw ConflictException('Solo se puede reservar una venta en borrador.');
    }

    await _db.transaction(() async {
      await createReservationDraft(
        CreateReservationDraftInput(
          reservationId: saleId,
          createdAt: draft.sale.createdAt,
          customerId: draft.sale.customerId,
          notes: draft.notes,
          lines: draft.lines
              .map(
                (line) => DraftReservationLineInput(
                  itemId: line.id,
                  productId: line.productId,
                  quantity: line.quantity,
                  unitPriceCents: line.unitPriceCents,
                  taxRateBps: line.taxRateBps,
                  discountCents: line.discountCents,
                ),
              )
              .toList(),
        ),
      );
      await reserveDraftReservation(saleId, reservedAt);
      await deleteSaleDraft(saleId);
    });
  }

  @override
  Future<void> confirmSaleDraft(String saleId, DateTime confirmedAt) async {
    final draft = await getSaleDetail(saleId);
    if (draft.sale.status != _statusDraft) {
      throw ConflictException('Solo se puede confirmar una venta en borrador.');
    }

    await _db.transaction(() async {
      await deleteSaleDraft(saleId);
      await createDirectSale(
        CreateDirectSaleInput(
          saleId: saleId,
          createdAt: confirmedAt,
          customerId: draft.sale.customerId,
          notes: draft.notes,
          lines: draft.lines
              .map(
                (line) => DirectSaleLineInput(
                  itemId: line.id,
                  productId: line.productId,
                  quantity: line.quantity,
                  unitPriceCents: line.unitPriceCents,
                  taxRateBps: line.taxRateBps,
                  discountCents: line.discountCents,
                ),
              )
              .toList(),
        ),
      );
    });
  }

  @override
  Future<void> confirmReservationSale(ConfirmSaleInput input) async {
    if (input.reservationId == null) {
      throw ValidationException(
          'La confirmación de venta requiere una reserva previa.');
    }
    await _db.transaction(() async {
      final existingSale = await (_db.select(_db.sales)
            ..where((t) => t.id.equals(input.saleId)))
          .getSingleOrNull();
      if (existingSale != null) {
        throw ConflictException(
            'La venta ya fue creada y no puede confirmarse nuevamente.');
      }

      final reservation = await (_db.select(_db.reservations)
            ..where((t) => t.id.equals(input.reservationId!)))
          .getSingleOrNull();
      if (reservation == null) {
        throw NotFoundException('La reserva no existe.');
      }
      if (reservation.status == _statusSold) {
        throw ConflictException('La reserva ya fue confirmada anteriormente.');
      }
      if (reservation.status != _statusReserved) {
        throw ConflictException(
            'Solo una reserva activa puede confirmarse como venta.');
      }

      var subtotalCents = 0;
      var totalTaxCents = 0;
      var discountCents = 0;
      var estimatedProfitCents = 0;

      final beforeProducts = <String, Map<String, Object?>>{};

      await _db.into(_db.sales).insert(
            SalesCompanion.insert(
              id: input.saleId,
              customerId: Value(input.customerId ?? reservation.customerId),
              reservationId: Value(reservation.id),
              status: const Value(_statusSold),
              notes: Value(input.notes ?? reservation.notes),
              createdAt: reservation.createdAt,
              updatedAt: input.confirmedAt.toUtc(),
              confirmedAt: Value(input.confirmedAt.toUtc()),
            ),
          );

      final reservationItems = await (_db.select(_db.reservationItems)
            ..where((t) => t.reservationId.equals(reservation.id)))
          .get();

      for (final reservationItem in reservationItems) {
        final product = await _requireProduct(reservationItem.productId);
        if (!product.isActive) {
          throw ConflictException('No se puede vender un producto inactivo.');
        }
        beforeProducts[reservationItem.productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
        final allocations = await (_db.select(_db.batchAllocations)
              ..where((t) =>
                  t.reservationItemId.equals(reservationItem.id) &
                  t.state.equals(_statusReserved)))
            .get();

        final lineProfit =
            ((reservationItem.unitPriceCents - reservationItem.unitCostCents) *
                    reservationItem.quantity) -
                reservationItem.discountCents;
        final lineTaxCents =
            ((reservationItem.lineTotalCents * reservationItem.taxRateBps) /
                    10000)
                .round();
        subtotalCents += reservationItem.lineTotalCents;
        discountCents += reservationItem.discountCents;
        estimatedProfitCents += lineProfit;
        totalTaxCents += lineTaxCents;

        await _db.into(_db.saleItems).insert(
              SaleItemsCompanion.insert(
                id: reservationItem.id,
                saleId: input.saleId,
                productId: reservationItem.productId,
                quantity: reservationItem.quantity,
                unitPriceCents: reservationItem.unitPriceCents,
                unitCostCents: reservationItem.unitCostCents,
                taxRateBps: Value(reservationItem.taxRateBps),
                discountCents: Value(reservationItem.discountCents),
                taxCents: Value(lineTaxCents),
                lineTotalCents: reservationItem.lineTotalCents,
                lineProfitCents: Value(lineProfit),
              ),
            );

        for (final allocation in allocations) {
          final batch = await (_db.select(_db.productBatches)
                ..where((t) => t.id.equals(allocation.batchId)))
              .getSingle();
          final nextBatchTotal = batch.quantityTotal - allocation.quantity;
          final nextBatchReserved =
              batch.quantityReserved - allocation.quantity;
          if (nextBatchTotal < 0 || nextBatchReserved < 0) {
            throw ConflictException(
                'El lote no tiene stock suficiente para confirmar la venta.');
          }
          await (_db.update(_db.productBatches)
                ..where((t) => t.id.equals(batch.id)))
              .write(
            ProductBatchesCompanion(
              quantityTotal: Value(nextBatchTotal),
              quantityReserved: Value(nextBatchReserved),
              updatedAt: Value(input.confirmedAt.toUtc()),
            ),
          );
          await (_db.update(_db.batchAllocations)
                ..where((t) => t.id.equals(allocation.id)))
              .write(
            BatchAllocationsCompanion(
              saleItemId: Value(reservationItem.id),
              state: const Value(_statusSold),
              quantityReserved: const Value(0),
              quantitySold: Value(allocation.quantity),
            ),
          );
        }

        final nextTotal = product.stockTotal - reservationItem.quantity;
        final nextReserved = product.stockReserved - reservationItem.quantity;
        if (nextTotal < 0 || nextReserved < 0) {
          throw ConflictException(
              'La confirmación de venta dejaría stock inválido.');
        }
        await (_db.update(_db.products)
              ..where((tbl) => tbl.id.equals(reservationItem.productId)))
            .write(
          ProductsCompanion(
            stockTotal: Value(nextTotal),
            stockReserved: Value(nextReserved),
            updatedAt: Value(input.confirmedAt.toUtc()),
          ),
        );

        await _insertMovement(
          productId: reservationItem.productId,
          movementType: 'sale_confirm',
          quantity: reservationItem.quantity,
          stockBefore: product.stockTotal,
          stockAfter: nextTotal,
          referenceType: 'sale',
          referenceId: input.saleId,
          createdAt: input.confirmedAt.toUtc(),
        );
      }

      await (_db.update(_db.reservations)
            ..where((t) => t.id.equals(reservation.id)))
          .write(
        ReservationsCompanion(
          status: const Value(_statusSold),
          confirmedAt: Value(input.confirmedAt.toUtc()),
          updatedAt: Value(input.confirmedAt.toUtc()),
        ),
      );

      await (_db.update(_db.sales)..where((t) => t.id.equals(input.saleId)))
          .write(
        SalesCompanion(
          subtotalCents: Value(subtotalCents),
          taxCents: Value(totalTaxCents),
          discountCents: Value(discountCents),
          totalCents: Value(subtotalCents + totalTaxCents),
          estimatedProfitCents: Value(estimatedProfitCents),
        ),
      );

      final afterProducts = <String, Map<String, Object?>>{};
      for (final productId in beforeProducts.keys) {
        final product = await _requireProduct(productId);
        afterProducts[productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
      }

      await _insertAudit(
        entityType: 'sale',
        entityId: input.saleId,
        action: 'sale_confirm_from_reservation',
        before: <String, Object?>{
          'reservation_id': reservation.id,
          'reservation_status': reservation.status,
          'products': beforeProducts,
        },
        after: <String, Object?>{
          'reservation_id': reservation.id,
          'reservation_status': _statusSold,
          'sale_status': _statusSold,
          'products': afterProducts,
        },
        createdAt: input.confirmedAt.toUtc(),
      );
    });
  }

  @override
  Future<void> createDirectSale(CreateDirectSaleInput input) async {
    if (input.lines.isEmpty) {
      throw ValidationException('La venta debe incluir productos.');
    }
    await _db.transaction(() async {
      final existingSale = await (_db.select(_db.sales)
            ..where((t) => t.id.equals(input.saleId)))
          .getSingleOrNull();
      if (existingSale != null) {
        throw ConflictException(
            'La venta ya existe y no puede volver a crearse.');
      }

      final beforeProducts = <String, Map<String, Object?>>{};
      var subtotalCents = 0;
      var totalTaxCents = 0;
      var discountCents = 0;
      var estimatedProfitCents = 0;
      await _db.into(_db.sales).insert(
            SalesCompanion.insert(
              id: input.saleId,
              customerId: Value(input.customerId),
              status: const Value(_statusSold),
              notes: Value(input.notes),
              createdAt: input.createdAt.toUtc(),
              updatedAt: input.createdAt.toUtc(),
              confirmedAt: Value(input.createdAt.toUtc()),
            ),
          );

      for (final line in input.lines) {
        if (line.quantity <= 0) {
          throw ValidationException(
              'La cantidad vendida debe ser mayor a cero.');
        }
        final product = await _requireProduct(line.productId);
        if (!product.isActive) {
          throw ConflictException('No se puede vender un producto inactivo.');
        }
        beforeProducts[line.productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
        final available = product.stockTotal - product.stockReserved;
        if (line.quantity > available) {
          throw ConflictException(
              'No hay stock disponible suficiente para vender.');
        }

        final allocations = await _allocateBatches(
          productId: line.productId,
          quantity: line.quantity,
          mode: _AllocationMode.sale,
        );
        final weightedCost = _weightedUnitCost(allocations, line.quantity);
        final lineTotal =
            (line.unitPriceCents * line.quantity) - line.discountCents;
        final lineTaxCents = ((lineTotal * line.taxRateBps) / 10000).round();
        final lineProfit =
            ((line.unitPriceCents - weightedCost) * line.quantity) -
                line.discountCents;

        subtotalCents += lineTotal;
        totalTaxCents += lineTaxCents;
        discountCents += line.discountCents;
        estimatedProfitCents += lineProfit;

        await _db.into(_db.saleItems).insert(
              SaleItemsCompanion.insert(
                id: line.itemId,
                saleId: input.saleId,
                productId: line.productId,
                quantity: line.quantity,
                unitPriceCents: line.unitPriceCents,
                unitCostCents: weightedCost,
                taxRateBps: Value(line.taxRateBps),
                discountCents: Value(line.discountCents),
                taxCents: Value(lineTaxCents),
                lineTotalCents: lineTotal,
                lineProfitCents: Value(lineProfit),
              ),
            );

        for (final allocation in allocations) {
          await _db.into(_db.batchAllocations).insert(
                BatchAllocationsCompanion.insert(
                  id: allocation.id,
                  productId: line.productId,
                  batchId: allocation.batchId,
                  saleItemId: Value(line.itemId),
                  quantity: allocation.quantity,
                  quantityReserved: const Value(0),
                  quantitySold: Value(allocation.quantity),
                  state: const Value(_statusSold),
                  createdAt: input.createdAt.toUtc(),
                ),
              );
        }

        final nextTotal = product.stockTotal - line.quantity;
        if (nextTotal < 0) {
          throw ConflictException('La venta dejaría stock negativo.');
        }
        await (_db.update(_db.products)
              ..where((tbl) => tbl.id.equals(line.productId)))
            .write(
          ProductsCompanion(
            stockTotal: Value(nextTotal),
            updatedAt: Value(input.createdAt.toUtc()),
          ),
        );

        await _insertMovement(
          productId: line.productId,
          movementType: 'sale_direct',
          quantity: line.quantity,
          stockBefore: product.stockTotal,
          stockAfter: nextTotal,
          referenceType: 'sale',
          referenceId: input.saleId,
          createdAt: input.createdAt.toUtc(),
        );
      }

      final afterProducts = <String, Map<String, Object?>>{};
      for (final productId in beforeProducts.keys) {
        final product = await _requireProduct(productId);
        afterProducts[productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
      }
      await (_db.update(_db.sales)..where((t) => t.id.equals(input.saleId)))
          .write(
        SalesCompanion(
          subtotalCents: Value(subtotalCents),
          taxCents: Value(totalTaxCents),
          discountCents: Value(discountCents),
          totalCents: Value(subtotalCents + totalTaxCents),
          estimatedProfitCents: Value(estimatedProfitCents),
        ),
      );
      await _insertAudit(
        entityType: 'sale',
        entityId: input.saleId,
        action: 'sale_direct',
        before: <String, Object?>{'products': beforeProducts},
        after: <String, Object?>{
          'sale_status': _statusSold,
          'products': afterProducts,
        },
        createdAt: input.createdAt.toUtc(),
      );
    });
  }

  @override
  Future<void> createReturn(CreateReturnInput input) async {
    if (input.lines.isEmpty) {
      throw ValidationException(
          'La devolución debe incluir al menos una línea.');
    }
    await _db.transaction(() async {
      final existing = await (_db.select(_db.returns)
            ..where((t) => t.id.equals(input.returnId)))
          .getSingleOrNull();
      if (existing != null) {
        throw ConflictException(
            'La devolución ya existe y no puede duplicarse.');
      }
      final sale = await (_db.select(_db.sales)
            ..where((t) => t.id.equals(input.saleId)))
          .getSingleOrNull();
      if (sale == null) {
        throw NotFoundException('La venta indicada para devolución no existe.');
      }

      final createdAt = input.createdAt.toUtc();
      final beforeProducts = <String, Map<String, Object?>>{};
      await _db.into(_db.returns).insert(
            ReturnsCompanion.insert(
              id: input.returnId,
              saleId: input.saleId,
              status: const Value('processed'),
              reason: Value(input.reason),
              createdAt: createdAt,
            ),
          );

      for (final line in input.lines) {
        if (line.quantity <= 0) {
          throw ValidationException(
              'La cantidad devuelta debe ser mayor a cero.');
        }
        final saleItem = await (_db.select(_db.saleItems)
              ..where((t) => t.id.equals(line.saleItemId)))
            .getSingleOrNull();
        if (saleItem == null || saleItem.saleId != input.saleId) {
          throw NotFoundException(
              'La línea de venta para devolución no existe.');
        }
        final batch = await _requireBatch(line.batchId);
        if (batch.productId != line.productId) {
          throw ConflictException(
              'El lote no coincide con el producto devuelto.');
        }

        final product = await _requireProduct(line.productId);
        beforeProducts[line.productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
          'batch_total': batch.quantityTotal,
        };

        await _db.into(_db.returnItems).insert(
              ReturnItemsCompanion.insert(
                id: line.id,
                returnId: input.returnId,
                saleItemId: line.saleItemId,
                batchId: line.batchId,
                quantity: line.quantity,
              ),
            );

        await (_db.update(_db.productBatches)
              ..where((t) => t.id.equals(batch.id)))
            .write(
          ProductBatchesCompanion(
            quantityTotal: Value(batch.quantityTotal + line.quantity),
            updatedAt: Value(createdAt),
          ),
        );

        await (_db.update(_db.products)
              ..where((tbl) => tbl.id.equals(product.id)))
            .write(
          ProductsCompanion(
            stockTotal: Value(product.stockTotal + line.quantity),
            updatedAt: Value(createdAt),
          ),
        );

        await _insertMovement(
          productId: product.id,
          batchId: batch.id,
          movementType: 'return_in',
          quantity: line.quantity,
          stockBefore: product.stockTotal,
          stockAfter: product.stockTotal + line.quantity,
          referenceType: 'return',
          referenceId: input.returnId,
          reason: input.reason,
          createdAt: createdAt,
        );
      }

      final afterProducts = <String, Map<String, Object?>>{};
      for (final productId in beforeProducts.keys) {
        final product = await _requireProduct(productId);
        afterProducts[productId] = <String, Object?>{
          'stock_total': product.stockTotal,
          'stock_reserved': product.stockReserved,
        };
      }
      await _insertAudit(
        entityType: 'return',
        entityId: input.returnId,
        action: 'return_create',
        before: <String, Object?>{
          'sale_id': input.saleId,
          'products': beforeProducts,
        },
        after: <String, Object?>{
          'sale_id': input.saleId,
          'return_status': 'processed',
          'products': afterProducts,
        },
        createdAt: createdAt,
      );
    });
  }

  @override
  Future<ProductStockSnapshot> getProductStock(String productId) async {
    final product = await _requireProduct(productId);
    return ProductStockSnapshot(
      productId: product.id,
      stockTotal: product.stockTotal,
      stockReserved: product.stockReserved,
    );
  }

  @override
  Future<void> createExpenseCategory(ExpenseCategoryUpsertInput input) async {
    if (input.name.trim().isEmpty) {
      throw ValidationException('La categoría de gasto requiere nombre.');
    }
    await _db.into(_db.expenseCategories).insert(
          ExpenseCategoriesCompanion.insert(
            id: input.id,
            name: input.name.trim(),
            isActive: Value(input.isActive),
          ),
        );
  }

  @override
  Future<void> updateExpenseCategory(ExpenseCategoryUpsertInput input) async {
    if (input.name.trim().isEmpty) {
      throw ValidationException('La categoría de gasto requiere nombre.');
    }
    final existing = await (_db.select(_db.expenseCategories)
          ..where((t) => t.id.equals(input.id)))
        .getSingleOrNull();
    if (existing == null) {
      throw NotFoundException('La categoría no existe.');
    }
    await (_db.update(_db.expenseCategories)
          ..where((t) => t.id.equals(input.id)))
        .write(
      ExpenseCategoriesCompanion(
        name: Value(input.name.trim()),
        isActive: Value(input.isActive),
      ),
    );
  }

  @override
  Future<void> setExpenseCategoryActive(
      String categoryId, bool isActive) async {
    final existing = await (_db.select(_db.expenseCategories)
          ..where((t) => t.id.equals(categoryId)))
        .getSingleOrNull();
    if (existing == null) {
      throw NotFoundException('La categoría no existe.');
    }
    await (_db.update(_db.expenseCategories)
          ..where((t) => t.id.equals(categoryId)))
        .write(ExpenseCategoriesCompanion(isActive: Value(isActive)));
  }

  Future<void> _ensureDefaultExpenseCategories() async {
    final existing = await (_db.select(_db.expenseCategories)).get();
    final existingNames =
        existing.map((item) => item.name.trim().toLowerCase()).toSet();

    for (final category in <({String id, String name})>[
      (id: 'uncategorized', name: 'Sin categoría'),
      (id: 'services', name: 'Servicios'),
      (id: 'transport', name: 'Transporte'),
      (id: 'supplies', name: 'Suministros'),
      (id: 'maintenance', name: 'Mantenimiento'),
      (id: 'marketing', name: 'Marketing'),
    ]) {
      if (!existingNames.contains(category.name.toLowerCase())) {
        await _db.into(_db.expenseCategories).insert(
              ExpenseCategoriesCompanion.insert(
                id: category.id,
                name: category.name,
                isActive: const Value(true),
              ),
            );
      }
    }
  }

  @override
  Future<List<ExpenseCategoryListItem>> listExpenseCategories({
    String? search,
    bool includeInactive = true,
  }) async {
    await _ensureDefaultExpenseCategories();
    final where = <String>['1=1'];
    final values = <Object>[];
    if (!includeInactive) {
      where.add('ec.is_active = 1');
    }
    final normalized = search?.trim().toLowerCase();
    if (normalized != null && normalized.isNotEmpty) {
      where.add('LOWER(ec.name) LIKE ?');
      values.add('%$normalized%');
    }
    final rows = await _db.customSelect(
      '''
      SELECT ec.id, ec.name, ec.is_active, COUNT(e.id) AS expense_count
      FROM expense_categories ec
      LEFT JOIN expenses e ON e.category_id = ec.id
      WHERE ${where.join(' AND ')}
      GROUP BY ec.id
      ORDER BY LOWER(ec.name) ASC
      ''',
      variables: values.map(_asVariable).toList(),
    ).get();
    return rows
        .map(
          (row) => ExpenseCategoryListItem(
            id: row.read<String>('id'),
            name: row.read<String>('name'),
            isActive: row.read<int>('is_active') == 1,
            expenseCount: row.read<int>('expense_count'),
          ),
        )
        .toList();
  }

  @override
  Future<void> createExpense(ExpenseUpsertInput input) async {
    if (input.description.trim().isEmpty) {
      throw ValidationException('La descripción es obligatoria.');
    }
    if (input.amountCents == 0) {
      throw ValidationException('El importe debe ser mayor a cero.');
    }
    if (input.categoryId.trim().isEmpty) {
      throw ValidationException('La categoría es obligatoria.');
    }
    final category = await (_db.select(_db.expenseCategories)
          ..where((t) => t.id.equals(input.categoryId)))
        .getSingleOrNull();
    if (category == null) {
      throw ValidationException('La categoría seleccionada no existe.');
    }
    if (!category.isActive) {
      throw ValidationException('La categoría seleccionada está inactiva.');
    }
    final occurredAt = DateTime.tryParse(input.occurredAt);
    if (occurredAt == null) {
      throw ValidationException('La fecha es inválida.');
    }
    final now = DateTime.now().toUtc();
    await _db.into(_db.expenses).insert(
          ExpensesCompanion.insert(
            id: input.id,
            name: input.description.trim(),
            categoryId: Value(input.categoryId),
            supplierId: Value(input.supplierId),
            description: Value(input.description.trim()),
            amountCents: input.amountCents,
            taxCents: const Value(0),
            paymentMethod: const Value(null),
            notes: Value(input.notes),
            isActive: const Value(true),
            occurredAt: occurredAt.toUtc(),
            createdAt: now,
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<void> updateExpense(ExpenseUpsertInput input) async {
    final existing = await (_db.select(_db.expenses)
          ..where((t) => t.id.equals(input.id)))
        .getSingleOrNull();
    if (existing == null) {
      throw NotFoundException('El gasto no existe.');
    }
    if (input.description.trim().isEmpty) {
      throw ValidationException('La descripción es obligatoria.');
    }
    if (input.amountCents == 0) {
      throw ValidationException('El importe debe ser mayor a cero.');
    }
    if (input.categoryId.trim().isEmpty) {
      throw ValidationException('La categoría es obligatoria.');
    }
    final category = await (_db.select(_db.expenseCategories)
          ..where((t) => t.id.equals(input.categoryId)))
        .getSingleOrNull();
    if (category == null) {
      throw ValidationException('La categoría seleccionada no existe.');
    }
    if (!category.isActive) {
      throw ValidationException('La categoría seleccionada está inactiva.');
    }
    final occurredAt = DateTime.tryParse(input.occurredAt);
    if (occurredAt == null) {
      throw ValidationException('La fecha es inválida.');
    }
    await (_db.update(_db.expenses)..where((t) => t.id.equals(input.id))).write(
      ExpensesCompanion(
        name: Value(input.description.trim()),
        categoryId: Value(input.categoryId),
        supplierId: Value(input.supplierId),
        description: Value(input.description.trim()),
        amountCents: Value(input.amountCents),
        notes: Value(input.notes),
        isActive: Value(input.isActive),
        occurredAt: Value(occurredAt.toUtc()),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> logicalDeleteExpense(String expenseId) async {
    final existing = await (_db.select(_db.expenses)
          ..where((t) => t.id.equals(expenseId)))
        .getSingleOrNull();
    if (existing == null) {
      throw NotFoundException('El gasto no existe.');
    }
    await (_db.update(_db.expenses)..where((t) => t.id.equals(expenseId)))
        .write(
      ExpensesCompanion(
        description: Value(existing.description),
        notes: Value(existing.notes),
        isActive: const Value(false),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<List<ExpenseListItem>> listExpenses(ExpenseQuery query) async {
    final where = <String>['1=1'];
    final values = <Object>[];
    final normalized = query.search?.trim().toLowerCase();
    if (normalized != null && normalized.isNotEmpty) {
      where.add('''
        (
          LOWER(e.name) LIKE ?
          OR LOWER(IFNULL(e.description, '')) LIKE ?
          OR LOWER(IFNULL(e.notes, '')) LIKE ?
          OR LOWER(IFNULL(c.name, '')) LIKE ?
          OR LOWER(IFNULL(s.name, '')) LIKE ?
        )
      ''');
      values.add('%$normalized%');
      values.add('%$normalized%');
      values.add('%$normalized%');
      values.add('%$normalized%');
      values.add('%$normalized%');
    }
    where.add('e.is_active = 1');
    if (query.categoryId != null && query.categoryId!.isNotEmpty) {
      where.add('e.category_id = ?');
      values.add(query.categoryId!);
    }
    if (query.supplierId != null && query.supplierId!.isNotEmpty) {
      where.add('e.supplier_id = ?');
      values.add(query.supplierId!);
    }
    final start = _expensePeriodStart(query.period, query.from, query.to);
    final end = _expensePeriodEnd(query.period, query.from, query.to);
    if (start != null) {
      where.add('e.occurred_at >= ?');
      values.add(start.toUtc());
    }
    if (end != null) {
      where.add('e.occurred_at < ?');
      values.add(end.toUtc());
    }
    final rows = await _db.customSelect(
      '''
      SELECT e.id, e.name, e.category_id, e.description, e.amount_cents, e.occurred_at,
             e.supplier_id, e.notes, c.name AS category_name, s.name AS supplier_name
      FROM expenses e
      LEFT JOIN expense_categories c ON c.id = e.category_id
      LEFT JOIN suppliers s ON s.id = e.supplier_id
      WHERE ${where.join(' AND ')}
      ORDER BY e.occurred_at DESC, e.created_at DESC
      LIMIT ? OFFSET ?
      ''',
      variables: <Variable<Object>>[
        ...values.map(_asVariable),
        _asVariable(query.limit),
        _asVariable(query.offset),
      ],
    ).get();
    return rows
        .map(
          (row) => ExpenseListItem(
            id: row.read<String>('id'),
            description: row.read<String>('name'),
            categoryId: row.readNullable<String>('category_id'),
            categoryName: row.read<String?>('category_name') ?? 'Sin categoría',
            amountCents: row.read<int>('amount_cents'),
            occurredAt: row.read<DateTime>('occurred_at'),
            supplierId: row.readNullable<String>('supplier_id'),
            supplierName: row.readNullable<String>('supplier_name'),
            notes: row.readNullable<String>('notes'),
            isActive: true,
          ),
        )
        .toList();
  }

  @override
  Future<ExpenseDetailView> getExpenseDetail(String expenseId) async {
    final row = await _db.customSelect(
      '''
      SELECT e.id, e.name, e.category_id, c.name AS category_name, e.description,
             e.amount_cents, e.occurred_at, e.supplier_id, s.name AS supplier_name,
             e.notes, e.created_at, e.created_at AS updated_at
      FROM expenses e
      LEFT JOIN expense_categories c ON c.id = e.category_id
      LEFT JOIN suppliers s ON s.id = e.supplier_id
      WHERE e.id = ? AND e.is_active = 1
      ''',
      variables: <Variable<Object>>[_asVariable(expenseId)],
    ).getSingleOrNull();
    if (row == null) {
      throw NotFoundException('El gasto no existe.');
    }
    return ExpenseDetailView(
      id: row.read<String>('id'),
      description: row.read<String>('name'),
      categoryId: row.readNullable<String>('category_id') ?? '',
      categoryName: row.read<String?>('category_name') ?? 'Sin categoría',
      amountCents: row.read<int>('amount_cents'),
      occurredAt: row.read<DateTime>('occurred_at'),
      supplierId: row.readNullable<String>('supplier_id'),
      supplierName: row.readNullable<String>('supplier_name'),
      notes: row.readNullable<String>('notes'),
      isActive: true,
      createdAt: row.read<DateTime>('created_at'),
      updatedAt: row.read<DateTime>('updated_at'),
    );
  }

  @override
  Future<ExpenseSummaryView> getExpenseSummary(ExpenseQuery query) async {
    final where = <String>['1=1'];
    final values = <Object>[];
    final start = _expensePeriodStart(query.period, query.from, query.to);
    final end = _expensePeriodEnd(query.period, query.from, query.to);
    if (start != null) {
      where.add('occurred_at >= ?');
      values.add(start.toUtc());
    }
    if (end != null) {
      where.add('occurred_at < ?');
      values.add(end.toUtc());
    }
    where.add('is_active = 1');
    if (query.categoryId != null && query.categoryId!.isNotEmpty) {
      where.add('category_id = ?');
      values.add(query.categoryId!);
    }
    if (query.supplierId != null && query.supplierId!.isNotEmpty) {
      where.add('supplier_id = ?');
      values.add(query.supplierId!);
    }
    final rows = await _db.customSelect(
      '''
      SELECT COUNT(*) AS count, COALESCE(SUM(amount_cents), 0) AS total_amount_cents
      FROM expenses
      WHERE ${where.join(' AND ')}
      ''',
      variables: values.map(_asVariable).toList(),
    ).getSingle();
    return ExpenseSummaryView(
      totalAmountCents: rows.read<int>('total_amount_cents'),
      count: rows.read<int>('count'),
      byCategory: const <ExpenseAggregateItem>[],
      bySupplier: const <ExpenseAggregateItem>[],
    );
  }

  @override
  Future<DashboardSummaryView> getDashboardSummary(DashboardQuery query) async {
    final range = _resolveDashboardRange(query);
    final sales = await _loadDashboardSalesStats(range);
    final profit = await _loadDashboardProfitStats(range, sales: sales);
    final expenseStats = await _loadDashboardExpenseStats(range);
    final inventory = await _loadDashboardInventoryStats(range);
    final reservations = await _loadDashboardReservationStats(range);
    final customers = await _loadDashboardCustomerStats(range);
    final suppliers = await _loadDashboardSupplierStats(range);
    final discounts = await _loadDashboardDiscountStats(range);
    final salesByCategory = await _loadSalesByCategory(range, limit: 6);
    final topProductsByUnits = await _loadProductRanking(range,
        orderBy: 'units_sold DESC, revenue_cents DESC', limit: 5);
    final topProductsByRevenue = await _loadProductRanking(range,
        orderBy: 'revenue_cents DESC, units_sold DESC', limit: 5);
    final topProductsByProfit = await _loadProductRanking(range,
        orderBy: 'profit_cents DESC, revenue_cents DESC', limit: 5);
    final leastSoldProducts = await _loadLeastSoldProducts(range, limit: 5);
    final stagnantProducts =
        await _loadProductsWithoutMovement(range, limit: 5);

    final netProfitCents =
        profit.grossProfitCents - expenseStats.totalAmountCents;
    final netMarginBps = _ratioBps(netProfitCents, sales.revenueCents);
    final completedProfit = DashboardProfitStats(
      revenueCents: profit.revenueCents,
      costCents: profit.costCents,
      grossProfitCents: profit.grossProfitCents,
      grossMarginBps: profit.grossMarginBps,
      expensesCents: expenseStats.totalAmountCents,
      netProfitCents: netProfitCents,
      netMarginBps: netMarginBps,
      taxCents: profit.taxCents,
      trend: profit.trend,
    );

    final topProducts = topProductsByRevenue
        .map(
          (item) => DashboardMetricItem(
            label: item.label,
            amountCents: item.revenueCents,
            count: item.unitsSold,
          ),
        )
        .toList();
    final topExpenses = expenseStats.byCategory
        .take(5)
        .map(
          (item) => DashboardMetricItem(
            label: item.label,
            amountCents: item.amountCents,
            count: item.count,
          ),
        )
        .toList();

    return DashboardSummaryView(
      period: range,
      revenueCents: sales.revenueCents,
      costCents: profit.costCents,
      grossProfitCents: completedProfit.grossProfitCents,
      expensesCents: expenseStats.totalAmountCents,
      netProfitCents: completedProfit.netProfitCents,
      taxCents: sales.taxCents,
      discountCents: sales.discountCents,
      salesCount: sales.salesCount,
      averageTicketCents: sales.averageTicketCents,
      unitsSold: sales.unitsSold,
      grossMarginBps: completedProfit.grossMarginBps,
      netMarginBps: completedProfit.netMarginBps,
      activeProductsCount: inventory.totalProducts,
      lowStockCount: inventory.lowStockCount,
      reservationsCount: reservations.activeReservations,
      customersCount: customers.totalCustomers,
      suppliersCount: suppliers.activeSuppliers,
      topProducts: topProducts,
      topExpenses: topExpenses,
      sales: sales,
      profit: completedProfit,
      expenseStats: expenseStats,
      inventory: inventory,
      reservations: reservations,
      customers: customers,
      suppliers: suppliers,
      discounts: discounts,
      topProductsByRevenue: topProductsByRevenue,
      topProductsByUnits: topProductsByUnits,
      topProductsByProfit: topProductsByProfit,
      leastSoldProducts: leastSoldProducts,
      stagnantProducts: stagnantProducts,
      salesByCategory: salesByCategory,
      alerts: _buildDashboardAlerts(
        inventory: inventory,
        reservations: reservations,
        netMarginBps: completedProfit.netMarginBps,
      ),
      unavailableMetrics: const <String>[
        'IVA credito fiscal no disponible: no existe un flujo de compras consolidado con impuesto recuperable.',
        'Ventas con oferta o liquidacion historica no disponibles: el estado actual del producto no garantiza la condicion comercial al momento de la venta.',
      ],
    );
  }

  Future<DashboardSalesStats> _loadDashboardSalesStats(
    DashboardDateRange range,
  ) async {
    final saleRow = await _db.customSelect(
      '''
      SELECT
        COUNT(*) AS sales_count,
        COALESCE(SUM(total_cents), 0) AS revenue_cents,
        COALESCE(SUM(tax_cents), 0) AS tax_cents,
        COALESCE(SUM(discount_cents), 0) AS discount_cents
      FROM sales
      WHERE status = 'sold'
        AND confirmed_at IS NOT NULL
        AND confirmed_at >= ?
        AND confirmed_at < ?
      ''',
      variables: _dashboardRangeVariables(range),
    ).getSingle();

    final itemRow = await _db.customSelect(
      '''
      SELECT
        COALESCE(SUM(si.quantity), 0) AS units_sold
      FROM sale_items si
      JOIN sales s ON s.id = si.sale_id
      WHERE s.status = 'sold'
        AND s.confirmed_at IS NOT NULL
        AND s.confirmed_at >= ?
        AND s.confirmed_at < ?
      ''',
      variables: _dashboardRangeVariables(range),
    ).getSingle();

    final revenueCents = saleRow.read<int>('revenue_cents');
    final salesCount = saleRow.read<int>('sales_count');

    return DashboardSalesStats(
      salesCount: salesCount,
      revenueCents: revenueCents,
      averageTicketCents: salesCount > 0 ? revenueCents ~/ salesCount : 0,
      unitsSold: itemRow.read<int>('units_sold'),
      discountCents: saleRow.read<int>('discount_cents'),
      taxCents: saleRow.read<int>('tax_cents'),
      salesByDay: await _loadSalesSeries(range, 'day'),
      salesByWeek: await _loadSalesSeries(range, 'week'),
      salesByMonth: await _loadSalesSeries(range, 'month'),
      trend: await _loadSalesSeries(
        range,
        _preferredDashboardBucket(range),
      ),
    );
  }

  Future<DashboardProfitStats> _loadDashboardProfitStats(
    DashboardDateRange range, {
    required DashboardSalesStats sales,
  }) async {
    final row = await _db.customSelect(
      '''
      SELECT
        COALESCE(SUM(si.unit_cost_cents * si.quantity), 0) AS cost_cents,
        COALESCE(SUM(si.line_profit_cents), 0) AS gross_profit_cents,
        COALESCE(SUM(si.tax_cents), 0) AS tax_cents
      FROM sale_items si
      JOIN sales s ON s.id = si.sale_id
      WHERE s.status = 'sold'
        AND s.confirmed_at IS NOT NULL
        AND s.confirmed_at >= ?
        AND s.confirmed_at < ?
      ''',
      variables: _dashboardRangeVariables(range),
    ).getSingle();

    final grossProfitCents = row.read<int>('gross_profit_cents');
    return DashboardProfitStats(
      revenueCents: sales.revenueCents,
      costCents: row.read<int>('cost_cents'),
      grossProfitCents: grossProfitCents,
      grossMarginBps: _ratioBps(grossProfitCents, sales.revenueCents),
      expensesCents: 0,
      netProfitCents: grossProfitCents,
      netMarginBps: _ratioBps(grossProfitCents, sales.revenueCents),
      taxCents: row.read<int>('tax_cents'),
      trend: await _loadProfitSeries(range, _preferredDashboardBucket(range)),
    );
  }

  Future<DashboardExpenseStats> _loadDashboardExpenseStats(
    DashboardDateRange range,
  ) async {
    final summaryRow = await _db.customSelect(
      '''
      SELECT
        COUNT(*) AS expense_count,
        COALESCE(SUM(amount_cents), 0) AS total_amount_cents
      FROM expenses
      WHERE is_active = 1
        AND occurred_at >= ?
        AND occurred_at < ?
      ''',
      variables: _dashboardRangeVariables(range),
    ).getSingle();

    final byCategoryRows = await _db.customSelect(
      '''
      SELECT
        ec.id AS id,
        COALESCE(ec.name, 'Sin categoria') AS label,
        COALESCE(SUM(e.amount_cents), 0) AS amount_cents,
        COUNT(*) AS count
      FROM expenses e
      LEFT JOIN expense_categories ec ON ec.id = e.category_id
      WHERE e.is_active = 1
        AND e.occurred_at >= ?
        AND e.occurred_at < ?
      GROUP BY ec.id, ec.name
      ORDER BY amount_cents DESC, count DESC
      LIMIT 8
      ''',
      variables: _dashboardRangeVariables(range),
    ).get();

    final bySupplierRows = await _db.customSelect(
      '''
      SELECT
        s.id AS id,
        COALESCE(s.name, 'Sin proveedor') AS label,
        COALESCE(SUM(e.amount_cents), 0) AS amount_cents,
        COUNT(*) AS count
      FROM expenses e
      LEFT JOIN suppliers s ON s.id = e.supplier_id
      WHERE e.is_active = 1
        AND e.occurred_at >= ?
        AND e.occurred_at < ?
      GROUP BY s.id, s.name
      ORDER BY amount_cents DESC, count DESC
      LIMIT 8
      ''',
      variables: _dashboardRangeVariables(range),
    ).get();

    final totalAmountCents = summaryRow.read<int>('total_amount_cents');
    final expenseCount = summaryRow.read<int>('expense_count');

    return DashboardExpenseStats(
      totalAmountCents: totalAmountCents,
      expenseCount: expenseCount,
      averageAmountCents:
          expenseCount > 0 ? totalAmountCents ~/ expenseCount : 0,
      byCategory: byCategoryRows.map(_mapDashboardBreakdownItem).toList(),
      bySupplier: bySupplierRows.map(_mapDashboardBreakdownItem).toList(),
      trend: await _loadExpenseSeries(range, _preferredDashboardBucket(range)),
    );
  }

  Future<DashboardInventoryStats> _loadDashboardInventoryStats(
    DashboardDateRange range,
  ) async {
    final inventoryRow = await _db.customSelect(
      '''
      SELECT
        COUNT(*) AS total_products,
        COALESCE(SUM(CASE WHEN (stock_total - stock_reserved) <= 0 THEN 1 ELSE 0 END), 0) AS no_stock_count,
        COALESCE(SUM(CASE WHEN (stock_total - stock_reserved) > 0 AND (stock_total - stock_reserved) <= stock_min THEN 1 ELSE 0 END), 0) AS low_stock_count,
        COALESCE(SUM(CASE WHEN stock_max IS NOT NULL AND (stock_total - stock_reserved) > stock_max THEN 1 ELSE 0 END), 0) AS over_stock_count,
        COALESCE(SUM(stock_reserved), 0) AS reserved_units,
        COALESCE(SUM((stock_total - stock_reserved) * cost_cents), 0) AS inventory_value_cents
      FROM products
      WHERE is_active = 1
      ''',
    ).getSingle();

    final todayStart = DateTime.utc(
      DateTime.now().toUtc().year,
      DateTime.now().toUtc().month,
      DateTime.now().toUtc().day,
    );
    final tomorrowStart = todayStart.add(const Duration(days: 1));
    final nearExpiryEnd = todayStart.add(const Duration(days: 31));

    final expirationRow = await _db.customSelect(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN expires_at < ? THEN 1 ELSE 0 END), 0) AS expired_count,
        COALESCE(SUM(CASE WHEN expires_at >= ? AND expires_at < ? THEN 1 ELSE 0 END), 0) AS due_today_count,
        COALESCE(SUM(CASE WHEN expires_at >= ? AND expires_at < ? THEN 1 ELSE 0 END), 0) AS near_expiry_count
      FROM product_batches
      WHERE quantity_total > quantity_reserved
        AND expires_at IS NOT NULL
      ''',
      variables: <Variable<Object>>[
        _asVariable(todayStart),
        _asVariable(todayStart),
        _asVariable(tomorrowStart),
        _asVariable(tomorrowStart),
        _asVariable(nearExpiryEnd),
      ],
    ).getSingle();

    final stagnantRow = await _db.customSelect(
      '''
      SELECT
        COUNT(*) AS no_movement_count,
        COALESCE(SUM((p.stock_total - p.stock_reserved) * p.cost_cents), 0) AS no_movement_value_cents
      FROM products p
      WHERE p.is_active = 1
        AND (p.stock_total - p.stock_reserved) > 0
        AND NOT EXISTS (
          SELECT 1
          FROM sale_items si
          JOIN sales s ON s.id = si.sale_id
          WHERE si.product_id = p.id
            AND s.status = 'sold'
            AND s.confirmed_at IS NOT NULL
            AND s.confirmed_at >= ?
            AND s.confirmed_at < ?
        )
      ''',
      variables: _dashboardRangeVariables(range),
    ).getSingle();

    return DashboardInventoryStats(
      totalProducts: inventoryRow.read<int>('total_products'),
      noStockCount: inventoryRow.read<int>('no_stock_count'),
      lowStockCount: inventoryRow.read<int>('low_stock_count'),
      overStockCount: inventoryRow.read<int>('over_stock_count'),
      nearExpiryCount: expirationRow.read<int>('near_expiry_count'),
      dueTodayCount: expirationRow.read<int>('due_today_count'),
      expiredCount: expirationRow.read<int>('expired_count'),
      reservedUnits: inventoryRow.read<int>('reserved_units'),
      inventoryValueCents: inventoryRow.read<int>('inventory_value_cents'),
      noMovementProductsCount: stagnantRow.read<int>('no_movement_count'),
      noMovementValueCents: stagnantRow.read<int>('no_movement_value_cents'),
    );
  }

  Future<DashboardReservationStats> _loadDashboardReservationStats(
    DashboardDateRange range,
  ) async {
    final stateRow = await _db.customSelect(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN status = 'reserved' THEN 1 ELSE 0 END), 0) AS active_reservations,
        COALESCE(SUM(CASE WHEN status = 'draft' THEN 1 ELSE 0 END), 0) AS pending_reservations,
        COALESCE(SUM(CASE WHEN status = 'cancelled' AND canceled_at >= ? AND canceled_at < ? THEN 1 ELSE 0 END), 0) AS cancelled_in_period,
        COALESCE(SUM(CASE WHEN status = 'sold' AND confirmed_at >= ? AND confirmed_at < ? THEN 1 ELSE 0 END), 0) AS converted_to_sale_count
      FROM reservations
      ''',
      variables: <Variable<Object>>[
        ..._dashboardRangeVariables(range),
        ..._dashboardRangeVariables(range),
      ],
    ).getSingle();

    final reservedRow = await _db.customSelect(
      '''
      SELECT
        COALESCE(SUM(ri.quantity), 0) AS reserved_units,
        COALESCE(SUM(ri.line_total_cents + CAST(ROUND((ri.line_total_cents * ri.tax_rate_bps) / 10000.0) AS INTEGER)), 0) AS reserved_value_cents
      FROM reservation_items ri
      JOIN reservations r ON r.id = ri.reservation_id
      WHERE r.status = 'reserved'
      ''',
    ).getSingle();

    return DashboardReservationStats(
      activeReservations: stateRow.read<int>('active_reservations'),
      pendingReservations: stateRow.read<int>('pending_reservations'),
      cancelledInPeriod: stateRow.read<int>('cancelled_in_period'),
      convertedToSaleCount: stateRow.read<int>('converted_to_sale_count'),
      reservedUnits: reservedRow.read<int>('reserved_units'),
      reservedValueCents: reservedRow.read<int>('reserved_value_cents'),
    );
  }

  Future<DashboardCustomerStats> _loadDashboardCustomerStats(
    DashboardDateRange range,
  ) async {
    final totalRow = await _db
        .customSelect(
          'SELECT COUNT(*) AS count FROM customers WHERE is_active = 1',
        )
        .getSingle();

    final withPurchasesRow = await _db.customSelect(
      '''
      SELECT COUNT(DISTINCT customer_id) AS count
      FROM sales
      WHERE status = 'sold'
        AND confirmed_at IS NOT NULL
        AND customer_id IS NOT NULL
        AND confirmed_at >= ?
        AND confirmed_at < ?
      ''',
      variables: _dashboardRangeVariables(range),
    ).getSingle();

    final topRows = await _db.customSelect(
      '''
      SELECT
        c.id AS customer_id,
        c.name AS label,
        COUNT(s.id) AS sales_count,
        COALESCE(SUM(s.total_cents), 0) AS revenue_cents
      FROM sales s
      JOIN customers c ON c.id = s.customer_id
      WHERE s.status = 'sold'
        AND s.confirmed_at IS NOT NULL
        AND s.confirmed_at >= ?
        AND s.confirmed_at < ?
      GROUP BY c.id, c.name
      ORDER BY revenue_cents DESC, sales_count DESC
      LIMIT 5
      ''',
      variables: _dashboardRangeVariables(range),
    ).get();

    final totalCustomers = totalRow.read<int>('count');
    final customersWithPurchases = withPurchasesRow.read<int>('count');

    return DashboardCustomerStats(
      totalCustomers: totalCustomers,
      customersWithPurchases: customersWithPurchases,
      customersWithoutPurchases: totalCustomers > customersWithPurchases
          ? totalCustomers - customersWithPurchases
          : 0,
      topCustomers: topRows.map(
        (row) {
          final salesCount = row.read<int>('sales_count');
          final revenueCents = row.read<int>('revenue_cents');
          return DashboardCustomerRankingItem(
            customerId: row.read<String>('customer_id'),
            label: row.read<String>('label'),
            salesCount: salesCount,
            revenueCents: revenueCents,
            averageTicketCents: salesCount > 0 ? revenueCents ~/ salesCount : 0,
          );
        },
      ).toList(),
    );
  }

  Future<DashboardSupplierStats> _loadDashboardSupplierStats(
    DashboardDateRange range,
  ) async {
    final totalRow = await _db.customSelect(
      '''
      SELECT
        COUNT(*) AS total_suppliers,
        COALESCE(SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END), 0) AS active_suppliers
      FROM suppliers
      ''',
    ).getSingle();

    final expensesRow = await _db.customSelect(
      '''
      SELECT COUNT(DISTINCT supplier_id) AS suppliers_with_expenses
      FROM expenses
      WHERE is_active = 1
        AND supplier_id IS NOT NULL
        AND occurred_at >= ?
        AND occurred_at < ?
      ''',
      variables: _dashboardRangeVariables(range),
    ).getSingle();

    final receivedRow = await _db.customSelect(
      '''
      SELECT
        COALESCE(SUM(quantity_total), 0) AS received_units,
        COALESCE(SUM(quantity_total * unit_cost_cents), 0) AS received_cost_cents
      FROM product_batches
      WHERE received_at >= ?
        AND received_at < ?
      ''',
      variables: _dashboardRangeVariables(range),
    ).getSingle();

    final topRows = await _db.customSelect(
      '''
      WITH received AS (
        SELECT
          supplier_id,
          COALESCE(SUM(quantity_total), 0) AS received_units,
          COALESCE(SUM(quantity_total * unit_cost_cents), 0) AS received_cost_cents
        FROM product_batches
        WHERE supplier_id IS NOT NULL
          AND received_at >= ?
          AND received_at < ?
        GROUP BY supplier_id
      ),
      supplier_expenses AS (
        SELECT
          supplier_id,
          COUNT(*) AS expense_count,
          COALESCE(SUM(amount_cents), 0) AS expense_amount_cents
        FROM expenses
        WHERE is_active = 1
          AND supplier_id IS NOT NULL
          AND occurred_at >= ?
          AND occurred_at < ?
        GROUP BY supplier_id
      )
      SELECT
        s.id AS supplier_id,
        s.name AS label,
        s.is_active AS is_active,
        COALESCE(r.received_units, 0) AS received_units,
        COALESCE(r.received_cost_cents, 0) AS received_cost_cents,
        COALESCE(e.expense_count, 0) AS expense_count,
        COALESCE(e.expense_amount_cents, 0) AS expense_amount_cents
      FROM suppliers s
      LEFT JOIN received r ON r.supplier_id = s.id
      LEFT JOIN supplier_expenses e ON e.supplier_id = s.id
      WHERE COALESCE(r.received_units, 0) > 0 OR COALESCE(e.expense_count, 0) > 0
      ORDER BY received_units DESC, expense_amount_cents DESC, label ASC
      LIMIT 5
      ''',
      variables: <Variable<Object>>[
        ..._dashboardRangeVariables(range),
        ..._dashboardRangeVariables(range),
      ],
    ).get();

    return DashboardSupplierStats(
      totalSuppliers: totalRow.read<int>('total_suppliers'),
      activeSuppliers: totalRow.read<int>('active_suppliers'),
      suppliersWithExpenses: expensesRow.read<int>('suppliers_with_expenses'),
      receivedUnits: receivedRow.read<int>('received_units'),
      receivedCostCents: receivedRow.read<int>('received_cost_cents'),
      topSuppliers: topRows
          .map(
            (row) => DashboardSupplierRankingItem(
              supplierId: row.read<String>('supplier_id'),
              label: row.read<String>('label'),
              receivedUnits: row.read<int>('received_units'),
              receivedCostCents: row.read<int>('received_cost_cents'),
              expenseCount: row.read<int>('expense_count'),
              expenseAmountCents: row.read<int>('expense_amount_cents'),
              isActive: row.read<int>('is_active') == 1,
            ),
          )
          .toList(),
    );
  }

  Future<DashboardDiscountStats> _loadDashboardDiscountStats(
    DashboardDateRange range,
  ) async {
    final summaryRow = await _db.customSelect(
      '''
      SELECT
        COUNT(DISTINCT CASE WHEN si.discount_cents > 0 THEN s.id END) AS discounted_operations_count,
        COALESCE(SUM(si.discount_cents), 0) AS total_discount_cents
      FROM sale_items si
      JOIN sales s ON s.id = si.sale_id
      WHERE s.status = 'sold'
        AND s.confirmed_at IS NOT NULL
        AND s.confirmed_at >= ?
        AND s.confirmed_at < ?
      ''',
      variables: _dashboardRangeVariables(range),
    ).getSingle();

    final topRows = await _db.customSelect(
      '''
      SELECT
        p.id AS id,
        p.name AS label,
        COALESCE(SUM(si.discount_cents), 0) AS amount_cents,
        COUNT(*) AS count,
        COALESCE(SUM(si.quantity), 0) AS quantity
      FROM sale_items si
      JOIN sales s ON s.id = si.sale_id
      JOIN products p ON p.id = si.product_id
      WHERE s.status = 'sold'
        AND s.confirmed_at IS NOT NULL
        AND s.confirmed_at >= ?
        AND s.confirmed_at < ?
        AND si.discount_cents > 0
      GROUP BY p.id, p.name
      ORDER BY amount_cents DESC, quantity DESC
      LIMIT 5
      ''',
      variables: _dashboardRangeVariables(range),
    ).get();

    final discountedOperationsCount =
        summaryRow.read<int>('discounted_operations_count');
    final totalDiscountCents = summaryRow.read<int>('total_discount_cents');

    return DashboardDiscountStats(
      discountedOperationsCount: discountedOperationsCount,
      totalDiscountCents: totalDiscountCents,
      averageDiscountCents: discountedOperationsCount > 0
          ? totalDiscountCents ~/ discountedOperationsCount
          : 0,
      topDiscountedProducts: topRows.map(_mapDashboardBreakdownItem).toList(),
    );
  }

  Future<List<DashboardBreakdownItem>> _loadSalesByCategory(
    DashboardDateRange range, {
    required int limit,
  }) async {
    final rows = await _db.customSelect(
      '''
      SELECT
        c.id AS id,
        COALESCE(c.name, 'Sin categoria') AS label,
        COALESCE(SUM(si.line_total_cents + si.tax_cents), 0) AS amount_cents,
        COUNT(DISTINCT s.id) AS count,
        COALESCE(SUM(si.quantity), 0) AS quantity
      FROM sale_items si
      JOIN sales s ON s.id = si.sale_id
      JOIN products p ON p.id = si.product_id
      LEFT JOIN categories c ON c.id = p.category_id
      WHERE s.status = 'sold'
        AND s.confirmed_at IS NOT NULL
        AND s.confirmed_at >= ?
        AND s.confirmed_at < ?
      GROUP BY c.id, c.name
      ORDER BY amount_cents DESC, quantity DESC
      LIMIT ?
      ''',
      variables: <Variable<Object>>[
        ..._dashboardRangeVariables(range),
        _asVariable(limit),
      ],
    ).get();
    return rows.map(_mapDashboardBreakdownItem).toList();
  }

  Future<List<DashboardProductRankingItem>> _loadProductRanking(
    DashboardDateRange range, {
    required String orderBy,
    required int limit,
  }) async {
    final rows = await _db.customSelect(
      '''
      SELECT
        p.id AS product_id,
        p.name AS label,
        COALESCE(SUM(si.quantity), 0) AS units_sold,
        COALESCE(SUM(si.line_total_cents + si.tax_cents), 0) AS revenue_cents,
        COALESCE(SUM(si.line_profit_cents), 0) AS profit_cents,
        p.stock_total,
        p.stock_reserved,
        p.cost_cents,
        MAX(s.confirmed_at) AS last_sale_at
      FROM sale_items si
      JOIN sales s ON s.id = si.sale_id
      JOIN products p ON p.id = si.product_id
      WHERE s.status = 'sold'
        AND s.confirmed_at IS NOT NULL
        AND s.confirmed_at >= ?
        AND s.confirmed_at < ?
      GROUP BY p.id, p.name, p.stock_total, p.stock_reserved, p.cost_cents
      ORDER BY $orderBy
      LIMIT ?
      ''',
      variables: <Variable<Object>>[
        ..._dashboardRangeVariables(range),
        _asVariable(limit),
      ],
    ).get();
    return rows.map(_mapDashboardProductRanking).toList();
  }

  Future<List<DashboardProductRankingItem>> _loadLeastSoldProducts(
    DashboardDateRange range, {
    required int limit,
  }) async {
    final rows = await _db.customSelect(
      '''
      SELECT
        p.id AS product_id,
        p.name AS label,
        COALESCE(SUM(si.quantity), 0) AS units_sold,
        COALESCE(SUM(si.line_total_cents + si.tax_cents), 0) AS revenue_cents,
        COALESCE(SUM(si.line_profit_cents), 0) AS profit_cents,
        p.stock_total,
        p.stock_reserved,
        p.cost_cents,
        MAX(s.confirmed_at) AS last_sale_at
      FROM sale_items si
      JOIN sales s ON s.id = si.sale_id
      JOIN products p ON p.id = si.product_id
      WHERE s.status = 'sold'
        AND s.confirmed_at IS NOT NULL
        AND s.confirmed_at >= ?
        AND s.confirmed_at < ?
      GROUP BY p.id, p.name, p.stock_total, p.stock_reserved, p.cost_cents
      ORDER BY units_sold ASC, revenue_cents ASC, label ASC
      LIMIT ?
      ''',
      variables: <Variable<Object>>[
        ..._dashboardRangeVariables(range),
        _asVariable(limit),
      ],
    ).get();
    return rows.map(_mapDashboardProductRanking).toList();
  }

  Future<List<DashboardProductRankingItem>> _loadProductsWithoutMovement(
    DashboardDateRange range, {
    required int limit,
  }) async {
    final rows = await _db.customSelect(
      '''
      WITH last_sales AS (
        SELECT
          si.product_id,
          MAX(s.confirmed_at) AS last_sale_at
        FROM sale_items si
        JOIN sales s ON s.id = si.sale_id
        WHERE s.status = 'sold'
          AND s.confirmed_at IS NOT NULL
        GROUP BY si.product_id
      )
      SELECT
        p.id AS product_id,
        p.name AS label,
        0 AS units_sold,
        0 AS revenue_cents,
        0 AS profit_cents,
        p.stock_total,
        p.stock_reserved,
        p.cost_cents,
        ls.last_sale_at
      FROM products p
      LEFT JOIN last_sales ls ON ls.product_id = p.id
      WHERE p.is_active = 1
        AND (p.stock_total - p.stock_reserved) > 0
        AND NOT EXISTS (
          SELECT 1
          FROM sale_items si
          JOIN sales s ON s.id = si.sale_id
          WHERE si.product_id = p.id
            AND s.status = 'sold'
            AND s.confirmed_at IS NOT NULL
            AND s.confirmed_at >= ?
            AND s.confirmed_at < ?
        )
      ORDER BY ((p.stock_total - p.stock_reserved) * p.cost_cents) DESC, ls.last_sale_at ASC
      LIMIT ?
      ''',
      variables: <Variable<Object>>[
        ..._dashboardRangeVariables(range),
        _asVariable(limit),
      ],
    ).get();
    return rows.map(_mapDashboardProductRanking).toList();
  }

  Future<List<DashboardSeriesPoint>> _loadSalesSeries(
    DashboardDateRange range,
    String bucket,
  ) async {
    final bucketExpression = _dashboardBucketExpression('confirmed_at', bucket);
    final rows = await _db.customSelect(
      '''
      SELECT
        $bucketExpression AS bucket_start,
        COALESCE(SUM(total_cents), 0) AS amount_cents,
        COUNT(*) AS count
      FROM sales
      WHERE status = 'sold'
        AND confirmed_at IS NOT NULL
        AND confirmed_at >= ?
        AND confirmed_at < ?
      GROUP BY bucket_start
      ORDER BY bucket_start ASC
      ''',
      variables: _dashboardRangeVariables(range),
    ).get();
    return rows.map((row) => _mapSeriesPoint(row, bucket)).toList();
  }

  Future<List<DashboardSeriesPoint>> _loadProfitSeries(
    DashboardDateRange range,
    String bucket,
  ) async {
    final bucketExpression =
        _dashboardBucketExpression('s.confirmed_at', bucket);
    final rows = await _db.customSelect(
      '''
      SELECT
        $bucketExpression AS bucket_start,
        COALESCE(SUM(si.line_profit_cents), 0) AS amount_cents,
        COUNT(DISTINCT s.id) AS count
      FROM sale_items si
      JOIN sales s ON s.id = si.sale_id
      WHERE s.status = 'sold'
        AND s.confirmed_at IS NOT NULL
        AND s.confirmed_at >= ?
        AND s.confirmed_at < ?
      GROUP BY bucket_start
      ORDER BY bucket_start ASC
      ''',
      variables: _dashboardRangeVariables(range),
    ).get();
    return rows.map((row) => _mapSeriesPoint(row, bucket)).toList();
  }

  Future<List<DashboardSeriesPoint>> _loadExpenseSeries(
    DashboardDateRange range,
    String bucket,
  ) async {
    final bucketExpression = _dashboardBucketExpression('occurred_at', bucket);
    final rows = await _db.customSelect(
      '''
      SELECT
        $bucketExpression AS bucket_start,
        COALESCE(SUM(amount_cents), 0) AS amount_cents,
        COUNT(*) AS count
      FROM expenses
      WHERE is_active = 1
        AND occurred_at >= ?
        AND occurred_at < ?
      GROUP BY bucket_start
      ORDER BY bucket_start ASC
      ''',
      variables: _dashboardRangeVariables(range),
    ).get();
    return rows.map((row) => _mapSeriesPoint(row, bucket)).toList();
  }

  List<DashboardAlertItem> _buildDashboardAlerts({
    required DashboardInventoryStats inventory,
    required DashboardReservationStats reservations,
    required int netMarginBps,
  }) {
    final alerts = <DashboardAlertItem>[];
    if (inventory.lowStockCount > 0) {
      alerts.add(
        DashboardAlertItem(
          key: 'low-stock',
          title: '${inventory.lowStockCount} productos debajo del minimo',
          subtitle: 'Abrir inventario con stock bajo.',
          route: '/stock?filter=lowStock',
        ),
      );
    }
    if (inventory.noStockCount > 0) {
      alerts.add(
        DashboardAlertItem(
          key: 'no-stock',
          title: '${inventory.noStockCount} productos sin stock',
          subtitle: 'Abrir inventario sin stock.',
          route: '/stock?filter=noStock',
        ),
      );
    }
    if (inventory.nearExpiryCount > 0) {
      alerts.add(
        DashboardAlertItem(
          key: 'near-expiry',
          title: '${inventory.nearExpiryCount} lotes proximos a vencer',
          subtitle: 'Abrir inventario con vencimientos cercanos.',
          route: '/stock?filter=nearExpiry',
        ),
      );
    }
    if (inventory.expiredCount > 0) {
      alerts.add(
        DashboardAlertItem(
          key: 'expired',
          title: '${inventory.expiredCount} lotes vencidos',
          subtitle: 'Abrir inventario vencido.',
          route: '/stock?filter=expired',
        ),
      );
    }
    if (reservations.pendingReservations > 0) {
      alerts.add(
        DashboardAlertItem(
          key: 'pending-reservations',
          title: '${reservations.pendingReservations} reservas pendientes',
          subtitle: 'Abrir reservas.',
          route: '/reservas',
        ),
      );
    }
    if (inventory.noMovementProductsCount > 0) {
      alerts.add(
        DashboardAlertItem(
          key: 'no-movement',
          title:
              '${inventory.noMovementProductsCount} productos sin movimiento',
          subtitle: 'Capital inmovilizado en stock.',
          route: '/productos?stagnant=1',
        ),
      );
    }
    alerts.add(
      DashboardAlertItem(
        key: 'net-margin',
        title: 'Margen neto: ${_formatPercentBps(netMarginBps)}',
        subtitle: 'Rentabilidad del periodo.',
        route: '/estadisticas',
      ),
    );
    return alerts;
  }

  DateTime? _expensePeriodStart(
      ExpensePeriod period, DateTime? from, DateTime? to) {
    final now = DateTime.now().toUtc();
    switch (period) {
      case ExpensePeriod.today:
        return DateTime.utc(now.year, now.month, now.day);
      case ExpensePeriod.thisWeek:
        return now.subtract(Duration(days: now.weekday - 1));
      case ExpensePeriod.thisMonth:
        return DateTime.utc(now.year, now.month, 1);
      case ExpensePeriod.previousMonth:
        return DateTime.utc(now.year, now.month - 1, 1);
      case ExpensePeriod.custom:
        return from?.toUtc();
    }
  }

  DateTime? _expensePeriodEnd(
      ExpensePeriod period, DateTime? from, DateTime? to) {
    final now = DateTime.now().toUtc();
    switch (period) {
      case ExpensePeriod.today:
        return DateTime.utc(now.year, now.month, now.day + 1);
      case ExpensePeriod.thisWeek:
        return now.add(const Duration(days: 1));
      case ExpensePeriod.thisMonth:
        return DateTime.utc(now.year, now.month + 1, 1);
      case ExpensePeriod.previousMonth:
        return DateTime.utc(now.year, now.month, 1);
      case ExpensePeriod.custom:
        return to?.toUtc().add(const Duration(days: 1));
    }
  }

  DateTime? _dashboardPeriodStart(
      DashboardPeriod period, DateTime? from, DateTime? to) {
    final now = DateTime.now().toUtc();
    switch (period) {
      case DashboardPeriod.today:
        return DateTime.utc(now.year, now.month, now.day);
      case DashboardPeriod.last7Days:
        return DateTime.utc(now.year, now.month, now.day)
            .subtract(const Duration(days: 6));
      case DashboardPeriod.thisWeek:
        return now.subtract(Duration(days: now.weekday - 1));
      case DashboardPeriod.thisMonth:
        return DateTime.utc(now.year, now.month, 1);
      case DashboardPeriod.previousMonth:
        final previousMonth = now.month == 1 ? 12 : now.month - 1;
        final previousYear = now.month == 1 ? now.year - 1 : now.year;
        return DateTime.utc(previousYear, previousMonth, 1);
      case DashboardPeriod.thisYear:
        return DateTime.utc(now.year, 1, 1);
      case DashboardPeriod.custom:
        return from?.toUtc();
    }
  }

  DateTime? _dashboardPeriodEnd(
      DashboardPeriod period, DateTime? from, DateTime? to) {
    final now = DateTime.now().toUtc();
    switch (period) {
      case DashboardPeriod.today:
        return DateTime.utc(now.year, now.month, now.day + 1);
      case DashboardPeriod.last7Days:
        return DateTime.utc(now.year, now.month, now.day + 1);
      case DashboardPeriod.thisWeek:
        return now.add(const Duration(days: 1));
      case DashboardPeriod.thisMonth:
        return DateTime.utc(now.year, now.month + 1, 1);
      case DashboardPeriod.previousMonth:
        return DateTime.utc(now.year, now.month, 1);
      case DashboardPeriod.thisYear:
        return DateTime.utc(now.year + 1, 1, 1);
      case DashboardPeriod.custom:
        return to?.toUtc().add(const Duration(days: 1));
    }
  }

  DashboardDateRange _resolveDashboardRange(DashboardQuery query) {
    final start = _dashboardPeriodStart(query.period, query.from, query.to) ??
        DateTime.utc(DateTime.now().toUtc().year, DateTime.now().toUtc().month,
            DateTime.now().toUtc().day);
    final end = _dashboardPeriodEnd(query.period, query.from, query.to) ??
        start.add(const Duration(days: 1));
    return DashboardDateRange(
      label:
          '${_formatShortDate(start)} -> ${_formatShortDate(end.subtract(const Duration(days: 1)))}',
      start: start,
      end: end,
    );
  }

  List<Variable<Object>> _dashboardRangeVariables(DashboardDateRange range) {
    return <Variable<Object>>[
      _asVariable(range.start.toUtc()),
      _asVariable(range.end.toUtc()),
    ];
  }

  DashboardBreakdownItem _mapDashboardBreakdownItem(QueryRow row) {
    return DashboardBreakdownItem(
      id: row.readNullable<String>('id'),
      label: row.read<String>('label'),
      amountCents: row.read<int>('amount_cents'),
      count: row.read<int>('count'),
      quantity: row.readNullable<int>('quantity') ?? 0,
    );
  }

  DashboardProductRankingItem _mapDashboardProductRanking(QueryRow row) {
    return DashboardProductRankingItem(
      productId: row.read<String>('product_id'),
      label: row.read<String>('label'),
      unitsSold: row.read<int>('units_sold'),
      revenueCents: row.read<int>('revenue_cents'),
      profitCents: row.read<int>('profit_cents'),
      stockTotal: row.read<int>('stock_total'),
      stockReserved: row.read<int>('stock_reserved'),
      costCents: row.read<int>('cost_cents'),
      lastSaleAt: _readNullableDateTimeFromRow(row, 'last_sale_at'),
    );
  }

  DashboardSeriesPoint _mapSeriesPoint(QueryRow row, String bucket) {
    final rawBucket = row.data['bucket_start'];
    final DateTime periodStart;
    if (rawBucket is DateTime) {
      periodStart = rawBucket.toUtc();
    } else if (rawBucket is String && rawBucket.trim().isNotEmpty) {
      periodStart = DateTime.parse('${rawBucket.trim()}T00:00:00Z');
    } else if (rawBucket is int) {
      periodStart = DateTime.fromMillisecondsSinceEpoch(rawBucket, isUtc: true);
    } else {
      periodStart = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    }
    return DashboardSeriesPoint(
      label: _formatDashboardBucketLabel(periodStart, bucket),
      periodStart: periodStart,
      amountCents: row.read<int>('amount_cents'),
      count: row.read<int>('count'),
    );
  }

  String _dashboardBucketExpression(String column, String bucket) {
    switch (bucket) {
      case 'week':
        return "DATE($column, '-' || ((CAST(strftime('%w', $column) AS INTEGER) + 6) % 7) || ' days')";
      case 'month':
        return "DATE(strftime('%Y-%m-01', $column))";
      case 'day':
      default:
        return 'DATE($column)';
    }
  }

  String _preferredDashboardBucket(DashboardDateRange range) {
    final totalDays = range.end.difference(range.start).inDays;
    if (totalDays <= 14) {
      return 'day';
    }
    if (totalDays <= 120) {
      return 'week';
    }
    return 'month';
  }

  String _formatDashboardBucketLabel(DateTime date, String bucket) {
    switch (bucket) {
      case 'week':
        final weekEnd = date.add(const Duration(days: 6));
        return '${_formatShortDate(date)} - ${_formatShortDate(weekEnd)}';
      case 'month':
        final month = date.month.toString().padLeft(2, '0');
        return '$month/${date.year}';
      case 'day':
      default:
        return _formatShortDate(date);
    }
  }

  String _formatShortDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day/$month/${local.year}';
  }

  int _ratioBps(int numerator, int denominator) {
    if (denominator == 0) {
      return 0;
    }
    final adjustment = numerator >= 0 ? denominator ~/ 2 : -(denominator ~/ 2);
    return ((numerator * 10000) + adjustment) ~/ denominator;
  }

  String _formatPercentBps(int bps) {
    final sign = bps < 0 ? '-' : '';
    final absolute = bps.abs();
    final whole = absolute ~/ 100;
    final decimals = (absolute % 100).toString().padLeft(2, '0');
    return '$sign$whole.$decimals%';
  }

  void _validateProductInput(ProductUpsertInput input) {
    if (input.name.trim().isEmpty) {
      throw ValidationException('El nombre del producto es obligatorio.');
    }
    if (input.internalCode.trim().isEmpty) {
      throw ValidationException(
          'El código interno del producto es obligatorio.');
    }
    if (input.unitsPerPack <= 0) {
      throw ValidationException(
          'Las unidades por pack deben ser mayores a cero.');
    }
    if (input.stockMin < 0) {
      throw ValidationException('El stock mínimo no puede ser negativo.');
    }
    if (input.stockMax != null && input.stockMax! < input.stockMin) {
      throw ValidationException(
          'El stock máximo no puede ser menor que el stock mínimo.');
    }
    if (input.costCents < 0) {
      throw ValidationException('El costo no puede ser negativo.');
    }
    if (input.salePriceCents < 0) {
      throw ValidationException('El precio de venta no puede ser negativo.');
    }
    if (input.taxRateBps < 0) {
      throw ValidationException('El IVA no puede ser negativo.');
    }
    if (input.defaultDiscountBps < 0) {
      throw ValidationException(
          'El descuento predeterminado no puede ser negativo.');
    }
  }

  Future<void> _assertUniqueProductIdentity({
    required String internalCode,
    required String? barcode,
    String? excludeProductId,
  }) async {
    final codeQuery = _db.select(_db.products)
      ..where((t) => t.internalCode.equals(internalCode));
    if (excludeProductId != null) {
      codeQuery.where((t) => t.id.equals(excludeProductId).not());
    }
    final codeExists = await codeQuery.getSingleOrNull();
    if (codeExists != null) {
      throw ConflictException('Ya existe un producto con ese código interno.');
    }

    if (barcode != null && barcode.trim().isNotEmpty) {
      final barcodeQuery = _db.select(_db.products)
        ..where((t) => t.barcode.equals(barcode.trim()));
      if (excludeProductId != null) {
        barcodeQuery.where((t) => t.id.equals(excludeProductId).not());
      }
      final barcodeExists = await barcodeQuery.getSingleOrNull();
      if (barcodeExists != null) {
        throw ConflictException(
            'Ya existe un producto con ese código de barras.');
      }
    }
  }

  Future<void> _assertCategoryIsAssignable(String? categoryId) async {
    if (categoryId == null || categoryId.trim().isEmpty) {
      return;
    }
    final category = await (_db.select(_db.categories)
          ..where((t) => t.id.equals(categoryId.trim())))
        .getSingleOrNull();
    if (category == null) {
      throw ValidationException('La categoría seleccionada no existe.');
    }
    if (!category.isActive) {
      throw ConflictException(
          'La categoría está inactiva y no acepta nuevos productos.');
    }
  }

  Future<void> _assertCategoryParent(String? parentId, String currentId) async {
    if (parentId == null) {
      return;
    }
    if (parentId == currentId) {
      throw ValidationException('Una categoría no puede ser su propio padre.');
    }
    final parent = await (_db.select(_db.categories)
          ..where((t) => t.id.equals(parentId)))
        .getSingleOrNull();
    if (parent == null) {
      throw ValidationException('La categoría padre no existe.');
    }
  }

  Future<void> _assertSupplierIsAssignable(String? supplierId) async {
    if (supplierId == null || supplierId.trim().isEmpty) {
      return;
    }
    final supplier = await (_db.select(_db.suppliers)
          ..where((t) => t.id.equals(supplierId.trim())))
        .getSingleOrNull();
    if (supplier == null) {
      throw ValidationException('El proveedor seleccionado no existe.');
    }
    if (!supplier.isActive) {
      throw ConflictException('El proveedor seleccionado está inactivo.');
    }
  }

  Future<void> _assertUniqueSupplierCuit(
    String cuit, {
    String? excludeSupplierId,
  }) async {
    final query = _db.select(_db.suppliers)..where((t) => t.cuit.equals(cuit));
    if (excludeSupplierId != null) {
      query.where((t) => t.id.equals(excludeSupplierId).not());
    }
    final exists = await query.getSingleOrNull();
    if (exists != null) {
      throw ConflictException('Ya existe un proveedor con ese CUIT.');
    }
  }

  void _assertCanTransition(String rawCurrent, CommercialStatus target) {
    final current = commercialStatusFromDb(rawCurrent);
    if (!current.canTransitionTo(target)) {
      throw ConflictException(
        'Transición de estado no permitida: ${current.dbValue} -> ${target.dbValue}.',
      );
    }
  }

  String? _normalizeOptional(String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _encodeProductAttributes(ProductUpsertInput input) {
    return jsonEncode(<String, Object?>{
      'characteristics': input.characteristics,
      'details': input.details,
      'location': input.location,
      'default_discount_bps': input.defaultDiscountBps,
      'is_offer': input.isOffer,
      'is_clearance': input.isClearance,
      'supplier_id': input.supplierId,
      'notes': input.notes,
      'tax_rate_bps': input.taxRateBps,
    });
  }

  String _buildFtsDescription(ProductUpsertInput input) {
    return <String?>[
      input.description,
      input.characteristics,
      input.details,
      input.notes,
    ].whereType<String>().join(' | ');
  }

  Map<String, dynamic> _decodeAttributes(String? jsonText) {
    if (jsonText == null || jsonText.trim().isEmpty) {
      return <String, dynamic>{};
    }
    final raw = jsonDecode(jsonText);
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    return <String, dynamic>{};
  }

  String? _readStringAttribute(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
    return null;
  }

  int _readIntAttribute(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return 0;
  }

  bool _readBoolAttribute(Map<String, dynamic> source, String key) {
    final value = source[key];
    return value == true;
  }

  String _productSortSql(ProductSortBy sortBy, bool descending) {
    final direction = descending ? 'DESC' : 'ASC';
    switch (sortBy) {
      case ProductSortBy.name:
        return 'LOWER(p.name) $direction';
      case ProductSortBy.code:
        return 'LOWER(p.internal_code) $direction';
      case ProductSortBy.stock:
        return '(p.stock_total - p.stock_reserved) $direction';
      case ProductSortBy.price:
        return 'p.sale_price_cents $direction';
      case ProductSortBy.createdAt:
        return 'p.created_at $direction';
      case ProductSortBy.updatedAt:
        return 'p.updated_at $direction';
    }
  }

  String _inventorySortSql(InventorySortBy sortBy, bool descending) {
    final direction = descending ? 'DESC' : 'ASC';
    switch (sortBy) {
      case InventorySortBy.name:
        return 'LOWER(p.name) $direction, p.id ASC';
      case InventorySortBy.stockAvailable:
        return '(p.stock_total - p.stock_reserved) $direction, LOWER(p.name) ASC';
      case InventorySortBy.stockReserved:
        return 'p.stock_reserved $direction, LOWER(p.name) ASC';
      case InventorySortBy.nextExpiry:
        return 'CASE WHEN next_relevant_expiry IS NULL THEN 1 ELSE 0 END ASC, next_relevant_expiry $direction, LOWER(p.name) ASC';
      case InventorySortBy.updatedAt:
        return 'p.updated_at $direction, LOWER(p.name) ASC';
    }
  }

  void _appendProductSearchWhere({
    required List<String> where,
    required List<Object> values,
    required String? rawSearch,
    required String productAlias,
  }) {
    final normalizedSearch = _normalizeSearch(rawSearch);
    if (normalizedSearch == null || normalizedSearch.isEmpty) {
      return;
    }

    final ftsMatchQuery = _buildFtsMatchQuery(normalizedSearch);
    final normalizedInternalCode = _sqlNormalize('$productAlias.internal_code');
    final normalizedBarcode =
        _sqlNormalize("IFNULL($productAlias.barcode, '')");
    final normalizedName = _sqlNormalize('$productAlias.name');
    final normalizedBrand = _sqlNormalize("IFNULL($productAlias.brand, '')");
    final normalizedDescription =
        _sqlNormalize("IFNULL($productAlias.description, '')");
    final normalizedAttributes =
        _sqlNormalize("IFNULL($productAlias.attributes_json, '')");
    final ftsCondition = ftsMatchQuery == null
        ? ''
        : '''
          OR $productAlias.id IN (
            SELECT product_id
            FROM products_fts
            WHERE products_fts MATCH ?
          )
          ''';

    where.add('''
      (
        $normalizedInternalCode = ?
        OR $normalizedBarcode = ?
        OR $normalizedName LIKE ?
        OR $normalizedName LIKE ?
        OR $normalizedBrand LIKE ?
        OR $normalizedDescription LIKE ?
        OR $normalizedAttributes LIKE ?
        $ftsCondition
      )
    ''');

    final prefix = '$normalizedSearch%';
    final partial = '%$normalizedSearch%';
    values.addAll(<Object>[
      normalizedSearch,
      normalizedSearch,
      prefix,
      partial,
      partial,
      partial,
      partial,
    ]);
    if (ftsMatchQuery != null) {
      values.add(ftsMatchQuery);
    }
  }

  InventoryStockState _resolveInventoryStockState({
    required int stockTotal,
    required int stockReserved,
    required int stockMin,
    required int? stockMax,
  }) {
    final available = stockTotal - stockReserved;
    if (available <= 0) {
      return InventoryStockState.noStock;
    }
    if (stockMax != null && available > stockMax) {
      return InventoryStockState.overStock;
    }
    if (available <= stockMin) {
      return InventoryStockState.lowStock;
    }
    return InventoryStockState.normal;
  }

  InventoryExpiryState _resolveInventoryExpiryState({
    required DateTime? nextExpiry,
    required DateTime todayStart,
    required DateTime tomorrowStart,
    required DateTime nearExpiryLimit,
  }) {
    if (nextExpiry == null) {
      return InventoryExpiryState.noExpiry;
    }
    final nextDate = DateTime.utc(
      nextExpiry.year,
      nextExpiry.month,
      nextExpiry.day,
    );
    final nearLimitDate = DateTime.utc(
      nearExpiryLimit.year,
      nearExpiryLimit.month,
      nearExpiryLimit.day,
    );
    if (nextDate.isBefore(todayStart)) {
      return InventoryExpiryState.expired;
    }
    if (!nextDate.isBefore(todayStart) && nextDate.isBefore(tomorrowStart)) {
      return InventoryExpiryState.dueToday;
    }
    if (!nextDate.isAfter(nearLimitDate)) {
      return InventoryExpiryState.nearExpiry;
    }
    return InventoryExpiryState.normal;
  }

  String? _normalizeSearch(String? raw) {
    if (raw == null) {
      return null;
    }
    final trimmed = raw.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return null;
    }
    return _stripDiacritics(trimmed);
  }

  String _stripDiacritics(String input) {
    return input
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ì', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('î', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('ö', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ñ', 'n');
  }

  String _sqlNormalize(String expression) {
    return "REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER($expression), 'á', 'a'), 'à', 'a'), 'ä', 'a'), 'â', 'a'), 'ã', 'a'), 'é', 'e'), 'è', 'e'), 'ë', 'e'), 'ê', 'e'), 'í', 'i'), 'ì', 'i'), 'ï', 'i'), 'î', 'i'), 'ó', 'o'), 'ò', 'o'), 'ö', 'o'), 'ô', 'o'), 'õ', 'o'), 'ú', 'u'), 'ù', 'u'), 'ü', 'u'), 'û', 'u'), 'ñ', 'n'), 'Á', 'a'), 'É', 'e')";
  }

  String? _buildFtsMatchQuery(String normalizedSearch) {
    final tokens = normalizedSearch
        .split(RegExp(r'[^a-z0-9]+'))
        .where((token) => token.trim().isNotEmpty)
        .toList();
    if (tokens.isEmpty) {
      return null;
    }
    return tokens.map((token) => '$token*').join(' ');
  }

  Variable<Object> _asVariable(Object value) {
    if (value is int) {
      return Variable<int>(value) as Variable<Object>;
    }
    if (value is bool) {
      return Variable<bool>(value) as Variable<Object>;
    }
    if (value is String) {
      return Variable<String>(value) as Variable<Object>;
    }
    if (value is DateTime) {
      return Variable<DateTime>(value) as Variable<Object>;
    }
    throw ArgumentError('Tipo de variable no soportado: ${value.runtimeType}');
  }

  ProductSummaryItem _mapProductSummary(QueryRow row) {
    final attributes =
        _decodeAttributes(row.readNullable<String>('attributes_json'));
    return ProductSummaryItem(
      id: row.read<String>('id'),
      name: row.read<String>('name'),
      internalCode: row.read<String>('internal_code'),
      barcode: row.readNullable<String>('barcode'),
      brand: row.readNullable<String>('brand'),
      categoryId: row.readNullable<String>('category_id'),
      subcategory: row.readNullable<String>('subcategory'),
      stockTotal: row.read<int>('stock_total'),
      stockReserved: row.read<int>('stock_reserved'),
      stockMin: row.read<int>('stock_min'),
      costCents: row.read<int>('cost_cents'),
      salePriceCents: row.read<int>('sale_price_cents'),
      isActive: row.read<int>('is_active') == 1,
      createdAt: _readDateTimeFromRow(row, 'created_at'),
      updatedAt: _readDateTimeFromRow(row, 'updated_at'),
      isOffer: _readBoolAttribute(attributes, 'is_offer'),
      isClearance: _readBoolAttribute(attributes, 'is_clearance'),
      hasNearExpiry: row.read<int>('has_near_expiry') == 1,
    );
  }

  SaleListItem _mapSaleListItem(QueryRow row) {
    return SaleListItem(
      id: row.read<String>('id'),
      status: row.read<String>('status'),
      customerId: row.readNullable<String>('customer_id'),
      customerName: row.readNullable<String>('customer_name'),
      productCount: row.read<int>('product_count'),
      unitsCount: row.read<int>('units_count'),
      subtotalCents: row.read<int>('subtotal_cents'),
      taxCents: row.read<int>('tax_cents'),
      discountCents: row.read<int>('discount_cents'),
      totalCents: row.read<int>('total_cents'),
      profitCents: row.read<int>('estimated_profit_cents'),
      createdAt: _readDateTimeFromRow(row, 'created_at'),
      updatedAt: _readNullableDateTimeFromRow(row, 'updated_at'),
      confirmedAt: _readNullableDateTimeFromRow(row, 'confirmed_at'),
    );
  }

  ReservationListItem _mapReservationListItem(QueryRow row) {
    return ReservationListItem(
      id: row.read<String>('id'),
      status: row.read<String>('status'),
      customerId: row.readNullable<String>('customer_id'),
      customerName: row.readNullable<String>('customer_name'),
      productCount: row.read<int>('product_count'),
      unitsCount: row.read<int>('units_count'),
      subtotalCents: row.read<int>('subtotal_cents'),
      taxCents: row.read<int>('tax_cents'),
      discountCents: row.read<int>('discount_cents'),
      totalCents: row.read<int>('total_cents'),
      createdAt: _readDateTimeFromRow(row, 'created_at'),
      updatedAt: _readNullableDateTimeFromRow(row, 'updated_at'),
      confirmedAt: _readNullableDateTimeFromRow(row, 'confirmed_at'),
      canceledAt: _readNullableDateTimeFromRow(row, 'canceled_at'),
      deletedAt: _readNullableDateTimeFromRow(row, 'deleted_at'),
    );
  }

  String _saleStatusFilterValue(SaleStatusFilter status) {
    switch (status) {
      case SaleStatusFilter.draft:
        return 'draft';
      case SaleStatusFilter.reserved:
        return 'reserved';
      case SaleStatusFilter.sold:
        return 'sold';
      case SaleStatusFilter.cancelled:
        return 'cancelled';
      case SaleStatusFilter.deleted:
        return 'deleted';
      case SaleStatusFilter.all:
        return '';
    }
  }

  String _reservationStatusFilterValue(ReservationStatusFilter status) {
    switch (status) {
      case ReservationStatusFilter.draft:
        return 'draft';
      case ReservationStatusFilter.reserved:
        return 'reserved';
      case ReservationStatusFilter.sold:
        return 'sold';
      case ReservationStatusFilter.cancelled:
        return 'cancelled';
      case ReservationStatusFilter.deleted:
        return 'deleted';
      case ReservationStatusFilter.all:
        return '';
    }
  }

  DateTime _readDateTimeFromRow(QueryRow row, String key) {
    final raw = row.data[key];
    if (raw is DateTime) {
      return raw;
    }
    if (raw is int) {
      return _readEpochDateTime(raw);
    }
    if (raw is String) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) {
        return parsed;
      }
    }
    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }

  DateTime? _readNullableDateTimeFromRow(QueryRow row, String key) {
    final raw = row.data[key];
    if (raw == null) {
      return null;
    }
    if (raw is DateTime) {
      return raw;
    }
    if (raw is int) {
      return _readEpochDateTime(raw);
    }
    if (raw is String) {
      return DateTime.tryParse(raw);
    }
    return null;
  }

  DateTime _readEpochDateTime(int raw) {
    final absolute = raw.abs();
    if (absolute < 100000000000) {
      return DateTime.fromMillisecondsSinceEpoch(raw * 1000, isUtc: true);
    }
    if (absolute > 10000000000000) {
      return DateTime.fromMicrosecondsSinceEpoch(raw, isUtc: true);
    }
    return DateTime.fromMillisecondsSinceEpoch(raw, isUtc: true);
  }

  Future<String?> _readCategoryName(String? categoryId) async {
    if (categoryId == null) {
      return null;
    }
    final category = await (_db.select(_db.categories)
          ..where((t) => t.id.equals(categoryId)))
        .getSingleOrNull();
    return category?.name;
  }

  Future<Product> _requireProduct(String productId) async {
    final product = await (_db.select(_db.products)
          ..where((tbl) => tbl.id.equals(productId)))
        .getSingleOrNull();
    if (product == null) {
      throw NotFoundException('El producto no existe.');
    }
    return product;
  }

  Future<ProductBatche> _requireBatch(String batchId) async {
    final batch = await (_db.select(_db.productBatches)
          ..where((tbl) => tbl.id.equals(batchId)))
        .getSingleOrNull();
    if (batch == null) {
      throw NotFoundException('El lote no existe.');
    }
    return batch;
  }

  Future<void> _insertMovement({
    required String productId,
    String? batchId,
    required String movementType,
    required int quantity,
    required int stockBefore,
    required int stockAfter,
    String? referenceType,
    String? referenceId,
    String? reason,
    String? observations,
    required DateTime createdAt,
  }) {
    return _db.into(_db.stockMovements).insert(
          StockMovementsCompanion.insert(
            id: '${movementType}_${productId}_${createdAt.microsecondsSinceEpoch}',
            productId: productId,
            batchId: Value(batchId),
            movementType: movementType,
            quantity: quantity,
            stockBefore: stockBefore,
            stockAfter: stockAfter,
            referenceType: Value(referenceType),
            referenceId: Value(referenceId),
            reason: Value(reason),
            observations: Value(observations),
            createdAt: createdAt,
          ),
        );
  }

  Future<void> _insertAudit({
    required String entityType,
    required String entityId,
    required String action,
    required Map<String, Object?> before,
    required Map<String, Object?> after,
    required DateTime createdAt,
  }) {
    return _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            id: 'audit_${entityType}_${entityId}_${createdAt.microsecondsSinceEpoch}',
            entityType: entityType,
            entityId: entityId,
            action: action,
            beforeJson: Value(jsonEncode(before)),
            afterJson: Value(jsonEncode(after)),
            createdAt: createdAt,
          ),
        );
  }

  Future<List<_BatchAllocation>> _allocateBatches({
    required String productId,
    required int quantity,
    required _AllocationMode mode,
  }) async {
    final batches = await (_db.select(_db.productBatches)
          ..where(
              (t) => t.productId.equals(productId) & t.status.equals('active'))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.receivedAt, mode: OrderingMode.asc)
          ]))
        .get();

    var remaining = quantity;
    final allocations = <_BatchAllocation>[];
    for (final batch in batches) {
      final batchAvailable = batch.quantityTotal - batch.quantityReserved;
      if (batchAvailable <= 0) {
        continue;
      }
      final used = remaining <= batchAvailable ? remaining : batchAvailable;
      if (used <= 0) {
        continue;
      }

      if (mode == _AllocationMode.reserve) {
        await (_db.update(_db.productBatches)
              ..where((t) => t.id.equals(batch.id)))
            .write(
          ProductBatchesCompanion(
            quantityReserved: Value(batch.quantityReserved + used),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
      } else {
        await (_db.update(_db.productBatches)
              ..where((t) => t.id.equals(batch.id)))
            .write(
          ProductBatchesCompanion(
            quantityTotal: Value(batch.quantityTotal - used),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
      }

      allocations.add(
        _BatchAllocation(
          id: 'alloc_${batch.id}_${DateTime.now().microsecondsSinceEpoch}_${allocations.length}',
          batchId: batch.id,
          quantity: used,
          unitCostCents: batch.unitCostCents,
        ),
      );
      remaining -= used;
      if (remaining == 0) {
        break;
      }
    }

    if (remaining > 0) {
      throw ConflictException(
          'No hay stock suficiente por lotes para completar la operación.');
    }

    return allocations;
  }

  int _weightedUnitCost(List<_BatchAllocation> allocations, int quantity) {
    final totalCost = allocations.fold<int>(0, (sum, allocation) {
      return sum + (allocation.unitCostCents * allocation.quantity);
    });
    return (totalCost / quantity).round();
  }
}

enum _AllocationMode { reserve, sale }

class _BatchAllocation {
  const _BatchAllocation({
    required this.id,
    required this.batchId,
    required this.quantity,
    required this.unitCostCents,
  });

  final String id;
  final String batchId;
  final int quantity;
  final int unitCostCents;
}
