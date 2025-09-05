import 'package:denta_incomes/models/api_response_dto.dart';
import 'package:denta_incomes/models/payment_dto.dart';
import 'package:denta_incomes/utils/api_client.dart';

class PaymentService {
  static const String _baseEndpoint = '/payments';

  // Payment CRUD Operations
  static Future<ApiResponse<PaginatedResponse<PaymentRecordDto>>> getPayments({
    Map<String, String>? queryParams,
  }) async {
    return ApiClient.get<PaginatedResponse<PaymentRecordDto>>(
      _baseEndpoint,
      queryParams: queryParams,
      fromJson: (data) => PaginatedResponse<PaymentRecordDto>.fromJson(
        data,
        (json) => PaymentRecordDto.fromJson(json),
      ),
    );
  }

  static Future<ApiResponse<PaymentRecordDto>> getPayment(int id) async {
    return ApiClient.get<PaymentRecordDto>(
      '$_baseEndpoint/$id',
      fromJson: (data) => PaymentRecordDto.fromJson(data),
    );
  }

  static Future<ApiResponse<PaymentRecordDto>> createPayment(
      CreatePaymentDto createPaymentDto) async {
    return ApiClient.post<PaymentRecordDto>(
      _baseEndpoint,
      body: createPaymentDto.toJson(),
      fromJson: (data) => PaymentRecordDto.fromJson(data),
    );
  }

  static Future<ApiResponse<bool>> voidPayment(
      int id, VoidPaymentDto voidDto) async {
    return ApiClient.patch<bool>(
      '$_baseEndpoint/$id/void',
      body: voidDto.toJson(),
      fromJson: (data) => data is bool ? data : (data == true || data == 'true'),
    );
  }

  // Payment History & Search
  static Future<ApiResponse<List<PaymentRecordDto>>> getPaymentHistory({
    int? patientId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};
    if (patientId != null) queryParams['patientId'] = patientId.toString();
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

    return ApiClient.get<List<PaymentRecordDto>>(
      '$_baseEndpoint/history',
      queryParams: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data as List)
          .map((e) => PaymentRecordDto.fromJson(e))
          .toList(),
    );
  }

  static Future<ApiResponse<List<PaymentRecordDto>>> getPaymentsByTreatment(
      int treatmentId) async {
    return ApiClient.get<List<PaymentRecordDto>>(
      '$_baseEndpoint/treatment/$treatmentId',
      fromJson: (data) => (data as List)
          .map((e) => PaymentRecordDto.fromJson(e))
          .toList(),
    );
  }

  static Future<ApiResponse<List<PaymentRecordDto>>> getPatientPayments(
      int patientId) async {
    return ApiClient.get<List<PaymentRecordDto>>(
      '$_baseEndpoint/patient/$patientId',
      fromJson: (data) => (data as List)
          .map((e) => PaymentRecordDto.fromJson(e))
          .toList(),
    );
  }

  // Daily Operations
  static Future<ApiResponse<DailyReceiptDto>> getDailyReceipts({
    DateTime? date,
  }) async {
    final queryParams = date != null 
        ? {'date': date.toIso8601String()} 
        : null;

    return ApiClient.get<DailyReceiptDto>(
      '$_baseEndpoint/daily',
      queryParams: queryParams,
      fromJson: (data) => DailyReceiptDto.fromJson(data),
    );
  }

  static Future<ApiResponse<List<PaymentRecordDto>>> getTodayPayments() async {
    return ApiClient.get<List<PaymentRecordDto>>(
      '$_baseEndpoint/today',
      fromJson: (data) => (data as List)
          .map((e) => PaymentRecordDto.fromJson(e))
          .toList(),
    );
  }

  static Future<ApiResponse<PaymentSummaryDto>> getPaymentSummary(
      DateTime startDate, DateTime endDate) async {
    return ApiClient.get<PaymentSummaryDto>(
      '$_baseEndpoint/summary',
      queryParams: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
      fromJson: (data) => PaymentSummaryDto.fromJson(data),
    );
  }

  // Analytics & Reports
  static Future<ApiResponse<PaymentMethodBreakdownDto>> getPaymentMethodBreakdown({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

    return ApiClient.get<PaymentMethodBreakdownDto>(
      '$_baseEndpoint/analytics/payment-methods',
      queryParams: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => PaymentMethodBreakdownDto.fromJson(data),
    );
  }

  static Future<ApiResponse<double>> getTotalRevenue({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

    return ApiClient.get<double>(
      '$_baseEndpoint/analytics/revenue',
      queryParams: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data as num).toDouble(),
    );
  }

  static Future<ApiResponse<double>> getOutstandingBalance() async {
    return ApiClient.get<double>(
      '$_baseEndpoint/analytics/outstanding',
      fromJson: (data) => (data as num).toDouble(),
    );
  }

  // Validation
  static Future<ApiResponse<bool>> validatePaymentAmount(
      int treatmentId, double amount) async {
    return ApiClient.get<bool>(
      '$_baseEndpoint/validate/amount',
      queryParams: {
        'treatmentId': treatmentId.toString(),
        'amount': amount.toString(),
      },
      fromJson: (data) => data is bool ? data : (data == true || data == 'true'),
    );
  }

  static Future<ApiResponse<PaymentValidationResultDto>> validateInstallmentPayment(
      int installmentId) async {
    return ApiClient.get<PaymentValidationResultDto>(
      '$_baseEndpoint/validate/installment/$installmentId',
      fromJson: (data) => PaymentValidationResultDto.fromJson(data),
    );
  }

  // Signature Management
  static Future<ApiResponse<String>> saveSignature(
      String signatureBase64, int paymentId) async {
    return ApiClient.post<String>(
      '$_baseEndpoint/$paymentId/signature',
      body: {'signatureBase64': signatureBase64},
      fromJson: (data) => data as String,
    );
  }

  static Future<ApiResponse<List<int>>> getSignature(int paymentId) async {
    return ApiClient.get<List<int>>(
      '$_baseEndpoint/$paymentId/signature',
      fromJson: (data) => (data as List).cast<int>(),
    );
  }

  // Advanced Payment Operations
  static Future<ApiResponse<PaymentRecordDto>> payInstallment(
      int installmentId, CreateInstallmentPaymentDto paymentDto) async {
    return ApiClient.post<PaymentRecordDto>(
      '$_baseEndpoint/installment/$installmentId',
      body: paymentDto.toJson(),
      fromJson: (data) => PaymentRecordDto.fromJson(data),
    );
  }

  static Future<ApiResponse<PaymentRecordDto>> payCustomAmount(
      CreateCustomPaymentDto paymentDto) async {
    return ApiClient.post<PaymentRecordDto>(
      '$_baseEndpoint/custom',
      body: paymentDto.toJson(),
      fromJson: (data) => PaymentRecordDto.fromJson(data),
    );
  }
}

// Supporting DTOs
class CreateInstallmentPaymentDto {
  int patientId;
  int patientTreatmentId;
  String paymentMethod;
  String? transactionReference;
  String? signatureBase64;
  String? notes;

  CreateInstallmentPaymentDto({
    required this.patientId,
    required this.patientTreatmentId,
    this.paymentMethod = 'Cash',
    this.transactionReference,
    this.signatureBase64,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'patientTreatmentId': patientTreatmentId,
        'paymentMethod': paymentMethod,
        'transactionReference': transactionReference,
        'signatureBase64': signatureBase64,
        'notes': notes,
      };

  factory CreateInstallmentPaymentDto.fromJson(Map<String, dynamic> json) {
    return CreateInstallmentPaymentDto(
      patientId: json['patientId'],
      patientTreatmentId: json['patientTreatmentId'],
      paymentMethod: json['paymentMethod'] ?? 'Cash',
      transactionReference: json['transactionReference'],
      signatureBase64: json['signatureBase64'],
      notes: json['notes'],
    );
  }
}

class CreateCustomPaymentDto {
  int patientId;
  int patientTreatmentId;
  double amount;
  double totalTreatmentCost;
  String paymentMethod;
  String? transactionReference;
  String? signatureBase64;
  String? notes;

  CreateCustomPaymentDto({
    required this.patientId,
    required this.patientTreatmentId,
    required this.amount,
    required this.totalTreatmentCost,
    this.paymentMethod = 'Cash',
    this.transactionReference,
    this.signatureBase64,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'patientTreatmentId': patientTreatmentId,
        'amount': amount,
        'totalTreatmentCost': totalTreatmentCost,
        'paymentMethod': paymentMethod,
        'transactionReference': transactionReference,
        'signatureBase64': signatureBase64,
        'notes': notes,
      };

  factory CreateCustomPaymentDto.fromJson(Map<String, dynamic> json) {
    return CreateCustomPaymentDto(
      patientId: json['patientId'],
      patientTreatmentId: json['patientTreatmentId'],
      amount: (json['amount'] as num).toDouble(),
      totalTreatmentCost: (json['totalTreatmentCost'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] ?? 'Cash',
      transactionReference: json['transactionReference'],
      signatureBase64: json['signatureBase64'],
      notes: json['notes'],
    );
  }
}

class VoidPaymentDto {
  String reason;

  VoidPaymentDto({required this.reason});

  Map<String, dynamic> toJson() => {'reason': reason};

  factory VoidPaymentDto.fromJson(Map<String, dynamic> json) {
    return VoidPaymentDto(reason: json['reason'] ?? '');
  }
}