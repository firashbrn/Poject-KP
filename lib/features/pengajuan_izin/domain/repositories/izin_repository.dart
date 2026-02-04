import '../entities/izin.dart';

abstract class IzinRepository {
  Future<void> mengajukanIzin({
    required String jenisIzin,
    required String tanggalMulai,
    required String tanggalSelesai,
    required String alasan,
    String? fileBukti,
  });

  Future<List<Izin>> getRiwayatIzin();
  Future<void> batalkanIzin(int izinId);

  Future<List<Izin>> getListPengajuanBawahan();
  Future<void> setujuiIzin(int izinId);
  Future<void> tolakIzin(int izinId, String catatan);
}
