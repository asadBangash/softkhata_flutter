import 'package:flutter/foundation.dart';

enum PartyType { customer, supplier, bank }

enum BalanceSide { youWillGet, youWillGive }

enum PaymentMethod { cash, bankTransfer, easypaisa, jazzCash, card, cheque, other }

enum InvoiceStatus { paid, partial, unpaid, overdue }

enum ProductUnit { pieces, kg, gram, liter, meter, box, pack }

enum StaffRole { owner, admin, accountant, cashier, salesman }

enum AttendanceStatus { present, absent, leave }

enum TransactionKind { receive, give, sale, purchase, expense, opening, adjustment }

@immutable
class BusinessProfile {
  const BusinessProfile({
    required this.id,
    required this.name,
    required this.owner,
    required this.phone,
    required this.email,
    required this.address,
    required this.category,
    this.currency = 'PKR',
  });

  final String id;
  final String name;
  final String owner;
  final String phone;
  final String email;
  final String address;
  final String category;
  final String currency;

  BusinessProfile copyWith({
    String? name,
    String? owner,
    String? phone,
    String? email,
    String? address,
    String? category,
  }) {
    return BusinessProfile(
      id: id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      category: category ?? this.category,
      currency: currency,
    );
  }
}

@immutable
class Party {
  const Party({
    required this.id,
    required this.businessId,
    required this.type,
    required this.name,
    required this.phone,
    this.email = '',
    this.address = '',
    this.openingBalance = 0,
    this.balanceSide = BalanceSide.youWillGet,
    this.notes = '',
    this.lastTransactionNote = '',
    this.lastTransactionDate,
    this.currentBalance = 0,
  });

  final String id;
  final String businessId;
  final PartyType type;
  final String name;
  final String phone;
  final String email;
  final String address;
  final double openingBalance;
  final BalanceSide balanceSide;
  final String notes;
  final String lastTransactionNote;
  final DateTime? lastTransactionDate;
  final double currentBalance;

  bool get isReceivable => currentBalance > 0;

  Party copyWith({
    String? name,
    String? phone,
    String? email,
    String? address,
    double? currentBalance,
    String? lastTransactionNote,
    DateTime? lastTransactionDate,
    String? notes,
  }) {
    return Party(
      id: id,
      businessId: businessId,
      type: type,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      openingBalance: openingBalance,
      balanceSide: balanceSide,
      notes: notes ?? this.notes,
      lastTransactionNote: lastTransactionNote ?? this.lastTransactionNote,
      lastTransactionDate: lastTransactionDate ?? this.lastTransactionDate,
      currentBalance: currentBalance ?? this.currentBalance,
    );
  }
}

@immutable
class LedgerEntry {
  const LedgerEntry({
    required this.id,
    required this.partyId,
    required this.date,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balanceAfter,
    this.paymentMethod = PaymentMethod.cash,
    this.notes = '',
    this.kind = TransactionKind.receive,
  });

  final String id;
  final String partyId;
  final DateTime date;
  final String description;
  final double debit;
  final double credit;
  final double balanceAfter;
  final PaymentMethod paymentMethod;
  final String notes;
  final TransactionKind kind;
}

@immutable
class CashEntry {
  const CashEntry({
    required this.id,
    required this.businessId,
    required this.isInflow,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    this.paymentMethod = PaymentMethod.cash,
  });

  final String id;
  final String businessId;
  final bool isInflow;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final PaymentMethod paymentMethod;
}

@immutable
class Product {
  const Product({
    required this.id,
    required this.businessId,
    required this.name,
    required this.category,
    required this.sku,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantity,
    required this.minStock,
    this.unit = ProductUnit.pieces,
    this.barcode = '',
    this.description = '',
  });

  final String id;
  final String businessId;
  final String name;
  final String category;
  final String sku;
  final double purchasePrice;
  final double sellingPrice;
  final double quantity;
  final double minStock;
  final ProductUnit unit;
  final String barcode;
  final String description;

  bool get isLowStock => quantity > 0 && quantity <= minStock;
  bool get isOutOfStock => quantity <= 0;
  double get stockValue => quantity * purchasePrice;

  Product copyWith({double? quantity, double? sellingPrice, double? purchasePrice}) {
    return Product(
      id: id,
      businessId: businessId,
      name: name,
      category: category,
      sku: sku,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      quantity: quantity ?? this.quantity,
      minStock: minStock,
      unit: unit,
      barcode: barcode,
      description: description,
    );
  }
}

@immutable
class LineItem {
  const LineItem({
    required this.productId,
    required this.name,
    required this.qty,
    required this.rate,
    this.discount = 0,
  });

  final String productId;
  final String name;
  final double qty;
  final double rate;
  final double discount;

  double get amount => (qty * rate) - discount;
}

@immutable
class SaleRecord {
  const SaleRecord({
    required this.id,
    required this.businessId,
    required this.invoiceNo,
    required this.customerId,
    required this.customerName,
    required this.date,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.grandTotal,
    required this.amountReceived,
    required this.status,
    this.notes = '',
  });

  final String id;
  final String businessId;
  final String invoiceNo;
  final String customerId;
  final String customerName;
  final DateTime date;
  final List<LineItem> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double grandTotal;
  final double amountReceived;
  final InvoiceStatus status;
  final String notes;

  double get remaining => grandTotal - amountReceived;
}

@immutable
class PurchaseRecord {
  const PurchaseRecord({
    required this.id,
    required this.businessId,
    required this.purchaseNo,
    required this.supplierId,
    required this.supplierName,
    required this.date,
    required this.items,
    required this.grandTotal,
    required this.paidAmount,
    required this.status,
  });

  final String id;
  final String businessId;
  final String purchaseNo;
  final String supplierId;
  final String supplierName;
  final DateTime date;
  final List<LineItem> items;
  final double grandTotal;
  final double paidAmount;
  final InvoiceStatus status;
}

@immutable
class InvoiceRecord {
  const InvoiceRecord({
    required this.id,
    required this.businessId,
    required this.number,
    required this.customerId,
    required this.customerName,
    required this.date,
    required this.dueDate,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.grandTotal,
    required this.paid,
    required this.status,
  });

  final String id;
  final String businessId;
  final String number;
  final String customerId;
  final String customerName;
  final DateTime date;
  final DateTime dueDate;
  final List<LineItem> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double grandTotal;
  final double paid;
  final InvoiceStatus status;

  double get balance => grandTotal - paid;
}

@immutable
class ExpenseRecord {
  const ExpenseRecord({
    required this.id,
    required this.businessId,
    required this.category,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    required this.description,
    this.reference = '',
  });

  final String id;
  final String businessId;
  final String category;
  final double amount;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final String description;
  final String reference;
}

@immutable
class StaffMember {
  const StaffMember({
    required this.id,
    required this.businessId,
    required this.name,
    required this.role,
    required this.phone,
    required this.monthlySalary,
    this.attendanceToday = AttendanceStatus.present,
    this.advanceBalance = 0,
    this.bonusTotal = 0,
    this.overtimeHours = 0,
  });

  final String id;
  final String businessId;
  final String name;
  final StaffRole role;
  final String phone;
  final double monthlySalary;
  final AttendanceStatus attendanceToday;
  final double advanceBalance;
  final double bonusTotal;
  final double overtimeHours;

  StaffMember copyWith({AttendanceStatus? attendanceToday, double? advanceBalance}) {
    return StaffMember(
      id: id,
      businessId: businessId,
      name: name,
      role: role,
      phone: phone,
      monthlySalary: monthlySalary,
      attendanceToday: attendanceToday ?? this.attendanceToday,
      advanceBalance: advanceBalance ?? this.advanceBalance,
      bonusTotal: bonusTotal,
      overtimeHours: overtimeHours,
    );
  }
}

@immutable
class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.read = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime time;
  final bool read;
}

@immutable
class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isCredit,
  });

  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final bool isCredit;
}

@immutable
class DemoUserProfile {
  const DemoUserProfile({
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    this.businessName,
    this.businessCategory,
    this.pinEnabled = true,
    this.biometricEnabled = false,
  });

  final String name;
  final String phone;
  final String email;
  final StaffRole role;
  final String? businessName;
  final String? businessCategory;
  final bool pinEnabled;
  final bool biometricEnabled;

  factory DemoUserProfile.fromJson(Map<String, dynamic> json) => DemoUserProfile(
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        role: StaffRole.values.firstWhere(
          (r) => r.name == (json['role'] as String? ?? 'owner'),
          orElse: () => StaffRole.owner,
        ),
        businessName: json['businessName'] as String?,
        businessCategory: json['businessCategory'] as String?,
        pinEnabled: json['pinEnabled'] as bool? ?? true,
        biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'role': role.name,
        'businessName': businessName,
        'businessCategory': businessCategory,
        'pinEnabled': pinEnabled,
        'biometricEnabled': biometricEnabled,
      };
}

String paymentMethodLabel(PaymentMethod m) {
  switch (m) {
    case PaymentMethod.cash:
      return 'Cash';
    case PaymentMethod.bankTransfer:
      return 'Bank Transfer';
    case PaymentMethod.easypaisa:
      return 'Easypaisa';
    case PaymentMethod.jazzCash:
      return 'JazzCash';
    case PaymentMethod.card:
      return 'Card';
    case PaymentMethod.cheque:
      return 'Cheque';
    case PaymentMethod.other:
      return 'Other';
  }
}

String invoiceStatusLabel(InvoiceStatus s) {
  switch (s) {
    case InvoiceStatus.paid:
      return 'Paid';
    case InvoiceStatus.partial:
      return 'Partial';
    case InvoiceStatus.unpaid:
      return 'Unpaid';
    case InvoiceStatus.overdue:
      return 'Overdue';
  }
}
