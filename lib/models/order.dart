import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 3)
class Order {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String customerName;
  @HiveField(2)
  final String customerPhone;
  @HiveField(3)
  final String customerLocation;
  @HiveField(4)
  final List<OrderItem> items;
  @HiveField(5)
  final double totalAmount;
  @HiveField(6)
  final DateTime orderDate;
  @HiveField(7)
  final String status;

  Order({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerLocation,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
  });

  Order copyWith({
    int? id,
    String? customerName,
    String? customerPhone,
    String? customerLocation,
    List<OrderItem>? items,
    double? totalAmount,
    DateTime? orderDate,
    String? status,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerLocation: customerLocation ?? this.customerLocation,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
    );
  }
}

@HiveType(typeId: 4)
class OrderItem {
  @HiveField(0)
  final int productId;
  @HiveField(1)
  final String productTitle;
  @HiveField(2)
  final double productPrice;
  @HiveField(3)
  final int quantity;
  @HiveField(4)
  final double totalPrice;

  OrderItem({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.quantity,
    required this.totalPrice,
  });

  OrderItem copyWith({
    int? productId,
    String? productTitle,
    double? productPrice,
    int? quantity,
    double? totalPrice,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      productTitle: productTitle ?? this.productTitle,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}