import '../../domain/repositories/izin_repository.dart';
import '../../domain/entities/izin.dart';
import '../datasources/izin_remote_datasource.dart';
import '../models/izin_model.dart';

class IzinRepositoryImpl implements IzinRepository {
  final IzinRemoteDataSource _dataSource;

  IzinRepositoryImpl(this._dataSource);

  @override
  Future<void> batalkanIzin(int izinId) async {
    await _dataSource.batalkanIzin(izinId);
  }

  @override
  Future<List<Izin>> getListPengajuanBawahan() async {
    return await _dataSource.getListPengajuanBawahan();
  }

  @override
  Future<List<Izin>> getRiwayatIzin() async {
    return await _dataSource.getRiwayatIzin();
  }

  @override
  Future<void> mengajukanIzin({
    required String jenisIzin,
    required String tanggalMulai,
    required String tanggalSelesai,
    required String alasan,
    String? fileBukti,
  }) async {
    final model = IzinModel(
      jenisIzin: jenisIzin,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      alasan: alasan,
      fileBukti: fileBukti,
    );
    await _dataSource.mengajukanIzin(model.toJson());
  }

  @override
  Future<void> setujuiIzin(int izinId) async {
    await _dataSource.setujuiIzin(izinId);
  }

  @override
  Future<void> tolakIzin(int izinId, String catatan) async {
    await _dataSource.tolakIzin(izinId, catatan);
  }
}
