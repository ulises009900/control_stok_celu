import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DashboardProductRankingMode {
  units,
  revenue,
  profit,
}

class DashboardViewState {
  const DashboardViewState({
    this.query = const DashboardQuery(),
    this.summary,
    this.isLoading = false,
    this.errorMessage,
    this.hasLoadedOnce = false,
    this.productRankingMode = DashboardProductRankingMode.units,
  });

  final DashboardQuery query;
  final DashboardSummaryView? summary;
  final bool isLoading;
  final String? errorMessage;
  final bool hasLoadedOnce;
  final DashboardProductRankingMode productRankingMode;

  DashboardViewState copyWith({
    DashboardQuery? query,
    DashboardSummaryView? summary,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? hasLoadedOnce,
    DashboardProductRankingMode? productRankingMode,
  }) {
    return DashboardViewState(
      query: query ?? this.query,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      productRankingMode: productRankingMode ?? this.productRankingMode,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardViewState> {
  DashboardNotifier(this._ref) : super(const DashboardViewState());

  final Ref _ref;

  Future<void> load() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final summary =
          await _ref.read(getDashboardSummaryUseCaseProvider)(state.query);
      state = state.copyWith(
        summary: summary,
        isLoading: false,
        hasLoadedOnce: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasLoadedOnce: true,
        errorMessage: 'No pudimos cargar el dashboard. $e',
      );
    }
  }

  Future<void> setPeriod(DashboardPeriod period) async {
    state = state.copyWith(
      query: DashboardQuery(
        period: period,
        from: state.query.from,
        to: state.query.to,
      ),
    );
    await load();
  }

  Future<void> setCustomRange({
    required DateTime from,
    required DateTime to,
  }) async {
    state = state.copyWith(
      query: DashboardQuery(
        period: DashboardPeriod.custom,
        from: from,
        to: to,
      ),
    );
    await load();
  }

  void setProductRankingMode(DashboardProductRankingMode mode) {
    state = state.copyWith(productRankingMode: mode);
  }
}

final dashboardStateProvider =
    StateNotifierProvider<DashboardNotifier, DashboardViewState>((ref) {
  return DashboardNotifier(ref);
});
