import 'package:control_stok_celu/domain/stock/stock_models.dart';

abstract interface class StockRepository {
  Future<void> createProduct(CreateProductInput input);
  Future<void> createProductProfile(ProductUpsertInput input);
  Future<void> updateProductProfile(ProductUpsertInput input);
  Future<void> setProductActive(String productId, bool isActive);
  Future<void> logicalDeleteProduct(String productId);
  Future<List<ProductSummaryItem>> listProducts(ProductQuery query);
  Future<InventorySummaryView> getInventorySummary(InventoryQuery query);
  Future<List<InventoryListItem>> listInventory(InventoryQuery query);
  Future<ProductDetailView> getProductDetail(String productId);
  Future<void> createCategory(CategoryUpsertInput input);
  Future<void> updateCategory(CategoryUpsertInput input);
  Future<void> setCategoryActive(String categoryId, bool isActive);
  Future<List<CategoryListItem>> listCategories({
    String? search,
    bool includeInactive = true,
    String? parentId,
  });
  Future<void> createSupplier(SupplierUpsertInput input);
  Future<void> updateSupplier(SupplierUpsertInput input);
  Future<void> setSupplierActive(String supplierId, bool isActive);
  Future<List<SupplierListItem>> listSuppliers({
    String? search,
    bool includeInactive = true,
  });
  Future<SupplierDetailView> getSupplierDetail(String supplierId);
  Future<void> createCustomer(CustomerUpsertInput input);
  Future<void> updateCustomer(CustomerUpsertInput input);
  Future<void> setCustomerActive(String customerId, bool isActive);
  Future<List<CustomerListItem>> listCustomers({
    String? search,
    bool includeInactive = true,
  });
  Future<void> createReservationDraft(CreateReservationDraftInput input);
  Future<int> expireReservations(DateTime now);
  Future<void> saveReservationDraft(CreateReservationDraftInput input);
  Future<void> saveSaleDraft(SaleDraftUpsertInput input);
  Future<void> deleteSaleDraft(String saleId);
  Future<void> reserveSaleDraft(String saleId, DateTime reservedAt);
  Future<void> confirmSaleDraft(String saleId, DateTime confirmedAt);
  Future<List<SaleListItem>> listSales(SaleQuery query);
  Future<SaleDetailView> getSaleDetail(String saleId);
  Future<List<ReservationListItem>> listReservations(ReservationQuery query);
  Future<ReservationDetailView> getReservationDetail(String reservationId);
  Future<CustomerDetailView> getCustomerDetail(String customerId);
  Future<void> reserveDraftReservation(
      String reservationId, DateTime reservedAt);
  Future<void> deleteReservation(String reservationId, DateTime deletedAt);
  Future<void> confirmDraftReservationSale(ConfirmSaleInput input);
  Future<void> receiveStock(ReceiveStockInput input);
  Future<void> adjustStock(StockAdjustmentInput input);
  Future<void> createReservation(CreateReservationInput input);
  Future<void> cancelReservation(String reservationId, DateTime canceledAt);
  Future<void> confirmReservationSale(ConfirmSaleInput input);
  Future<void> createDirectSale(CreateDirectSaleInput input);
  Future<void> createReturn(CreateReturnInput input);
  Future<ProductStockSnapshot> getProductStock(String productId);
  Future<void> createExpenseCategory(ExpenseCategoryUpsertInput input);
  Future<void> updateExpenseCategory(ExpenseCategoryUpsertInput input);
  Future<void> setExpenseCategoryActive(String categoryId, bool isActive);
  Future<List<ExpenseCategoryListItem>> listExpenseCategories({
    String? search,
    bool includeInactive = true,
  });
  Future<void> createExpense(ExpenseUpsertInput input);
  Future<void> updateExpense(ExpenseUpsertInput input);
  Future<void> logicalDeleteExpense(String expenseId);
  Future<List<ExpenseListItem>> listExpenses(ExpenseQuery query);
  Future<ExpenseDetailView> getExpenseDetail(String expenseId);
  Future<ExpenseSummaryView> getExpenseSummary(ExpenseQuery query);
  Future<DashboardSummaryView> getDashboardSummary(DashboardQuery query);
}
