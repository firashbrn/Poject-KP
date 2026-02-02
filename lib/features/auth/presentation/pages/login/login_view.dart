import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/form/custom_button.dart';
import '../../../../../core/widgets/form/custom_password_field.dart';
import '../../../../../core/widgets/form/custom_text_field.dart';
import 'login_controller.dart';


class LoginView extends CleanView {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState extends CleanViewState<LoginView, LoginController> {
  LoginViewState() : super(sl<LoginController>());

  final TextEditingController nipController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children:[
            ControlledWidgetBuilder<LoginController>(
              builder: (context, controller) {
                return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/Login.json'),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: nipController,
                label: 'Nomor Induk Pegawai',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              CustomPasswordField(
                controller: passwordController,
                label: 'Kata sandi',
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Masuk',
                isLoading: controller.isLoading,
                onPressed: controller.login,
                icon: Icons.login,
              ),
              const SizedBox(height: 24),
              TextButton(
                  onPressed: controller.navigateToForgotPassword,
                  child: const Text('Lupa Kata Sandi'))
            ],
          );
              },
            ),
          ],
        ),
    )
    );
    }
  }