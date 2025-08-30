// Add these new model classes to your screens/main.dart file
class Patient {
  final String name;
  final String reference;
  final String? phone;
  final String? email;

  Patient({
    required this.name, 
    required this.reference,
    this.phone,
    this.email,
  });
}

class Payment {
  final Patient patient;
  final double amount;
  final DateTime date;
  final String? signature;

  Payment({
    required this.patient,
    required this.amount,
    required this.date,
    this.signature,
  });
}
// Treatment model
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

// Installment model
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

// Payment record model
class PaymentRecord {
  final String id;
  final String treatmentId;
  final String installmentId;
  final double amount;
  final DateTime date;
  final String? signature;
  final PaymentType type;

  PaymentRecord({
    required this.id,
    required this.treatmentId,
    required this.installmentId,
    required this.amount,
    required this.date,
    this.signature,
    this.type = PaymentType.installment,
  });
}

// Enums
enum TreatmentStatus { active, completed, cancelled }
enum PaymentType { installment, partial, full }

// Mock Data Service
class TreatmentService {
   static List<PatientWithTreatments> mockPatients = [
    PatientWithTreatments(
      name: "Abdelhak Ait elhad",
      reference: "9090",
      phone: "+212 6 12 34 56 78",
      email: "abdelhak@email.com",
      treatments: [
        PatientTreatment(
          id: "pt1",
          patientReference: "9090",
          treatmentTemplateId: "tmpl_orthodontie",
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          installments: [
            PatientInstallment(
              id: "pi1",
              order: 1,
              amount: 5000.0,
              isObligatory: true,
              description: 'Premier paiement - Pose des appareils',
              isPaid: true,
              paidDate: DateTime.now().subtract(const Duration(days: 30)),
            ),
            PatientInstallment(
              id: "pi2",
              order: 2,
              amount: 3000.0,
              isObligatory: true,
              description: 'Deuxième paiement - Suivi 3 mois',
            ),
            PatientInstallment(
              id: "pi3",
              order: 3,
              amount: 2000.0,
              isObligatory: false,
              description: 'Paiement optionnel - Suivi 6 mois',
            ),
          ],
        ),
      ],
      paymentHistory: [
        PaymentRecord(
          id: "p1",
          treatmentId: "pt1",
          installmentId: "pi1",
          amount: 5000.0,
          date: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ],
    ),
    PatientWithTreatments(
      name: "Sarah El Mansouri",
      reference: "8821",
      phone: "+212 6 87 65 43 21",
      treatments: [
        PatientTreatment(
          id: "pt2",
          patientReference: "8821",
          treatmentTemplateId: "tmpl_implant",
          startDate: DateTime.now().subtract(const Duration(days: 15)),
          installments: [
            PatientInstallment(
              id: "pi4",
              order: 1,
              amount: 4000.0,
              isObligatory: true,
              description: 'Pose de l\'implant',
              isPaid: true,
              paidDate: DateTime.now().subtract(const Duration(days: 15)),
            ),
            PatientInstallment(
              id: "pi5",
              order: 2,
              amount: 2000.0,
              isObligatory: true,
              description: 'Pose de la couronne',
            ),
          ],
        ),
      ],
      paymentHistory: [
        PaymentRecord(
          id: "p2",
          treatmentId: "pt2",
          installmentId: "pi4",
          amount: 4000.0,
          date: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ],
    ),
  ];

  static List<Treatment> getAvailableTreatmentTemplates() {
    return [
      Treatment(
        id: "template1",
        name: "Orthodontie Complète",
        description: "Traitement orthodontique avec appareils dentaires",
        totalPrice: 15000.0,
        createdDate: DateTime.now(),
        installments: [
          Installment(id: "temp_i1", order: 1, amount: 5000.0, isObligatory: true),
          Installment(id: "temp_i2", order: 2, amount: 3000.0, isObligatory: true),
        ],
      ),
      Treatment(
        id: "template2",
        name: "Implant Dentaire",
        description: "Pose d'implant avec couronne céramique",
        totalPrice: 8000.0,
        createdDate: DateTime.now(),
        installments: [
          Installment(id: "temp_i3", order: 1, amount: 3000.0, isObligatory: true),
          Installment(id: "temp_i4", order: 2, amount: 2000.0, isObligatory: true),
        ],
      ),
      Treatment(
        id: "template3",
        name: "Blanchiment",
        description: "Blanchiment dentaire professionnel",
        totalPrice: 2000.0,
        createdDate: DateTime.now(),
        installments: [
          Installment(id: "temp_i5", order: 1, amount: 1000.0, isObligatory: true),
          Installment(id: "temp_i6", order: 2, amount: 500.0, isObligatory: true),
        ],
      ),
    ];
  }

 static PatientWithTreatments? getPatientByReference(String reference) {
    try {
      return mockPatients.firstWhere((patient) => patient.reference == reference);
    } catch (e) {
      return null;
    }
  }

  static TreatmentTemplate? getTreatmentTemplate(String templateId) {
    try {
      return treatmentTemplates.firstWhere((template) => template.id == templateId);
    } catch (e) {
      return null;
    }
  }

  static List<TreatmentTemplate> getTreatmentTemplatesByCategory(String category) {
    return treatmentTemplates.where((template) => 
        template.category == category && template.isActive).toList();
  }

  static List<String> getTreatmentCategories() {
    return treatmentTemplates
        .where((template) => template.isActive)
        .map((template) => template.category)
        .toSet()
        .toList();
  }

  static void assignTreatmentToPatient(String patientReference, String treatmentTemplateId) {
    final template = getTreatmentTemplate(treatmentTemplateId);
    if (template == null) return;

    final patientIndex = mockPatients.indexWhere((p) => p.reference == patientReference);
    if (patientIndex == -1) return;

    // Create patient treatment with installments from template
    final treatmentId = DateTime.now().millisecondsSinceEpoch.toString();
    final patientTreatment = PatientTreatment(
      id: treatmentId,
      patientReference: patientReference,
      treatmentTemplateId: treatmentTemplateId,
      startDate: DateTime.now(),
      installments: template.installmentTemplates.map((installmentTemplate) {
        return PatientInstallment(
          id: '${treatmentId}_${installmentTemplate.order}',
          order: installmentTemplate.order,
          amount: installmentTemplate.amount,
          isObligatory: installmentTemplate.isObligatory,
          description: installmentTemplate.description,
        );
      }).toList(),
    );

    // Add to patient
    final currentPatient = mockPatients[patientIndex];
    mockPatients[patientIndex] = PatientWithTreatments(
      name: currentPatient.name,
      reference: currentPatient.reference,
      phone: currentPatient.phone,
      email: currentPatient.email,
      treatments: [...currentPatient.treatments, patientTreatment],
      paymentHistory: currentPatient.paymentHistory,
    );
  }

  static void addPaymentToPatient(String patientReference, PaymentRecord payment) {
    final patientIndex = mockPatients.indexWhere((p) => p.reference == patientReference);
    if (patientIndex == -1) return;

    final currentPatient = mockPatients[patientIndex];
    mockPatients[patientIndex] = PatientWithTreatments(
      name: currentPatient.name,
      reference: currentPatient.reference,
      phone: currentPatient.phone,
      email: currentPatient.email,
      treatments: currentPatient.treatments,
      paymentHistory: [...currentPatient.paymentHistory, payment],
    );
  }


static List<TreatmentTemplate> treatmentTemplates = [
    TreatmentTemplate(
      id: 'tmpl_orthodontie',
      name: 'Orthodontie Complète',
      description: 'Traitement orthodontique avec appareils dentaires complet',
      totalPrice: 15000.0,
      category: 'Orthodontie',
      installmentTemplates: [
        InstallmentTemplate(
          order: 1,
          amount: 5000.0,
          isObligatory: true,
          description: 'Premier paiement - Pose des appareils',
        ),
        InstallmentTemplate(
          order: 2,
          amount: 3000.0,
          isObligatory: true,
          description: 'Deuxième paiement - Suivi 3 mois',
        ),
        InstallmentTemplate(
          order: 3,
          amount: 2000.0,
          isObligatory: false,
          description: 'Paiement optionnel - Suivi 6 mois',
        ),
      ],
    ),
    TreatmentTemplate(
      id: 'tmpl_implant',
      name: 'Implant Dentaire',
      description: 'Pose d\'implant avec couronne céramique',
      totalPrice: 8000.0,
      category: 'Chirurgie',
      installmentTemplates: [
        InstallmentTemplate(
          order: 1,
          amount: 4000.0,
          isObligatory: true,
          description: 'Pose de l\'implant',
        ),
        InstallmentTemplate(
          order: 2,
          amount: 2000.0,
          isObligatory: true,
          description: 'Pose de la couronne',
        ),
      ],
    ),
    TreatmentTemplate(
      id: 'tmpl_blanchiment',
      name: 'Blanchiment Dentaire',
      description: 'Blanchiment dentaire professionnel complet',
      totalPrice: 2500.0,
      category: 'Esthétique',
      installmentTemplates: [
        InstallmentTemplate(
          order: 1,
          amount: 1500.0,
          isObligatory: true,
          description: 'Première séance',
        ),
        InstallmentTemplate(
          order: 2,
          amount: 1000.0,
          isObligatory: true,
          description: 'Séance de rappel',
        ),
      ],
    ),
    TreatmentTemplate(
      id: 'tmpl_nettoyage',
      name: 'Nettoyage Complet',
      description: 'Détartrage et nettoyage dentaire professionnel',
      totalPrice: 800.0,
      category: 'Prévention',
      installmentTemplates: [
        InstallmentTemplate(
          order: 1,
          amount: 800.0,
          isObligatory: true,
          description: 'Paiement unique',
        ),
      ],
    ),
    TreatmentTemplate(
      id: 'tmpl_couronne',
      name: 'Couronne Céramique',
      description: 'Pose de couronne céramique sur dent',
      totalPrice: 3500.0,
      category: 'Prothèse',
      installmentTemplates: [
        InstallmentTemplate(
          order: 1,
          amount: 2000.0,
          isObligatory: true,
          description: 'Préparation et empreinte',
        ),
        InstallmentTemplate(
          order: 2,
          amount: 1500.0,
          isObligatory: true,
          description: 'Pose de la couronne',
        ),
      ],
    ),
  ];
}

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
    final template = TreatmentService.getTreatmentTemplate(treatmentTemplateId);
    return (template?.totalPrice ?? 0.0) - totalPaidAmount;
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

// Enhanced Patient model
class PatientWithTreatments extends Patient {
  final List<PatientTreatment> treatments;
  final List<PaymentRecord> paymentHistory;
  final String? phone;
  final String? email;

  PatientWithTreatments({
    required String name,
    required String reference,
    this.phone,
    this.email,
    this.treatments = const [],
    this.paymentHistory = const [],
  }) : super(name: name, reference: reference);

  double get totalAmountPaid {
    return paymentHistory.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  double get totalTreatmentCost {
    double total = 0.0;
    for (var treatment in treatments) {
      final template = TreatmentService.getTreatmentTemplate(treatment.treatmentTemplateId);
      total += template?.totalPrice ?? 0.0;
    }
    return total;
  }

  double get remainingBalance {
    return totalTreatmentCost - totalAmountPaid;
  }
}

// Enums
enum PatientTreatmentStatus { active, completed, cancelled }
