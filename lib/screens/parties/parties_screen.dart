import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/parties/add_party_screen.dart';
import 'package:soft_khata_flutter/screens/parties/party_detail_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class PartiesScreen extends StatefulWidget {
  const PartiesScreen({super.key});

  @override
  State<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends State<PartiesScreen> {
  int _tab = 0;
  String _query = '';

  static const _tabs = ['All', 'Customers', 'Suppliers', 'Banks'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const AddPartyScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final filtered = _filterParties(state.partiesForCurrent);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name or phone',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
                ),
              ),
              const SizedBox(height: 8),
              FilterChipRow(
                labels: _tabs,
                selectedIndex: _tab,
                onSelected: (i) => setState(() => _tab = i),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.people_outline,
                        title: 'No parties found',
                        subtitle: 'Add customers, suppliers, or bank accounts.',
                        actionLabel: 'Add party',
                        onAction: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const AddPartyScreen()),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final p = filtered[i];
                          return AppCard(
                            padding: EdgeInsets.zero,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => PartyDetailScreen(partyId: p.id),
                              ),
                            ),
                            child: PartyListTile(
                              name: p.name,
                              subtitle: '${_typeLabel(p.type)} · ${p.phone}',
                              balance: p.currentBalance,
                              leadingIcon: _iconForType(p.type),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => PartyDetailScreen(partyId: p.id),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const AddPartyScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Party> _filterParties(List<Party> all) {
    Iterable<Party> list = all;
    switch (_tab) {
      case 1:
        list = list.where((p) => p.type == PartyType.customer);
        break;
      case 2:
        list = list.where((p) => p.type == PartyType.supplier);
        break;
      case 3:
        list = list.where((p) => p.type == PartyType.bank);
        break;
    }
    if (_query.isNotEmpty) {
      list = list.where(
        (p) => p.name.toLowerCase().contains(_query) || p.phone.contains(_query),
      );
    }
    return list.toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  String _typeLabel(PartyType t) {
    switch (t) {
      case PartyType.customer:
        return 'Customer';
      case PartyType.supplier:
        return 'Supplier';
      case PartyType.bank:
        return 'Bank';
    }
  }

  IconData _iconForType(PartyType t) {
    switch (t) {
      case PartyType.customer:
        return Icons.person_outline;
      case PartyType.supplier:
        return Icons.local_shipping_outlined;
      case PartyType.bank:
        return Icons.account_balance_outlined;
    }
  }
}
