import '../../domain/repositories/cuti_repository.dart';
import '../../domain/entities/cuti.dart';
import '../datasources/cuti_remote_datasource.dart';
import '../models/cuti_model.dart';

class CutiRepositoryImpl implements CutiRepository {
  final CutiRemoteDataSource _dataSource;

  CutiRepositoryImpl(this._dataSource);

  @override
  Future<void> batalkanCuti(int cutiId) async {
    await _dataSource.batalkanCuti(cutiId);
  }

  @override
  Future<List<Cuti>> getListPengajuanBawahan() async {
    return await _dataSource.getListPengajuanBawahan();
  }

  @override
  Future<List<Cuti>> getRiwayatCuti() async {
    return await _dataSource.getRiwayatCuti();
  }

  @override
  Future<void> mengajukanCuti({
    required String jenisCuti,
    required String tanggalMulai,
    required String tanggalSelesai,
    required String alasan,
    String? fileBukti,
  }) async {
    final model = CutiModel(
      jenisCuti: jenisCuti,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      alasan: alasan,
      fileBukti: fileBukti,
    );
    await _dataSource.mengajukanCuti(model.toJson());
  }

  @override
  Future<void> setujuiCuti(int cutiId) async {
    await _dataSource.setujuiCuti(cutiId);
  }

  @override
  Future<void> tolakCuti(int cutiId, String catatan) async {
    await _dataSource.tolakCuti(cutiId, catatan);
  }
}
