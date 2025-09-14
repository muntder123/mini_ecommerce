import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class HiveService {
  static const String cartBoxName = 'cart';
  static const String productsBoxName = 'products';
  static const String languageBoxName = 'language';
  static const String ordersBoxName = 'orders';

  static Future<void> init() async {
    try {
      // For Android/iOS, try application support directory first
      if (!kIsWeb) {
        try {
          final supportDir = await getApplicationSupportDirectory();
          await Hive.initFlutter(supportDir.path);
        } catch (supportError) {
          // Fallback to application documents directory
          final directory = await getApplicationDocumentsDirectory();
          await Hive.initFlutter(directory.path);
        }
      } else {
        // For web, use default initialization
        await Hive.initFlutter();
      }
    } catch (e) {
      // Last resort - try without path
      await Hive.initFlutter();
    }

    // Register adapters
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(RatingAdapter());
    Hive.registerAdapter(CartItemAdapter());
    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(OrderItemAdapter());

    // Brief stabilization delay
    await Future.delayed(const Duration(milliseconds: 100));
  }

  static Box<CartItem> getCartBox() => Hive.box<CartItem>(cartBoxName);

  static Box<Product> getProductsBox() => Hive.box<Product>(productsBoxName);

  static Box<Order> getOrdersBox() => Hive.box<Order>(ordersBoxName);

  static Future<void> openBoxes() async {
    try {
      if (!Hive.isBoxOpen(cartBoxName)) {
        await Hive.openBox<CartItem>(cartBoxName);
      }

      if (!Hive.isBoxOpen(productsBoxName)) {
        await Hive.openBox<Product>(productsBoxName);
      }

      if (!Hive.isBoxOpen(languageBoxName)) {
        await Hive.openBox(languageBoxName);
      }

      if (!Hive.isBoxOpen(ordersBoxName)) {
        await Hive.openBox<Order>(ordersBoxName);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> closeBoxes() async {
    await Hive.box<CartItem>(cartBoxName).close();
    await Hive.box<Product>(productsBoxName).close();
  }
}