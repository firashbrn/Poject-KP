import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/user_providers.dart';
import '../../../banner/domain/entities/banner_entity.dart';
import '../../../kehadiran/domain/entities/kehadiran.dart';
import 'dashboard_presenter.dart';

class DashboardController extends Controller {
  final DashboardPresenter _presenter;

  DashboardController(this._presenter);

  // State
  bool isLoading = false;
  String? errorMessage;
  Attendance? todayAttendance;
  Map<String, dynamic>? rawTodayStatus; // For raw data display if needed
  List<BannerEntity>? banners;

  @override
  void initListeners() {
    _presenter.onCheckInSuccess = (Attendance data) {
      isLoading = false;
      todayAttendance = data; // Update local state
      errorMessage = null;
      refreshUI();
      // Optionally show success message
      ScaffoldMessenger.of(getContext()).showSnackBar(
        SnackBar(content: Text('Check-in Berhasil: ${data.checkInTime}')),
      );
    };

    _presenter.onCheckInError = (e) {
      isLoading = false;
      errorMessage = e.toString();
      refreshUI();
      ScaffoldMessenger.of(getContext()).showSnackBar(
        SnackBar(content: Text('Check-in Gagal: $errorMessage')),
      );
    };

    _presenter.onCheckOutSuccess = (Attendance data) {
      isLoading = false;
      todayAttendance = data;
      errorMessage = null;
      refreshUI();
      ScaffoldMessenger.of(getContext()).showSnackBar(
        SnackBar(content: Text('Check-out Berhasil')),
      );
    };

    _presenter.onCheckOutError = (e) {
      isLoading = false;
      errorMessage = e.toString();
      refreshUI();
      ScaffoldMessenger.of(getContext()).showSnackBar(
        SnackBar(content: Text('Check-out Gagal: $errorMessage')),
      );
    };

    _presenter.onGetTodaySuccess = (Map<String, dynamic> data) {
      isLoading = false;
      rawTodayStatus = data;
      // You might want to map this to Attendance entity if possible
      // todayAttendance = AttendanceModel.fromJson(data); 
      refreshUI();
    };

    _presenter.onGetTodayError = (e) {
      isLoading = false;
      // Don't show error for getToday, just log or ignore
      refreshUI();
    };

    _presenter.onGetBannersSuccess = (List<BannerEntity> data) {
       banners = data;
       refreshUI();
    };

    _presenter.onGetBannersError = (e) {
       print('Error getting banners: $e');
       // refreshUI(); // Optional, might not want to refresh on banner fail
    };
  }

  @override
  void onInitState() {
    super.onInitState();
    getTodayStatus();
    getBanners();
  }

  void getBanners() {
    _presenter.getBanners();
  }

  void getTodayStatus() {
    // isLoading = true; // Optional, maybe don't block UI for init load
    _presenter.getTodayAttendance();
  }

  void checkIn(double lat, double long) {
    isLoading = true;
    refreshUI();
    _presenter.checkIn(lat, long);
  }

  void checkOut(double lat, double long) {
    isLoading = true;
    refreshUI();
    _presenter.checkOut(lat, long);
  }

  void logout() {
    try {
        ProviderScope.containerOf(
          getContext(),
          listen: false,
        ).read(userProvider.notifier).logout();
        Navigator.of(getContext()).pushReplacementNamed('/login');
    } catch(e) {
       print("Logout error: $e");
    }
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }
}
