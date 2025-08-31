// Enums matching the C# backend
enum TreatmentStatus {
  active,
  completed,
  cancelled,
}

enum PaymentType {
  installment,
  partial,
  full,
}

enum PatientTreatmentStatus {
  active,
  completed,
  cancelled,
}

enum TreatmentCategory {
  orthodontie,
  chirurgie,
  esthetique,
  prevention,
  prothese,
  personnalise,
  general,
}

// Extension methods for enum conversion
extension TreatmentCategoryExtension on TreatmentCategory {
  String get displayName {
    switch (this) {
      case TreatmentCategory.orthodontie:
        return 'Orthodontie';
      case TreatmentCategory.chirurgie:
        return 'Chirurgie';
      case TreatmentCategory.esthetique:
        return 'Esthétique';
      case TreatmentCategory.prevention:
        return 'Prévention';
      case TreatmentCategory.prothese:
        return 'Prothèse';
      case TreatmentCategory.personnalise:
        return 'Personnalisé';
      case TreatmentCategory.general:
        return 'Général';
    }
  }

  static TreatmentCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'orthodontie':
        return TreatmentCategory.orthodontie;
      case 'chirurgie':
        return TreatmentCategory.chirurgie;
      case 'esthetique':
      case 'esthétique':
        return TreatmentCategory.esthetique;
      case 'prevention':
      case 'prévention':
        return TreatmentCategory.prevention;
      case 'prothese':
      case 'prothèse':
        return TreatmentCategory.prothese;
      case 'personnalise':
      case 'personnalisé':
        return TreatmentCategory.personnalise;
      case 'general':
      case 'général':
        return TreatmentCategory.general;
      default:
        return TreatmentCategory.general;
    }
  }

  int get enumIndex {
    return TreatmentCategory.values.indexOf(this);
  }

  static TreatmentCategory fromIndex(int index) {
    if (index >= 0 && index < TreatmentCategory.values.length) {
      return TreatmentCategory.values[index];
    }
    return TreatmentCategory.general;
  }
}

// Treatment Template DTOs
class TreatmentTemplateDto {
  final int id;
  final String name;
  final String description;
  final double totalPrice;
  final String category;
  final bool isActive;
  final DateTime createdDate;
  final List<InstallmentTemplateDto> installmentTemplates;
  final int installmentCount;
  final int obligatoryInstallmentCount;
  final double obligatoryAmount;
  final double optionalAmount;

  TreatmentTemplateDto({
    required this.id,
    required this.name,
    required this.description,
    required this.totalPrice,
    required this.category,
    required this.isActive,
    required this.createdDate,
    this.installmentTemplates = const [],
    required this.installmentCount,
    required this.obligatoryInstallmentCount,
    required this.obligatoryAmount,
    required this.optionalAmount,
  });

  factory TreatmentTemplateDto.fromJson(Map<String, dynamic> json) {
    // Extract installmentTemplates safely
    List<InstallmentTemplateDto> installments = [];
    if (json['installmentTemplates'] != null ) {
      final values = json['installmentTemplates'] ;
      if (values is List) {
        installments = values
            .map((e) => InstallmentTemplateDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    return TreatmentTemplateDto(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      category: json['category'] ?? 'General',
      isActive: json['isActive'] ?? true,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : DateTime.now(),
      installmentTemplates: installments,
      installmentCount: json['installmentCount'] ?? 0,
      obligatoryInstallmentCount: json['obligatoryInstallmentCount'] ?? 0,
      obligatoryAmount: (json['obligatoryAmount'] ?? 0.0).toDouble(),
      optionalAmount: (json['optionalAmount'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'totalPrice': totalPrice,
        'category': category,
        'isActive': isActive,
        'createdDate': createdDate.toIso8601String(),
        'installmentTemplates': installmentTemplates.map((e) => e.toJson()).toList(),
        'installmentCount': installmentCount,
        'obligatoryInstallmentCount': obligatoryInstallmentCount,
        'obligatoryAmount': obligatoryAmount,
        'optionalAmount': optionalAmount,
      };
}

class CreateTreatmentTemplateDto {
  final String name;
  final String description;
  final double totalPrice;
  final int category; // TreatmentCategory enum index
  final List<CreateInstallmentTemplateDto> installmentTemplates;

  CreateTreatmentTemplateDto({
    required this.name,
    required this.description,
    required this.totalPrice,
    required this.category,
    this.installmentTemplates = const [],
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'totalPrice': totalPrice,
        'category': category,
        'installmentTemplates': installmentTemplates.map((e) => e.toJson()).toList(),
      };

  factory CreateTreatmentTemplateDto.fromJson(Map<String, dynamic> json) {
    return CreateTreatmentTemplateDto(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      category: json['category'] ?? 0,
      installmentTemplates: (json['installmentTemplates'] as List<dynamic>?)
          ?.map((e) => CreateInstallmentTemplateDto.fromJson(e))
          .toList() ?? [],
    );
  }
}

class UpdateTreatmentTemplateDto {
  final String? name;
  final String? description;
  final double? totalPrice;
  final int? category; // TreatmentCategory enum index
  final bool? isActive;
  final List<UpdateInstallmentTemplateDto>? installmentTemplates;

  UpdateTreatmentTemplateDto({
    this.name,
    this.description,
    this.totalPrice,
    this.category,
    this.isActive,
    this.installmentTemplates,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (description != null) map['description'] = description;
    if (totalPrice != null) map['totalPrice'] = totalPrice;
    if (category != null) map['category'] = category;
    if (isActive != null) map['isActive'] = isActive;
    if (installmentTemplates != null) {
      map['installmentTemplates'] = installmentTemplates!.map((e) => e.toJson()).toList();
    }
    return map;
  }

  factory UpdateTreatmentTemplateDto.fromJson(Map<String, dynamic> json) {
    return UpdateTreatmentTemplateDto(
      name: json['name'],
      description: json['description'],
      totalPrice: json['totalPrice']?.toDouble(),
      category: json['category'],
      isActive: json['isActive'],
      installmentTemplates: (json['installmentTemplates'] as List<dynamic>?)
          ?.map((e) => UpdateInstallmentTemplateDto.fromJson(e))
          .toList(),
    );
  }
}

// Installment Template DTOs
class InstallmentTemplateDto {
  final int id;
  final int treatmentTemplateId;
  final int order;
  final double amount;
  final bool isObligatory;
  final String description;
  final DateTime createdDate;

  InstallmentTemplateDto({
    required this.id,
    required this.treatmentTemplateId,
    required this.order,
    required this.amount,
    required this.isObligatory,
    required this.description,
    required this.createdDate,
  });

  factory InstallmentTemplateDto.fromJson(Map<String, dynamic> json) {
    return InstallmentTemplateDto(
      id: json['id'] ?? 0,
      treatmentTemplateId: json['treatmentTemplateId'] ?? 0,
      order: json['order'] ?? 0,
      amount: (json['amount'] ?? 0.0).toDouble(),
      isObligatory: json['isObligatory'] ?? false,
      description: json['description'] ?? '',
      createdDate: json['createdDate'] != null 
          ? DateTime.parse(json['createdDate']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'treatmentTemplateId': treatmentTemplateId,
        'order': order,
        'amount': amount,
        'isObligatory': isObligatory,
        'description': description,
        'createdDate': createdDate.toIso8601String(),
      };
}

class CreateInstallmentTemplateDto {
  final int order;
  final double amount;
  final bool isObligatory;
  final String description;

  CreateInstallmentTemplateDto({
    required this.order,
    required this.amount,
    required this.isObligatory,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'order': order,
        'amount': amount,
        'isObligatory': isObligatory,
        'description': description,
      };

  factory CreateInstallmentTemplateDto.fromJson(Map<String, dynamic> json) {
    return CreateInstallmentTemplateDto(
      order: json['order'] ?? 0,
      amount: (json['amount'] ?? 0.0).toDouble(),
      isObligatory: json['isObligatory'] ?? false,
      description: json['description'] ?? '',
    );
  }
}

class UpdateInstallmentTemplateDto {
  final int? id;
  final int? order;
  final double? amount;
  final bool? isObligatory;
  final String? description;

  UpdateInstallmentTemplateDto({
    this.id,
    this.order,
    this.amount,
    this.isObligatory,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    if (order != null) map['order'] = order;
    if (amount != null) map['amount'] = amount;
    if (isObligatory != null) map['isObligatory'] = isObligatory;
    if (description != null) map['description'] = description;
    return map;
  }

  factory UpdateInstallmentTemplateDto.fromJson(Map<String, dynamic> json) {
    return UpdateInstallmentTemplateDto(
      id: json['id'],
      order: json['order'],
      amount: json['amount']?.toDouble(),
      isObligatory: json['isObligatory'],
      description: json['description'],
    );
  }
}

// Patient Treatment DTOs
class PatientTreatmentDto {
  final int id;
  final int patientId;
  final int treatmentTemplateId;
  final String treatmentName;
  final String treatmentDescription;
  final String category;
  final double totalPrice;
  final DateTime startDate;
  final DateTime? completedDate;
  final String status;
  final String? notes;
  final double totalPaidAmount;
  final double remainingAmount;
  final double progressPercentage;
  final bool areObligatoryInstallmentsPaid;
  final bool isCompleted;
  final List<PatientInstallmentDto> installments;

  PatientTreatmentDto({
    required this.id,
    required this.patientId,
    required this.treatmentTemplateId,
    required this.treatmentName,
    required this.treatmentDescription,
    required this.category,
    required this.totalPrice,
    required this.startDate,
    this.completedDate,
    required this.status,
    this.notes,
    required this.totalPaidAmount,
    required this.remainingAmount,
    required this.progressPercentage,
    required this.areObligatoryInstallmentsPaid,
    required this.isCompleted,
    this.installments = const [],
  });

  factory PatientTreatmentDto.fromJson(Map<String, dynamic> json) {
    return PatientTreatmentDto(
      id: json['id'] ?? 0,
      patientId: json['patientId'] ?? 0,
      treatmentTemplateId: json['treatmentTemplateId'] ?? 0,
      treatmentName: json['treatmentName'] ?? '',
      treatmentDescription: json['treatmentDescription'] ?? '',
      category: json['category'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate']) 
          : DateTime.now(),
      completedDate: json['completedDate'] != null 
          ? DateTime.parse(json['completedDate']) 
          : null,
      status: json['status'] ?? 'Active',
      notes: json['notes'],
      totalPaidAmount: (json['totalPaidAmount'] ?? 0.0).toDouble(),
      remainingAmount: (json['remainingAmount'] ?? 0.0).toDouble(),
      progressPercentage: (json['progressPercentage'] ?? 0.0).toDouble(),
      areObligatoryInstallmentsPaid: json['areObligatoryInstallmentsPaid'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      installments: (json['installments'] as List<dynamic>?)
          ?.map((e) => PatientInstallmentDto.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'treatmentTemplateId': treatmentTemplateId,
        'treatmentName': treatmentName,
        'treatmentDescription': treatmentDescription,
        'category': category,
        'totalPrice': totalPrice,
        'startDate': startDate.toIso8601String(),
        'completedDate': completedDate?.toIso8601String(),
        'status': status,
        'notes': notes,
        'totalPaidAmount': totalPaidAmount,
        'remainingAmount': remainingAmount,
        'progressPercentage': progressPercentage,
        'areObligatoryInstallmentsPaid': areObligatoryInstallmentsPaid,
        'isCompleted': isCompleted,
        'installments': installments.map((e) => e.toJson()).toList(),
      };
}

class PatientInstallmentDto {
  final int id;
  final int patientTreatmentId;
  final int order;
  final double amount;
  final bool isObligatory;
  final String description;
  final bool isPaid;
  final DateTime? paidDate;
  final DateTime? dueDate;
  final bool isOverdue;
  final int daysUntilDue;
  final String statusText;

  PatientInstallmentDto({
    required this.id,
    required this.patientTreatmentId,
    required this.order,
    required this.amount,
    required this.isObligatory,
    required this.description,
    required this.isPaid,
    this.paidDate,
    this.dueDate,
    required this.isOverdue,
    required this.daysUntilDue,
    required this.statusText,
  });

  factory PatientInstallmentDto.fromJson(Map<String, dynamic> json) {
    return PatientInstallmentDto(
      id: json['id'] ?? 0,
      patientTreatmentId: json['patientTreatmentId'] ?? 0,
      order: json['order'] ?? 0,
      amount: (json['amount'] ?? 0.0).toDouble(),
      isObligatory: json['isObligatory'] ?? false,
      description: json['description'] ?? '',
      isPaid: json['isPaid'] ?? false,
      paidDate: json['paidDate'] != null 
          ? DateTime.parse(json['paidDate']) 
          : null,
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate']) 
          : null,
      isOverdue: json['isOverdue'] ?? false,
      daysUntilDue: json['daysUntilDue'] ?? 0,
      statusText: json['statusText'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientTreatmentId': patientTreatmentId,
        'order': order,
        'amount': amount,
        'isObligatory': isObligatory,
        'description': description,
        'isPaid': isPaid,
        'paidDate': paidDate?.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'isOverdue': isOverdue,
        'daysUntilDue': daysUntilDue,
        'statusText': statusText,
      };
}