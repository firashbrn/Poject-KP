import '../../domain/entities/cuti.dart';

class CutiModel extends Cuti {
  const CutiModel({
    super.id,
    super.userId,
    super.namaUser,
    super.jenisCuti,
    super.tanggalMulai,
    super.tanggalSelesai,
    super.alasan,
    super.fileBukti,
    super.status,
    super.catatanPenolakan,
    super.unitKerja,
  });

  factory CutiModel.fromJson(Map<String, dynamic> json) {
    return CutiModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      userId: json['user_id']?.toString(), // Adjust based on actual API
      namaUser: json['user_name'] ?? json['nama_lengkap'], // Adjust
      jenisCuti: json['jenis_cuti'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
      alasan: json['alasan'],
      fileBukti: json['file_bukti'],
      status: json['status'], // MENUNGGU, DISETUJUI, DITOLAK
      catatanPenolakan: json['catatan_penolakan'],
      unitKerja: json['unit_kerja'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jenis_cuti': jenisCuti,
      'tanggal_mulai': tanggalMulai,
      'tanggal_selesai': tanggalSelesai,
      'alasan': alasan,
      'file_bukti': fileBukti,
    };
  }
}
