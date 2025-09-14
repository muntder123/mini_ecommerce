import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/orders_provider.dart';
import '../models/order.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orderHistory),
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
        child: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.noOrdersYet,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noOrdersDesc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[orders.length - 1 - index]; // Most recent first
                return OrderCard(order: order);
              },
            ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.orderNumber}${order.id}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Customer Info
            Text(
              '${l10n.customer}: ${order.customerName}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${l10n.phone}: ${order.customerPhone}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),

            // Order Date
            Text(
              '${l10n.date}: ${order.orderDate.toString().split('.')[0]}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 12),
            const Divider(),

            // Order Items
            Text(
              '${l10n.items} (${order.items.length}):',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.productTitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'x${item.quantity}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )),

            const Divider(),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.totalAmount}:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}