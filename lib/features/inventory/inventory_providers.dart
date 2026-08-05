import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryState {
  const InventoryState({
    this.items = const <InventoryListItem>[],
    this.summary,
    this.query = const InventoryQuery(),
    this.isLoading = false,
    this.isSearching = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.hasLoadedOnce = false,
    this.errorMessage,
  });

  final List<InventoryListItem> items;
  final InventorySummaryView? summary;
  final InventoryQuery query;
  final bool isLoading;
  final bool isSearching;
  final bool isLoadingMore;
  final bool hasMore;
  final bool hasLoadedOnce;
  final String? errorMessage;

  bool get hasSearch => (query.search ?? '').trim().isNotEmpty;

  InventoryState copyWith({
    List<InventoryListItem>? items,
    InventorySummaryView? summary,
    InventoryQuery? query,
    bool? isLoading,
    bool? isSearching,
    bool? isLoadingMore,
    bool? hasMore,
    bool? hasLoadedOnce,
    String? errorMessage,
    bool clearError = false,
  }) {
    return InventoryState(
      items: items ?? this.items,
      summary: summary ?? this.summary,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class InventoryNotifier extends StateNotifier<InventoryState> {
  InventoryNotifier(this._ref) : super(const InventoryState());

  static const int _pageSize = 80;

  final Ref _ref;

  Future<void> loadInitial() async {
    state = state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      clearError: true,
      hasMore: true,
    );

    try {
      final summaryQuery = _summaryQuery(state.query);
      final listQuery = state.query.copyWith(limit: _pageSize, offset: 0);
      final results = await Future.wait<Object>(<Future<Object>>[
        _ref.read(getInventorySummaryUseCaseProvider)(summaryQuery),
        _ref.read(listInventoryUseCaseProvider)(listQuery),
      ]);

      final summary = results[0] as InventorySummaryView;
      final items = results[1] as List<InventoryListItem>;

      state = state.copyWith(
        summary: summary,
        items: items,
        isLoading: false,
        isSearching: false,
        isLoadingMore: false,
        hasMore: items.length == _pageSize,
        hasLoadedOnce: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSearching: false,
        isLoadingMore: false,
        errorMessage: 'No pudimos cargar el inventario. $e',
        hasLoadedOnce: true,
      );
    }
  }

  Future<void> applyRouteQuery({
    InventoryFilter? filter,
    String? search,
  }) async {
    state = state.copyWith(
      query: state.query.copyWith(
        filter: filter ?? state.query.filter,
        search: search,
      ),
    );
    await loadInitial();
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final nextQuery = state.query.copyWith(
        limit: _pageSize,
        offset: state.items.length,
      );
      final nextItems =
          await _ref.read(listInventoryUseCaseProvider)(nextQuery);
      state = state.copyWith(
        items: <InventoryListItem>[...state.items, ...nextItems],
        isLoadingMore: false,
        hasMore: nextItems.length == _pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'No pudimos cargar más productos. $e',
      );
    }
  }

  void setSearching() {
    state = state.copyWith(isSearching: true, clearError: true);
  }

  Future<void> setSearch(String search) async {
    final normalized = search.trim().isEmpty ? null : search.trim();
    state = state.copyWith(
      query: InventoryQuery(
        search: normalized,
        filter: state.query.filter,
        sortBy: state.query.sortBy,
        descending: state.query.descending,
        nearExpiryDays: state.query.nearExpiryDays,
        includeInactive: state.query.includeInactive,
        limit: state.query.limit,
        offset: state.query.offset,
      ),
    );
    await loadInitial();
  }

  Future<void> setFilter(InventoryFilter filter) async {
    if (state.query.filter == filter) {
      return;
    }
    state = state.copyWith(
      query: state.query.copyWith(filter: filter),
    );
    await loadInitial();
  }

  Future<void> setSort(InventorySortBy sortBy) async {
    if (state.query.sortBy == sortBy) {
      return;
    }
    state = state.copyWith(
      query: state.query.copyWith(sortBy: sortBy),
    );
    await loadInitial();
  }

  Future<void> toggleDescending() async {
    state = state.copyWith(
      query: state.query.copyWith(descending: !state.query.descending),
    );
    await loadInitial();
  }

  InventoryQuery _summaryQuery(InventoryQuery current) {
    return InventoryQuery(
      search: current.search,
      filter: InventoryFilter.all,
      sortBy: current.sortBy,
      descending: current.descending,
      nearExpiryDays: current.nearExpiryDays,
      includeInactive: current.includeInactive,
      limit: 1,
      offset: 0,
    );
  }
}

final inventoryStateProvider =
    StateNotifierProvider<InventoryNotifier, InventoryState>((ref) {
  return InventoryNotifier(ref);
});
