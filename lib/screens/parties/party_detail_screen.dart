import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/transactions/transaction_form_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';
import 'package:soft_khata_flutter/widgets/payment_reminder_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class PartyDetailScreen extends StatefulWidget {
  const PartyDetailScreen({super.key, required this.partyId});

  final String partyId;

  @override
  State<PartyDetailScreen> createState() => _PartyDetailScreenState();
}

class _PartyDetailScreenState extends State<PartyDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AppState>();
      if (state.usesLaravel) {
        state.refreshPartyLedger(widget.partyId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final party = state.partyById(widget.partyId);
        if (party == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Party')),
            body: const EmptyState(icon: Icons.error_outline, title: 'Party not found'),
          );
        }
        final ledger = state.ledgerForParty(widget.partyId);
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(party.name),
              actions: [
                if (party.phone.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.call_outlined),
                    onPressed: () => launchUrl(Uri.parse('tel:${party.phone}')),
                  ),
                IconButton(
                  icon: const Icon(Icons.notifications_active_outlined),
                  onPressed: () => showPaymentReminderSheet(context, party),
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Transactions'),
                  Tab(text: 'Details'),
                  Tab(text: 'Notes'),
                ],
              ),
            ),
            floatingActionButton: party.type == PartyType.bank
                ? null
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'give',
                        onPressed: () => _openForm(context, party, TransactionKind.give),
                        child: const Icon(Icons.call_made),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: 'recv',
                        onPressed: () => _openForm(context, party, TransactionKind.receive),
                        child: const Icon(Icons.call_received),
                      ),
                    ],
                  ),
            body: TabBarView(
              children: [
                _LedgerTab(entries: ledger),
                _SummaryTab(party: party),
                _NotesTab(notes: party.notes),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openForm(BuildContext context, Party party, TransactionKind kind) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => TransactionFormScreen(initialKind: kind, partyId: party.id),
      ),
    );
  }
}

class _SummaryTab extends StatelessWidget {
  const _SummaryTab({required this.party});

  final Party party;

  @override
  Widget build(BuildContext context) {
    final color = party.currentBalance >= 0 ? AppTheme.success : AppTheme.danger;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current balance', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(
                CurrencyFormat.format(party.currentBalance.abs()),
                style: TextStyle(fontSize: 26, fontFamily: 'Bold', color: color),
              ),
              Text(party.currentBalance >= 0 ? 'They owe you' : 'You owe them'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              _infoRow(Icons.phone, party.phone),
              if (party.email.isNotEmpty) _infoRow(Icons.email_outlined, party.email),
              if (party.address.isNotEmpty) _infoRow(Icons.location_on_outlined, party.address),
              if (party.notes.isNotEmpty) _infoRow(Icons.notes, party.notes),
            ],
          ),
        ),
        if (party.lastTransactionDate != null) ...[
          const SectionHeader(title: 'Last transaction'),
          AppCard(
            child: ListTile(
              title: Text(party.lastTransactionNote.isEmpty ? '—' : party.lastTransactionNote),
              subtitle: Text(
                '${party.lastTransactionDate!.day}/${party.lastTransactionDate!.month}/${party.lastTransactionDate!.year}',
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(text),
      dense: true,
    );
  }
}

class _NotesTab extends StatelessWidget {
  const _NotesTab({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const EmptyState(icon: Icons.sticky_note_2_outlined, title: 'No notes for this party');
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [AppCard(child: Text(notes, style: const TextStyle(height: 1.5)))],
    );
  }
}

class _LedgerTab extends StatelessWidget {
  const _LedgerTab({required this.entries});

  final List<LedgerEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const EmptyState(icon: Icons.receipt_long, title: 'No ledger entries yet');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final e = entries[i];
        final inflow = e.credit > 0;
        return AppCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.description, style: const TextStyle(fontFamily: 'SemiBold')),
                    Text('${e.date.day}/${e.date.month}/${e.date.year} · ${paymentMethodLabel(e.paymentMethod)}'),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AmountChip(amount: inflow ? e.credit : -e.debit, compact: true),
                  Text('Bal ${CurrencyFormat.formatCompact(e.balanceAfter)}', style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
