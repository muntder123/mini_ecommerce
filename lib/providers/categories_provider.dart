import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final apiService = ApiService();
  return await apiService.fetchCategories();
});