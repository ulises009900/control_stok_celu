import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SupplierStatusFilter { active, inactive, all }

class SuppliersState {
  const SuppliersState({
    this.items = const <SupplierListItem>[],
    this.statusFilter = SupplierStatusFilter.active,
    this.searchQuery = '',
    this.isLoading = false,
    this.isSearching = false,
    this.errorMessage,
    this.successMessage,
    this.hasLoadedOnce = false,
  });

  final List<SupplierListItem> items;
  final SupplierStatusFilter statusFilter;
  final String searchQuery;
  final bool isLoading;
  final bool isSearching;
  final String? errorMessage;
  final String? successMessage;
  final bool hasLoadedOnce;

  bool get hasSearch => searchQuery.trim().isNotEmpty;

  SuppliersState copyWith({
    List<SupplierListItem>? items,
    SupplierStatusFilter? statusFilter,
    String? searchQuery,
    bool? isLoading,
    bool? isSearching,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
    bool? hasLoadedOnce,
  }) {
    return SuppliersState(
      items: items ?? this.items,
      statusFilter: statusFilter ?? this.statusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
    );
  }
}

class SuppliersNotifier extends StateNotifier<SuppliersState> {
  SuppliersNotifier(this._ref) : super(const SuppliersState());

  final Ref _ref;

  Future<void> loadSuppliers() async {
    state = state.copyWith(
      isLoading: !state.hasLoadedOnce,
      isSearching: state.isSearching,
      clearError: true,
      clearSuccess: true,
    );

    try {
      final useCase = _ref.read(listSuppliersUseCaseProvider);
      final includeInactive = state.statusFilter != SupplierStatusFilter.active;
      final search = state.searchQuery.trim();
      var items = await useCase(
        search: search.isEmpty ? null : search,
        includeInactive: includeInactive,
      );

      if (state.statusFilter == SupplierStatusFilter.inactive) {
        items = items.where((supplier) => !supplier.isActive).toList();
      }

      state = state.copyWith(
        items: items,
        isLoading: false,
        isSearching: false,
        hasLoadedOnce: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSearching: false,
        errorMessage: 'No pudimos cargar proveedores. $e',
        hasLoadedOnce: true,
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSearching() {
    state = state.copyWith(isSearching: true, clearError: true);
  }

  Future<void> setFilter(SupplierStatusFilter filter) async {
    if (state.statusFilter == filter) {
      return;
    }
    state = state.copyWith(statusFilter: filter);
    await loadSuppliers();
  }

  Future<void> toggleActive({
    required SupplierListItem supplier,
    required bool isActive,
  }) async {
    try {
      await _ref.read(setSupplierActiveUseCaseProvider)(supplier.id, isActive);
      state = state.copyWith(
        successMessage:
            isActive ? 'Proveedor reactivado.' : 'Proveedor desactivado.',
      );
      await loadSuppliers();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'No pudimos actualizar el estado del proveedor. $e',
      );
    }
  }

  Future<void> createSupplier(SupplierUpsertInput input) async {
    try {
      await _ref.read(createSupplierUseCaseProvider)(input);
      state = state.copyWith(successMessage: 'Proveedor creado.');
      await loadSuppliers();
    } on AppException {
      rethrow;
    }
  }

  Future<void> updateSupplier(SupplierUpsertInput input) async {
    try {
      await _ref.read(updateSupplierUseCaseProvider)(input);
      state = state.copyWith(successMessage: 'Proveedor actualizado.');
      await loadSuppliers();
    } on AppException {
      rethrow;
    }
  }

  void clearFeedback() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

final suppliersStateProvider =
    StateNotifierProvider<SuppliersNotifier, SuppliersState>((ref) {
  return SuppliersNotifier(ref);
});

final activeSuppliersProvider = FutureProvider<List<SupplierListItem>>((ref) {
  return ref.read(listSuppliersUseCaseProvider)(
    includeInactive: false,
  );
});
