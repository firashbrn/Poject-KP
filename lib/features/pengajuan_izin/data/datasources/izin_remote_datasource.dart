import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/izin_model.dart';

abstract class IzinRemoteDataSource {
  Future<void> mengajukanIzin(Map<String, dynamic> body);
  Future<List<IzinModel>> getRiwayatIzin();
  Future<void> batalkanIzin(int izinId);
  Future<List<IzinModel>> getListPengajuanBawahan();
  Future<void> setujuiIzin(int izinId);
  Future<void> tolakIzin(int izinId, String catatan);
}

class IzinRemoteDataSourceImpl implements IzinRemoteDataSource {
  final ApiClient _apiClient;

  IzinRemoteDataSourceImpl(this._apiClient);

  @override
  Future<void> mengajukanIzin(Map<String, dynamic> body) async {
    try {
      if (body['file_bukti'] != null) {
          // File logic if needed
      }
      
      
      await _apiClient.post(ApiConstants.ajukanIzinCuti, data: body);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengajukan izin');
    }
  }

  @override
  Future<List<IzinModel>> getRiwayatIzin() async {
    try {
      final response = await _apiClient.get(ApiConstants.riwayatIzinCuti);
      final List data = (response.data['data'] ?? response.data) as List;
      // Filter logic might be needed if API returns mixed
      return data
          .map((e) => IzinModel.fromJson(e))
          .where((e) => (e.jenisIzin ?? '').toUpperCase() != 'CUTI') // Assuming Cuti is explicit type
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat riwayat');
    }
  }

  @override
  Future<List<IzinModel>> getListPengajuanBawahan() async {
    try {
      final response = await _apiClient.get(ApiConstants.listIzinCuti);
       final List data = (response.data['data'] ?? response.data) as List;
       // Assuming this endpoint returns both Cuti & Izin for subordinates
      return data
        .map((e) => IzinModel.fromJson(e))
        .where((e) => (e.jenisIzin ?? '').toUpperCase() != 'CUTI') 
        .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat list bawahan');
    }
  }

  @override
  Future<void> batalkanIzin(int izinId) async {
      throw UnimplementedError("API Cancel implementation needed");
  }

  @override
  Future<void> setujuiIzin(int izinId) async {
    try {
      await _apiClient.post(ApiConstants.setujuIzinCuti, data: {
        'id': izinId,
        'status': 'DISETUJUI',
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menyetujui');
    }
  }

  @override
  Future<void> tolakIzin(int izinId, String catatan) async {
    try {
      await _apiClient.post(ApiConstants.setujuIzinCuti, data: {
        'id': izinId,
        'status': 'DITOLAK',
        'catatan': catatan,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menolak');
    }
  }
}
