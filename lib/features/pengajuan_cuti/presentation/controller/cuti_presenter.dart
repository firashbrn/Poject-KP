import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../domain/entities/cuti.dart';
import '../../domain/usecase/approve_cuti_usecase.dart';
import '../../domain/usecase/create_cuti_usecase.dart';
import '../../domain/usecase/get_list_cuti_bawahan_usecase.dart';
import '../../domain/usecase/get_list_cuti_usecase.dart';
import '../../domain/usecase/reject_cuti_usecase.dart';

class CutiPresenter extends Presenter {
  final CreateCutiUseCase _createCutiUseCase;
  final GetListCutiUseCase _getListCutiUseCase;
  final GetListCutiBawahanUseCase _getListCutiBawahanUseCase;
  final ApproveCutiUseCase _approveCutiUseCase;
  final RejectCutiUseCase _rejectCutiUseCase;

  CutiPresenter(
    this._createCutiUseCase,
    this._getListCutiUseCase,
    this._getListCutiBawahanUseCase,
    this._approveCutiUseCase,
    this._rejectCutiUseCase,
  );

  @override
  void dispose() {
    _createCutiUseCase.dispose();
    _getListCutiUseCase.dispose();
    _getListCutiBawahanUseCase.dispose();
    _approveCutiUseCase.dispose();
    _rejectCutiUseCase.dispose();
  }

  // Observers
  Function(void)? onCreateSuccess;
  Function(dynamic)? onCreateError;

  Function(List<Cuti>)? onGetListSuccess;
  Function(dynamic)? onGetListError;

  Function(List<Cuti>)? onGetListBawahanSuccess;
  Function(dynamic)? onGetListBawahanError;

  Function(void)? onApproveSuccess;
  Function(dynamic)? onApproveError;

  Function(void)? onRejectSuccess;
  Function(dynamic)? onRejectError;

  void createCuti(CreateCutiParams params) {
    _createCutiUseCase.execute(_CreateObserver(this), params);
  }

  void getListCuti() {
    _getListCutiUseCase.execute(_GetListObserver(this), null);
  }

  void getListBawahan() {
    _getListCutiBawahanUseCase.execute(_GetListBawahanObserver(this), null);
  }

  void approveCuti(int cutiId) {
    _approveCutiUseCase.execute(_ApproveObserver(this), cutiId);
  }

  void rejectCuti(RejectCutiParams params) {
    _rejectCutiUseCase.execute(_RejectObserver(this), params);
  }
}

class _CreateObserver implements Observer<void> {
  final CutiPresenter _presenter;
  _CreateObserver(this._presenter);
  @override
  void onNext(void response) => _presenter.onCreateSuccess?.call(null);
  @override
  void onComplete() {}
  @override
  void onError(e) => _presenter.onCreateError?.call(e);
}

class _GetListObserver implements Observer<List<Cuti>> {
  final CutiPresenter _presenter;
  _GetListObserver(this._presenter);
  @override
  void onNext(List<Cuti>? response) {
    if (response != null) _presenter.onGetListSuccess?.call(response);
  }
  @override
  void onComplete() {}
  @override
  void onError(e) => _presenter.onGetListError?.call(e);
}

class _GetListBawahanObserver implements Observer<List<Cuti>> {
  final CutiPresenter _presenter;
  _GetListBawahanObserver(this._presenter);
  @override
  void onNext(List<Cuti>? response) {
    if (response != null) _presenter.onGetListBawahanSuccess?.call(response);
  }
  @override
  void onComplete() {}
  @override
  void onError(e) => _presenter.onGetListBawahanError?.call(e);
}

class _ApproveObserver implements Observer<void> {
  final CutiPresenter _presenter;
  _ApproveObserver(this._presenter);
  @override
  void onNext(void response) => _presenter.onApproveSuccess?.call(null);
  @override
  void onComplete() {}
  @override
  void onError(e) => _presenter.onApproveError?.call(e);
}

class _RejectObserver implements Observer<void> {
  final CutiPresenter _presenter;
  _RejectObserver(this._presenter);
  @override
  void onNext(void response) => _presenter.onRejectSuccess?.call(null);
  @override
  void onComplete() {}
  @override
  void onError(e) => _presenter.onRejectError?.call(e);
}
