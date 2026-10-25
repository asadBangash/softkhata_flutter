import 'package:soft_khata_flutter/data/mappers/laravel_mappers.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/services/laravel_api_holder.dart';

class LaravelSyncService {
  LaravelSyncService(this._api);

  final LaravelApiHolder _api;

  Future<void> applyTo(AppState state) async {
    final catalog = _api.catalog;
    final me = await _api.auth.me();
    await catalog.loadExpenseCategories();

    final userName = me['name']?.toString() ?? '';
    final userEmail = me['email']?.toString() ?? '';
    final currentBusinessId = me['current_business_id']?.toString();

    final businessRows = await catalog.businesses();
    final businesses = businessRows
        .map((b) => mapBusiness(b, ownerName: userName, ownerEmail: userEmail))
        .toList();

    final businessId = currentBusinessId ??
        (businesses.isNotEmpty ? businesses.first.id : '0');

    final businessInt = int.tryParse(businessId);
    if (businessInt != null) {
      await _api.client.tokenStorage.saveBusinessId(businessInt);
    }

    final partyRows = await catalog.parties();
    final parties = partyRows.map((p) => mapParty(p, businessId)).toList();

    final productRows = await catalog.products();
    final products = productRows.map((p) => mapProduct(p, businessId)).toList();

    final saleRows = await catalog.sales();
    final sales = saleRows.map((s) => mapSale(s, businessId)).toList();

    final purchaseRows = await catalog.purchases();
    final purchases = purchaseRows.map((p) => mapPurchase(p, businessId)).toList();

    final expenseRows = await catalog.expenses();
    final expenses = expenseRows
        .map((e) => mapExpense(e, businessId, categoryName: catalog.expenseCategoryById[e['expense_category_id'] as int?]))
        .toList();

    final staffRows = await catalog.staff();
    final staff = staffRows.map((s) => mapStaff(s, businessId)).toList();

    final notificationRows = await catalog.notifications();
    final notifications = notificationRows.map(mapNotification).toList();

    final cashData = await catalog.cashBook();
    final openingCash = (cashData['opening_cash'] as num?)?.toDouble() ?? 0;
    final cashRows = await catalog.cashTransactions();
    final cashEntries = cashRows.map((c) => mapCashEntry(c, businessId)).toList();

    state.replaceRemoteSnapshot(
      businesses: businesses,
      currentBusinessId: businessId,
      parties: parties,
      cashEntries: cashEntries,
      openingCash: openingCash,
      products: products,
      sales: sales,
      purchases: purchases,
      expenses: expenses,
      staff: staff,
      notifications: notifications,
      invoices: const [],
    );
  }
}
