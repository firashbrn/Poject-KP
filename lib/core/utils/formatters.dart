// core/utils/formatters.dart
import 'package:intl/intl.dart';

class Formatters {
  /// Format date to readable string
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  /// Format date with time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dateTime);
  }

  /// Format currency (IDR)
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  /// Format number with thousand separator
  static String formatNumber(int number) {
    return NumberFormat.decimalPattern('id_ID').format(number);
  }

  /// Format phone number
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digits
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Format: 0812-3456-7890
    if (digits.length >= 10) {
      return '${digits.substring(0, 4)}-${digits.substring(4, 8)}-${digits.substring(8)}';
    }

    return phoneNumber;
  }
}