class PaymentRecordDto {
  int id;
  int patientId;
  String patientName;
  String patientReference;
  int patientTreatmentId;
  String treatmentName;
  int? patientInstallmentId;
  String? installmentDescription;
  double amount;
  DateTime paymentDate;
  String paymentType;
  String paymentMethod;
  String? transactionReference;
  bool hasSignature;
  String? signatureFilePath;
  String? notes;
  String? processedBy;
  bool isVoided;
  String statusDisplay;
  String formattedAmount;
  String paymentTypeDisplay;

  PaymentRecordDto({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientReference,
    required this.patientTreatmentId,
    required this.treatmentName,
    this.patientInstallmentId,
    this.installmentDescription,
    required this.amount,
    required this.paymentDate,
    required this.paymentType,
    required this.paymentMethod,
    this.transactionReference,
    required this.hasSignature,
    this.signatureFilePath,
    this.notes,
    this.processedBy,
    required this.isVoided,
    required this.statusDisplay,
    required this.formattedAmount,
    required this.paymentTypeDisplay,
  });

  factory PaymentRecordDto.fromJson(Map<String, dynamic> json) => PaymentRecordDto(
        id: json['id'],
        patientId: json['patientId'],
        patientName: json['patientName'] ?? '',
        patientReference: json['patientReference'] ?? '',
        patientTreatmentId: json['patientTreatmentId'],
        treatmentName: json['treatmentName'] ?? '',
        patientInstallmentId: json['patientInstallmentId'],
        installmentDescription: json['installmentDescription'],
        amount: (json['amount'] ?? 0).toDouble(),
        paymentDate: DateTime.parse(json['paymentDate']),
        paymentType: json['paymentType'] ?? '',
        paymentMethod: json['paymentMethod'] ?? 'Cash',
        transactionReference: json['transactionReference'],
        hasSignature: json['hasSignature'] ?? false,
        signatureFilePath: json['signatureFilePath'],
        notes: json['notes'],
        processedBy: json['processedBy'],
        isVoided: json['isVoided'] ?? false,
        statusDisplay: json['statusDisplay'] ?? '',
        formattedAmount: json['formattedAmount'] ?? '',
        paymentTypeDisplay: json['paymentTypeDisplay'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'patientName': patientName,
        'patientReference': patientReference,
        'patientTreatmentId': patientTreatmentId,
        'treatmentName': treatmentName,
        'patientInstallmentId': patientInstallmentId,
        'installmentDescription': installmentDescription,
        'amount': amount,
        'paymentDate': paymentDate.toIso8601String(),
        'paymentType': paymentType,
        'paymentMethod': paymentMethod,
        'transactionReference': transactionReference,
        'hasSignature': hasSignature,
        'signatureFilePath': signatureFilePath,
        'notes': notes,
        'processedBy': processedBy,
        'isVoided': isVoided,
        'statusDisplay': statusDisplay,
        'formattedAmount': formattedAmount,
        'paymentTypeDisplay': paymentTypeDisplay,
      };
}

class CreatePaymentDto {
  int patientId;
  int patientTreatmentId;
  int? patientInstallmentId;
  double amount;
  String paymentType; // Use string to represent PaymentType enum
  String paymentMethod;
  String? transactionReference;
  String? signatureBase64;
  String? notes;

  CreatePaymentDto({
    required this.patientId,
    required this.patientTreatmentId,
    this.patientInstallmentId,
    required this.amount,
    this.paymentType = 'Installment',
    this.paymentMethod = 'Cash',
    this.transactionReference,
    this.signatureBase64,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'patientTreatmentId': patientTreatmentId,
        'patientInstallmentId': patientInstallmentId,
        'amount': amount,
        'paymentType': paymentType,
        'paymentMethod': paymentMethod,
        'transactionReference': transactionReference,
        'signatureBase64': signatureBase64,
        'notes': notes,
      };
}

class PaymentSummaryDto {
  DateTime date;
  int paymentCount;
  double totalAmount;
  List<PaymentRecordDto> payments;

  PaymentSummaryDto({
    required this.date,
    required this.paymentCount,
    required this.totalAmount,
    this.payments = const [],
  });

  factory PaymentSummaryDto.fromJson(Map<String, dynamic> json) => PaymentSummaryDto(
        date: DateTime.parse(json['date']),
        paymentCount: json['paymentCount'] ?? 0,
        totalAmount: (json['totalAmount'] ?? 0).toDouble(),
        payments: (json['payments'] as List<dynamic>?)
                ?.map((e) => PaymentRecordDto.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'paymentCount': paymentCount,
        'totalAmount': totalAmount,
        'payments': payments.map((e) => e.toJson()).toList(),
      };
}

class PaymentMethodBreakdownDto {
  double cashAmount;
  double cardAmount;
  double transferAmount;
  double otherAmount;

  PaymentMethodBreakdownDto({
    this.cashAmount = 0,
    this.cardAmount = 0,
    this.transferAmount = 0,
    this.otherAmount = 0,
  });

  factory PaymentMethodBreakdownDto.fromJson(Map<String, dynamic> json) =>
      PaymentMethodBreakdownDto(
        cashAmount: (json['cashAmount'] ?? 0).toDouble(),
        cardAmount: (json['cardAmount'] ?? 0).toDouble(),
        transferAmount: (json['transferAmount'] ?? 0).toDouble(),
        otherAmount: (json['otherAmount'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'cashAmount': cashAmount,
        'cardAmount': cardAmount,
        'transferAmount': transferAmount,
        'otherAmount': otherAmount,
      };
}

class DailyReceiptDto {
  DateTime date;
  double totalAmount;
  int paymentCount;
  List<PaymentRecordDto> payments;
  PaymentMethodBreakdownDto paymentMethodBreakdown;

  DailyReceiptDto({
    required this.date,
    required this.totalAmount,
    required this.paymentCount,
    this.payments = const [],
    PaymentMethodBreakdownDto? paymentMethodBreakdown,
  }) : paymentMethodBreakdown = paymentMethodBreakdown ?? PaymentMethodBreakdownDto();

  factory DailyReceiptDto.fromJson(Map<String, dynamic> json) => DailyReceiptDto(
        date: DateTime.parse(json['date']),
        totalAmount: (json['totalAmount'] ?? 0).toDouble(),
        paymentCount: json['paymentCount'] ?? 0,
        payments: (json['payments'] as List<dynamic>?)
                ?.map((e) => PaymentRecordDto.fromJson(e))
                .toList() ??
            [],
        paymentMethodBreakdown: json['paymentMethodBreakdown'] != null
            ? PaymentMethodBreakdownDto.fromJson(json['paymentMethodBreakdown'])
            : PaymentMethodBreakdownDto(),
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'totalAmount': totalAmount,
        'paymentCount': paymentCount,
        'payments': payments.map((e) => e.toJson()).toList(),
        'paymentMethodBreakdown': paymentMethodBreakdown.toJson(),
      };
}

class VoidPaymentDto {
  String reason;
  String? notes;

  VoidPaymentDto({
    required this.reason,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'reason': reason,
        'notes': notes,
      };
}

class PaymentReceiptDto {
  int paymentId;
  String patientName;
  String patientReference;
  String treatmentName;
  double amount;
  DateTime paymentDate;
  String paymentMethod;
  String? transactionReference;
  bool hasSignature;
  String? signatureFilePath;
  String clinicName;
  String? clinicAddress;
  String? clinicPhone;
  String? processedBy;

  PaymentReceiptDto({
    required this.paymentId,
    required this.patientName,
    required this.patientReference,
    required this.treatmentName,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    this.transactionReference,
    required this.hasSignature,
    this.signatureFilePath,
    required this.clinicName,
    this.clinicAddress,
    this.clinicPhone,
    this.processedBy,
  });

  factory PaymentReceiptDto.fromJson(Map<String, dynamic> json) => PaymentReceiptDto(
        paymentId: json['paymentId'],
        patientName: json['patientName'] ?? '',
        patientReference: json['patientReference'] ?? '',
        treatmentName: json['treatmentName'] ?? '',
        amount: (json['amount'] ?? 0).toDouble(),
        paymentDate: DateTime.parse(json['paymentDate']),
        paymentMethod: json['paymentMethod'] ?? 'Cash',
        transactionReference: json['transactionReference'],
        hasSignature: json['hasSignature'] ?? false,
        signatureFilePath: json['signatureFilePath'],
        clinicName: json['clinicName'] ?? '',
        clinicAddress: json['clinicAddress'],
        clinicPhone: json['clinicPhone'],
        processedBy: json['processedBy'],
      );

  Map<String, dynamic> toJson() => {
        'paymentId': paymentId,
        'patientName': patientName,
        'patientReference': patientReference,
        'treatmentName': treatmentName,
        'amount': amount,
        'paymentDate': paymentDate.toIso8601String(),
        'paymentMethod': paymentMethod,
        'transactionReference': transactionReference,
        'hasSignature': hasSignature,
        'signatureFilePath': signatureFilePath,
        'clinicName': clinicName,
        'clinicAddress': clinicAddress,
        'clinicPhone': clinicPhone,
        'processedBy': processedBy,
      };
}
