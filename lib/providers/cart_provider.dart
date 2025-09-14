import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/hive_service.dart';
import 'hive_status_provider.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final hiveStatus = ref.watch(hiveStatusProvider);
  return CartNotifier(hiveStatus);
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  final HiveStatus hiveStatus;

  CartNotifier(this.hiveStatus) : super([]) {
    if (hiveStatus == HiveStatus.ready) {
      _loadCart();
    }
  }

  void _loadCart() {
    try {
      if (Hive.isBoxOpen(HiveService.cartBoxName)) {
        final box = HiveService.getCartBox();
        state = box.values.toList();
      } else {
        // Box not open yet, try again later
        Future.delayed(const Duration(milliseconds: 100), _loadCart);
      }
    } catch (e) {
      // Continue with empty cart on failure
    }
  }

  void addToCart(Product product) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);
    if (existingIndex != -1) {
      final updatedItem = state[existingIndex].copyWith(
        quantity: state[existingIndex].quantity + 1,
      );
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
    _saveCart();
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
    _saveCart();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final updatedItem = state[index].copyWith(quantity: quantity);
      state = [
        ...state.sublist(0, index),
        updatedItem,
        ...state.sublist(index + 1),
      ];
      _saveCart();
    }
  }

  void clearCart() {
    state = [];
    _saveCart();
  }

  double get totalPrice => state.fold(0, (sum, item) => sum + item.totalPrice);

  void _saveCart() {
    try {
      if (Hive.isBoxOpen(HiveService.cartBoxName)) {
        final box = HiveService.getCartBox();
        box.clear();
        for (final item in state) {
          box.add(item);
        }
      }
    } catch (e) {
      // Silent failure - cart persistence should not break the app
    }
  }
}