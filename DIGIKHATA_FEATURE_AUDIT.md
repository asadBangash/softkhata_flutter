# Soft Khata — DigiKhata-style feature audit (demo build)

**Mode:** Local mock data via `AppState` (`ChangeNotifier` + `Provider`).  
**Entry:** `lib/main.dart` → `DemoSplashScreen` → `MainShell`  
**Legacy API app:** preserved under `lib/ui`, `lib/bloc`, `lib/data` — run with `flutter run -t lib/main_legacy.dart`

| Feature | Status | Screen(s) | Notes |
|---------|--------|-----------|-------|
| Dashboard | Complete | `screens/home/home_dashboard_screen.dart` | Balances, modules, activity, invoices, low stock |
| Bottom navigation | Complete | `screens/shell/main_shell.dart` | Home, Parties, Transactions, Reports, More |
| Parties / Khata | Complete | `screens/parties/*` | Tabs, search, add party, filters |
| Party ledger profile | Complete | `party_detail_screen.dart` | Transactions, details, notes, reminder sheet |
| Receive / Give money | Complete | `transaction_form_screen.dart` | Updates ledger + cash locally |
| Transactions list | Complete | `transactions_screen.dart` | Filters |
| Cash book | Complete | `screens/cash/cash_book_screen.dart` | In/out, categories, date chips |
| Stock book | Complete | `screens/stock/*` | Products, add, detail, adjust stock |
| Sales | Complete | `screens/sales/*` | List + create sale |
| Purchases | Complete | `screens/purchases/*` | List + create purchase, stock + supplier |
| Invoices / Bill book | Complete | `screens/invoices/*` | List, preview, create, share/demo PDF |
| Expense book | Complete | `screens/expenses/expense_book_screen.dart` | Categories, filters |
| Staff book | Complete | `screens/staff/*` | Attendance, salary actions (demo) |
| Reports | Complete | `screens/reports/reports_screen.dart` | Cards + `fl_chart` dummy charts |
| Payment reminders | Complete | `widgets/payment_reminder_sheet.dart` | SMS/WhatsApp/copy/share |
| Business management | Complete | `screens/business/business_management_screen.dart` | Switch/add business |
| Users & permissions | Complete | `screens/users/permissions_screen.dart` | Role UI simulation |
| Notifications | Complete | `screens/notifications/notifications_screen.dart` | Mark read |
| Global search | Complete | `screens/search/global_search_screen.dart` | Grouped results |
| Profile | Complete | `screens/profile/demo_profile_screen.dart` | |
| Settings | Complete | `screens/settings/demo_settings_screen.dart` | Backup/demo actions |
| Security UI | Complete | `screens/settings/security_screen.dart` | PIN/biometric switches |
| More menu | Complete | `screens/more/more_screen.dart` | All modules linked |

## Dummy data volume (seed)

Approximate per business (Asad Traders bundle + variants for Skyline / Demo Wholesale):

- 20+ parties (customers, suppliers, banks)
- 30 products
- 30+ ledger/cash movements
- 15 invoices, 15 expenses, 10 purchases, sales records
- 8 staff, notifications, activities

See `lib/mock/mock_seed_data.dart`.

## Reused from original project

- App name, logo asset (`assets/icons/logo.svg`)
- Josefin font family
- Primary brand color `#1B5DA8`
- Original API layer untouched: `lib/data/remote/*`, `lib/bloc/*`, legacy UI under `lib/ui/*`

## Preserved for later API integration

| Component | Path |
|-----------|------|
| HTTP data source | `lib/data/remote/api_data_source.dart` |
| Repository | `lib/data/remote/app_repository.dart` |
| BLoC cubits | `lib/bloc/**` |
| Endpoints | `lib/utils/end_points.dart`, `app_constants.dart` |
| Legacy routes | `lib/navigation/app_routes.dart` |

**Suggested swap:** Introduce interfaces under `lib/data/repositories/` and bind `AppState` (or new cubits) to `ApiCustomerRepository` etc., while keeping UI on shared models in `lib/models/domain_models.dart`.

## APIs to connect later

- Auth: login, signup
- User profile get/update
- Customer CRUD + ledger entries
- Entry CRUD
- (New backend work needed for stock, sales, invoices, staff — not in current Node API)

## Run commands

```bash
cd soft_khata_flutter
flutter pub get
flutter run                    # demo app
flutter run -t lib/main_legacy.dart   # original API app
flutter analyze lib/main.dart lib/screens lib/services lib/mock lib/models lib/core lib/widgets lib/routes lib/theme
```
