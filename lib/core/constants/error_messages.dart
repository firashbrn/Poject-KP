class AppStrings {
  // Errors
  static const String serverError = 'Terjadi kesalahan server';
  static const String networkError = 'Tidak ada koneksi internet';
  static const String invalidCredentials = 'NIP atau Kata Sandi salah';
  static const String fillAllFields = 'Harap isi semua kolom';
  static const String invalidNip = 'NIP tidak valid';
  static const String otpInvalid = 'Kode OTP tidak valid';
  static const String outsideRadius = 'Lokasi di luar radius kantor';
  static const String alreadyCheckin = 'Sudah check-in hari ini';
  static const String alreadyCheckout = 'Sudah check-out hari ini';

  // UI Auth
  static const String loginTitle = 'Login';
  static const String ssoTitle = 'Single Sign On Kota Padang';
  static const String nipLabel = 'Nomor Induk Pegawai';
  static const String passwordLabel = 'Kata Sandi';
  static const String loginButton = 'Masuk';
  static const String forgotPassword = 'Lupa Password?';
  static const String otpLabel = 'Kode OTP';

  // UI Absensi
  static const String checkinButton = 'Masuk';
  static const String checkoutButton = 'Pulang';
  static const String statusBelumAbsen = 'Belum Absen';
  static const String statusHadir = 'Hadir';
  static const String statusTerlambat = 'Terlambat';
  static const String distanceLabel = 'Jarak: ';

  // UI Perizinan/Koreksi
  static const String izinCuti = 'Izin/Cuti';
  static const String koreksiAbsen = 'Koreksi Absen';
  static const String alasanLabel = 'Alasan';
  static const String buktiLabel = 'Bukti (opsional)';

  // Success messages
  static const String loginSuccess = 'Selamat datang, ';
  static const String checkinSuccess = 'Absen Masuk berhasil';
  static const String checkoutSuccess = 'Absen Pulang berhasil';
  static const String pengajuanSuccess = 'Pengajuan berhasil diajukan';
}
