import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/domain/stock/stock_repository.dart';

class CreateProductUseCase {
  const CreateProductUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(CreateProductInput input) =>
      _repository.createProduct(input);
}

class CreateProductProfileUseCase {
  const CreateProductProfileUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(ProductUpsertInput input) =>
      _repository.createProductProfile(input);
}

class UpdateProductProfileUseCase {
  const UpdateProductProfileUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(ProductUpsertInput input) =>
      _repository.updateProductProfile(input);
}

class SetProductActiveUseCase {
  const SetProductActiveUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String productId, bool isActive) =>
      _repository.setProductActive(productId, isActive);
}

class LogicalDeleteProductUseCase {
  const LogicalDeleteProductUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String productId) =>
      _repository.logicalDeleteProduct(productId);
}

class ListProductsUseCase {
  const ListProductsUseCase(this._repository);

  final StockRepository _repository;

  Future<List<ProductSummaryItem>> call(ProductQuery query) =>
      _repository.listProducts(query);
}

class GetInventorySummaryUseCase {
  const GetInventorySummaryUseCase(this._repository);

  final StockRepository _repository;

  Future<InventorySummaryView> call(InventoryQuery query) =>
      _repository.getInventorySummary(query);
}

class ListInventoryUseCase {
  const ListInventoryUseCase(this._repository);

  final StockRepository _repository;

  Future<List<InventoryListItem>> call(InventoryQuery query) =>
      _repository.listInventory(query);
}

class GetProductDetailUseCase {
  const GetProductDetailUseCase(this._repository);

  final StockRepository _repository;

  Future<ProductDetailView> call(String productId) =>
      _repository.getProductDetail(productId);
}

class CreateCategoryUseCase {
  const CreateCategoryUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(CategoryUpsertInput input) =>
      _repository.createCategory(input);
}

class UpdateCategoryUseCase {
  const UpdateCategoryUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(CategoryUpsertInput input) =>
      _repository.updateCategory(input);
}

class SetCategoryActiveUseCase {
  const SetCategoryActiveUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String categoryId, bool isActive) =>
      _repository.setCategoryActive(categoryId, isActive);
}

class ListCategoriesUseCase {
  const ListCategoriesUseCase(this._repository);

  final StockRepository _repository;

  Future<List<CategoryListItem>> call({
    String? search,
    bool includeInactive = true,
    String? parentId,
  }) {
    return _repository.listCategories(
      search: search,
      includeInactive: includeInactive,
      parentId: parentId,
    );
  }
}

class CreateSupplierUseCase {
  const CreateSupplierUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(SupplierUpsertInput input) =>
      _repository.createSupplier(input);
}

class UpdateSupplierUseCase {
  const UpdateSupplierUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(SupplierUpsertInput input) =>
      _repository.updateSupplier(input);
}

class SetSupplierActiveUseCase {
  const SetSupplierActiveUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String supplierId, bool isActive) =>
      _repository.setSupplierActive(supplierId, isActive);
}

class ListSuppliersUseCase {
  const ListSuppliersUseCase(this._repository);

  final StockRepository _repository;

  Future<List<SupplierListItem>> call({
    String? search,
    bool includeInactive = true,
  }) {
    return _repository.listSuppliers(
      search: search,
      includeInactive: includeInactive,
    );
  }
}

class GetSupplierDetailUseCase {
  const GetSupplierDetailUseCase(this._repository);

  final StockRepository _repository;

  Future<SupplierDetailView> call(String supplierId) =>
      _repository.getSupplierDetail(supplierId);
}

class CreateCustomerUseCase {
  const CreateCustomerUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(CustomerUpsertInput input) =>
      _repository.createCustomer(input);
}

class UpdateCustomerUseCase {
  const UpdateCustomerUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(CustomerUpsertInput input) =>
      _repository.updateCustomer(input);
}

class SetCustomerActiveUseCase {
  const SetCustomerActiveUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String customerId, bool isActive) =>
      _repository.setCustomerActive(customerId, isActive);
}

class ListCustomersUseCase {
  const ListCustomersUseCase(this._repository);

  final StockRepository _repository;

  Future<List<CustomerListItem>> call({
    String? search,
    bool includeInactive = true,
  }) {
    return _repository.listCustomers(
      search: search,
      includeInactive: includeInactive,
    );
  }
}

class CreateReservationDraftUseCase {
  const CreateReservationDraftUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(CreateReservationDraftInput input) =>
      _repository.createReservationDraft(input);
}

class SaveReservationDraftUseCase {
  const SaveReservationDraftUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(CreateReservationDraftInput input) =>
      _repository.saveReservationDraft(input);
}

class SaveSaleDraftUseCase {
  const SaveSaleDraftUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(SaleDraftUpsertInput input) =>
      _repository.saveSaleDraft(input);
}

class DeleteSaleDraftUseCase {
  const DeleteSaleDraftUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String saleId) => _repository.deleteSaleDraft(saleId);
}

class ReserveSaleDraftUseCase {
  const ReserveSaleDraftUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String saleId, DateTime reservedAt) =>
      _repository.reserveSaleDraft(saleId, reservedAt);
}

class ConfirmSaleDraftUseCase {
  const ConfirmSaleDraftUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String saleId, DateTime confirmedAt) =>
      _repository.confirmSaleDraft(saleId, confirmedAt);
}

class ListSalesUseCase {
  const ListSalesUseCase(this._repository);

  final StockRepository _repository;

  Future<List<SaleListItem>> call(SaleQuery query) =>
      _repository.listSales(query);
}

class GetSaleDetailUseCase {
  const GetSaleDetailUseCase(this._repository);

  final StockRepository _repository;

  Future<SaleDetailView> call(String saleId) =>
      _repository.getSaleDetail(saleId);
}

class ListReservationsUseCase {
  const ListReservationsUseCase(this._repository);

  final StockRepository _repository;

  Future<List<ReservationListItem>> call(ReservationQuery query) =>
      _repository.listReservations(query);
}

class GetReservationDetailUseCase {
  const GetReservationDetailUseCase(this._repository);

  final StockRepository _repository;

  Future<ReservationDetailView> call(String reservationId) =>
      _repository.getReservationDetail(reservationId);
}

class GetCustomerDetailUseCase {
  const GetCustomerDetailUseCase(this._repository);

  final StockRepository _repository;

  Future<CustomerDetailView> call(String customerId) =>
      _repository.getCustomerDetail(customerId);
}

class ReserveDraftReservationUseCase {
  const ReserveDraftReservationUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String reservationId, DateTime reservedAt) =>
      _repository.reserveDraftReservation(reservationId, reservedAt);
}

class DeleteReservationUseCase {
  const DeleteReservationUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String reservationId, DateTime deletedAt) =>
      _repository.deleteReservation(reservationId, deletedAt);
}

class ConfirmDraftReservationSaleUseCase {
  const ConfirmDraftReservationSaleUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(ConfirmSaleInput input) =>
      _repository.confirmDraftReservationSale(input);
}

class ReceiveStockUseCase {
  const ReceiveStockUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(ReceiveStockInput input) => _repository.receiveStock(input);
}

class AdjustStockUseCase {
  const AdjustStockUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(StockAdjustmentInput input) =>
      _repository.adjustStock(input);
}

class CreateReservationUseCase {
  const CreateReservationUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(CreateReservationInput input) =>
      _repository.createReservation(input);
}

class CancelReservationUseCase {
  const CancelReservationUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String reservationId, DateTime canceledAt) =>
      _repository.cancelReservation(reservationId, canceledAt);
}

class ConfirmReservationSaleUseCase {
  const ConfirmReservationSaleUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(ConfirmSaleInput input) =>
      _repository.confirmReservationSale(input);
}

class CreateDirectSaleUseCase {
  const CreateDirectSaleUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(CreateDirectSaleInput input) =>
      _repository.createDirectSale(input);
}

class CreateReturnUseCase {
  const CreateReturnUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(CreateReturnInput input) => _repository.createReturn(input);
}

class CreateExpenseCategoryUseCase {
  const CreateExpenseCategoryUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(ExpenseCategoryUpsertInput input) =>
      _repository.createExpenseCategory(input);
}

class UpdateExpenseCategoryUseCase {
  const UpdateExpenseCategoryUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(ExpenseCategoryUpsertInput input) =>
      _repository.updateExpenseCategory(input);
}

class SetExpenseCategoryActiveUseCase {
  const SetExpenseCategoryActiveUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String categoryId, bool isActive) =>
      _repository.setExpenseCategoryActive(categoryId, isActive);
}

class ListExpenseCategoriesUseCase {
  const ListExpenseCategoriesUseCase(this._repository);

  final StockRepository _repository;

  Future<List<ExpenseCategoryListItem>> call({
    String? search,
    bool includeInactive = true,
  }) =>
      _repository.listExpenseCategories(
        search: search,
        includeInactive: includeInactive,
      );
}

class CreateExpenseUseCase {
  const CreateExpenseUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(ExpenseUpsertInput input) =>
      _repository.createExpense(input);
}

class UpdateExpenseUseCase {
  const UpdateExpenseUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(ExpenseUpsertInput input) =>
      _repository.updateExpense(input);
}

class LogicalDeleteExpenseUseCase {
  const LogicalDeleteExpenseUseCase(this._repository);

  final StockRepository _repository;

  Future<void> call(String expenseId) =>
      _repository.logicalDeleteExpense(expenseId);
}

class ListExpensesUseCase {
  const ListExpensesUseCase(this._repository);

  final StockRepository _repository;

  Future<List<ExpenseListItem>> call(ExpenseQuery query) =>
      _repository.listExpenses(query);
}

class GetExpenseDetailUseCase {
  const GetExpenseDetailUseCase(this._repository);

  final StockRepository _repository;

  Future<ExpenseDetailView> call(String expenseId) =>
      _repository.getExpenseDetail(expenseId);
}

class GetExpenseSummaryUseCase {
  const GetExpenseSummaryUseCase(this._repository);

  final StockRepository _repository;

  Future<ExpenseSummaryView> call(ExpenseQuery query) =>
      _repository.getExpenseSummary(query);
}

class GetDashboardSummaryUseCase {
  const GetDashboardSummaryUseCase(this._repository);

  final StockRepository _repository;

  Future<DashboardSummaryView> call(DashboardQuery query) =>
      _repository.getDashboardSummary(query);
}
