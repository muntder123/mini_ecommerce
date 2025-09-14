import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import 'hive_status_provider.dart';

class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final String? searchQuery;
  final String? selectedCategory;
  final bool hiveReady;

  ProductsState({
    required this.products,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.searchQuery,
    this.selectedCategory,
    this.hiveReady = false,
  });

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? hasMore,
    String? error,
    String? searchQuery,
    String? selectedCategory,
    bool? hiveReady,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      hiveReady: hiveReady ?? this.hiveReady,
    );
  }
}

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final hiveStatus = ref.watch(hiveStatusProvider);
  return ProductsNotifier(hiveStatus);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ApiService _apiService = ApiService();
  final HiveStatus hiveStatus;
  int _skip = 0;
  static const int _limit = 20;
  bool _isDisposed = false;

  ProductsNotifier(this.hiveStatus) : super(ProductsState(products: [], hiveReady: false)) {
    if (hiveStatus == HiveStatus.ready) {
      _onHiveReady();
    }
    fetchProducts();
  }

  void onHiveStatusChanged(HiveStatus newStatus) {
    if (newStatus == HiveStatus.ready && !state.hiveReady) {
      _onHiveReady();
    }
  }

  void _onHiveReady() {
    state = state.copyWith(hiveReady: true);
    loadCachedProducts();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> loadCachedProducts() async {
    if (_isDisposed) return;

    try {
      if (Hive.isBoxOpen(HiveService.productsBoxName)) {
        final box = HiveService.getProductsBox();
        final cachedProducts = box.values.toList();
        if (cachedProducts.isNotEmpty && !_isDisposed) {
          state = state.copyWith(products: cachedProducts);
        }
      }
    } catch (e) {
      // Silent failure - cached products loading should not break the app
    }
  }

  Future<void> fetchProducts({bool loadMore = false}) async {
    if (_isDisposed || state.isLoading || (!loadMore && !state.hasMore)) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      List<Product> newProducts;
      if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
        newProducts = await _apiService.searchProducts(state.searchQuery!);
        if (!_isDisposed) {
          state = state.copyWith(products: newProducts, isLoading: false, hasMore: false);
        }
      } else {
        newProducts = await _apiService.fetchProducts(
          limit: _limit,
          skip: loadMore ? _skip : 0,
          category: state.selectedCategory,
        );

        if (!_isDisposed) {
          if (loadMore) {
            state = state.copyWith(
              products: [...state.products, ...newProducts],
              isLoading: false,
              hasMore: newProducts.length == _limit,
            );
            _skip += _limit;
          } else {
            state = state.copyWith(
              products: newProducts,
              isLoading: false,
              hasMore: newProducts.length == _limit,
            );
            _skip = _limit;
          }
        }
      }

      // Cache products only if not disposed
      if (!_isDisposed) {
        await _cacheProducts(state.products);
      }
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }

  Future<void> _cacheProducts(List<Product> products) async {
    try {
      if (!Hive.isBoxOpen(HiveService.productsBoxName)) {
        return; // Silent failure
      }

      final box = HiveService.getProductsBox();
      await box.clear();

      for (final product in products) {
        try {
          await box.add(product);
        } catch (e) {
          // Skip individual product failures
          break;
        }
      }
    } catch (e) {
      // Silent failure - caching should not break the app
    }
  }

  void searchProducts(String query) {
    state = state.copyWith(searchQuery: query, products: [], hasMore: true);
    _skip = 0;
    fetchProducts();
  }

  void filterByCategory(String? category) {
    state = state.copyWith(selectedCategory: category, products: [], hasMore: true);
    _skip = 0;
    fetchProducts();
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: null, products: [], hasMore: true);
    _skip = 0;
    fetchProducts();
  }

  void clearFilters() {
    state = state.copyWith(selectedCategory: null, searchQuery: null, products: [], hasMore: true);
    _skip = 0;
    fetchProducts();
  }
}