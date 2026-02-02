import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'forgotPassword_presenter.dart';

class ForgotpasswordController extends Controller{
  final ForgotpasswordPresenter _presenter;
  ForgotpasswordController(this._presenter);

  int currentStep = 1;
  bool isLoading = false;

  final nipController = TextEditingController();
  final otpController = TextEditingController();
  final newpasswordController = TextEditingController();

  @override
  void initListeners() {
    _presenter.onRequestOtpSuccess = () {
      isLoading = false;
      currentStep = 2;
      refreshUI();
    };

    _presenter.onVerifyOtpSuccess = () {
      isLoading = false;
      currentStep = 3;
      refreshUI();
    };

    _presenter.onResetPasswordSuccess = () {
      isLoading = false;
      Navigator.of(getContext()).pop(); // Go back to login page
    };

    _presenter.OnError = (e) {
      isLoading = false;
      String cleanMessage = e.toString();
      if (cleanMessage.contains('ServerException:')) {
        cleanMessage = cleanMessage.replaceAll('ServerException:', '').trim();
      } else if (cleanMessage.contains('ServerFailure:')) {
        cleanMessage = cleanMessage.replaceAll('ServerFailure:', '').trim();
      } else if (cleanMessage.contains('Exception:')) {
        cleanMessage = cleanMessage.replaceAll('Exception:', '').trim();
      }

      // Show error dialog
      showDialog(
        context: getContext(),
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(cleanMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );

      refreshUI();
    };
   
  }
  void next() {
    if (isLoading) return; 

    isLoading = true;
    refreshUI();

    if (currentStep == 1) {
      _presenter.requestOtp(nipController.text);
    } else if (currentStep == 2) {
      _presenter.verifyOtp(nipController.text, otpController.text);
    } else if (currentStep == 3) {
      _presenter.resetPassword(nipController.text, newpasswordController.text);
    }
  }

  void previous() {
    if (isLoading) return; 

    if (currentStep > 1) {
      currentStep--;
      refreshUI();
    } else {
      Navigator.of(getContext()).pop(); 
    }
  }
  
  @override
  void onDisposed() {
    nipController.dispose();
    otpController.dispose();
    newpasswordController.dispose();
    _presenter.dispose();
    super.onDisposed();
  }
}