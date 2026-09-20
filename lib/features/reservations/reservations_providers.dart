import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReservationsState {
  const ReservationsState({
    this.items = const <ReservationListItem>[],
    this.query = const ReservationQuery(),
    this.isLoading = false,
    this.isSearching = false,
    this.errorMessage,
    this.hasLoadedOnce = false,
  });

  final List<ReservationListItem> items;
  final ReservationQuery query;
  final bool isLoading;
  final bool isSearching;
  final String? errorMessage;
  final bool hasLoadedOnce;

  ReservationsState copyWith({
    List<ReservationListItem>? items,
    ReservationQuery? query,
    bool? isLoading,
    bool? isSearching,
    String? errorMessage,
    bool clearError = false,
    bool? hasLoadedOnce,
  }) {
    return ReservationsState(
      items: items ?? this.items,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
    );
  }
}

class ReservationsNotifier extends StateNotifier<ReservationsState> {
  ReservationsNotifier(this._ref) : super(const ReservationsState());

  final Ref _ref;

  Future<void> setFilters({required ReservationStatusFilter status, String? customerId, DateTime? from, DateTime? to}) async {
    state = state.copyWith(query: ReservationQuery(
      search: state.query.search, status: status, customerId: customerId,
      period: DashboardPeriod.custom, from: from, to: to,
    ));
    await load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final items =
          await _ref.read(listReservationsUseCaseProvider)(state.query);
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
        hasLoadedOnce: true,
        errorMessage: 'No pudimos cargar reservas. $e',
      );
    }
  }

  void setSearching() {
    state = state.copyWith(isSearching: true, clearError: true);
  }

  Future<void> setSearch(String search) async {
    state = state.copyWith(
      query: ReservationQuery(
        search: search.trim().isEmpty ? null : search.trim(),
        status: state.query.status,
        customerId: state.query.customerId,
        period: state.query.period,
        from: state.query.from,
        to: state.query.to,
      ),
    );
    await load();
  }

  Future<void> setStatus(ReservationStatusFilter status) async {
    state = state.copyWith(
      query: ReservationQuery(
        search: state.query.search,
        status: status,
        customerId: state.query.customerId,
        period: state.query.period,
        from: state.query.from,
        to: state.query.to,
      ),
    );
    await load();
  }

  Future<void> setCustomer(String? customerId) async {
    state = state.copyWith(
      query: ReservationQuery(
        search: state.query.search,
        status: state.query.status,
        customerId: customerId,
        period: state.query.period,
        from: state.query.from,
        to: state.query.to,
      ),
    );
    await load();
  }
}

final reservationsStateProvider =
    StateNotifierProvider<ReservationsNotifier, ReservationsState>((ref) {
  return ReservationsNotifier(ref);
});
