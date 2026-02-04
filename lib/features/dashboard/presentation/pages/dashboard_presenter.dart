import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../banner/domain/entities/banner_entity.dart';
import '../../../banner/domain/usecases/get_banners_usecase.dart';
import '../../../kehadiran/domain/entities/kehadiran.dart';
import '../../../kehadiran/domain/usecase/kehadiran/checkin_usecase.dart';
import '../../../kehadiran/domain/usecase/kehadiran/checkout_usecase.dart';
import '../../../kehadiran/domain/usecase/kehadiran/get_today_attendance_usecase.dart';


class DashboardPresenter extends Presenter {
  final CheckInUseCase _checkInUseCase;
  final CheckOutUseCase _checkOutUseCase;
  final GetTodayAttendanceUseCase _getTodayAttendanceUseCase;
  final GetBannersUseCase _getBannersUseCase;

  DashboardPresenter(
    this._checkInUseCase,
    this._checkOutUseCase,
    this._getTodayAttendanceUseCase,
    this._getBannersUseCase,
  );

  Function(Attendance)? onCheckInSuccess;
  Function(dynamic)? onCheckInError;

  Function(Attendance)? onCheckOutSuccess;
  Function(dynamic)? onCheckOutError;

  Function(Map<String, dynamic>)? onGetTodaySuccess;
  Function(dynamic)? onGetTodayError;

  Function(List<BannerEntity>)? onGetBannersSuccess;
  Function(dynamic)? onGetBannersError;

  void checkIn(double lat, double long) {
    _checkInUseCase.execute(
      _CheckInObserver(this),
      CheckInParams(lat: lat, long: long),
    );
  }

  void checkOut(double lat, double long) {
    _checkOutUseCase.execute(
      _CheckOutObserver(this),
      CheckOutParams(lat: lat, long: long),
    );
  }

  void getTodayAttendance() {
    _getTodayAttendanceUseCase.execute(_GetTodayObserver(this), null);
  }

  void getBanners() {
    _getBannersUseCase.execute(_GetBannersObserver(this), null);
  }

  @override
  void dispose() {
    _checkInUseCase.dispose();
    _checkOutUseCase.dispose();
    _getTodayAttendanceUseCase.dispose();
    _getBannersUseCase.dispose();
  }
}

class _CheckInObserver implements Observer<Attendance> {
  final DashboardPresenter _presenter;
  _CheckInObserver(this._presenter);

  @override
  void onNext(Attendance? response) {
    if (response != null) {
      _presenter.onCheckInSuccess?.call(response);
    }
  }

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.onCheckInError?.call(e);
  }
}

class _CheckOutObserver implements Observer<Attendance> {
  final DashboardPresenter _presenter;
  _CheckOutObserver(this._presenter);

  @override
  void onNext(Attendance? response) {
    if (response != null) {
      _presenter.onCheckOutSuccess?.call(response);
    }
  }

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.onCheckOutError?.call(e);
  }
}

class _GetTodayObserver implements Observer<Map<String, dynamic>> {
  final DashboardPresenter _presenter;
  _GetTodayObserver(this._presenter);

  @override
  void onNext(Map<String, dynamic>? response) {
    if (response != null) {
      _presenter.onGetTodaySuccess?.call(response);
    }
  }

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.onGetTodayError?.call(e);
  }
}

class _GetBannersObserver implements Observer<List<BannerEntity>> {
  final DashboardPresenter _presenter;
  _GetBannersObserver(this._presenter);

  @override
  void onNext(List<BannerEntity>? response) {
    if (response != null) {
      _presenter.onGetBannersSuccess?.call(response);
    }
  }

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.onGetBannersError?.call(e);
  }
}
