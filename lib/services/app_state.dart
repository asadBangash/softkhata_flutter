import 'package:flutter/foundation.dart';
import 'package:soft_khata_flutter/data/mappers/laravel_mappers.dart';
import 'package:soft_khata_flutter/mock/mock_seed_data.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/services/laravel_api_holder.dart';
import 'package:soft_khata_flutter/services/laravel_sync_service.dart';

class AppState extends ChangeNotifier {
  AppState({bool skipSeed = false}) {
    if (!skipSeed) {
      _loadFromSeed();
    }
  }

  LaravelApiHolder? _laravelApi;
  bool isSyncing = false;

  bool get usesLaravel => _laravelApi != null;

  void attachLaravel(LaravelApiHolder api) {
    _laravelApi = api;
  }

  Future<void> refreshFromApi() async {
    if (_laravelApi == null) return;
    isSyncing = true;
    notifyListeners();
    try {
      await LaravelSyncService(_laravelApi!).applyTo(this);
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> refreshPartyLedger(String partyId) async {
    if (_laravelApi == null) return;
    final partyInt = int.tryParse(partyId);
    if (partyInt == null) return;
    final lines = await _laravelApi!.catalog.ledgerLines(partyInt);
    _ledgerByParty[partyId] =
        lines.map((line) => mapLedgerLine(line, partyId)).toList();
    notifyListeners();
  }

  void replaceRemoteSnapshot({
    required List<BusinessProfile> businesses,
    required String currentBusinessId,
    required List<Party> parties,
    required List<CashEntry> cashEntries,
    required double openingCash,
    required List<Product> products,
    required List<SaleRecord> sales,
    required List<PurchaseRecord> purchases,
    required List<ExpenseRecord> expenses,
    required List<StaffMember> staff,
    required List<AppNotificationItem> notifications,
    required List<InvoiceRecord> invoices,
  }) {
    _businesses
      ..clear()
      ..addAll(businesses);
    _currentBusinessId = currentBusinessId;
    _parties
      ..clear()
      ..addAll(parties);
    _ledgerByParty.clear();
    _cashEntries
      ..clear()
      ..addAll(cashEntries);
    _openingCashByBusiness[_currentBusinessId] = openingCash;
    _products
      ..clear()
      ..addAll(products);
    _sales
      ..clear()
      ..addAll(sales);
    _purchases
      ..clear()
      ..addAll(purchases);
    _expenses
      ..clear()
      ..addAll(expenses);
    _staff
      ..clear()
      ..addAll(staff);
    _notifications
      ..clear()
      ..addAll(notifications);
    _invoices
      ..clear()
      ..addAll(invoices);
    _activities.clear();
    notifyListeners();
  }

  final List<BusinessProfile> _businesses = [];
  String _currentBusinessId = MockSeedData.asadId;

  final List<Party> _parties = [];
  final Map<String, List<LedgerEntry>> _ledgerByParty = {};
  final List<CashEntry> _cashEntries = [];
  final List<Product> _products = [];
  final List<SaleRecord> _sales = [];
  final List<PurchaseRecord> _purchases = [];
  final List<InvoiceRecord> _invoices = [];
  final List<ExpenseRecord> _expenses = [];
  final List<StaffMember> _staff = [];
  final List<AppNotificationItem> _notifications = [];
  final List<ActivityItem> _activities = [];
  final Map<String, double> _openingCashByBusiness = {};

  int _idSeq = 1000;

  String _nextId(String prefix) => '$prefix-${_idSeq++}';

  List<BusinessProfile> get businesses => List.unmodifiable(_businesses);
  String get currentBusinessId => _currentBusinessId;

  BusinessProfile get currentBusiness =>
      _businesses.firstWhere((b) => b.id == _currentBusinessId);

  List<Party> get partiesForCurrent =>
      _parties.where((p) => p.businessId == _currentBusinessId).toList();

  List<CashEntry> get cashForCurrent =>
      _cashEntries.where((c) => c.businessId == _currentBusinessId).toList();

  List<Product> get productsForCurrent =>
      _products.where((p) => p.businessId == _currentBusinessId).toList();

  List<SaleRecord> get salesForCurrent =>
      _sales.where((s) => s.businessId == _currentBusinessId).toList();

  List<PurchaseRecord> get purchasesForCurrent =>
      _purchases.where((p) => p.businessId == _currentBusinessId).toList();

  List<InvoiceRecord> get invoicesForCurrent =>
      _invoices.where((i) => i.businessId == _currentBusinessId).toList();

  List<ExpenseRecord> get expensesForCurrent =>
      _expenses.where((e) => e.businessId == _currentBusinessId).toList();

  List<StaffMember> get staffForCurrent =>
      _staff.where((s) => s.businessId == _currentBusinessId).toList();

  List<AppNotificationItem> get notifications =>
      List.unmodifiable(_notifications);

  List<ActivityItem> get activitiesForCurrent =>
      _activities.where((a) => true).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  double get youWillGet => partiesForCurrent
      .where((p) => p.type != PartyType.bank && p.currentBalance > 0)
      .fold(0.0, (s, p) => s + p.currentBalance);

  double get youWillGive => partiesForCurrent
      .where((p) => p.type != PartyType.bank && p.currentBalance < 0)
      .fold(0.0, (s, p) => s + p.currentBalance.abs());

  double get netPartyBalance => youWillGet - youWillGive;

  double get cashInHand {
    final opening = _openingCashByBusiness[_currentBusinessId] ?? 0;
    return cashForCurrent.fold(opening, (bal, e) {
      return e.isInflow ? bal + e.amount : bal - e.amount;
    });
  }

  double get totalSales => salesForCurrent.fold(0.0, (s, r) => s + r.grandTotal);

  double get totalPurchases =>
      purchasesForCurrent.fold(0.0, (s, r) => s + r.grandTotal);

  double get totalExpenses =>
      expensesForCurrent.fold(0.0, (s, e) => s + e.amount);

  double get stockValue =>
      productsForCurrent.fold(0.0, (s, p) => s + p.stockValue);

  int get lowStockCount => productsForCurrent.where((p) => p.isLowStock).length;

  int get unreadNotifications => _notifications.where((n) => !n.read).length;

  List<LedgerEntry> ledgerForParty(String partyId) {
    final list = _ledgerByParty[partyId] ?? [];
    return List<LedgerEntry>.from(list)..sort((a, b) => b.date.compareTo(a.date));
  }

  Party? partyById(String id) {
    try {
      return _parties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void _loadFromSeed() {
    _businesses.clear();
    _businesses.addAll(MockSeedData.businesses);
    for (final b in _businesses) {
      _mergeBundle(b.id, MockSeedData.seedForBusiness(b.id));
    }
    _currentBusinessId = MockSeedData.asadId;
    notifyListeners();
  }

  void _mergeBundle(String businessId, MockBusinessBundle bundle) {
    _openingCashByBusiness[businessId] = bundle.openingCash;
    _parties.removeWhere((p) => p.businessId == businessId);
    _parties.addAll(bundle.parties);
    for (final e in bundle.ledgerByParty.entries) {
      _ledgerByParty[e.key] = List<LedgerEntry>.from(e.value);
    }
    _cashEntries.removeWhere((c) => c.businessId == businessId);
    _cashEntries.addAll(bundle.cashEntries);
    _products.removeWhere((p) => p.businessId == businessId);
    _products.addAll(bundle.products);
    _sales.removeWhere((s) => s.businessId == businessId);
    _sales.addAll(bundle.sales);
    _purchases.removeWhere((p) => p.businessId == businessId);
    _purchases.addAll(bundle.purchases);
    _invoices.removeWhere((i) => i.businessId == businessId);
    _invoices.addAll(bundle.invoices);
    _expenses.removeWhere((e) => e.businessId == businessId);
    _expenses.addAll(bundle.expenses);
    _staff.removeWhere((s) => s.businessId == businessId);
    _staff.addAll(bundle.staff);
    _notifications.addAll(bundle.notifications);
    _activities.addAll(bundle.activities);
  }

  void switchBusiness(String id) {
    if (!_businesses.any((b) => b.id == id)) return;
    _currentBusinessId = id;
    notifyListeners();
  }

  void addBusiness(BusinessProfile profile) {
    _businesses.add(profile);
    _mergeBundle(profile.id, MockSeedData.seedForBusiness(profile.id));
    _currentBusinessId = profile.id;
    notifyListeners();
  }

  Future<void> addParty(Party party) async {
    if (_laravelApi != null) {
      await _laravelApi!.catalog.createParty(party);
      await refreshFromApi();
      return;
    }
    _parties.add(party);
    _ledgerByParty[party.id] = [];
    if (party.openingBalance != 0) {
      final bal = party.balanceSide == BalanceSide.youWillGive
          ? -party.openingBalance.abs()
          : party.openingBalance;
      _updatePartyBalance(party.id, bal, 'Opening balance', TransactionKind.opening);
    }
    notifyListeners();
  }

  Future<void> addLedgerTransaction({
    required String partyId,
    required TransactionKind kind,
    required double amount,
    required String description,
    PaymentMethod paymentMethod = PaymentMethod.cash,
    String notes = '',
    bool recordCash = true,
  }) async {
    final party = partyById(partyId);
    if (party == null || amount <= 0) return;

    if (_laravelApi != null) {
      final partyInt = int.tryParse(partyId);
      if (partyInt == null) return;
      await _laravelApi!.catalog.createTransaction(
        partyId: partyInt,
        kind: kind,
        amount: amount,
        description: description,
      );
      await refreshFromApi();
      await refreshPartyLedger(partyId);
      return;
    }

    double newBal = party.currentBalance;
    double debit = 0;
    double credit = 0;

    if (kind == TransactionKind.receive) {
      credit = amount;
      newBal -= amount;
      if (recordCash) {
        addCashEntry(
          isInflow: true,
          amount: amount,
          category: 'Collection',
          description: description.isEmpty ? 'Received from ${party.name}' : description,
          paymentMethod: paymentMethod,
        );
      }
    } else if (kind == TransactionKind.give) {
      debit = amount;
      newBal += amount;
      if (recordCash) {
        addCashEntry(
          isInflow: false,
          amount: amount,
          category: 'Payment',
          description: description.isEmpty ? 'Paid to ${party.name}' : description,
          paymentMethod: paymentMethod,
        );
      }
    } else {
      return;
    }

    final entry = LedgerEntry(
      id: _nextId('le'),
      partyId: partyId,
      date: DateTime.now(),
      description: description,
      debit: debit,
      credit: credit,
      balanceAfter: newBal,
      paymentMethod: paymentMethod,
      notes: notes,
      kind: kind,
    );
    _ledgerByParty.putIfAbsent(partyId, () => []).add(entry);
    _replaceParty(party.copyWith(
      currentBalance: newBal,
      lastTransactionNote: description,
      lastTransactionDate: DateTime.now(),
    ));
    _activities.insert(
      0,
      ActivityItem(
        id: _nextId('act'),
        title: kind == TransactionKind.receive ? 'Payment received' : 'Payment given',
        subtitle: party.name,
        amount: amount,
        date: DateTime.now(),
        isCredit: kind == TransactionKind.receive,
      ),
    );
    notifyListeners();
  }

  void _updatePartyBalance(
    String partyId,
    double balanceAfter,
    String note,
    TransactionKind kind,
  ) {
    final party = partyById(partyId);
    if (party == null) return;
    final entry = LedgerEntry(
      id: _nextId('le'),
      partyId: partyId,
      date: DateTime.now(),
      description: note,
      debit: balanceAfter > party.currentBalance ? balanceAfter - party.currentBalance : 0,
      credit: balanceAfter < party.currentBalance ? party.currentBalance - balanceAfter : 0,
      balanceAfter: balanceAfter,
      kind: kind,
    );
    _ledgerByParty.putIfAbsent(partyId, () => []).add(entry);
    _replaceParty(party.copyWith(
      currentBalance: balanceAfter,
      lastTransactionNote: note,
      lastTransactionDate: DateTime.now(),
    ));
  }

  void _replaceParty(Party updated) {
    final i = _parties.indexWhere((p) => p.id == updated.id);
    if (i >= 0) _parties[i] = updated;
  }

  Future<void> addCashEntry({
    required bool isInflow,
    required double amount,
    required String category,
    required String description,
    PaymentMethod paymentMethod = PaymentMethod.cash,
    DateTime? date,
  }) async {
    if (_laravelApi != null) {
      await _laravelApi!.catalog.createCashEntry(
        isInflow: isInflow,
        amount: amount,
        category: category,
        description: description,
        date: date,
      );
      await refreshFromApi();
      return;
    }
    _cashEntries.add(CashEntry(
      id: _nextId('ce'),
      businessId: _currentBusinessId,
      isInflow: isInflow,
      amount: amount,
      category: category,
      description: description,
      date: date ?? DateTime.now(),
      paymentMethod: paymentMethod,
    ));
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    if (_laravelApi != null) {
      await _laravelApi!.catalog.createProduct(product);
      await refreshFromApi();
      return;
    }
    _products.add(product);
    notifyListeners();
  }

  void adjustStock(String productId, double delta, {String reason = 'Adjustment'}) {
    final i = _products.indexWhere((p) => p.id == productId);
    if (i < 0) return;
    final p = _products[i];
    _products[i] = p.copyWith(quantity: (p.quantity + delta).clamp(0, 999999));
    notifyListeners();
  }

  Future<void> addSale(SaleRecord sale) async {
    if (_laravelApi != null) {
      await _laravelApi!.catalog.createSale(sale);
      await refreshFromApi();
      return;
    }
    _sales.add(sale);
    _updatePartyBalance(
      sale.customerId,
      (partyById(sale.customerId)?.currentBalance ?? 0) +
          (sale.grandTotal - sale.amountReceived),
      'Sale ${sale.invoiceNo}',
      TransactionKind.sale,
    );
    for (final item in sale.items) {
      adjustStock(item.productId, -item.qty);
    }
    notifyListeners();
  }

  Future<void> addPurchase(PurchaseRecord purchase) async {
    if (_laravelApi != null) {
      await _laravelApi!.catalog.createPurchase(purchase);
      await refreshFromApi();
      return;
    }
    _purchases.add(purchase);
    _updatePartyBalance(
      purchase.supplierId,
      (partyById(purchase.supplierId)?.currentBalance ?? 0) -
          (purchase.grandTotal - purchase.paidAmount),
      'Purchase ${purchase.purchaseNo}',
      TransactionKind.purchase,
    );
    for (final item in purchase.items) {
      final prod = _products.where((p) => p.id == item.productId).toList();
      if (prod.isNotEmpty) {
        adjustStock(item.productId, item.qty);
      }
    }
    notifyListeners();
  }

  void addInvoice(InvoiceRecord invoice) {
    _invoices.add(invoice);
    notifyListeners();
  }

  Future<void> addExpense(ExpenseRecord expense) async {
    if (_laravelApi != null) {
      await _laravelApi!.catalog.createExpense(expense);
      await refreshFromApi();
      return;
    }
    _expenses.add(expense);
    await addCashEntry(
      isInflow: false,
      amount: expense.amount,
      category: expense.category,
      description: expense.description,
      paymentMethod: expense.paymentMethod,
      date: expense.date,
    );
    notifyListeners();
  }

  void markStaffPresent(String staffId) => _setAttendance(staffId, AttendanceStatus.present);

  void markStaffAbsent(String staffId) => _setAttendance(staffId, AttendanceStatus.absent);

  void _setAttendance(String staffId, AttendanceStatus status) {
    final i = _staff.indexWhere((s) => s.id == staffId);
    if (i < 0) return;
    _staff[i] = _staff[i].copyWith(attendanceToday: status);
    notifyListeners();
  }

  void markNotificationRead(String id) {
    final i = _notifications.indexWhere((n) => n.id == id);
    if (i < 0) return;
    final n = _notifications[i];
    _notifications[i] = AppNotificationItem(
      id: n.id,
      title: n.title,
      body: n.body,
      time: n.time,
      read: true,
    );
    notifyListeners();
  }
}
