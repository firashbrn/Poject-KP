class ApiConstants {
  // Base URL
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/apim',
  );

  //ENDPOINTS
  //auth
  static const String Login = '/api/login';
  static const String refreshToken = '/api/refresh-token';
  static const String getProfile = '/api/asn/profile';

  //password management
  static const String changePassword = '/api/asn/password';
  static const String forgotPassword = '/api/forgot-password/request';
  static const String verifyOTP = '/api/forgot-password/verify';
  static const String resetPassword = '/api/forgot-password/reset';

  //kehadiran
  static const String absenMasuk = '/api/kehadiran/checkin';
  static const String absenPulang = '/api/kehadiran/checkout';
  static const String riwayatKehadiran = '/api/kehadiran/riwayat';
  static const String statusKehadiranHariIni = '/api/kehadiran/status-hari-ini';
  static const String rekapKehadiran = '/api/kehadiran/rekap';

  //perizinan cuti
  static const String ajukanIzinCuti = '/api/perizinan/cuti';
  static const String riwayatIzinCuti = '/api/perizinan/riwayat';
  static const String setujuIzinCuti = '/api/perizinan/approval';
  static const String listIzinCuti = '/api/perizinan/bawahan';

  //koreksi absen
  static const String koreksiAbsen = '/api/koreksi/ajukan';
  static const String riwayatKoreksiAbsen = '/api/koreksi/riwayat';
  static const String listKoreksi = '/api/koreksi/bawahan';
  static const String approveKoreksi = '/api/koreksi/approval';

  //banner
  static const String banner = '/api/banner';

  //TIMEOUTS
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}