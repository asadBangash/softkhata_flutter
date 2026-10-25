import 'package:soft_khata_flutter/models/domain_models.dart';

class MockBusinessBundle {
  const MockBusinessBundle({
    required this.parties,
    required this.ledgerByParty,
    required this.cashEntries,
    required this.products,
    required this.sales,
    required this.purchases,
    required this.invoices,
    required this.expenses,
    required this.staff,
    required this.notifications,
    required this.activities,
    this.openingCash = 50000,
  });

  final List<Party> parties;
  final Map<String, List<LedgerEntry>> ledgerByParty;
  final List<CashEntry> cashEntries;
  final List<Product> products;
  final List<SaleRecord> sales;
  final List<PurchaseRecord> purchases;
  final List<InvoiceRecord> invoices;
  final List<ExpenseRecord> expenses;
  final List<StaffMember> staff;
  final List<AppNotificationItem> notifications;
  final List<ActivityItem> activities;
  final double openingCash;
}

class MockSeedData {
  MockSeedData._();

  static const String asadId = 'biz-asad';
  static const String skylineId = 'biz-skyline';
  static const String demoId = 'biz-demo';

  static final List<BusinessProfile> businesses = [
    const BusinessProfile(
      id: asadId,
      name: 'Asad Traders',
      owner: 'Asad Khan',
      phone: '+92 300 1234567',
      email: 'asad@asadtraders.pk',
      address: 'Saddar, Rawalpindi',
      category: 'General Store',
    ),
    const BusinessProfile(
      id: skylineId,
      name: 'Skyline Store',
      owner: 'Skyline Retail',
      phone: '+92 321 7654321',
      email: 'info@skyline.store',
      address: 'Blue Area, Islamabad',
      category: 'Electronics',
    ),
    const BusinessProfile(
      id: demoId,
      name: 'Demo Wholesale',
      owner: 'Demo Owner',
      phone: '+92 333 1112233',
      email: 'demo@softkhata.app',
      address: 'Gulberg, Lahore',
      category: 'Wholesale',
    ),
  ];

  static MockBusinessBundle seedForBusiness(String businessId) {
    switch (businessId) {
      case asadId:
        return _asadBundle();
      case skylineId:
        return _skylineBundle();
      case demoId:
        return _demoBundle();
      default:
        return _emptyBundle(businessId);
    }
  }

  static MockBusinessBundle _emptyBundle(String businessId) {
    return MockBusinessBundle(
      parties: [],
      ledgerByParty: {},
      cashEntries: [],
      products: [],
      sales: [],
      purchases: [],
      invoices: [],
      expenses: [],
      staff: [],
      notifications: [],
      activities: [],
    );
  }

  static DateTime _d(int dayOffset) =>
      DateTime.now().subtract(Duration(days: dayOffset));

  static MockBusinessBundle _asadBundle() {
    const c1 = 'p-asad-c1';
    const c2 = 'p-asad-c2';
    const s1 = 'p-asad-s1';
    const b1 = 'p-asad-b1';

    final parties = [
      Party(
        id: c1,
        businessId: asadId,
        type: PartyType.customer,
        name: 'Ali General Store',
        phone: '0300-1111111',
        currentBalance: 12500,
        lastTransactionNote: 'Urgent payment pending',
        lastTransactionDate: _d(1),
      ),
      Party(
        id: c2,
        businessId: asadId,
        type: PartyType.customer,
        name: 'Hamza Mart',
        phone: '0321-2222222',
        currentBalance: 8200,
        lastTransactionDate: _d(3),
      ),
      Party(
        id: s1,
        businessId: asadId,
        type: PartyType.supplier,
        name: 'Metro Distributors',
        phone: '0333-3333333',
        currentBalance: -15600,
        balanceSide: BalanceSide.youWillGive,
        lastTransactionDate: _d(2),
      ),
      Party(
        id: b1,
        businessId: asadId,
        type: PartyType.bank,
        name: 'HBL Current A/C',
        phone: '021-111111',
        currentBalance: 245000,
      ),
    ];

    final ledger = {
      c1: [
        LedgerEntry(
          id: 'le-1',
          partyId: c1,
          date: _d(5),
          description: 'Opening balance',
          debit: 15000,
          credit: 0,
          balanceAfter: 15000,
          kind: TransactionKind.opening,
        ),
        LedgerEntry(
          id: 'le-2',
          partyId: c1,
          date: _d(1),
          description: 'Partial payment received',
          debit: 0,
          credit: 2500,
          balanceAfter: 12500,
          kind: TransactionKind.receive,
          paymentMethod: PaymentMethod.cash,
        ),
      ],
      s1: [
        LedgerEntry(
          id: 'le-3',
          partyId: s1,
          date: _d(4),
          description: 'Stock purchase on credit',
          debit: 0,
          credit: 15600,
          balanceAfter: -15600,
          kind: TransactionKind.purchase,
        ),
      ],
    };

    return MockBusinessBundle(
      parties: parties,
      ledgerByParty: ledger,
      openingCash: 85000,
      cashEntries: [
        CashEntry(
          id: 'ce-1',
          businessId: asadId,
          isInflow: true,
          amount: 2500,
          category: 'Collection',
          description: 'From Ali General Store',
          date: _d(1),
        ),
        CashEntry(
          id: 'ce-2',
          businessId: asadId,
          isInflow: false,
          amount: 1200,
          category: 'Shop expense',
          description: 'Electricity bill',
          date: _d(2),
        ),
      ],
      products: [
        Product(
          id: 'pr-1',
          businessId: asadId,
          name: 'Surf Excel 1kg',
          category: 'Detergent',
          sku: 'SE-1K',
          purchasePrice: 420,
          sellingPrice: 480,
          quantity: 48,
          minStock: 10,
        ),
        Product(
          id: 'pr-2',
          businessId: asadId,
          name: 'Cooking Oil 5L',
          category: 'Grocery',
          sku: 'CO-5L',
          purchasePrice: 2100,
          sellingPrice: 2350,
          quantity: 6,
          minStock: 8,
        ),
      ],
      sales: [
        SaleRecord(
          id: 'sa-1',
          businessId: asadId,
          invoiceNo: 'INV-1001',
          customerId: c1,
          customerName: 'Ali General Store',
          date: _d(2),
          items: const [
            LineItem(productId: 'pr-1', name: 'Surf Excel 1kg', qty: 10, rate: 480),
          ],
          subtotal: 4800,
          discount: 0,
          tax: 0,
          grandTotal: 4800,
          amountReceived: 2000,
          status: InvoiceStatus.partial,
        ),
      ],
      purchases: [],
      invoices: [
        InvoiceRecord(
          id: 'inv-1',
          businessId: asadId,
          number: 'INV-1001',
          customerId: c1,
          customerName: 'Ali General Store',
          date: _d(2),
          dueDate: _d(-5),
          items: const [
            LineItem(productId: 'pr-1', name: 'Surf Excel 1kg', qty: 10, rate: 480),
          ],
          subtotal: 4800,
          discount: 0,
          tax: 0,
          grandTotal: 4800,
          paid: 2000,
          status: InvoiceStatus.partial,
        ),
      ],
      expenses: [
        ExpenseRecord(
          id: 'ex-1',
          businessId: asadId,
          category: 'Utilities',
          amount: 1200,
          date: _d(2),
          paymentMethod: PaymentMethod.cash,
          description: 'Electricity',
        ),
      ],
      staff: [
        StaffMember(
          id: 'st-1',
          businessId: asadId,
          name: 'Usman',
          role: StaffRole.cashier,
          phone: '0345-9999999',
          monthlySalary: 35000,
        ),
      ],
      notifications: [
        AppNotificationItem(
          id: 'n-1',
          title: 'Low stock alert',
          body: 'Cooking Oil 5L is below minimum stock.',
          time: _d(0),
        ),
      ],
      activities: [
        ActivityItem(
          id: 'a-1',
          title: 'Payment received',
          subtitle: 'Ali General Store',
          amount: 2500,
          date: _d(1),
          isCredit: true,
        ),
        ActivityItem(
          id: 'a-2',
          title: 'Sale invoice',
          subtitle: 'INV-1001',
          amount: 4800,
          date: _d(2),
          isCredit: true,
        ),
      ],
    );
  }

  static MockBusinessBundle _skylineBundle() {
    const c1 = 'p-sky-c1';
    final parties = [
      Party(
        id: c1,
        businessId: skylineId,
        type: PartyType.customer,
        name: 'Tech Hub Pvt Ltd',
        phone: '051-4444444',
        currentBalance: 45000,
        lastTransactionDate: _d(0),
      ),
      Party(
        id: 'p-sky-s1',
        businessId: skylineId,
        type: PartyType.supplier,
        name: 'Samsung Pakistan',
        phone: '042-5555555',
        currentBalance: -89000,
        balanceSide: BalanceSide.youWillGive,
      ),
    ];

    return MockBusinessBundle(
      parties: parties,
      ledgerByParty: {
        c1: [
          LedgerEntry(
            id: 'le-s1',
            partyId: c1,
            date: _d(1),
            description: 'LED TVs x 5',
            debit: 45000,
            credit: 0,
            balanceAfter: 45000,
            kind: TransactionKind.sale,
          ),
        ],
      },
      openingCash: 120000,
      cashEntries: [
        CashEntry(
          id: 'ce-s1',
          businessId: skylineId,
          isInflow: true,
          amount: 15000,
          category: 'Sale',
          description: 'Walk-in customer',
          date: _d(0),
        ),
      ],
      products: [
        Product(
          id: 'pr-s1',
          businessId: skylineId,
          name: '32" Smart TV',
          category: 'Electronics',
          sku: 'TV-32',
          purchasePrice: 28000,
          sellingPrice: 32000,
          quantity: 12,
          minStock: 3,
        ),
      ],
      sales: [
        SaleRecord(
          id: 'sa-s1',
          businessId: skylineId,
          invoiceNo: 'SKY-501',
          customerId: c1,
          customerName: 'Tech Hub Pvt Ltd',
          date: _d(1),
          items: const [
            LineItem(productId: 'pr-s1', name: '32" Smart TV', qty: 5, rate: 32000),
          ],
          subtotal: 160000,
          discount: 5000,
          tax: 0,
          grandTotal: 155000,
          amountReceived: 110000,
          status: InvoiceStatus.partial,
        ),
      ],
      purchases: [],
      invoices: [],
      expenses: [
        ExpenseRecord(
          id: 'ex-s1',
          businessId: skylineId,
          category: 'Rent',
          amount: 45000,
          date: _d(5),
          paymentMethod: PaymentMethod.bankTransfer,
          description: 'Shop rent',
        ),
      ],
      staff: [
        StaffMember(
          id: 'st-s1',
          businessId: skylineId,
          name: 'Sara',
          role: StaffRole.salesman,
          phone: '0300-8888888',
          monthlySalary: 42000,
        ),
      ],
      notifications: [],
      activities: [
        ActivityItem(
          id: 'a-s1',
          title: 'New sale',
          subtitle: 'Tech Hub Pvt Ltd',
          amount: 155000,
          date: _d(1),
          isCredit: true,
        ),
      ],
    );
  }

  static MockBusinessBundle _demoBundle() {
    return MockBusinessBundle(
      parties: [
        Party(
          id: 'p-demo-c1',
          businessId: demoId,
          type: PartyType.customer,
          name: 'Sample Customer',
          phone: '0300-0000001',
          currentBalance: 5000,
        ),
        Party(
          id: 'p-demo-s1',
          businessId: demoId,
          type: PartyType.supplier,
          name: 'Sample Supplier',
          phone: '0300-0000002',
          currentBalance: -3000,
          balanceSide: BalanceSide.youWillGive,
        ),
      ],
      ledgerByParty: {},
      openingCash: 25000,
      cashEntries: [],
      products: [
        Product(
          id: 'pr-d1',
          businessId: demoId,
          name: 'Demo Product',
          category: 'General',
          sku: 'DEMO-1',
          purchasePrice: 100,
          sellingPrice: 150,
          quantity: 100,
          minStock: 20,
        ),
      ],
      sales: [],
      purchases: [],
      invoices: [],
      expenses: [],
      staff: [],
      notifications: [],
      activities: [],
    );
  }
}
