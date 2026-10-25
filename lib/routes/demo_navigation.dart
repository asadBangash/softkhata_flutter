import 'package:flutter/material.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/business/business_management_screen.dart';
import 'package:soft_khata_flutter/screens/cash/cash_book_screen.dart';
import 'package:soft_khata_flutter/screens/expenses/expense_book_screen.dart';
import 'package:soft_khata_flutter/screens/invoices/invoice_list_screen.dart';
import 'package:soft_khata_flutter/screens/notifications/notifications_screen.dart';
import 'package:soft_khata_flutter/screens/profile/demo_profile_screen.dart';
import 'package:soft_khata_flutter/screens/purchases/purchases_screen.dart';
import 'package:soft_khata_flutter/screens/sales/sales_screen.dart';
import 'package:soft_khata_flutter/screens/search/global_search_screen.dart';
import 'package:soft_khata_flutter/screens/settings/demo_settings_screen.dart';
import 'package:soft_khata_flutter/screens/settings/security_screen.dart';
import 'package:soft_khata_flutter/screens/staff/staff_book_screen.dart';
import 'package:soft_khata_flutter/screens/stock/stock_book_screen.dart';
import 'package:soft_khata_flutter/screens/transactions/transaction_form_screen.dart';
import 'package:soft_khata_flutter/screens/users/permissions_screen.dart';

class DemoNavigation {
  static void openCashBook(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const CashBookScreen()));
  }

  static void openStockBook(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const StockBookScreen()));
  }

  static void openSales(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const SalesScreen()));
  }

  static void openPurchases(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PurchasesScreen()));
  }

  static void openInvoices(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const InvoiceListScreen()));
  }

  static void openExpenses(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ExpenseBookScreen()));
  }

  static void openStaff(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const StaffBookScreen()));
  }

  static void openNotifications(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const NotificationsScreen()));
  }

  static void openSearch(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const GlobalSearchScreen()));
  }

  static void openProfile(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const DemoProfileScreen()));
  }

  static void openSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const DemoSettingsScreen()));
  }

  static void openSecurity(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const SecurityScreen()));
  }

  static void openBusinessManagement(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const BusinessManagementScreen()));
  }

  static void openPermissions(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PermissionsScreen()));
  }

  static void openReceiveMoney(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const TransactionFormScreen(initialKind: TransactionKind.receive),
      ),
    );
  }

  static void openGiveMoney(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const TransactionFormScreen(initialKind: TransactionKind.give),
      ),
    );
  }
}
