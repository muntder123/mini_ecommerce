import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../models/cart_item.dart';

class CustomerInfoScreen extends ConsumerStatefulWidget {
  const CustomerInfoScreen({super.key});

  @override
  ConsumerState<CustomerInfoScreen> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends ConsumerState<CustomerInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final cartItems = ref.read(cartProvider);
      final totalPrice = ref.read(cartProvider.notifier).totalPrice;

      // Create the order
      await ref.read(ordersProvider.notifier).createOrder(
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        customerLocation: _locationController.text.trim(),
        cartItems: cartItems,
        totalAmount: totalPrice,
      );

      // Clear the cart
      ref.read(cartProvider.notifier).clearCart();

      // Show success message
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.orderPlacedSuccess),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate back to home screen
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.failedToPlaceOrder}: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalPrice = ref.read(cartProvider.notifier).totalPrice;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customerInformation),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              Text(
                l10n.orderSummary,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...cartItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item.product.title} (x${item.quantity})',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              '\$${item.totalPrice.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${l10n.total}:',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Customer Information Form
              Text(
                l10n.customerInformation,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.fullName,
                        hintText: l10n.enterFullName,
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.nameRequired;
                        }
                        if (value.trim().length < 2) {
                          return l10n.nameMinLength;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: l10n.phoneNumber,
                        hintText: l10n.enterPhoneNumber,
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.phoneRequired;
                        }
                        if (value.trim().length < 10) {
                          return l10n.phoneInvalid;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: l10n.deliveryAddress,
                        hintText: l10n.enterDeliveryAddress,
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.addressRequired;
                        }
                        if (value.trim().length < 10) {
                          return l10n.addressMinLength;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        l10n.placeOrder,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}