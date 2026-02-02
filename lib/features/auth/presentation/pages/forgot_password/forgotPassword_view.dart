import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:presensi_application_1/features/auth/presentation/pages/forgot_password/forgotPassword_controller.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/widgets/form/custom_password_field.dart';
import '../../../../../core/widgets/form/custom_text_field.dart';

class ForgotpasswordView extends CleanView {
  const ForgotpasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotpasswordView> createState() => _ForgotpasswordViewState();
}

class _ForgotpasswordViewState extends CleanViewState<ForgotpasswordView, ForgotpasswordController> {
  _ForgotpasswordViewState() : super(sl<ForgotpasswordController>());
  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(title: const Text('Lupa Kata Sandi')),
      body: ControlledWidgetBuilder<ForgotpasswordController>(
        builder: (context, controller) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text("Langkah ${controller.currentStep} dari 3"),
                
                const SizedBox(height: 20),
                
                // Menampilkan Section berdasarkan Step
                if (controller.currentStep == 1) _buildNipSection(controller),
                if (controller.currentStep == 2) _buildOtpSection(controller),
                if (controller.currentStep == 3) _buildResetSection(controller),
                
                const SizedBox(height: 20),
                
                if (controller.isLoading) 
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: controller.next,
                    child: Text(controller.currentStep == 3 ? 'Simpan' : 'Lanjut'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNipSection(ForgotpasswordController controller) {
    return CustomTextField(controller: controller.nipController, label: 'Masukkan NIP');
  }

  Widget _buildOtpSection(ForgotpasswordController controller) {
    return CustomTextField(controller: controller.otpController, label: 'Masukkan Kode OTP');
  }

  Widget _buildResetSection(ForgotpasswordController controller) {
    return CustomPasswordField(controller: controller.newpasswordController, label: 'Password Baru');
  }
}