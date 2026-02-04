import '../../domain/entities/izin.dart';

class IzinModel extends Izin {
  const IzinModel({
    super.id,
    super.userId,
    super.namaUser,
    super.jenisIzin,
    super.tanggalMulai,
    super.tanggalSelesai,
    super.alasan,
    super.fileBukti,
    super.status,
    super.catatanPenolakan,
    super.unitKerja,
  });

  factory IzinModel.fromJson(Map<String, dynamic> json) {
    return IzinModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      userId: json['user_id']?.toString(),
      namaUser: json['user_name'] ?? json['nama_lengkap'],
      jenisIzin: json['jenis_izin'] ?? json['jenis'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
      alasan: json['alasan'],
      fileBukti: json['file_bukti'],
      status: json['status'],
      catatanPenolakan: json['catatan_penolakan'],
      unitKerja: json['unit_kerja'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jenis_izin': jenisIzin,
      'tanggal_mulai': tanggalMulai,
      'tanggal_selesai': tanggalSelesai,
      'alasan': alasan,
      'file_bukti': fileBukti,
    };
  }
}
