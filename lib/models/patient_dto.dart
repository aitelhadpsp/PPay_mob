import 'package:denta_incomes/models/payment_dto.dart';
import 'package:denta_incomes/models/treatment_dto.dart';

class PatientDto {
  int id;
  String name;
  String reference;
  String? phone;
  String? email;
  String? address;
  String? gender;
  DateTime? birthDate;
  String? medicalNotes;
  DateTime createdDate;
  bool isActive;
  int age;
  double totalAmountPaid;
  double totalTreatmentCost;
  double remainingBalance;

  PatientDto({
    required this.id,
    required this.name,
    required this.reference,
    this.phone,
    this.email,
    this.address,
    this.gender,
    this.birthDate,
    this.medicalNotes,
    required this.createdDate,
    required this.isActive,
    required this.age,
    required this.totalAmountPaid,
    required this.totalTreatmentCost,
    required this.remainingBalance,
  });

  factory PatientDto.fromJson(Map<String, dynamic> json) {
    return PatientDto(
      id: json['id'],
      name: json['name'],
      reference: json['reference'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      gender: json['gender'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      medicalNotes: json['medicalNotes'],
      createdDate: DateTime.parse(json['createdDate']),
      isActive: json['isActive'],
      age: json['age'] ?? 0,
      totalAmountPaid: (json['totalAmountPaid'] ?? 0).toDouble(),
      totalTreatmentCost: (json['totalTreatmentCost'] ?? 0).toDouble(),
      remainingBalance: (json['remainingBalance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'reference': reference,
        'phone': phone,
        'email': email,
        'address': address,
        'gender': gender,
        'birthDate': birthDate?.toIso8601String(),
        'medicalNotes': medicalNotes,
        'createdDate': createdDate.toIso8601String(),
        'isActive': isActive,
        'age': age,
        'totalAmountPaid': totalAmountPaid,
        'totalTreatmentCost': totalTreatmentCost,
        'remainingBalance': remainingBalance,
      };
}

class CreatePatientDto {
  String name;
  String reference;
  String? phone;
  String? email;
  String? address;
  String? gender;
  DateTime? birthDate;
  String? medicalNotes;

  CreatePatientDto({
    required this.name,
    required this.reference,
    this.phone,
    this.email,
    this.address,
    this.gender,
    this.birthDate,
    this.medicalNotes,
  });

  // Serialize to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'reference': reference,
        'phone': phone,
        'email': email,
        'address': address,
        'gender': gender,
        'birthDate': birthDate?.toIso8601String(),
        'medicalNotes': medicalNotes,
      };

  // Deserialize from JSON
  factory CreatePatientDto.fromJson(Map<String, dynamic> json) {
    return CreatePatientDto(
      name: json['name'] ?? '',
      reference: json['reference'] ?? '',
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      gender: json['gender'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      medicalNotes: json['medicalNotes'],
    );
  }
}

class UpdatePatientDto {
  String? name;
  String? phone;
  String? email;
  String? address;
  String? gender;
  DateTime? birthDate;
  String? medicalNotes;
  bool? isActive;

  UpdatePatientDto({
    this.name,
    this.phone,
    this.email,
    this.address,
    this.gender,
    this.birthDate,
    this.medicalNotes,
    this.isActive,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'gender': gender,
        'birthDate': birthDate?.toIso8601String(),
        'medicalNotes': medicalNotes,
        'isActive': isActive,
      };
}

class PatientSummaryDto {
  int id;
  String name;
  String reference;
  String? phone;
  int treatmentCount;
  double totalAmountPaid;
  double remainingBalance;
  DateTime? lastPaymentDate;
  DateTime? nextAppointmentDate;

  PatientSummaryDto({
    required this.id,
    required this.name,
    required this.reference,
    this.phone,
    required this.treatmentCount,
    required this.totalAmountPaid,
    required this.remainingBalance,
    this.lastPaymentDate,
    this.nextAppointmentDate,
  });

  factory PatientSummaryDto.fromJson(Map<String, dynamic> json) {
    return PatientSummaryDto(
      id: json['id'],
      name: json['name'],
      reference: json['reference'],
      phone: json['phone'],
      treatmentCount: json['treatmentCount'] ?? 0,
      totalAmountPaid: (json['totalAmountPaid'] ?? 0).toDouble(),
      remainingBalance: (json['remainingBalance'] ?? 0).toDouble(),
      lastPaymentDate: json['lastPaymentDate'] != null
          ? DateTime.parse(json['lastPaymentDate'])
          : null,
      nextAppointmentDate: json['nextAppointmentDate'] != null
          ? DateTime.parse(json['nextAppointmentDate'])
          : null,
    );
  }
}

class PatientWithTreatmentsDto extends PatientDto {
  List<PatientTreatmentDto> treatments;
  List<PaymentRecordDto> paymentHistory;

  PatientWithTreatmentsDto({
    required int id,
    required String name,
    required String reference,
    String? phone,
    String? email,
    String? address,
    String? gender,
    DateTime? birthDate,
    String? medicalNotes,
    required DateTime createdDate,
    required bool isActive,
    required int age,
    required double totalAmountPaid,
    required double totalTreatmentCost,
    required double remainingBalance,
    this.treatments = const [],
    this.paymentHistory = const [],
  }) : super(
          id: id,
          name: name,
          reference: reference,
          phone: phone,
          email: email,
          address: address,
          gender: gender,
          birthDate: birthDate,
          medicalNotes: medicalNotes,
          createdDate: createdDate,
          isActive: isActive,
          age: age,
          totalAmountPaid: totalAmountPaid,
          totalTreatmentCost: totalTreatmentCost,
          remainingBalance: remainingBalance,
        );

  factory PatientWithTreatmentsDto.fromJson(Map<String, dynamic> json) {
    return PatientWithTreatmentsDto(
      id: json['id'],
      name: json['name'],
      reference: json['reference'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      gender: json['gender'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      medicalNotes: json['medicalNotes'],
      createdDate: DateTime.parse(json['createdDate']),
      isActive: json['isActive'],
      age: json['age'] ?? 0,
      totalAmountPaid: (json['totalAmountPaid'] ?? 0).toDouble(),
      totalTreatmentCost: (json['totalTreatmentCost'] ?? 0).toDouble(),
      remainingBalance: (json['remainingBalance'] ?? 0).toDouble(),
      treatments: (json['treatments'] as List<dynamic>?)
              ?.map((e) => PatientTreatmentDto.fromJson(e))
              .toList() ??
          [],
      paymentHistory: (json['paymentHistory'] as List<dynamic>?)
              ?.map((e) => PaymentRecordDto.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PatientStatsDto {
  int patientId;
  int totalTreatments;
  int completedTreatments;
  int activeTreatments;
  double totalTreatmentValue;
  double totalPaidAmount;
  double remainingBalance;
  DateTime? lastPaymentDate;
  DateTime firstVisitDate;
  int paymentCount;

  PatientStatsDto({
    required this.patientId,
    required this.totalTreatments,
    required this.completedTreatments,
    required this.activeTreatments,
    required this.totalTreatmentValue,
    required this.totalPaidAmount,
    required this.remainingBalance,
    this.lastPaymentDate,
    required this.firstVisitDate,
    required this.paymentCount,
  });

  factory PatientStatsDto.fromJson(Map<String, dynamic> json) {
    return PatientStatsDto(
      patientId: json['patientId'],
      totalTreatments: json['totalTreatments'],
      completedTreatments: json['completedTreatments'],
      activeTreatments: json['activeTreatments'],
      totalTreatmentValue: (json['totalTreatmentValue'] ?? 0).toDouble(),
      totalPaidAmount: (json['totalPaidAmount'] ?? 0).toDouble(),
      remainingBalance: (json['remainingBalance'] ?? 0).toDouble(),
      lastPaymentDate: json['lastPaymentDate'] != null
          ? DateTime.parse(json['lastPaymentDate'])
          : null,
      firstVisitDate: DateTime.parse(json['firstVisitDate']),
      paymentCount: json['paymentCount'],
    );
  }
}
