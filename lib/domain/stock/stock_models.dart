class CreateProductInput {
  const CreateProductInput({
    required this.id,
    required this.internalCode,
    required this.name,
    this.barcode,
    this.categoryId,
    this.brand,
    this.description,
    this.unit = 'unit',
    this.unitsPerPack = 1,
    this.costCents = 0,
    this.salePriceCents = 0,
    this.taxProfileId,
  });

  final String id;
  final String internalCode;
  final String name;
  final String? barcode;
  final String? categoryId;
  final String? brand;
  final String? description;
  final String unit;
  final int unitsPerPack;
  final int costCents;
  final int salePriceCents;
  final String? taxProfileId;
}

class ReceiveStockInput {
  const ReceiveStockInput({
    required this.batchId,
    required this.productId,
    required this.quantity,
    required this.unitCostCents,
    required this.receivedAt,
    this.batchCode,
    this.supplierId,
    this.expiresAt,
    this.notes,
  });

  final String batchId;
  final String productId;
  final int quantity;
  final int unitCostCents;
  final DateTime receivedAt;
  final String? batchCode;
  final String? supplierId;
  final DateTime? expiresAt;
  final String? notes;
}

class ReservationLineInput {
  const ReservationLineInput({
    required this.itemId,
    required this.productId,
    required this.quantity,
    required this.unitPriceCents,
    required this.taxRateBps,
    required this.discountCents,
  });

  final String itemId;
  final String productId;
  final int quantity;
  final int unitPriceCents;
  final int taxRateBps;
  final int discountCents;
}

class CreateReservationInput {
  const CreateReservationInput({
    required this.reservationId,
    required this.createdAt,
    required this.lines,
    this.customerId,
    this.notes,
  });

  final String reservationId;
  final DateTime createdAt;
  final List<ReservationLineInput> lines;
  final String? customerId;
  final String? notes;
}

class ConfirmSaleInput {
  const ConfirmSaleInput({
    required this.saleId,
    required this.confirmedAt,
    this.reservationId,
    this.customerId,
    this.notes,
  });

  final String saleId;
  final DateTime confirmedAt;
  final String? reservationId;
  final String? customerId;
  final String? notes;
}

enum CommercialStatus {
  draft,
  reserved,
  sold,
  cancelled,
  deleted,
}

extension CommercialStatusX on CommercialStatus {
  String get dbValue {
    switch (this) {
      case CommercialStatus.draft:
        return 'draft';
      case CommercialStatus.reserved:
        return 'reserved';
      case CommercialStatus.sold:
        return 'sold';
      case CommercialStatus.cancelled:
        return 'cancelled';
      case CommercialStatus.deleted:
        return 'deleted';
    }
  }

  bool canTransitionTo(CommercialStatus next) {
    if (this == next) {
      return false;
    }
    switch (this) {
      case CommercialStatus.draft:
        return next == CommercialStatus.reserved ||
            next == CommercialStatus.sold ||
            next == CommercialStatus.deleted;
      case CommercialStatus.reserved:
        return next == CommercialStatus.sold ||
            next == CommercialStatus.cancelled ||
            next == CommercialStatus.deleted;
      case CommercialStatus.sold:
        return false;
      case CommercialStatus.cancelled:
        return false;
      case CommercialStatus.deleted:
        return false;
    }
  }
}

CommercialStatus commercialStatusFromDb(String raw) {
  switch (raw) {
    case 'draft':
      return CommercialStatus.draft;
    case 'reserved':
      return CommercialStatus.reserved;
    case 'sold':
      return CommercialStatus.sold;
    case 'cancelled':
    case 'canceled':
      return CommercialStatus.cancelled;
    case 'deleted':
      return CommercialStatus.deleted;
    default:
      throw FormatException('Estado comercial no soportado: $raw');
  }
}

class DirectSaleLineInput {
  const DirectSaleLineInput({
    required this.itemId,
    required this.productId,
    required this.quantity,
    required this.unitPriceCents,
    required this.taxRateBps,
    required this.discountCents,
  });

  final String itemId;
  final String productId;
  final int quantity;
  final int unitPriceCents;
  final int taxRateBps;
  final int discountCents;
}

class CreateDirectSaleInput {
  const CreateDirectSaleInput({
    required this.saleId,
    required this.createdAt,
    required this.lines,
    this.customerId,
    this.notes,
  });

  final String saleId;
  final DateTime createdAt;
  final List<DirectSaleLineInput> lines;
  final String? customerId;
  final String? notes;
}

class StockAdjustmentInput {
  const StockAdjustmentInput({
    required this.adjustmentId,
    required this.productId,
    required this.deltaQuantity,
    required this.createdAt,
    this.batchId,
    this.reason,
    this.observations,
  });

  final String adjustmentId;
  final String productId;
  final int deltaQuantity;
  final DateTime createdAt;
  final String? batchId;
  final String? reason;
  final String? observations;
}

class ReturnLineInput {
  const ReturnLineInput({
    required this.id,
    required this.saleItemId,
    required this.batchId,
    required this.productId,
    required this.quantity,
  });

  final String id;
  final String saleItemId;
  final String batchId;
  final String productId;
  final int quantity;
}

class CreateReturnInput {
  const CreateReturnInput({
    required this.returnId,
    required this.saleId,
    required this.createdAt,
    required this.lines,
    this.reason,
  });

  final String returnId;
  final String saleId;
  final DateTime createdAt;
  final List<ReturnLineInput> lines;
  final String? reason;
}

class DraftReservationLineInput {
  const DraftReservationLineInput({
    required this.itemId,
    required this.productId,
    required this.quantity,
    required this.unitPriceCents,
    required this.taxRateBps,
    required this.discountCents,
  });

  final String itemId;
  final String productId;
  final int quantity;
  final int unitPriceCents;
  final int taxRateBps;
  final int discountCents;
}

class CreateReservationDraftInput {
  const CreateReservationDraftInput({
    required this.reservationId,
    required this.createdAt,
    required this.lines,
    this.customerId,
    this.notes,
  });

  final String reservationId;
  final DateTime createdAt;
  final List<DraftReservationLineInput> lines;
  final String? customerId;
  final String? notes;
}

class ProductStockSnapshot {
  const ProductStockSnapshot({
    required this.productId,
    required this.stockTotal,
    required this.stockReserved,
  });

  final String productId;
  final int stockTotal;
  final int stockReserved;

  int get stockAvailable => stockTotal - stockReserved;
}

enum ProductStatusFilter { all, active, inactive }

enum ProductStockFilter { all, lowStock, noStock }

enum ProductSortBy { name, code, stock, price, createdAt, updatedAt }

enum InventoryFilter {
  all,
  noStock,
  lowStock,
  normal,
  overStock,
  nearExpiry,
  expired,
}

enum InventorySortBy {
  name,
  stockAvailable,
  stockReserved,
  nextExpiry,
  updatedAt,
}

enum InventoryStockState { noStock, lowStock, normal, overStock }

enum InventoryExpiryState { noExpiry, normal, nearExpiry, dueToday, expired }

class InventoryQuery {
  const InventoryQuery({
    this.search,
    this.filter = InventoryFilter.all,
    this.sortBy = InventorySortBy.name,
    this.descending = false,
    this.nearExpiryDays = 30,
    this.includeInactive = false,
    this.limit = 80,
    this.offset = 0,
  });

  final String? search;
  final InventoryFilter filter;
  final InventorySortBy sortBy;
  final bool descending;
  final int nearExpiryDays;
  final bool includeInactive;
  final int limit;
  final int offset;

  InventoryQuery copyWith({
    String? search,
    InventoryFilter? filter,
    InventorySortBy? sortBy,
    bool? descending,
    int? nearExpiryDays,
    bool? includeInactive,
    int? limit,
    int? offset,
  }) {
    return InventoryQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
      nearExpiryDays: nearExpiryDays ?? this.nearExpiryDays,
      includeInactive: includeInactive ?? this.includeInactive,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}

class InventorySummaryView {
  const InventorySummaryView({
    required this.totalProducts,
    required this.noStockCount,
    required this.lowStockCount,
    required this.nearExpiryCount,
    required this.expiredCount,
    required this.overStockCount,
  });

  final int totalProducts;
  final int noStockCount;
  final int lowStockCount;
  final int nearExpiryCount;
  final int expiredCount;
  final int overStockCount;
}

class InventoryListItem {
  const InventoryListItem({
    required this.id,
    required this.name,
    required this.internalCode,
    required this.barcode,
    required this.categoryName,
    required this.stockTotal,
    required this.stockReserved,
    required this.stockMin,
    required this.stockMax,
    required this.stockState,
    required this.expiryState,
    required this.nextRelevantExpiry,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String internalCode;
  final String? barcode;
  final String? categoryName;
  final int stockTotal;
  final int stockReserved;
  final int stockMin;
  final int? stockMax;
  final InventoryStockState stockState;
  final InventoryExpiryState expiryState;
  final DateTime? nextRelevantExpiry;
  final DateTime updatedAt;

  int get stockAvailable => stockTotal - stockReserved;
}

class ProductQuery {
  const ProductQuery({
    this.search,
    this.categoryId,
    this.subcategory,
    this.status = ProductStatusFilter.active,
    this.stock = ProductStockFilter.all,
    this.onlyOffer,
    this.onlyClearance,
    this.nearExpiryDays,
    this.sortBy = ProductSortBy.name,
    this.descending = false,
    this.limit = 40,
    this.offset = 0,
  });

  final String? search;
  final String? categoryId;
  final String? subcategory;
  final ProductStatusFilter status;
  final ProductStockFilter stock;
  final bool? onlyOffer;
  final bool? onlyClearance;
  final int? nearExpiryDays;
  final ProductSortBy sortBy;
  final bool descending;
  final int limit;
  final int offset;

  ProductQuery copyWith({
    String? search,
    String? categoryId,
    String? subcategory,
    ProductStatusFilter? status,
    ProductStockFilter? stock,
    bool? onlyOffer,
    bool? onlyClearance,
    int? nearExpiryDays,
    ProductSortBy? sortBy,
    bool? descending,
    int? limit,
    int? offset,
  }) {
    return ProductQuery(
      search: search ?? this.search,
      categoryId: categoryId ?? this.categoryId,
      subcategory: subcategory ?? this.subcategory,
      status: status ?? this.status,
      stock: stock ?? this.stock,
      onlyOffer: onlyOffer ?? this.onlyOffer,
      onlyClearance: onlyClearance ?? this.onlyClearance,
      nearExpiryDays: nearExpiryDays ?? this.nearExpiryDays,
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}

class ProductUpsertInput {
  const ProductUpsertInput({
    required this.id,
    required this.name,
    required this.internalCode,
    this.barcode,
    this.brand,
    this.categoryId,
    this.subcategory,
    this.description,
    this.characteristics,
    this.details,
    this.unit = 'unit',
    this.unitsPerPack = 1,
    this.stockMin = 0,
    this.stockMax,
    this.location,
    this.costCents = 0,
    this.salePriceCents = 0,
    this.taxRateBps = 0,
    this.defaultDiscountBps = 0,
    this.isOffer = false,
    this.isClearance = false,
    this.supplierId,
    this.notes,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String internalCode;
  final String? barcode;
  final String? brand;
  final String? categoryId;
  final String? subcategory;
  final String? description;
  final String? characteristics;
  final String? details;
  final String unit;
  final int unitsPerPack;
  final int stockMin;
  final int? stockMax;
  final String? location;
  final int costCents;
  final int salePriceCents;
  final int taxRateBps;
  final int defaultDiscountBps;
  final bool isOffer;
  final bool isClearance;
  final String? supplierId;
  final String? notes;
  final bool isActive;
}

class ProductSummaryItem {
  const ProductSummaryItem({
    required this.id,
    required this.name,
    required this.internalCode,
    this.barcode,
    this.brand,
    this.categoryId,
    this.subcategory,
    required this.stockTotal,
    required this.stockReserved,
    required this.stockMin,
    required this.costCents,
    required this.salePriceCents,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.isOffer,
    required this.isClearance,
    required this.hasNearExpiry,
  });

  final String id;
  final String name;
  final String internalCode;
  final String? barcode;
  final String? brand;
  final String? categoryId;
  final String? subcategory;
  final int stockTotal;
  final int stockReserved;
  final int stockMin;
  final int costCents;
  final int salePriceCents;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isOffer;
  final bool isClearance;
  final bool hasNearExpiry;

  int get stockAvailable => stockTotal - stockReserved;
  bool get hasLowStock => stockAvailable > 0 && stockAvailable <= stockMin;
}

class ProductBatchView {
  const ProductBatchView({
    required this.id,
    this.batchCode,
    required this.receivedAt,
    this.expiresAt,
    required this.quantityTotal,
    required this.quantityReserved,
    required this.unitCostCents,
  });

  final String id;
  final String? batchCode;
  final DateTime receivedAt;
  final DateTime? expiresAt;
  final int quantityTotal;
  final int quantityReserved;
  final int unitCostCents;

  int get quantityAvailable => quantityTotal - quantityReserved;
}

class ProductMovementView {
  const ProductMovementView({
    required this.id,
    required this.movementType,
    required this.quantity,
    required this.stockBefore,
    required this.stockAfter,
    this.batchId,
    this.referenceType,
    this.referenceId,
    this.reason,
    required this.createdAt,
  });

  final String id;
  final String movementType;
  final int quantity;
  final int stockBefore;
  final int stockAfter;
  final String? batchId;
  final String? referenceType;
  final String? referenceId;
  final String? reason;
  final DateTime createdAt;
}

class ProductDetailView {
  const ProductDetailView({
    required this.product,
    required this.categoryName,
    required this.description,
    required this.unit,
    required this.unitsPerPack,
    required this.stockMax,
    required this.characteristics,
    required this.details,
    required this.location,
    required this.taxRateBps,
    required this.defaultDiscountBps,
    required this.notes,
    required this.supplierId,
    required this.batches,
    required this.movements,
  });

  final ProductSummaryItem product;
  final String? categoryName;
  final String? description;
  final String unit;
  final int unitsPerPack;
  final int? stockMax;
  final String? characteristics;
  final String? details;
  final String? location;
  final int taxRateBps;
  final int defaultDiscountBps;
  final String? notes;
  final String? supplierId;
  final List<ProductBatchView> batches;
  final List<ProductMovementView> movements;

  int get estimatedProfitCents => product.salePriceCents - product.costCents;
}

class CategoryUpsertInput {
  const CategoryUpsertInput({
    required this.id,
    required this.name,
    this.parentId,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? parentId;
  final bool isActive;
}

class CategoryListItem {
  const CategoryListItem({
    required this.id,
    required this.name,
    required this.parentId,
    required this.isActive,
    required this.productCount,
  });

  final String id;
  final String name;
  final String? parentId;
  final bool isActive;
  final int productCount;
}

class SupplierUpsertInput {
  const SupplierUpsertInput({
    required this.id,
    required this.name,
    this.legalName,
    this.cuit,
    this.phone,
    this.email,
    this.address,
    this.notes,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? legalName;
  final String? cuit;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final bool isActive;
}

class SupplierListItem {
  const SupplierListItem({
    required this.id,
    required this.name,
    required this.legalName,
    required this.cuit,
    required this.phone,
    required this.email,
    required this.address,
    required this.notes,
    required this.isActive,
    required this.productBatchCount,
  });

  final String id;
  final String name;
  final String? legalName;
  final String? cuit;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final bool isActive;
  final int productBatchCount;
}

class SupplierDetailView {
  const SupplierDetailView({
    required this.id,
    required this.name,
    required this.legalName,
    required this.cuit,
    required this.phone,
    required this.email,
    required this.address,
    required this.notes,
    required this.isActive,
    required this.incomeCount,
    required this.associatedProductsCount,
    required this.lastIncomeAt,
  });

  final String id;
  final String name;
  final String? legalName;
  final String? cuit;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final bool isActive;
  final int incomeCount;
  final int associatedProductsCount;
  final DateTime? lastIncomeAt;
}

class CustomerUpsertInput {
  const CustomerUpsertInput({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.document,
    this.address,
    this.notes,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? document;
  final String? address;
  final String? notes;
  final bool isActive;
}

class CustomerListItem {
  const CustomerListItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.document,
    required this.address,
    required this.notes,
    required this.isActive,
  });

  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? document;
  final String? address;
  final String? notes;
  final bool isActive;
}

enum SaleStatusFilter { all, draft, reserved, sold, cancelled, deleted }

class SaleQuery {
  const SaleQuery({
    this.search,
    this.status = SaleStatusFilter.all,
    this.customerId,
    this.period = DashboardPeriod.thisMonth,
    this.from,
    this.to,
    this.limit = 80,
    this.offset = 0,
  });

  final String? search;
  final SaleStatusFilter status;
  final String? customerId;
  final DashboardPeriod period;
  final DateTime? from;
  final DateTime? to;
  final int limit;
  final int offset;
}

class SaleLineDraftInput {
  const SaleLineDraftInput({
    required this.itemId,
    required this.productId,
    required this.quantity,
    required this.unitPriceCents,
    required this.taxRateBps,
    required this.discountCents,
  });

  final String itemId;
  final String productId;
  final int quantity;
  final int unitPriceCents;
  final int taxRateBps;
  final int discountCents;
}

class SaleDraftUpsertInput {
  const SaleDraftUpsertInput({
    required this.saleId,
    required this.createdAt,
    required this.lines,
    this.customerId,
    this.notes,
  });

  final String saleId;
  final DateTime createdAt;
  final List<SaleLineDraftInput> lines;
  final String? customerId;
  final String? notes;
}

class SaleListItem {
  const SaleListItem({
    required this.id,
    required this.status,
    required this.customerId,
    required this.customerName,
    required this.productCount,
    required this.unitsCount,
    required this.subtotalCents,
    required this.taxCents,
    required this.discountCents,
    required this.totalCents,
    required this.profitCents,
    required this.createdAt,
    this.updatedAt,
    this.confirmedAt,
  });

  final String id;
  final String status;
  final String? customerId;
  final String? customerName;
  final int productCount;
  final int unitsCount;
  final int subtotalCents;
  final int taxCents;
  final int discountCents;
  final int totalCents;
  final int profitCents;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? confirmedAt;
}

class SaleLineView {
  const SaleLineView({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.unitPriceCents,
    required this.unitCostCents,
    required this.taxRateBps,
    required this.taxCents,
    required this.discountCents,
    required this.lineTotalCents,
    required this.lineProfitCents,
  });

  final String id;
  final String productId;
  final String productName;
  final String productCode;
  final int quantity;
  final int unitPriceCents;
  final int unitCostCents;
  final int taxRateBps;
  final int taxCents;
  final int discountCents;
  final int lineTotalCents;
  final int lineProfitCents;
}

class SaleDetailView {
  const SaleDetailView({
    required this.sale,
    required this.lines,
    this.notes,
    this.reservationId,
  });

  final SaleListItem sale;
  final List<SaleLineView> lines;
  final String? notes;
  final String? reservationId;
}

enum ReservationStatusFilter {
  all,
  draft,
  reserved,
  sold,
  cancelled,
  deleted,
}

class ReservationQuery {
  const ReservationQuery({
    this.search,
    this.status = ReservationStatusFilter.all,
    this.customerId,
    this.period = DashboardPeriod.thisMonth,
    this.from,
    this.to,
    this.limit = 80,
    this.offset = 0,
  });

  final String? search;
  final ReservationStatusFilter status;
  final String? customerId;
  final DashboardPeriod period;
  final DateTime? from;
  final DateTime? to;
  final int limit;
  final int offset;
}

class ReservationListItem {
  const ReservationListItem({
    required this.id,
    required this.status,
    required this.customerId,
    required this.customerName,
    required this.productCount,
    required this.unitsCount,
    required this.subtotalCents,
    required this.taxCents,
    required this.discountCents,
    required this.totalCents,
    required this.createdAt,
    this.updatedAt,
    this.confirmedAt,
    this.canceledAt,
    this.deletedAt,
  });

  final String id;
  final String status;
  final String? customerId;
  final String? customerName;
  final int productCount;
  final int unitsCount;
  final int subtotalCents;
  final int taxCents;
  final int discountCents;
  final int totalCents;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? confirmedAt;
  final DateTime? canceledAt;
  final DateTime? deletedAt;
}

class ReservationLineView {
  const ReservationLineView({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.unitPriceCents,
    required this.unitCostCents,
    required this.taxRateBps,
    required this.discountCents,
    required this.lineTotalCents,
  });

  final String id;
  final String productId;
  final String productName;
  final String productCode;
  final int quantity;
  final int unitPriceCents;
  final int unitCostCents;
  final int taxRateBps;
  final int discountCents;
  final int lineTotalCents;
}

class ReservationDetailView {
  const ReservationDetailView({
    required this.reservation,
    required this.lines,
    this.notes,
  });

  final ReservationListItem reservation;
  final List<ReservationLineView> lines;
  final String? notes;
}

class CustomerHistoryItem {
  const CustomerHistoryItem({
    required this.id,
    required this.referenceType,
    required this.status,
    required this.amountCents,
    required this.createdAt,
  });

  final String id;
  final String referenceType;
  final String status;
  final int amountCents;
  final DateTime createdAt;
}

class CustomerDetailView {
  const CustomerDetailView({
    required this.customer,
    required this.salesCount,
    required this.reservationsCount,
    required this.revenueCents,
    required this.averageTicketCents,
    required this.history,
  });

  final CustomerListItem customer;
  final int salesCount;
  final int reservationsCount;
  final int revenueCents;
  final int averageTicketCents;
  final List<CustomerHistoryItem> history;
}

class DashboardMetricItem {
  const DashboardMetricItem({
    required this.label,
    required this.amountCents,
    required this.count,
  });

  final String label;
  final int amountCents;
  final int count;
}

class DashboardDateRange {
  const DashboardDateRange({
    required this.label,
    required this.start,
    required this.end,
  });

  final String label;
  final DateTime start;
  final DateTime end;
}

class DashboardSeriesPoint {
  const DashboardSeriesPoint({
    required this.label,
    required this.periodStart,
    required this.amountCents,
    this.count = 0,
  });

  final String label;
  final DateTime periodStart;
  final int amountCents;
  final int count;
}

class DashboardBreakdownItem {
  const DashboardBreakdownItem({
    required this.label,
    required this.amountCents,
    required this.count,
    this.quantity = 0,
    this.id,
  });

  final String? id;
  final String label;
  final int amountCents;
  final int count;
  final int quantity;
}

class DashboardProductRankingItem {
  const DashboardProductRankingItem({
    required this.productId,
    required this.label,
    required this.unitsSold,
    required this.revenueCents,
    required this.profitCents,
    required this.stockTotal,
    required this.stockReserved,
    required this.costCents,
    this.lastSaleAt,
  });

  final String productId;
  final String label;
  final int unitsSold;
  final int revenueCents;
  final int profitCents;
  final int stockTotal;
  final int stockReserved;
  final int costCents;
  final DateTime? lastSaleAt;

  int get stockAvailable => stockTotal - stockReserved;
  int get inventoryValueCents => stockAvailable * costCents;
}

class DashboardCustomerRankingItem {
  const DashboardCustomerRankingItem({
    required this.customerId,
    required this.label,
    required this.salesCount,
    required this.revenueCents,
    required this.averageTicketCents,
  });

  final String customerId;
  final String label;
  final int salesCount;
  final int revenueCents;
  final int averageTicketCents;
}

class DashboardSupplierRankingItem {
  const DashboardSupplierRankingItem({
    required this.supplierId,
    required this.label,
    required this.receivedUnits,
    required this.receivedCostCents,
    required this.expenseCount,
    required this.expenseAmountCents,
    required this.isActive,
  });

  final String supplierId;
  final String label;
  final int receivedUnits;
  final int receivedCostCents;
  final int expenseCount;
  final int expenseAmountCents;
  final bool isActive;
}

class DashboardSalesStats {
  const DashboardSalesStats({
    required this.salesCount,
    required this.revenueCents,
    required this.averageTicketCents,
    required this.unitsSold,
    required this.discountCents,
    required this.taxCents,
    this.salesByDay = const <DashboardSeriesPoint>[],
    this.salesByWeek = const <DashboardSeriesPoint>[],
    this.salesByMonth = const <DashboardSeriesPoint>[],
    this.trend = const <DashboardSeriesPoint>[],
  });

  final int salesCount;
  final int revenueCents;
  final int averageTicketCents;
  final int unitsSold;
  final int discountCents;
  final int taxCents;
  final List<DashboardSeriesPoint> salesByDay;
  final List<DashboardSeriesPoint> salesByWeek;
  final List<DashboardSeriesPoint> salesByMonth;
  final List<DashboardSeriesPoint> trend;
}

class DashboardProfitStats {
  const DashboardProfitStats({
    required this.revenueCents,
    required this.costCents,
    required this.grossProfitCents,
    required this.grossMarginBps,
    required this.expensesCents,
    required this.netProfitCents,
    required this.netMarginBps,
    required this.taxCents,
    this.trend = const <DashboardSeriesPoint>[],
  });

  final int revenueCents;
  final int costCents;
  final int grossProfitCents;
  final int grossMarginBps;
  final int expensesCents;
  final int netProfitCents;
  final int netMarginBps;
  final int taxCents;
  final List<DashboardSeriesPoint> trend;
}

class DashboardExpenseStats {
  const DashboardExpenseStats({
    required this.totalAmountCents,
    required this.expenseCount,
    required this.averageAmountCents,
    this.byCategory = const <DashboardBreakdownItem>[],
    this.bySupplier = const <DashboardBreakdownItem>[],
    this.trend = const <DashboardSeriesPoint>[],
  });

  final int totalAmountCents;
  final int expenseCount;
  final int averageAmountCents;
  final List<DashboardBreakdownItem> byCategory;
  final List<DashboardBreakdownItem> bySupplier;
  final List<DashboardSeriesPoint> trend;
}

class DashboardInventoryStats {
  const DashboardInventoryStats({
    required this.totalProducts,
    required this.noStockCount,
    required this.lowStockCount,
    required this.overStockCount,
    required this.nearExpiryCount,
    required this.dueTodayCount,
    required this.expiredCount,
    required this.reservedUnits,
    required this.inventoryValueCents,
    required this.noMovementProductsCount,
    required this.noMovementValueCents,
  });

  final int totalProducts;
  final int noStockCount;
  final int lowStockCount;
  final int overStockCount;
  final int nearExpiryCount;
  final int dueTodayCount;
  final int expiredCount;
  final int reservedUnits;
  final int inventoryValueCents;
  final int noMovementProductsCount;
  final int noMovementValueCents;
}

class DashboardReservationStats {
  const DashboardReservationStats({
    required this.activeReservations,
    required this.pendingReservations,
    required this.cancelledInPeriod,
    required this.convertedToSaleCount,
    required this.reservedUnits,
    required this.reservedValueCents,
  });

  final int activeReservations;
  final int pendingReservations;
  final int cancelledInPeriod;
  final int convertedToSaleCount;
  final int reservedUnits;
  final int reservedValueCents;
}

class DashboardCustomerStats {
  const DashboardCustomerStats({
    required this.totalCustomers,
    required this.customersWithPurchases,
    required this.customersWithoutPurchases,
    this.topCustomers = const <DashboardCustomerRankingItem>[],
  });

  final int totalCustomers;
  final int customersWithPurchases;
  final int customersWithoutPurchases;
  final List<DashboardCustomerRankingItem> topCustomers;
}

class DashboardSupplierStats {
  const DashboardSupplierStats({
    required this.totalSuppliers,
    required this.activeSuppliers,
    required this.suppliersWithExpenses,
    required this.receivedUnits,
    required this.receivedCostCents,
    this.topSuppliers = const <DashboardSupplierRankingItem>[],
  });

  final int totalSuppliers;
  final int activeSuppliers;
  final int suppliersWithExpenses;
  final int receivedUnits;
  final int receivedCostCents;
  final List<DashboardSupplierRankingItem> topSuppliers;
}

class DashboardDiscountStats {
  const DashboardDiscountStats({
    required this.discountedOperationsCount,
    required this.totalDiscountCents,
    required this.averageDiscountCents,
    this.topDiscountedProducts = const <DashboardBreakdownItem>[],
  });

  final int discountedOperationsCount;
  final int totalDiscountCents;
  final int averageDiscountCents;
  final List<DashboardBreakdownItem> topDiscountedProducts;
}

class DashboardAlertItem {
  const DashboardAlertItem({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final String key;
  final String title;
  final String subtitle;
  final String route;
}

class DashboardSummaryView {
  const DashboardSummaryView({
    required this.revenueCents,
    required this.grossProfitCents,
    required this.expensesCents,
    required this.netProfitCents,
    required this.salesCount,
    required this.averageTicketCents,
    required this.activeProductsCount,
    required this.lowStockCount,
    required this.reservationsCount,
    required this.customersCount,
    required this.suppliersCount,
    required this.topProducts,
    required this.topExpenses,
    required this.period,
    this.costCents = 0,
    this.taxCents = 0,
    this.discountCents = 0,
    this.unitsSold = 0,
    this.grossMarginBps = 0,
    this.netMarginBps = 0,
    this.sales = const DashboardSalesStats(
      salesCount: 0,
      revenueCents: 0,
      averageTicketCents: 0,
      unitsSold: 0,
      discountCents: 0,
      taxCents: 0,
    ),
    this.profit = const DashboardProfitStats(
      revenueCents: 0,
      costCents: 0,
      grossProfitCents: 0,
      grossMarginBps: 0,
      expensesCents: 0,
      netProfitCents: 0,
      netMarginBps: 0,
      taxCents: 0,
    ),
    this.expenseStats = const DashboardExpenseStats(
      totalAmountCents: 0,
      expenseCount: 0,
      averageAmountCents: 0,
    ),
    this.inventory = const DashboardInventoryStats(
      totalProducts: 0,
      noStockCount: 0,
      lowStockCount: 0,
      overStockCount: 0,
      nearExpiryCount: 0,
      dueTodayCount: 0,
      expiredCount: 0,
      reservedUnits: 0,
      inventoryValueCents: 0,
      noMovementProductsCount: 0,
      noMovementValueCents: 0,
    ),
    this.reservations = const DashboardReservationStats(
      activeReservations: 0,
      pendingReservations: 0,
      cancelledInPeriod: 0,
      convertedToSaleCount: 0,
      reservedUnits: 0,
      reservedValueCents: 0,
    ),
    this.customers = const DashboardCustomerStats(
      totalCustomers: 0,
      customersWithPurchases: 0,
      customersWithoutPurchases: 0,
    ),
    this.suppliers = const DashboardSupplierStats(
      totalSuppliers: 0,
      activeSuppliers: 0,
      suppliersWithExpenses: 0,
      receivedUnits: 0,
      receivedCostCents: 0,
    ),
    this.discounts = const DashboardDiscountStats(
      discountedOperationsCount: 0,
      totalDiscountCents: 0,
      averageDiscountCents: 0,
    ),
    this.topProductsByRevenue = const <DashboardProductRankingItem>[],
    this.topProductsByUnits = const <DashboardProductRankingItem>[],
    this.topProductsByProfit = const <DashboardProductRankingItem>[],
    this.leastSoldProducts = const <DashboardProductRankingItem>[],
    this.stagnantProducts = const <DashboardProductRankingItem>[],
    this.salesByCategory = const <DashboardBreakdownItem>[],
    this.alerts = const <DashboardAlertItem>[],
    this.unavailableMetrics = const <String>[],
  });

  final int revenueCents;
  final int costCents;
  final int grossProfitCents;
  final int expensesCents;
  final int netProfitCents;
  final int taxCents;
  final int discountCents;
  final int salesCount;
  final int averageTicketCents;
  final int unitsSold;
  final int grossMarginBps;
  final int netMarginBps;
  final int activeProductsCount;
  final int lowStockCount;
  final int reservationsCount;
  final int customersCount;
  final int suppliersCount;
  final List<DashboardMetricItem> topProducts;
  final List<DashboardMetricItem> topExpenses;
  final DashboardDateRange period;
  final DashboardSalesStats sales;
  final DashboardProfitStats profit;
  final DashboardExpenseStats expenseStats;
  final DashboardInventoryStats inventory;
  final DashboardReservationStats reservations;
  final DashboardCustomerStats customers;
  final DashboardSupplierStats suppliers;
  final DashboardDiscountStats discounts;
  final List<DashboardProductRankingItem> topProductsByRevenue;
  final List<DashboardProductRankingItem> topProductsByUnits;
  final List<DashboardProductRankingItem> topProductsByProfit;
  final List<DashboardProductRankingItem> leastSoldProducts;
  final List<DashboardProductRankingItem> stagnantProducts;
  final List<DashboardBreakdownItem> salesByCategory;
  final List<DashboardAlertItem> alerts;
  final List<String> unavailableMetrics;
}

enum DashboardPeriod {
  today,
  last7Days,
  thisWeek,
  thisMonth,
  previousMonth,
  thisYear,
  custom,
}

class DashboardQuery {
  const DashboardQuery({
    this.period = DashboardPeriod.thisMonth,
    this.from,
    this.to,
  });

  final DashboardPeriod period;
  final DateTime? from;
  final DateTime? to;
}

class ExpenseCategoryUpsertInput {
  const ExpenseCategoryUpsertInput({
    required this.id,
    required this.name,
    this.isActive = true,
  });

  final String id;
  final String name;
  final bool isActive;
}

class ExpenseCategoryListItem {
  const ExpenseCategoryListItem({
    required this.id,
    required this.name,
    required this.isActive,
    required this.expenseCount,
  });

  final String id;
  final String name;
  final bool isActive;
  final int expenseCount;
}

class ExpenseUpsertInput {
  const ExpenseUpsertInput({
    required this.id,
    required this.description,
    required this.categoryId,
    required this.amountCents,
    required this.occurredAt,
    this.supplierId,
    this.notes,
    this.isActive = true,
  });

  final String id;
  final String description;
  final String categoryId;
  final int amountCents;
  final String occurredAt;
  final String? supplierId;
  final String? notes;
  final bool isActive;
}

class ExpenseListItem {
  const ExpenseListItem({
    required this.id,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.amountCents,
    required this.occurredAt,
    this.supplierId,
    this.supplierName,
    this.notes,
    required this.isActive,
  });

  final String id;
  final String description;
  final String? categoryId;
  final String categoryName;
  final int amountCents;
  final DateTime occurredAt;
  final String? supplierId;
  final String? supplierName;
  final String? notes;
  final bool isActive;
}

class ExpenseDetailView {
  const ExpenseDetailView({
    required this.id,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.amountCents,
    required this.occurredAt,
    required this.supplierId,
    required this.supplierName,
    required this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String description;
  final String categoryId;
  final String categoryName;
  final int amountCents;
  final DateTime occurredAt;
  final String? supplierId;
  final String? supplierName;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class ExpenseSummaryView {
  const ExpenseSummaryView({
    required this.totalAmountCents,
    required this.count,
    required this.byCategory,
    required this.bySupplier,
  });

  final int totalAmountCents;
  final int count;
  final List<ExpenseAggregateItem> byCategory;
  final List<ExpenseAggregateItem> bySupplier;
}

class ExpenseAggregateItem {
  const ExpenseAggregateItem({
    required this.label,
    required this.amountCents,
    required this.count,
  });

  final String label;
  final int amountCents;
  final int count;
}

enum ExpensePeriod { today, thisWeek, thisMonth, previousMonth, custom }

class ExpenseQuery {
  const ExpenseQuery({
    this.search,
    this.period = ExpensePeriod.thisMonth,
    this.categoryId,
    this.supplierId,
    this.from,
    this.to,
    this.limit = 80,
    this.offset = 0,
  });

  final String? search;
  final ExpensePeriod period;
  final String? categoryId;
  final String? supplierId;
  final DateTime? from;
  final DateTime? to;
  final int limit;
  final int offset;
}
