import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts({
    int limit = 20,
    int skip = 0,
    String? category,
  }) async {
    String url = '$baseUrl/products?limit=$limit&skip=$skip';
    if (category != null && category.isNotEmpty) {
      url = '$baseUrl/products/category/$category?limit=$limit&skip=$skip';
    }

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/categories')).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((category) => category.toString()).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      // Since the API doesn't support search, fetch all products and filter locally
      final response = await http.get(Uri.parse('$baseUrl/products')).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Product> products = data.map((json) => Product.fromJson(json)).toList();
        return products.where((product) =>
          product.title.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase())
        ).toList();
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}