import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/user_providers.dart';
import '../../../banner/domain/entities/banner_entity.dart';
import '../../../kehadiran/domain/entities/kehadiran.dart';
import 'dart:io';
import '../../../../core/device/repositories/gps_device.dart';
import '../../../../core/device/repositories/camera_device.dart';
import 'dashboard_presenter.dart';

class DashboardController extends Controller {
  final DashboardPresenter _presenter;
  final GpsDevice _gpsDevice;
  final CameraDevice _cameraDevice;

  DashboardController(this._presenter, this._gpsDevice, this._cameraDevice);

  // State
  bool isLoading = false;
  String? errorMessage;
  Attendance? todayAttendance;
  Map<String, dynamic>? rawTodayStatus; // For raw data display if needed
  List<BannerEntity>? banners;
  String currentAddress = "Memuat Lokasi..."; // Address State

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
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final hasPermission = await _gpsDevice.handleLocationPermission();
      if (hasPermission) {
        final position = await _gpsDevice.getCurrentPosition();
        final placemarks = await _gpsDevice.getAddressFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        
        String address = "${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.subAdministrativeArea ?? ''}";
        
        currentAddress = address.replaceAll(RegExp(r'^, |, $'), '').trim();
        
        if (currentAddress.isEmpty) currentAddress = "Lokasi ditemukan (Tanpa Nama Jalan)";
      } else {
        currentAddress = "Alamat tidak ditemukan";
      }
    } else {
      currentAddress = "Izin lokasi ditolak";
    }
  } catch (e) {
    print("Error getting location address: $e");
    // Show specific error for debugging
    currentAddress = "Error: ${e.toString().replaceAll('Exception:', '')}";
  } finally {
    refreshUI(); 
  }
}

  void getBanners() {
    _presenter.getBanners();
  }

  void getTodayStatus() {
    // isLoading = true; // Optional, maybe don't block UI for init load
    _presenter.getTodayAttendance();
  }

  
  // Office Coordinates (Placeholder)
  static const double officeLat = -1.6212165;
  static const double officeLong = 103.559952;
  static const double maxDistance = 100.0; // meters

  Future<void> _handleAttendance(bool isCheckIn) async {
    isLoading = true;
    refreshUI();

    try {
      // 1. Check Permissions & GPS
      final hasPermission = await _gpsDevice.handleLocationPermission();
      if (!hasPermission) {
        throw Exception("Location permission denied");
      }

      // 2. Get Location
      final position = await _gpsDevice.getCurrentPosition();
      final double lat = position.latitude;
      final double long = position.longitude;

      // 3. Calculate Distance
      final double distance = _gpsDevice.getDistanceBetween(
        lat,
        long,
        officeLat,
        officeLong,
      );

      print("Distance: $distance meters");

      if (distance <= maxDistance) {
        // Within Range
        if (isCheckIn) {
          _presenter.checkIn(lat, long);
        } else {
          _presenter.checkOut(lat, long);
        }
      } else {
        // Outside Range -> Require Photo
        ScaffoldMessenger.of(getContext()).showSnackBar(
          const SnackBar(content: Text('Anda berada di luar jangkauan (100m). Silahkan ambil foto.')),
        );
        
        final File? photo = await _cameraDevice.takePhoto();
        if (photo != null) {
          // Proceed with photo (Pass null or handle upload if backend supports it)
          // For now, we proceed as normal but logging the photo
          print("Photo taken: ${photo.path}");
          
          if (isCheckIn) {
            _presenter.checkIn(lat, long);
          } else {
            _presenter.checkOut(lat, long);
          }
        } else {
          isLoading = false;
          refreshUI();
          ScaffoldMessenger.of(getContext()).showSnackBar(
            const SnackBar(content: Text('Absensi dibatalkan (Foto wajib).')),
          );
        }
      }
    } catch (e) {
      isLoading = false;
      refreshUI();
      ScaffoldMessenger.of(getContext()).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void checkIn() {
    _handleAttendance(true);
  }

  void checkOut() {
    _handleAttendance(false);
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
