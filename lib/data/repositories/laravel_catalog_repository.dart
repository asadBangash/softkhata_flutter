import 'package:soft_khata_flutter/core/api/api_client.dart';
import 'package:soft_khata_flutter/core/api/laravel_pagination.dart';
import 'package:soft_khata_flutter/data/mappers/laravel_mappers.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';

class LaravelCatalogRepository {
  LaravelCatalogRepository(this._client);

  final ApiClient _client;

  Map<int, String> expenseCategoryById = {};
  Map<String, int> expenseCategoryByName = {};

  Future<Map<String, dynamic>> me() async {
    final response = await _client.dio.get('me');
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> businesses() async {
    return fetchAllPaginated(_client.dio, 'businesses');
  }

  Future<void> loadExpenseCategories() async {
    final response = await _client.dio.get('expense-categories');
    final list = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    expenseCategoryById.clear();
    expenseCategoryByName.clear();
    for (final raw in list) {
      final row = raw as Map<String, dynamic>;
      final id = row['id'] as int;
      final name = row['name']?.toString() ?? 'Miscellaneous';
      expenseCategoryById[id] = name;
      expenseCategoryByName[name.toLowerCase()] = id;
    }
  }

  Future<List<Map<String, dynamic>>> parties() => fetchAllPaginated(_client.dio, 'parties');

  Future<List<Map<String, dynamic>>> products() => fetchAllPaginated(_client.dio, 'products');

  Future<List<Map<String, dynamic>>> sales() => fetchAllPaginated(_client.dio, 'sales');

  Future<List<Map<String, dynamic>>> purchases() => fetchAllPaginated(_client.dio, 'purchases');

  Future<List<Map<String, dynamic>>> expenses() => fetchAllPaginated(_client.dio, 'expenses');

  Future<List<Map<String, dynamic>>> staff() => fetchAllPaginated(_client.dio, 'staff');

  Future<List<Map<String, dynamic>>> notifications() =>
      fetchAllPaginated(_client.dio, 'notifications');

  Future<List<Map<String, dynamic>>> invoices() => fetchAllPaginated(_client.dio, 'invoices');

  Future<Map<String, dynamic>> cashBook() async {
    final response = await _client.dio.get('cash-book', queryParameters: {'per_page': 100});
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> cashTransactions() async {
    final items = <Map<String, dynamic>>[];
    var page = 1;
    while (true) {
      final response = await _client.dio.get(
        'cash-book',
        queryParameters: {'page': page, 'per_page': 100},
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      final nested = data['transactions'] as Map<String, dynamic>;
      final batch = (nested['data'] as List<dynamic>).cast<Map<String, dynamic>>();
      items.addAll(batch);
      final meta = nested['meta'] as Map<String, dynamic>?;
      if (meta == null || page >= (meta['last_page'] as int? ?? 1)) break;
      page++;
    }
    return items;
  }

  Future<List<Map<String, dynamic>>> ledgerLines(int partyId) async {
    final response = await _client.dio.get('parties/$partyId/ledger');
    final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return (data['lines'] as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createParty(Party party) async {
    final response = await _client.dio.post('parties', data: partyToApi(party));
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  Future<void> createTransaction({
    required int partyId,
    required TransactionKind kind,
    required double amount,
    required String description,
    DateTime? date,
  }) async {
    final type = kind == TransactionKind.give ? 'give' : 'receive';
    await _client.dio.post('transactions', data: {
      'party_id': partyId,
      'type': type,
      'amount': amount,
      'date': formatApiDate(date ?? DateTime.now()),
      'description': description,
    });
  }

  Future<void> createCashEntry({
    required bool isInflow,
    required double amount,
    required String category,
    required String description,
    DateTime? date,
  }) async {
    await _client.dio.post('cash-book', data: {
      'direction': isInflow ? 'in' : 'out',
      'amount': amount,
      'category': category,
      'description': description,
      'date': formatApiDate(date ?? DateTime.now()),
    });
  }

  Future<Map<String, dynamic>> createProduct(Product product) async {
    final response = await _client.dio.post('products', data: {
      'name': product.name,
      'sku': product.sku.isEmpty ? null : product.sku,
      'purchase_price': product.purchasePrice,
      'selling_price': product.sellingPrice,
      'current_stock': product.quantity,
      'minimum_stock': product.minStock,
      'description': product.description.isEmpty ? null : product.description,
    });
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  Future<void> createSale(SaleRecord sale) async {
    await _client.dio.post('sales', data: {
      'party_id': int.tryParse(sale.customerId),
      'date': formatApiDate(sale.date),
      'discount': sale.discount,
      'tax': sale.tax,
      'amount_paid': sale.amountReceived,
      'notes': sale.notes.isEmpty ? null : sale.notes,
      'items': sale.items
          .map((i) => {
                'product_id': int.tryParse(i.productId),
                'description': i.name,
                'quantity': i.qty,
                'rate': i.rate,
              })
          .toList(),
    });
  }

  Future<void> createPurchase(PurchaseRecord purchase) async {
    await _client.dio.post('purchases', data: {
      'party_id': int.tryParse(purchase.supplierId),
      'date': formatApiDate(purchase.date),
      'amount_paid': purchase.paidAmount,
      'items': purchase.items
          .map((i) => {
                'product_id': int.tryParse(i.productId),
                'description': i.name,
                'quantity': i.qty,
                'rate': i.rate,
              })
          .toList(),
    });
  }

  Future<void> createExpense(ExpenseRecord expense) async {
    await loadExpenseCategories();
    var categoryId = expenseCategoryByName[expense.category.toLowerCase()];
    categoryId ??= expenseCategoryByName['miscellaneous'];
    categoryId ??= expenseCategoryById.keys.firstOrNull;
    if (categoryId == null) {
      throw StateError('No expense categories on server. Run php artisan db:seed.');
    }
    await _client.dio.post('expenses', data: {
      'expense_category_id': categoryId,
      'amount': expense.amount,
      'date': formatApiDate(expense.date),
      'description': expense.description,
      'reference': expense.reference.isEmpty ? null : expense.reference,
    });
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
