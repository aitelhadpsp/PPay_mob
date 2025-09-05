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



class PaymentTrendDto {
  DateTime month;
  double totalAmount;
  int paymentCount;
  double averagePayment;

  PaymentTrendDto({
    required this.month,
    required this.totalAmount,
    required this.paymentCount,
    required this.averagePayment,
  });

  factory PaymentTrendDto.fromJson(Map<String, dynamic> json) {
    return PaymentTrendDto(
      month: DateTime.parse(json['month']),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentCount: json['paymentCount'],
      averagePayment: (json['averagePayment'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'month': month.toIso8601String(),
        'totalAmount': totalAmount,
        'paymentCount': paymentCount,
        'averagePayment': averagePayment,
      };
}

class PaymentValidationResultDto {
  bool isValid;
  String? errorMessage;
  double maxAllowedAmount;
  bool requiresObligatoryPayments;
  List<String> validationMessages;

  PaymentValidationResultDto({
    required this.isValid,
    this.errorMessage,
    required this.maxAllowedAmount,
    required this.requiresObligatoryPayments,
    this.validationMessages = const [],
  });

  factory PaymentValidationResultDto.fromJson(Map<String, dynamic> json) {
    return PaymentValidationResultDto(
      isValid: json['isValid'],
      errorMessage: json['errorMessage'],
      maxAllowedAmount: (json['maxAllowedAmount'] as num).toDouble(),
      requiresObligatoryPayments: json['requiresObligatoryPayments'],
      validationMessages: (json['validationMessages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'isValid': isValid,
        'errorMessage': errorMessage,
        'maxAllowedAmount': maxAllowedAmount,
        'requiresObligatoryPayments': requiresObligatoryPayments,
        'validationMessages': validationMessages,
      };
}

class OutstandingPaymentDto {
  int patientId;
  String patientName;
  String patientReference;
  int patientTreatmentId;
  String treatmentName;
  double outstandingAmount;
  int unpaidInstallments;
  DateTime? nextDueDate;
  bool hasOverduePayments;

  OutstandingPaymentDto({
    required this.patientId,
    required this.patientName,
    required this.patientReference,
    required this.patientTreatmentId,
    required this.treatmentName,
    required this.outstandingAmount,
    required this.unpaidInstallments,
    this.nextDueDate,
    required this.hasOverduePayments,
  });

  factory OutstandingPaymentDto.fromJson(Map<String, dynamic> json) {
    return OutstandingPaymentDto(
      patientId: json['patientId'],
      patientName: json['patientName'] ?? '',
      patientReference: json['patientReference'] ?? '',
      patientTreatmentId: json['patientTreatmentId'],
      treatmentName: json['treatmentName'] ?? '',
      outstandingAmount: (json['outstandingAmount'] as num).toDouble(),
      unpaidInstallments: json['unpaidInstallments'],
      nextDueDate: json['nextDueDate'] != null 
          ? DateTime.parse(json['nextDueDate']) 
          : null,
      hasOverduePayments: json['hasOverduePayments'],
    );
  }

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'patientName': patientName,
        'patientReference': patientReference,
        'patientTreatmentId': patientTreatmentId,
        'treatmentName': treatmentName,
        'outstandingAmount': outstandingAmount,
        'unpaidInstallments': unpaidInstallments,
        'nextDueDate': nextDueDate?.toIso8601String(),
        'hasOverduePayments': hasOverduePayments,
      };
}

class OverdueInstallmentDto {
  int patientInstallmentId;
  int patientId;
  String patientName;
  String patientReference;
  String treatmentName;
  String installmentDescription;
  double amount;
  DateTime dueDate;
  int daysOverdue;
  bool isObligatory;

  OverdueInstallmentDto({
    required this.patientInstallmentId,
    required this.patientId,
    required this.patientName,
    required this.patientReference,
    required this.treatmentName,
    required this.installmentDescription,
    required this.amount,
    required this.dueDate,
    required this.daysOverdue,
    required this.isObligatory,
  });

  factory OverdueInstallmentDto.fromJson(Map<String, dynamic> json) {
    return OverdueInstallmentDto(
      patientInstallmentId: json['patientInstallmentId'],
      patientId: json['patientId'],
      patientName: json['patientName'] ?? '',
      patientReference: json['patientReference'] ?? '',
      treatmentName: json['treatmentName'] ?? '',
      installmentDescription: json['installmentDescription'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      daysOverdue: json['daysOverdue'],
      isObligatory: json['isObligatory'],
    );
  }

  Map<String, dynamic> toJson() => {
        'patientInstallmentId': patientInstallmentId,
        'patientId': patientId,
        'patientName': patientName,
        'patientReference': patientReference,
        'treatmentName': treatmentName,
        'installmentDescription': installmentDescription,
        'amount': amount,
        'dueDate': dueDate.toIso8601String(),
        'daysOverdue': daysOverdue,
        'isObligatory': isObligatory,
      };
}

class PaymentReminderDto {
  int patientId;
  String patientName;
  String patientEmail;
  String patientPhone;
  int patientInstallmentId;
  String installmentDescription;
  double amount;
  DateTime dueDate;
  int daysUntilDue;
  bool isOverdue;
  DateTime? lastReminderSent;

  PaymentReminderDto({
    required this.patientId,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.patientInstallmentId,
    required this.installmentDescription,
    required this.amount,
    required this.dueDate,
    required this.daysUntilDue,
    required this.isOverdue,
    this.lastReminderSent,
  });

  factory PaymentReminderDto.fromJson(Map<String, dynamic> json) {
    return PaymentReminderDto(
      patientId: json['patientId'],
      patientName: json['patientName'] ?? '',
      patientEmail: json['patientEmail'] ?? '',
      patientPhone: json['patientPhone'] ?? '',
      patientInstallmentId: json['patientInstallmentId'],
      installmentDescription: json['installmentDescription'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      daysUntilDue: json['daysUntilDue'],
      isOverdue: json['isOverdue'],
      lastReminderSent: json['lastReminderSent'] != null 
          ? DateTime.parse(json['lastReminderSent']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'patientName': patientName,
        'patientEmail': patientEmail,
        'patientPhone': patientPhone,
        'patientInstallmentId': patientInstallmentId,
        'installmentDescription': installmentDescription,
        'amount': amount,
        'dueDate': dueDate.toIso8601String(),
        'daysUntilDue': daysUntilDue,
        'isOverdue': isOverdue,
        'lastReminderSent': lastReminderSent?.toIso8601String(),
      };
}