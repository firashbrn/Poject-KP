import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../domain/entities/izin.dart';
import '../../domain/usecase/approve_izin_usecase.dart';
import '../../domain/usecase/create_izin_usecase.dart';
import '../../domain/usecase/get_list_izin_bawahan_usecase.dart';
import '../../domain/usecase/get_list_izin_usecase.dart';
import '../../domain/usecase/reject_izin_usecase.dart';

class IzinPresenter extends Presenter {
  final CreateIzinUseCase _createIzinUseCase;
  final GetListIzinUseCase _getListIzinUseCase;
  final GetListIzinBawahanUseCase _getListIzinBawahanUseCase;
  final ApproveIzinUseCase _approveIzinUseCase;
  final RejectIzinUseCase _rejectIzinUseCase;

  IzinPresenter(
    this._createIzinUseCase,
    this._getListIzinUseCase,
    this._getListIzinBawahanUseCase,
    this._approveIzinUseCase,
    this._rejectIzinUseCase,
  );

  @override
  void dispose() {
    _createIzinUseCase.dispose();
    _getListIzinUseCase.dispose();
    _getListIzinBawahanUseCase.dispose();
    _approveIzinUseCase.dispose();
    _rejectIzinUseCase.dispose();
  }

  Function(void)? onCreateSuccess;
  Function(dynamic)? onCreateError;

  Function(List<Izin>)? onGetListSuccess;
  Function(dynamic)? onGetListError;

  Function(List<Izin>)? onGetListBawahanSuccess;
  Function(dynamic)? onGetListBawahanError;

  Function(void)? onApproveSuccess;
  Function(dynamic)? onApproveError;

  Function(void)? onRejectSuccess;
  Function(dynamic)? onRejectError;

  void createIzin(CreateIzinParams params) {
    _createIzinUseCase.execute(_CreateObserver(this), params);
  }

  void getListIzin() {
    _getListIzinUseCase.execute(_GetListObserver(this), null);
  }

  void getListBawahan() {
    _getListIzinBawahanUseCase.execute(_GetListBawahanObserver(this), null);
  }

  void approveIzin(int izinId) {
    _approveIzinUseCase.execute(_ApproveObserver(this), izinId);
  }

  void rejectIzin(RejectIzinParams params) {
    _rejectIzinUseCase.execute(_RejectObserver(this), params);
  }
}

class _CreateObserver implements Observer<void> {
  final IzinPresenter _presenter;
  _CreateObserver(this._presenter);
  @override
  void onNext(void response) => _presenter.onCreateSuccess?.call(null);
  @override
  void onComplete() {}
  @override
  void onError(e) => _presenter.onCreateError?.call(e);
}

class _GetListObserver implements Observer<List<Izin>> {
  final IzinPresenter _presenter;
  _GetListObserver(this._presenter);
  @override
  void onNext(List<Izin>? response) {
    if (response != null) _presenter.onGetListSuccess?.call(response);
  }
  @override
  void onComplete() {}
  @override
  void onError(e) => _presenter.onGetListError?.call(e);
}

class _GetListBawahanObserver implements Observer<List<Izin>> {
  final IzinPresenter _presenter;
  _GetListBawahanObserver(this._presenter);
  @override
  void onNext(List<Izin>? response) {
    if (response != null) _presenter.onGetListBawahanSuccess?.call(response);
  }
  @override
  void onComplete() {}
  @override
  void onError(e) => _presenter.onGetListBawahanError?.call(e);
}

class _ApproveObserver implements Observer<void> {
  final IzinPresenter _presenter;
  _ApproveObserver(this._presenter);
  @override
  void onNext(void response) => _presenter.onApproveSuccess?.call(null);
  @override
  void onComplete() {}
  @override
  void onError(e) => _presenter.onApproveError?.call(e);
}

class _RejectObserver implements Observer<void> {
  final IzinPresenter _presenter;
  _RejectObserver(this._presenter);
  @override
  void onNext(void response) => _presenter.onRejectSuccess?.call(null);
  @override
  void onComplete() {}
  @override
  void onError(e) => _presenter.onRejectError?.call(e);
}
