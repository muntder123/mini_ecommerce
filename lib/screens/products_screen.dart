import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/products_provider.dart';
import '../providers/categories_provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import '../widgets/animated_widgets.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      ref.read(productsProvider.notifier).fetchProducts(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.products),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchProducts,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(productsProvider.notifier).clearSearch();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  onSubmitted: (query) {
                    ref.read(productsProvider.notifier).searchProducts(query);
                  },
                ),
                const SizedBox(height: 12),
                categoriesAsync.when(
                  data: (categories) => SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        FilterChip(
                          label: Text(l10n.all),
                          selected: productsState.selectedCategory == null,
                          onSelected: (selected) {
                            if (selected) {
                              ref.read(productsProvider.notifier).clearFilters();
                            }
                          },
                        ),
                        ...categories.map((category) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilterChip(
                            label: Text(category),
                            selected: productsState.selectedCategory == category,
                            onSelected: (selected) {
                              if (selected) {
                                ref.read(productsProvider.notifier).filterByCategory(category);
                              } else {
                                ref.read(productsProvider.notifier).clearFilters();
                              }
                            },
                          ),
                        )),
                      ],
                    ),
                  ),
                  loading: () => const SizedBox(height: 50, child: Center(child: CircularProgressIndicator())),
                  error: (error, stack) => SizedBox(height: 50, child: Center(child: Text('${l10n.error}: $error'))),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: productsState.error != null
            ? Center(child: Text('${l10n.error}: ${productsState.error}'))
            : productsState.products.isEmpty && !productsState.isLoading
                ? Center(child: Text(l10n.noProductsFound))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: productsState.products.length + (productsState.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == productsState.products.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final product = productsState.products[index];
                      return AnimatedProductCard(
                        delay: Duration(milliseconds: index * 100),
                        child: ProductCard(product: product, l10n: l10n),
                      );
                    },
                  ),
      ),
    );
  }
}

class ProductCard extends ConsumerWidget {
  final Product product;
  final AppLocalizations l10n;

  const ProductCard({super.key, required this.product, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Could navigate to product details
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Hero(
                tag: 'product-${product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.image, size: 40),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.error, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BounceButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const SuccessAnimation(size: 24, color: Colors.white),
                          const SizedBox(width: 12),
                          Text(l10n.addedToCart),
                        ],
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: null, // Handled by BounceButton
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}