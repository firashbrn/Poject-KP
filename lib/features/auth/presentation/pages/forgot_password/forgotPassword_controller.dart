import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../../../core/utils/validators.dart';
import 'forgotPassword_presenter.dart';

// ignore: unused_element
class ForgotpasswordController extends Controller{
  final ForgotpasswordPresenter _presenter;
  ForgotpasswordController(this._presenter);

  int currentStep = 1;
  bool isLoading = false;
  String? errorMessage; // Added error message state

  final nipController = TextEditingController();
  final otpController = TextEditingController();
  final newpasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); // Added Confirm Password Controller

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

      errorMessage = cleanMessage; // Set inline error message
      refreshUI();
    };
  }

  void showError(String message) {
    showDialog(
        context: getContext(),
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            )
          ],
        )
    );
  }
  void next() {
    if (isLoading) return; 

    isLoading = true;
    errorMessage = null; // Clear previous errors
    refreshUI();

    if (currentStep == 1) {
      print("[DEBUG] NIP Input: '${nipController.text}'"); // Debug Log
      _presenter.requestOtp(nipController.text.trim());
    } else if (currentStep == 2) {
      _presenter.verifyOtp(nipController.text, otpController.text);
    } else if (currentStep == 3) {
      // Validasi Ketat Password Baru
      final passwordError = Validators.validatePassword(newpasswordController.text);
      if (passwordError != null) {
        errorMessage = passwordError;
        isLoading = false;
        refreshUI();
        return;
      }

      if (newpasswordController.text != confirmPasswordController.text) {
        errorMessage = "Kata sandi tidak cocok!";
        isLoading = false;
        refreshUI();
        return;
      }
      _presenter.resetPassword(nipController.text, newpasswordController.text, otpController.text);
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