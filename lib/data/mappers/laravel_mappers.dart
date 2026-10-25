import 'package:soft_khata_flutter/models/domain_models.dart';

double _num(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

DateTime _date(dynamic v) {
  if (v == null) return DateTime.now();
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString()) ?? DateTime.now();
}

PartyType _partyType(String? t) {
  switch (t) {
    case 'supplier':
      return PartyType.supplier;
    case 'bank':
      return PartyType.bank;
    default:
      return PartyType.customer;
  }
}

BalanceSide _balanceSide(String? t) {
  return t == 'give' ? BalanceSide.youWillGive : BalanceSide.youWillGet;
}

PaymentMethod _paymentMethod(String? name) {
  final n = (name ?? '').toLowerCase();
  if (n.contains('bank')) return PaymentMethod.bankTransfer;
  if (n.contains('easypaisa')) return PaymentMethod.easypaisa;
  if (n.contains('jazz')) return PaymentMethod.jazzCash;
  if (n.contains('card')) return PaymentMethod.card;
  if (n.contains('cheque')) return PaymentMethod.cheque;
  if (n.contains('other')) return PaymentMethod.other;
  return PaymentMethod.cash;
}

InvoiceStatus _invoiceStatus(String? s) {
  switch (s) {
    case 'paid':
      return InvoiceStatus.paid;
    case 'partial':
      return InvoiceStatus.partial;
    case 'overdue':
      return InvoiceStatus.overdue;
    default:
      return InvoiceStatus.unpaid;
  }
}

TransactionKind _txKind(String? t) {
  switch (t) {
    case 'give':
    case 'payment':
      return TransactionKind.give;
    case 'sale':
      return TransactionKind.sale;
    case 'purchase':
      return TransactionKind.purchase;
    case 'expense':
      return TransactionKind.expense;
    case 'adjustment':
      return TransactionKind.adjustment;
    case 'opening':
      return TransactionKind.opening;
    default:
      return TransactionKind.receive;
  }
}

BusinessProfile mapBusiness(Map<String, dynamic> json, {String? ownerName, String? ownerEmail}) {
  return BusinessProfile(
    id: json['id'].toString(),
    name: json['name']?.toString() ?? 'Business',
    owner: ownerName ?? json['owner_name']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    email: json['email']?.toString() ?? ownerEmail ?? '',
    address: json['address']?.toString() ?? '',
    category: json['category']?.toString() ?? 'General Store',
    currency: json['currency']?.toString() ?? 'PKR',
  );
}

Party mapParty(Map<String, dynamic> json, String businessId) {
  return Party(
    id: json['id'].toString(),
    businessId: businessId,
    type: _partyType(json['type']?.toString()),
    name: json['name']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    address: json['address']?.toString() ?? '',
    openingBalance: _num(json['opening_balance']),
    balanceSide: _balanceSide(json['balance_type']?.toString()),
    notes: json['notes']?.toString() ?? '',
    currentBalance: _num(json['current_balance']),
    lastTransactionNote: json['last_transaction_note']?.toString() ?? '',
    lastTransactionDate: json['updated_at'] != null ? _date(json['updated_at']) : null,
  );
}

LedgerEntry mapLedgerLine(Map<String, dynamic> json, String partyId) {
  final debit = _num(json['debit']);
  final credit = _num(json['credit']);
  return LedgerEntry(
    id: json['id']?.toString() ?? 'le-${json['date']}',
    partyId: partyId,
    date: _date(json['date']),
    description: json['description']?.toString() ?? '',
    debit: debit,
    credit: credit,
    balanceAfter: _num(json['balance']),
    kind: _txKind(json['type']?.toString()),
  );
}

CashEntry mapCashEntry(Map<String, dynamic> json, String businessId) {
  final direction = json['direction']?.toString();
  return CashEntry(
    id: json['id'].toString(),
    businessId: businessId,
    isInflow: direction == 'in',
    amount: _num(json['amount']),
    category: json['category']?.toString() ?? 'General',
    description: json['description']?.toString() ?? '',
    date: _date(json['date']),
    paymentMethod: PaymentMethod.cash,
  );
}

Product mapProduct(Map<String, dynamic> json, String businessId) {
  return Product(
    id: json['id'].toString(),
    businessId: businessId,
    name: json['name']?.toString() ?? '',
    category: json['category']?.toString() ?? 'General',
    sku: json['sku']?.toString() ?? '',
    purchasePrice: _num(json['purchase_price']),
    sellingPrice: _num(json['selling_price']),
    quantity: _num(json['current_stock']),
    minStock: _num(json['minimum_stock']),
    barcode: json['barcode']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
  );
}

LineItem mapLineItem(Map<String, dynamic> json) {
  return LineItem(
    productId: json['product_id']?.toString() ?? '',
    name: json['description']?.toString() ?? json['product']?['name']?.toString() ?? 'Item',
    qty: _num(json['quantity']),
    rate: _num(json['rate']),
    discount: _num(json['discount']),
  );
}

SaleRecord mapSale(Map<String, dynamic> json, String businessId, {String? partyName}) {
  final itemsRaw = json['items'] as List<dynamic>? ?? [];
  return SaleRecord(
    id: json['id'].toString(),
    businessId: businessId,
    invoiceNo: json['sale_number']?.toString() ?? json['invoice_no']?.toString() ?? '',
    customerId: json['party_id']?.toString() ?? '',
    customerName: partyName ?? json['party']?['name']?.toString() ?? '',
    date: _date(json['date']),
    items: itemsRaw.map((e) => mapLineItem(e as Map<String, dynamic>)).toList(),
    subtotal: _num(json['subtotal']),
    discount: _num(json['discount']),
    tax: _num(json['tax']),
    grandTotal: _num(json['grand_total']),
    amountReceived: _num(json['amount_paid']),
    status: _invoiceStatus(json['payment_status']?.toString()),
    notes: json['notes']?.toString() ?? '',
  );
}

PurchaseRecord mapPurchase(Map<String, dynamic> json, String businessId, {String? partyName}) {
  final itemsRaw = json['items'] as List<dynamic>? ?? [];
  return PurchaseRecord(
    id: json['id'].toString(),
    businessId: businessId,
    purchaseNo: json['purchase_number']?.toString() ?? '',
    supplierId: json['party_id']?.toString() ?? '',
    supplierName: partyName ?? json['party']?['name']?.toString() ?? '',
    date: _date(json['date']),
    items: itemsRaw.map((e) => mapLineItem(e as Map<String, dynamic>)).toList(),
    grandTotal: _num(json['grand_total']),
    paidAmount: _num(json['amount_paid']),
    status: _invoiceStatus(json['payment_status']?.toString()),
  );
}

ExpenseRecord mapExpense(Map<String, dynamic> json, String businessId, {String? categoryName}) {
  return ExpenseRecord(
    id: json['id'].toString(),
    businessId: businessId,
    category: categoryName ?? json['category']?['name']?.toString() ?? 'Miscellaneous',
    amount: _num(json['amount']),
    date: _date(json['date']),
    paymentMethod: PaymentMethod.cash,
    description: json['description']?.toString() ?? '',
    reference: json['reference']?.toString() ?? '',
  );
}

StaffMember mapStaff(Map<String, dynamic> json, String businessId) {
  return StaffMember(
    id: json['id'].toString(),
    businessId: businessId,
    name: json['name']?.toString() ?? '',
    role: StaffRole.cashier,
    phone: json['phone']?.toString() ?? '',
    monthlySalary: _num(json['monthly_salary'] ?? json['salary']),
  );
}

AppNotificationItem mapNotification(Map<String, dynamic> json) {
  return AppNotificationItem(
    id: json['id'].toString(),
    title: json['title']?.toString() ?? 'Notification',
    body: json['message']?.toString() ?? json['body']?.toString() ?? '',
    time: _date(json['created_at']),
    read: json['is_read'] == true || json['read_at'] != null,
  );
}

Map<String, dynamic> partyToApi(Party party) {
  return {
    'type': party.type.name,
    'name': party.name,
    'phone': party.phone,
    'email': party.email.isEmpty ? null : party.email,
    'address': party.address.isEmpty ? null : party.address,
    'opening_balance': party.openingBalance,
    'balance_type': party.balanceSide == BalanceSide.youWillGive ? 'give' : 'receive',
    'notes': party.notes.isEmpty ? null : party.notes,
  };
}

String formatApiDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
