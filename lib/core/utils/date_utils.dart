// core/utils/date_utils.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtils {

  static String formatDate(DateTime date) {
    return DateFormat('EEEE, d MMM yyyy', 'id_ID').format(date);
  }

  /// Format untuk Jam Realtime (Contoh: 08:30)
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm', 'id_ID').format(date);
  }
  
  /// Cek apakah tanggal adalah hari ini
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  /// Cek apakah sudah lewat jam check-in kantor (misal jam 8 pagi)
  static bool isAfterCheckinTime(DateTime dateTime, {TimeOfDay checkinTime = const TimeOfDay(hour: 8, minute: 0)}) {
    final now = DateTime.now();
    final todayCheckin = DateTime(now.year, now.month, now.day, checkinTime.hour, checkinTime.minute);
    return dateTime.isAfter(todayCheckin);
  }

  /// Cek apakah dalam rentang shift kantor
  static bool isWithinShift(DateTime dateTime, TimeOfDay jamMasuk, TimeOfDay jamPulang) {
    final now = DateTime.now();
    final todayMasuk = DateTime(now.year, now.month, now.day, jamMasuk.hour, jamMasuk.minute);
    final todayPulang = DateTime(now.year, now.month, now.day, jamPulang.hour, jamPulang.minute);
    return dateTime.isAfter(todayMasuk) && dateTime.isBefore(todayPulang);
  }

  /// Hitung selisih hari dari sekarang
  static int daysDifference(DateTime date) {
    final now = DateTime.now();
    return date.difference(now).inDays;
  }

  /// Ambil tanggal awal bulan
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Ambil tanggal akhir bulan
  static DateTime lastDayOfMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1));
  }

  /// Parse string tanggal dari backend
  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat('yyyy-MM-dd', 'id_ID').parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
