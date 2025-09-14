import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/custom_illustrations.dart';
import 'customer_info_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final totalPrice = cartNotifier.totalPrice;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cart),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.clearCart),
                    content: Text(l10n.confirmClearCart),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          cartNotifier.clearCart();
                          Navigator.of(context).pop();
                        },
                        child: Text(l10n.clear),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
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
        child: cartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const EmptyCartIllustration(size: 120),
                    const SizedBox(height: 24),
                    Text(
                      l10n.cartEmpty,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.cartEmptyDesc,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    BounceButton(
                      onPressed: () {
                        // Navigate to products
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          l10n.startShopping,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItemCard(
                        item: item,
                        onRemove: () => cartNotifier.removeFromCart(item.product.id),
                        onUpdateQuantity: (quantity) => cartNotifier.updateQuantity(item.product.id, quantity),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.total, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          Text('\$${totalPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      BounceButton(
                        onPressed: () {
                          // Navigate to customer information screen
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const CustomerInfoScreen()),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF059669)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              l10n.checkout,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final Function(int) onUpdateQuantity;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: item.product.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${item.product.price}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: item.quantity > 1 ? () => onUpdateQuantity(item.quantity - 1) : null,
                ),
                Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => onUpdateQuantity(item.quantity + 1),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutScreen extends ConsumerWidget {
  final AppLocalizations l10n;

  const CheckoutScreen({super.key, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalPrice = ref.read(cartProvider.notifier).totalPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: item.product.image,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    title: Text(item.product.title),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('\$${totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Mock checkout process
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Processing payment...'),
                        ],
                      ),
                    ),
                  );

                  // Simulate API call
                  await Future.delayed(const Duration(seconds: 2));

                  Navigator.of(context).pop(); // Close loading dialog

                  // Always success for demo purposes
                  final success = true;

                  if (success) {
                    ref.read(cartProvider.notifier).clearCart();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Success!'),
                        content: const Text('Your order has been placed successfully.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close success dialog
                              Navigator.of(context).pop(); // Go back to cart
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Payment Failed'),
                        content: const Text('There was an error processing your payment. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}