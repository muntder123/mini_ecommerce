import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../services/hive_service.dart';

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier();
});

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]) {
    _loadOrders();
  }

  void _loadOrders() {
    try {
      if (Hive.isBoxOpen(HiveService.ordersBoxName)) {
        final box = HiveService.getOrdersBox();
        state = box.values.toList();
      }
    } catch (e) {
      // Continue with empty orders list
    }
  }

  Future<void> createOrder({
    required String customerName,
    required String customerPhone,
    required String customerLocation,
    required List<CartItem> cartItems,
    required double totalAmount,
  }) async {
    try {
      if (!Hive.isBoxOpen(HiveService.ordersBoxName)) {
        return;
      }

      final box = HiveService.getOrdersBox();

      // Generate order ID (simple increment)
      final orderId = box.isEmpty ? 1 : box.keys.last + 1;

      // Convert cart items to order items
      final orderItems = cartItems.map((cartItem) => OrderItem(
        productId: cartItem.product.id,
        productTitle: cartItem.product.title,
        productPrice: cartItem.product.price,
        quantity: cartItem.quantity,
        totalPrice: cartItem.totalPrice,
      )).toList();

      final order = Order(
        id: orderId,
        customerName: customerName,
        customerPhone: customerPhone,
        customerLocation: customerLocation,
        items: orderItems,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        status: 'completed',
      );

      await box.put(orderId, order);

      // Update state
      state = [...state, order];

    } catch (e) {
      // Silent failure - order creation should not crash app
    }
  }

  List<Order> getOrdersByCustomer(String customerName) {
    return state.where((order) =>
      order.customerName.toLowerCase().contains(customerName.toLowerCase())
    ).toList();
  }

  Order? getOrderById(int id) {
    return state.where((order) => order.id == id).firstOrNull;
  }
}