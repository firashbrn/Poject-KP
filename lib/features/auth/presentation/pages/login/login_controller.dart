import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:presensi_application_1/core/constants/api_constants.dart';
import 'package:presensi_application_1/core/utils/validators.dart';
import '../../../../../core/providers/user_providers.dart';
import '../../../domain/entities/user.dart';
import 'login_presenter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginController extends Controller {
  final LoginPresenter _presenter;

  LoginController(this._presenter);

  final TextEditingController nipController = TextEditingController(); 
  final TextEditingController passwordController = TextEditingController();

  // State
  bool isLoading = false;
  String? errorMessage;
  User? currentUser;

  @override
  void initListeners() {
    _presenter.onLoginSuccess = (User user) {
      isLoading = false;
      currentUser = user;

      // Update Global State (Riverpod)
      try {
        ProviderScope.containerOf(
          getContext(),
          listen: false,
        ).read(userProvider.notifier).setUser(user);
      } catch (e) {
        // Fallback or log if context or provider scope is missing (unlikely)
        print('Riverpod Error: $e');
      }

      errorMessage = null;
      refreshUI();
      Navigator.of(getContext()).pushReplacementNamed('/dashboard');
    };

    _presenter.onLoginError = (e) {
      isLoading = false;
      // Clean up error message prefix if present
      String cleanMessage = e.toString();
      if (cleanMessage.contains('ServerException:')) {
        cleanMessage = cleanMessage.replaceAll('ServerException:', '').trim();
      } else if (cleanMessage.contains('ServerFailure:')) {
        cleanMessage = cleanMessage.replaceAll('ServerFailure:', '').trim();
      } else if (cleanMessage.contains('Exception:')) {
        cleanMessage = cleanMessage.replaceAll('Exception:', '').trim();
      }

      errorMessage = cleanMessage;
      refreshUI();
      // SnackBar removed as per user request (duplicate alert)
    };
  }

  void login() {
    final nipError = Validators.validateNip(nipController.text);
    final passwordError = Validators.validatePassword(
      passwordController.text,
    );

    if (nipError == null && passwordError == null) {
      isLoading = true;
      errorMessage = null;
      refreshUI();
      _presenter.login(nipController.text, passwordController.text);
    } else {
      errorMessage = nipError ?? passwordError;
      refreshUI();
    }
  }

  void navigateToForgotPassword() {
    Navigator.of(
      getContext(),
    ).pushNamed(ApiConstants.forgotPassword); 
  }

  @override
  void onDisposed() {
    nipController.dispose();
    passwordController.dispose();
    _presenter.dispose(); // Ensure presenter is disposed
    super.onDisposed();
  }
}
