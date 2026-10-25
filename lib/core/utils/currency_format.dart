import 'package:intl/intl.dart';

class CurrencyFormat {
  static final _fmt = NumberFormat.currency(locale: 'en_PK', symbol: 'Rs. ', decimalDigits: 0);

  static String format(num amount) => _fmt.format(amount);

  static String formatCompact(num amount) {
    if (amount.abs() >= 100000) {
      return 'Rs. ${(amount / 100000).toStringAsFixed(1)}L';
    }
    return format(amount);
  }
}
