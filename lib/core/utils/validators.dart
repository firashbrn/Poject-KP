class Validators {

  static final RegExp _passwordRegex = RegExp(
  r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$',
);


//Validate NIP
  static String? validateNip(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIP tidak boleh kosong';
    }
   if (value.length != 18) {
      return 'NIP harus terdiri dari 18 digit';
    }
    return null;
  }

//Validate Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata Sandi tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Kata Sandi harus terdiri dari minimal 8 karakter';
    }
    if (!_passwordRegex.hasMatch(value)) {
      return 'Kata Sandi harus mengandung huruf besar, huruf kecil, dan angka';
    }
    return null;
  }

}