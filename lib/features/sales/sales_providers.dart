import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesState {
  const SalesState({
    this.items = const <SaleListItem>[],
    this.query = const SaleQuery(status: SaleStatusFilter.sold),
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isLoading = false,
    this.isSearching = false,
    this.errorMessage,
    this.hasLoadedOnce = false,
  });

  final List<SaleListItem> items;
  final SaleQuery query;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isLoading;
  final bool isSearching;
  final String? errorMessage;
  final bool hasLoadedOnce;

  SalesState copyWith({
    List<SaleListItem>? items,
    SaleQuery? query,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isLoading,
    bool? isSearching,
    String? errorMessage,
    bool clearError = false,
    bool? hasLoadedOnce,
  }) {
    return SalesState(
      items: items ?? this.items,
      query: query ?? this.query,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
    );
  }
}

class SalesNotifier extends StateNotifier<SalesState> {
  SalesNotifier(this._ref) : super(const SalesState());

  final Ref _ref;

  int _request = 0;

  Future<void> load() async {
    final request = ++_request;
    state =
        state.copyWith(isLoading: true, isLoadingMore: false, clearError: true);
    try {
      final items = await _ref.read(listSalesUseCaseProvider)(state.query);
      if (!mounted || request != _request) return;
      state = state.copyWith(
        hasMore: items.length == state.query.limit,
        items: items,
        isLoading: false,
        isSearching: false,
        hasLoadedOnce: true,
        clearError: true,
      );
    } catch (e) {
      if (!mounted || request != _request) return;
      state = state.copyWith(
        isLoading: false,
        isSearching: false,
        hasLoadedOnce: true,
        errorMessage: 'No pudimos cargar ventas. $e',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    final request = _request;
    final q = state.query;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final items = await _ref.read(listSalesUseCaseProvider)(SaleQuery(
        search: q.search,
        status: q.status,
        customerId: q.customerId,
        sellerSearch: q.sellerSearch,
        period: q.period,
        from: q.from,
        to: q.to,
        limit: q.limit,
        offset: state.items.length,
      ));
      if (!mounted || request != _request) return;
      state = state.copyWith(
          items: [...state.items, ...items],
          hasMore: items.length == q.limit,
          isLoadingMore: false);
    } catch (e) {
      if (!mounted || request != _request) return;
      state = state.copyWith(
          isLoadingMore: false,
          errorMessage: 'No pudimos cargar más ventas. $e');
    }
  }

  void setSearching() {
    state = state.copyWith(isSearching: true, clearError: true);
  }

  Future<void> setSearch(String search) async {
    state = state.copyWith(
      query: SaleQuery(
        search: search.trim().isEmpty ? null : search.trim(),
        status: state.query.status,
        customerId: state.query.customerId,
        sellerSearch: state.query.sellerSearch,
        period: state.query.period,
        from: state.query.from,
        to: state.query.to,
      ),
    );
    await load();
  }

  Future<void> setStatus(SaleStatusFilter status) async {
    state = state.copyWith(
      query: SaleQuery(
        search: state.query.search,
        status: status,
        customerId: state.query.customerId,
        sellerSearch: state.query.sellerSearch,
        period: state.query.period,
        from: state.query.from,
        to: state.query.to,
      ),
    );
    await load();
  }

  Future<void> setCustomer(String? customerId) async {
    state = state.copyWith(
      query: SaleQuery(
        search: state.query.search,
        status: state.query.status,
        customerId: customerId,
        sellerSearch: state.query.sellerSearch,
        period: state.query.period,
        from: state.query.from,
        to: state.query.to,
      ),
    );
    await load();
  }

  Future<void> setPeriod(DashboardPeriod period) async {
    state = state.copyWith(
      query: SaleQuery(
        search: state.query.search,
        status: state.query.status,
        customerId: state.query.customerId,
        sellerSearch: state.query.sellerSearch,
        period: period,
        from: state.query.from,
        to: state.query.to,
      ),
    );
    await load();
  }

  Future<void> setSellerSearch(String? value) async {
    final clean = value?.trim();
    state = state.copyWith(
      query: SaleQuery(
        search: state.query.search,
        status: state.query.status,
        customerId: state.query.customerId,
        sellerSearch: clean == null || clean.isEmpty ? null : clean,
        period: state.query.period,
        from: state.query.from,
        to: state.query.to,
      ),
    );
    await load();
  }
}

final salesStateProvider =
    StateNotifierProvider<SalesNotifier, SalesState>((ref) {
  return SalesNotifier(ref);
});
