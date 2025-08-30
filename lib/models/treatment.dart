import 'enums.dart';

// Base Treatment model (used for creating new treatments)
class Treatment {
  final String id;
  final String name;
  final String description;
  final double totalPrice;
  final List<Installment> installments;
  final DateTime createdDate;
  final TreatmentStatus status;

  Treatment({
    required this.id,
    required this.name,
    required this.description,
    required this.totalPrice,
    required this.installments,
    required this.createdDate,
    this.status = TreatmentStatus.active,
  });

  double get totalPaidAmount {
    return installments
        .where((installment) => installment.isPaid)
        .fold(0.0, (sum, installment) => sum + installment.amount);
  }

  double get remainingAmount {
    return totalPrice - totalPaidAmount;
  }

  List<Installment> get obligatoryInstallments {
    return installments.where((installment) => installment.isObligatory).toList();
  }

  List<Installment> get paidObligatoryInstallments {
    return obligatoryInstallments.where((installment) => installment.isPaid).toList();
  }

  List<Installment> get unpaidObligatoryInstallments {
    return obligatoryInstallments.where((installment) => !installment.isPaid).toList();
  }

  bool get areObligatoryInstallmentsPaid {
    return unpaidObligatoryInstallments.isEmpty;
  }

  double get remainingObligatoryAmount {
    return unpaidObligatoryInstallments.fold(0.0, (sum, installment) => sum + installment.amount);
  }
}

// Installment model (for base treatments)
class Installment {
  final String id;
  final int order;
  final double amount;
  final bool isObligatory;
  final bool isPaid;
  final DateTime? paidDate;
  final String? paymentId;

  Installment({
    required this.id,
    required this.order,
    required this.amount,
    required this.isObligatory,
    this.isPaid = false,
    this.paidDate,
    this.paymentId,
  });

  Installment copyWith({
    String? id,
    int? order,
    double? amount,
    bool? isObligatory,
    bool? isPaid,
    DateTime? paidDate,
    String? paymentId,
  }) {
    return Installment(
      id: id ?? this.id,
      order: order ?? this.order,
      amount: amount ?? this.amount,
      isObligatory: isObligatory ?? this.isObligatory,
      isPaid: isPaid ?? this.isPaid,
      paidDate: paidDate ?? this.paidDate,
      paymentId: paymentId ?? this.paymentId,
    );
  }
}

// Treatment Template (global, reusable treatment definitions)
class TreatmentTemplate {
  final String id;
  final String name;
  final String description;
  final double totalPrice;
  final List<InstallmentTemplate> installmentTemplates;
  final String category;
  final bool isActive;

  TreatmentTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.totalPrice,
    required this.installmentTemplates,
    this.category = 'Général',
    this.isActive = true,
  });
}

// Installment Template (for predefined treatments)
class InstallmentTemplate {
  final int order;
  final double amount;
  final bool isObligatory;
  final String description;

  InstallmentTemplate({
    required this.order,
    required this.amount,
    required this.isObligatory,
    required this.description,
  });
}

// Patient Treatment Assignment (links patient to a treatment template)
class PatientTreatment {
  final String id;
  final String patientReference;
  final String treatmentTemplateId;
  final DateTime startDate;
  final List<PatientInstallment> installments;
  final PatientTreatmentStatus status;

  PatientTreatment({
    required this.id,
    required this.patientReference,
    required this.treatmentTemplateId,
    required this.startDate,
    required this.installments,
    this.status = PatientTreatmentStatus.active,
  });

  double get totalPaidAmount {
    return installments
        .where((installment) => installment.isPaid)
        .fold(0.0, (sum, installment) => sum + installment.amount);
  }

  double get remainingAmount {
    // This would typically call TreatmentService.getTreatmentTemplate()
    // For now, calculate from installments
    final totalFromInstallments = installments.fold(0.0, (sum, inst) => sum + inst.amount);
    return totalFromInstallments - totalPaidAmount;
  }

  List<PatientInstallment> get obligatoryInstallments {
    return installments.where((installment) => installment.isObligatory).toList();
  }

  List<PatientInstallment> get unpaidObligatoryInstallments {
    return obligatoryInstallments.where((installment) => !installment.isPaid).toList();
  }

  bool get areObligatoryInstallmentsPaid {
    return unpaidObligatoryInstallments.isEmpty;
  }
}

// Patient-specific installment (instance of template)
class PatientInstallment {
  final String id;
  final int order;
  final double amount;
  final bool isObligatory;
  final String description;
  final bool isPaid;
  final DateTime? paidDate;
  final String? paymentId;

  PatientInstallment({
    required this.id,
    required this.order,
    required this.amount,
    required this.isObligatory,
    required this.description,
    this.isPaid = false,
    this.paidDate,
    this.paymentId,
  });

  PatientInstallment copyWith({
    String? id,
    int? order,
    double? amount,
    bool? isObligatory,
    String? description,
    bool? isPaid,
    DateTime? paidDate,
    String? paymentId,
  }) {
    return PatientInstallment(
      id: id ?? this.id,
      order: order ?? this.order,
      amount: amount ?? this.amount,
      isObligatory: isObligatory ?? this.isObligatory,
      description: description ?? this.description,
      isPaid: isPaid ?? this.isPaid,
      paidDate: paidDate ?? this.paidDate,
      paymentId: paymentId ?? this.paymentId,
    );
  }
}