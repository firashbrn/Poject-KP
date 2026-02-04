import '../entities/cuti.dart';

abstract class CutiRepository {
  // Pegawai
  Future<void> mengajukanCuti({
    required String jenisCuti,
    required String tanggalMulai,
    required String tanggalSelesai,
    required String alasan,
    String? fileBukti,
  });

  Future<List<Cuti>> getRiwayatCuti();
  Future<void> batalkanCuti(int cutiId);

  // Atasan
  Future<List<Cuti>> getListPengajuanBawahan(); // Filter by sub-unit internally or via API
  Future<void> setujuiCuti(int cutiId);
  Future<void> tolakCuti(int cutiId, String catatan);
}
