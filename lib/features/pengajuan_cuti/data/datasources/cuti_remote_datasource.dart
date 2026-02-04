import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/cuti_model.dart';

abstract class CutiRemoteDataSource {
  Future<void> mengajukanCuti(Map<String, dynamic> body);
  Future<List<CutiModel>> getRiwayatCuti();
  Future<void> batalkanCuti(int cutiId);
  Future<List<CutiModel>> getListPengajuanBawahan();
  Future<void> setujuiCuti(int cutiId);
  Future<void> tolakCuti(int cutiId, String catatan);
}

class CutiRemoteDataSourceImpl implements CutiRemoteDataSource {
  final ApiClient _apiClient;

  CutiRemoteDataSourceImpl(this._apiClient);

  @override
  Future<void> mengajukanCuti(Map<String, dynamic> body) async {
    // Requires multipart/form-data usually if file included
    // For now assuming JSON or simple multipart
    try {
      if (body['file_bukti'] != null) {
          // If file handling needed:
          // FormData formData = FormData.fromMap(body);
          // await _apiClient.dio.post(ApiConstants.ajukanIzinCuti, data: formData);
          // Keeping it simple as per instructions "fileBukti" is string path/base64?
      }
      // Using JSON for now as per Model
      await _apiClient.post(ApiConstants.ajukanIzinCuti, data: body);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengajukan cuti');
    }
  }

  @override
  Future<List<CutiModel>> getRiwayatCuti() async {
    try {
      final response = await _apiClient.get(ApiConstants.riwayatIzinCuti);
      // Assuming response.data is List or {data: List}
      final List data = (response.data['data'] ?? response.data) as List;
      // Filter only "CUTI" if API returns mixed
      return data
          .map((e) => CutiModel.fromJson(e))
          .where((e) => (e.jenisCuti ?? '').toUpperCase().contains('CUTI')) // Weak filter?
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat riwayat');
    }
  }

  @override
  Future<List<CutiModel>> getListPengajuanBawahan() async {
    try {
      final response = await _apiClient.get(ApiConstants.listIzinCuti);
       final List data = (response.data['data'] ?? response.data) as List;
      return data.map((e) => CutiModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat list bawahan');
    }
  }

  @override
  Future<void> batalkanCuti(int cutiId) async {
      // Endpoint depends on API, assuming standard DELETE or POST
      // await _apiClient.dio.post('${ApiConstants.ajukanIzinCuti}/cancel/$cutiId');
      throw UnimplementedError("API Cancel implementation needed");
  }

  @override
  Future<void> setujuiCuti(int cutiId) async {
    try {
      await _apiClient.post(ApiConstants.setujuIzinCuti, data: {
        'id': cutiId,
        'status': 'DISETUJUI',
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menyetujui');
    }
  }

  @override
  Future<void> tolakCuti(int cutiId, String catatan) async {
    try {
      await _apiClient.post(ApiConstants.setujuIzinCuti, data: {
        'id': cutiId,
        'status': 'DITOLAK',
        'catatan': catatan,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menolak');
    }
  }
}
