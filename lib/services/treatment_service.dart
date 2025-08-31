import 'package:denta_incomes/models/api_response_dto.dart';
import 'package:denta_incomes/models/treatment_dto.dart';
import 'package:denta_incomes/utils/api_client.dart';

class TreatmentService {
  static const String _baseEndpoint = '/treatments';

  // =============================
  // Treatment Templates Methods
  // =============================

  /// Get all treatment templates
  static Future<ApiResponse<List<TreatmentTemplateDto>>> getTreatmentTemplates() async {
    return ApiClient.get<List<TreatmentTemplateDto>>(
      '$_baseEndpoint/templates',
      fromJson: (data) => (data as List)
          .map((e) => TreatmentTemplateDto.fromJson(e))
          .toList(),
    );
  }

  /// Get active treatment templates only
  static Future<ApiResponse<List<TreatmentTemplateDto>>> getActiveTreatmentTemplates() async {
    return ApiClient.get<List<TreatmentTemplateDto>>(
      '$_baseEndpoint/templates/active',
      fromJson: (data) => (data as List)
          .map((e) => TreatmentTemplateDto.fromJson(e))
          .toList(),
    );
  }

  /// Get treatment template by ID
  static Future<ApiResponse<TreatmentTemplateDto>> getTreatmentTemplate(int id) async {
    return ApiClient.get<TreatmentTemplateDto>(
      '$_baseEndpoint/templates/$id',
      fromJson: (data) => TreatmentTemplateDto.fromJson(data),
    );
  }

  /// Get treatment templates by category
  static Future<ApiResponse<List<TreatmentTemplateDto>>> getTreatmentTemplatesByCategory(
      String category) async {
    return ApiClient.get<List<TreatmentTemplateDto>>(
      '$_baseEndpoint/templates/category/$category',
      fromJson: (data) => (data as List)
          .map((e) => TreatmentTemplateDto.fromJson(e))
          .toList(),
    );
  }

  /// Create new treatment template
  static Future<ApiResponse<TreatmentTemplateDto>> createTreatmentTemplate(
      CreateTreatmentTemplateDto dto) async {
    return ApiClient.post<TreatmentTemplateDto>(
      '$_baseEndpoint/templates',
      body: dto.toJson(),
      fromJson: (data) => TreatmentTemplateDto.fromJson(data),
    );
  }

  /// Update treatment template
  static Future<ApiResponse<TreatmentTemplateDto>> updateTreatmentTemplate(
      int id, UpdateTreatmentTemplateDto dto) async {
    return ApiClient.put<TreatmentTemplateDto>(
      '$_baseEndpoint/templates/$id',
      body: dto.toJson(),
      fromJson: (data) => TreatmentTemplateDto.fromJson(data),
    );
  }

  /// Deactivate treatment template
  static Future<ApiResponse<bool>> deactivateTreatmentTemplate(int id) async {
    return ApiClient.patch<bool>(
      '$_baseEndpoint/templates/$id/deactivate',
      fromJson: (data) => data is bool ? data : (data == true || data == 'true'),
    );
  }

  /// Delete treatment template (Admin only)
  static Future<ApiResponse<bool>> deleteTreatmentTemplate(int id) async {
    return ApiClient.delete<bool>(
      '$_baseEndpoint/templates/$id',
      fromJson: (data) => data is bool ? data : (data == true || data == 'true'),
    );
  }

  /// Get all treatment categories
  static Future<ApiResponse<List<String>>> getTreatmentCategories() async {
    return ApiClient.get<List<String>>(
      '$_baseEndpoint/categories',
      fromJson: (data) => (data as List).map((e) => e.toString()).toList(),
    );
  }

  /// Validate treatment template name uniqueness
  static Future<ApiResponse<bool>> validateTemplateName(
      String name, int? excludeId) async {
    final queryParams = excludeId != null 
        ? {'excludeId': excludeId.toString()}
        : null;
        
    return ApiClient.get<bool>(
      '$_baseEndpoint/templates/validate/name/$name',
      queryParams: queryParams,
      fromJson: (data) => data is bool ? data : (data == true || data == 'true'),
    );
  }

  // =============================
  // Patient Treatments Methods
  // =============================

  /// Assign treatment to patient
  static Future<ApiResponse<PatientTreatmentDto>> assignTreatmentToPatient(
      AssignTreatmentRequest request) async {
    return ApiClient.post<PatientTreatmentDto>(
      '$_baseEndpoint/assign',
      body: request.toJson(),
      fromJson: (data) => PatientTreatmentDto.fromJson(data),
    );
  }

  /// Get all treatments for a specific patient
  static Future<ApiResponse<List<PatientTreatmentDto>>> getPatientTreatments(
      int patientId) async {
    return ApiClient.get<List<PatientTreatmentDto>>(
      '$_baseEndpoint/patient/$patientId',
      fromJson: (data) => (data as List)
          .map((e) => PatientTreatmentDto.fromJson(e))
          .toList(),
    );
  }

  /// Get specific patient treatment by ID
  static Future<ApiResponse<PatientTreatmentDto>> getPatientTreatment(int id) async {
    return ApiClient.get<PatientTreatmentDto>(
      '$_baseEndpoint/patient-treatment/$id',
      fromJson: (data) => PatientTreatmentDto.fromJson(data),
    );
  }

  /// Update patient treatment
  static Future<ApiResponse<PatientTreatmentDto>> updatePatientTreatment(
      int id, UpdatePatientTreatmentDto dto) async {
    return ApiClient.put<PatientTreatmentDto>(
      '$_baseEndpoint/patient-treatment/$id',
      body: dto.toJson(),
      fromJson: (data) => PatientTreatmentDto.fromJson(data),
    );
  }

  /// Complete treatment (Admin/Doctor only)
  static Future<ApiResponse<bool>> completeTreatment(int id) async {
    return ApiClient.patch<bool>(
      '$_baseEndpoint/patient-treatment/$id/complete',
      fromJson: (data) => data is bool ? data : (data == true || data == 'true'),
    );
  }

  /// Cancel treatment (Admin/Doctor only)
  static Future<ApiResponse<bool>> cancelTreatment(
      int id, CancelTreatmentRequest request) async {
    return ApiClient.patch<bool>(
      '$_baseEndpoint/patient-treatment/$id/cancel',
      body: request.toJson(),
      fromJson: (data) => data is bool ? data : (data == true || data == 'true'),
    );
  }
}

// =============================
// Request DTOs
// =============================

class AssignTreatmentRequest {
  final int patientId;
  final int treatmentTemplateId;
  final String? notes;

  AssignTreatmentRequest({
    required this.patientId,
    required this.treatmentTemplateId,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'treatmentTemplateId': treatmentTemplateId,
        'notes': notes,
      };

  factory AssignTreatmentRequest.fromJson(Map<String, dynamic> json) {
    return AssignTreatmentRequest(
      patientId: json['patientId'],
      treatmentTemplateId: json['treatmentTemplateId'],
      notes: json['notes'],
    );
  }
}

class CancelTreatmentRequest {
  final String reason;

  CancelTreatmentRequest({
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
        'reason': reason,
      };

  factory CancelTreatmentRequest.fromJson(Map<String, dynamic> json) {
    return CancelTreatmentRequest(
      reason: json['reason'] ?? '',
    );
  }
}

// =============================
// Update DTO for Patient Treatment
// =============================

class UpdatePatientTreatmentDto {
  final String? notes;
  final DateTime? startDate;
  final DateTime? completedDate;
  final String? status;

  UpdatePatientTreatmentDto({
    this.notes,
    this.startDate,
    this.completedDate,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    
    if (notes != null) map['notes'] = notes;
    if (startDate != null) map['startDate'] = startDate!.toIso8601String();
    if (completedDate != null) map['completedDate'] = completedDate!.toIso8601String();
    if (status != null) map['status'] = status;
    
    return map;
  }

  factory UpdatePatientTreatmentDto.fromJson(Map<String, dynamic> json) {
    return UpdatePatientTreatmentDto(
      notes: json['notes'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      completedDate: json['completedDate'] != null ? DateTime.parse(json['completedDate']) : null,
      status: json['status'],
    );
  }
}