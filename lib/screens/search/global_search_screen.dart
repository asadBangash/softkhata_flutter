import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/screens/invoices/invoice_preview_screen.dart';
import 'package:soft_khata_flutter/screens/parties/party_detail_screen.dart';
import 'package:soft_khata_flutter/screens/stock/product_detail_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search parties, products, invoices…',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          if (_query.length < 2) {
            return const EmptyState(
              icon: Icons.search,
              title: 'Start typing',
              subtitle: 'Search across parties, stock, sales, and invoices.',
            );
          }

          final parties = state.partiesForCurrent.where((p) {
            return p.name.toLowerCase().contains(_query) || p.phone.contains(_query);
          }).take(8).toList();

          final products = state.productsForCurrent.where((p) {
            return p.name.toLowerCase().contains(_query) ||
                p.sku.toLowerCase().contains(_query) ||
                p.category.toLowerCase().contains(_query);
          }).take(8).toList();

          final sales = state.salesForCurrent.where((s) {
            return s.invoiceNo.toLowerCase().contains(_query) ||
                s.customerName.toLowerCase().contains(_query);
          }).take(5).toList();

          final invoices = state.invoicesForCurrent.where((i) {
            return i.number.toLowerCase().contains(_query) ||
                i.customerName.toLowerCase().contains(_query);
          }).take(5).toList();

          final empty = parties.isEmpty && products.isEmpty && sales.isEmpty && invoices.isEmpty;

          if (empty) {
            return EmptyState(
              icon: Icons.search_off,
              title: 'No results',
              subtitle: 'Try another keyword for "${_controller.text.trim()}".',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (parties.isNotEmpty) ...[
                const SectionHeader(title: 'Parties'),
                ...parties.map(
                  (p) => AppCard(
                    padding: EdgeInsets.zero,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => PartyDetailScreen(partyId: p.id)),
                    ),
                    child: PartyListTile(
                      name: p.name,
                      subtitle: p.phone,
                      balance: p.currentBalance,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (_) => PartyDetailScreen(partyId: p.id)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (products.isNotEmpty) ...[
                const SectionHeader(title: 'Products'),
                ...products.map(
                  (p) => AppCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => ProductDetailScreen(productId: p.id)),
                    ),
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text('SKU ${p.sku} · Stock ${p.quantity}'),
                      trailing: Text(CurrencyFormat.format(p.sellingPrice)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (sales.isNotEmpty) ...[
                const SectionHeader(title: 'Sales'),
                ...sales.map(
                  (s) => AppCard(
                    child: ListTile(
                      title: Text(s.invoiceNo),
                      subtitle: Text(s.customerName),
                      trailing: Text(CurrencyFormat.format(s.grandTotal)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (invoices.isNotEmpty) ...[
                const SectionHeader(title: 'Invoices'),
                ...invoices.map(
                  (i) => AppCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => InvoicePreviewScreen(invoiceId: i.id)),
                    ),
                    child: ListTile(
                      title: Text(i.number),
                      subtitle: Text(i.customerName),
                      trailing: Text(CurrencyFormat.format(i.grandTotal)),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
