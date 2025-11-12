import '../constants/api_constants.dart';
import '../models/pain_record_model.dart';
import 'api_service.dart';

class PainService {
  static final PainService _instance = PainService._internal();
  factory PainService() => _instance;
  PainService._internal();

  final ApiService _apiService = ApiService();

  /// Criar novo registro de dor
  Future<PainRecordModel> createPainRecord({
    required String bodyPart,
    required int intensity,
    String? description,
    List<String>? symptoms,
    DateTime? timestamp,
  }) async {
    try {
      final body = {
        'body_part': bodyPart,
        'intensity': intensity,
      };

      if (description != null && description.isNotEmpty) {
        body['description'] = description;
      }
      if (symptoms != null && symptoms.isNotEmpty) {
        body['symptoms'] = symptoms;
      }
      if (timestamp != null) {
        body['timestamp'] = timestamp.toIso8601String();
      }

      final response = await _apiService.post(
        ApiConstants.pain,
        body: body,
        requiresAuth: true,
      );

      return PainRecordModel.fromJson(response['pain_record']);
    } catch (e) {
      rethrow;
    }
  }

  /// Listar registros de dor com filtros opcionais
  Future<List<PainRecordModel>> getPainRecords({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final response = await _apiService.get(
        ApiConstants.pain,
        requiresAuth: true,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final List<dynamic> records = response['pain_records'] as List<dynamic>;
      return records.map((json) => PainRecordModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Buscar registro específico por ID
  Future<PainRecordModel> getPainRecordById(int id) async {
    try {
      final response = await _apiService.get(
        ApiConstants.painById(id),
        requiresAuth: true,
      );

      return PainRecordModel.fromJson(response['pain_record']);
    } catch (e) {
      rethrow;
    }
  }

  /// Atualizar registro de dor
  Future<PainRecordModel> updatePainRecord({
    required int id,
    String? bodyPart,
    int? intensity,
    String? description,
    List<String>? symptoms,
  }) async {
    try {
      final body = <String, dynamic>{};
      
      if (bodyPart != null) body['body_part'] = bodyPart;
      if (intensity != null) body['intensity'] = intensity;
      if (description != null) body['description'] = description;
      if (symptoms != null) body['symptoms'] = symptoms;

      final response = await _apiService.put(
        ApiConstants.painById(id),
        body: body,
        requiresAuth: true,
      );

      return PainRecordModel.fromJson(response['pain_record']);
    } catch (e) {
      rethrow;
    }
  }

  /// Deletar registro de dor
  Future<void> deletePainRecord(int id) async {
    try {
      await _apiService.delete(
        ApiConstants.painById(id),
        requiresAuth: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Buscar estatísticas de dor
  Future<PainStatisticsModel> getPainStatistics({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final response = await _apiService.get(
        ApiConstants.painStatistics,
        requiresAuth: true,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return PainStatisticsModel.fromJson(response['statistics']);
    } catch (e) {
      rethrow;
    }
  }
}
