import 'package:hive/hive.dart';
import 'product.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 2)
class CartItem {
  @HiveField(0)
  final Product product;
  @HiveField(1)
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}