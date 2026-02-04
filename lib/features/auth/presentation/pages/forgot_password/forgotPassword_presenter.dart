import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../domain/usecase/fogot-password/requestOTP_usecase.dart';
import '../../../domain/usecase/fogot-password/resetPasswod_usecase.dart';
import '../../../domain/usecase/fogot-password/verifyOTP_usecase.dart';

class ForgotpasswordPresenter extends Presenter {
  final RequestotpUsecase _requestotpUsecase;
  final VerifyOtpUseCase _verifyOtpUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;

  ForgotpasswordPresenter(this._requestotpUsecase, this._verifyOtpUsecase, this._resetPasswordUsecase);

  late Function onRequestOtpSuccess;
  late Function onVerifyOtpSuccess;
  late Function onResetPasswordSuccess;
  late Function(dynamic) OnError;

  void requestOtp(String nip) {
    _requestotpUsecase.execute(_RequestOtpObserver(this), RequestOtpParams(nip));
  }

  void verifyOtp(String nip, String otp) {
    _verifyOtpUsecase.execute(_VerifyOtpObserver(this), VerifyOtpParams(nip, otp));
  }

  void resetPassword(String nip, String newPassword, String otp) {
    _resetPasswordUsecase.execute(
        _ResetPasswordObserver(this), ResetPasswordParams(nip, newPassword, otp));
  }

  @override
  void dispose() {
    _requestotpUsecase.dispose();
    _verifyOtpUsecase.dispose();
    _resetPasswordUsecase.dispose();
  }

}
class _ResetPasswordObserver extends Observer<String> {
  final ForgotpasswordPresenter _presenter;
  _ResetPasswordObserver(this._presenter);

  @override
  void onNext(response) => _presenter.onResetPasswordSuccess();

  @override
  void onError(e) => _presenter.OnError(e);

  @override
  void onComplete() {}
}

class _VerifyOtpObserver extends Observer<String> {
  final ForgotpasswordPresenter _presenter;
  _VerifyOtpObserver(this._presenter);

  @override
  void onNext(response) => _presenter.onVerifyOtpSuccess();

  @override
  void onError(e) => _presenter.OnError(e);

  @override
  void onComplete() {}
}

class _RequestOtpObserver extends Observer<String> {
  final ForgotpasswordPresenter _presenter;
  _RequestOtpObserver(this._presenter);

  @override
  void onNext(response) => _presenter.onRequestOtpSuccess();


  @override
  void onError(e) => _presenter.OnError(e);

  @override
  void onComplete() {}
}