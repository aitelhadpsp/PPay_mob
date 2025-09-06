import 'package:denta_incomes/models/api_response_dto.dart';
import 'package:denta_incomes/models/patient_dto.dart';
import 'package:denta_incomes/utils/api_client.dart';

class PatientService {
  static const String _baseEndpoint = '/patients';

  static Future<ApiResponse<PaginatedResponse<PatientDto>>> getPatients({
    String? searchTerm ="",
    int page = 1,
    int pageSize = 20,
    String? sortBy,
    bool sortDescending = false,
    Map<String, String>? filters,
  }) async {
   final queryParams = <String, String>{
      'page': page.toString(),
      'pageSize': pageSize.toString(),
      'sortDescending': sortDescending.toString(),
    };

      queryParams['searchTerm'] = searchTerm??" ";

    if (sortBy != null && sortBy.isNotEmpty) {
      queryParams['sortBy'] = sortBy;
    }

    if (filters != null) {
      filters.forEach((key, value) {
        queryParams['filters[$key]'] = value;
      });
    }
    return ApiClient.get<PaginatedResponse<PatientDto>>(
      _baseEndpoint,
      queryParams: queryParams,
      fromJson: (data) => PaginatedResponse<PatientDto>.fromJson(
        data,
        (json) => PatientDto.fromJson(json),
      ),
    );
  }

  // New method for paginated patient search
  static Future<ApiResponse<PaginatedResponse<PatientSummaryDto>>> searchPatientsWithPagination({
    String? searchTerm ="",
    int page = 1,
    int pageSize = 20,
    String? sortBy,
    bool sortDescending = false,
    Map<String, String>? filters,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'pageSize': pageSize.toString(),
      'sortDescending': sortDescending.toString(),
    };

      queryParams['searchTerm'] = searchTerm??" ";

    if (sortBy != null && sortBy.isNotEmpty) {
      queryParams['sortBy'] = sortBy;
    }

    if (filters != null) {
      filters.forEach((key, value) {
        queryParams['filters[$key]'] = value;
      });
    }

    return ApiClient.get<PaginatedResponse<PatientSummaryDto>>(
      '$_baseEndpoint/search',
      queryParams: queryParams,
      fromJson: (data) => PaginatedResponse<PatientSummaryDto>.fromJson(
        data,
        (json) => PatientSummaryDto.fromJson(json),
      ),
    );
  }

  static Future<ApiResponse<List<PatientSummaryDto>>> getActivePatients() async {
    return ApiClient.get<List<PatientSummaryDto>>(
      '$_baseEndpoint/active',
      fromJson: (data) => (data as List)
          .map((e) => PatientSummaryDto.fromJson(e))
          .toList(),
    );
  }

  static Future<ApiResponse<List<PatientSummaryDto>>> searchPatients(
      String searchTerm) async {
    return ApiClient.get<List<PatientSummaryDto>>(
      '$_baseEndpoint/search',
      queryParams: {'searchTerm': searchTerm},
      fromJson: (data) => (data as List)
          .map((e) => PatientSummaryDto.fromJson(e))
          .toList(),
    );
  }

  static Future<ApiResponse<PatientDto>> getPatient(int id) async {
    return ApiClient.get<PatientDto>(
      '$_baseEndpoint/$id',
      fromJson: (data) => PatientDto.fromJson(data),
    );
  }

  static Future<ApiResponse<PatientWithTreatmentsDto>> getPatientWithTreatments(
      int id) async {
    return ApiClient.get<PatientWithTreatmentsDto>(
      '$_baseEndpoint/$id/with-treatments',
      fromJson: (data) => PatientWithTreatmentsDto.fromJson(data),
    );
  }

  static Future<ApiResponse<PatientDto>> getPatientByReference(
      String reference) async {
    return ApiClient.get<PatientDto>(
      '$_baseEndpoint/reference/$reference',
      fromJson: (data) => PatientDto.fromJson(data),
    );
  }

  static Future<ApiResponse<PatientDto>> createPatient(
      CreatePatientDto dto) async {
    return ApiClient.post<PatientDto>(
      _baseEndpoint,
      body: dto.toJson(),
      fromJson: (data) => PatientDto.fromJson(data),
    );
  }

  static Future<ApiResponse<PatientDto>> updatePatient(
      int id, UpdatePatientDto dto) async {
    return ApiClient.put<PatientDto>(
      '$_baseEndpoint/$id',
      body: dto.toJson(),
      fromJson: (data) => PatientDto.fromJson(data),
    );
  }

  static Future<ApiResponse<bool>> deactivatePatient(int id) async {
    return ApiClient.patch<bool>(
      '$_baseEndpoint/$id/deactivate',
      fromJson: (data) => data as bool,
    );
  }

  static Future<ApiResponse<bool>> deletePatient(int id) async {
    return ApiClient.delete<bool>(
      '$_baseEndpoint/$id',
      fromJson: (data) => data as bool,
    );
  }

  static Future<ApiResponse<String>> generateReference() async {
    return ApiClient.get<String>(
      '$_baseEndpoint/generate-reference',
      fromJson: (data) => data as String,
    );
  }

  static Future<ApiResponse<bool>> validateReference(
      String reference, int? excludePatientId) async {
    final queryParams = excludePatientId != null 
        ? {'excludePatientId': excludePatientId.toString()}
        : null;
        
    return ApiClient.get<bool>(
      '$_baseEndpoint/validate/reference/$reference',
      queryParams: queryParams,
      fromJson: (data) => data as bool,
    );
  }
}