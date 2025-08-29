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
// Enhanced Patient model with treatments
class PatientWithTreatments extends Patient {
  final List<Treatment> treatments;
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
    return treatments.fold(0.0, (sum, treatment) => sum + treatment.totalPrice);
  }

  double get remainingBalance {
    return totalTreatmentCost - totalAmountPaid;
  }
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
        Treatment(
          id: "t1",
          name: "Orthodontie",
          description: "Traitement orthodontique complet avec appareils",
          totalPrice: 15000.0,
          createdDate: DateTime.now().subtract(const Duration(days: 30)),
          installments: [
            Installment(id: "i1", order: 1, amount: 5000.0, isObligatory: true, isPaid: true, paidDate: DateTime.now().subtract(const Duration(days: 30))),
            Installment(id: "i2", order: 2, amount: 3000.0, isObligatory: true),
            Installment(id: "i3", order: 3, amount: 2000.0, isObligatory: false),
          ],
        ),
        Treatment(
          id: "t2",
          name: "Nettoyage",
          description: "Nettoyage dentaire complet",
          totalPrice: 800.0,
          createdDate: DateTime.now().subtract(const Duration(days: 10)),
          installments: [
            Installment(id: "i4", order: 1, amount: 800.0, isObligatory: true, isPaid: true, paidDate: DateTime.now().subtract(const Duration(days: 10))),
          ],
        ),
      ],
      paymentHistory: [
        PaymentRecord(
          id: "p1",
          treatmentId: "t1",
          installmentId: "i1",
          amount: 5000.0,
          date: DateTime.now().subtract(const Duration(days: 30)),
        ),
        PaymentRecord(
          id: "p2",
          treatmentId: "t2",
          installmentId: "i4",
          amount: 800.0,
          date: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ],
    ),
    PatientWithTreatments(
      name: "Sarah El Mansouri",
      reference: "8821",
      phone: "+212 6 87 65 43 21",
      treatments: [
        Treatment(
          id: "t3",
          name: "Implant Dentaire",
          description: "Pose d'implant avec couronne",
          totalPrice: 8000.0,
          createdDate: DateTime.now().subtract(const Duration(days: 15)),
          installments: [
            Installment(id: "i5", order: 1, amount: 3000.0, isObligatory: true, isPaid: true, paidDate: DateTime.now().subtract(const Duration(days: 15))),
            Installment(id: "i6", order: 2, amount: 2000.0, isObligatory: true),
          ],
        ),
      ],
      paymentHistory: [
        PaymentRecord(
          id: "p3",
          treatmentId: "t3",
          installmentId: "i5",
          amount: 3000.0,
          date: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ],
    ),
  ];

  static PatientWithTreatments? getPatientByReference(String reference) {
    try {
      return mockPatients.firstWhere((patient) => patient.reference == reference);
    } catch (e) {
      return null;
    }
  }

  static void addTreatmentToPatient(String patientReference, Treatment treatment) {
    final patientIndex = mockPatients.indexWhere((p) => p.reference == patientReference);
    if (patientIndex != -1) {
      mockPatients[patientIndex] = PatientWithTreatments(
        name: mockPatients[patientIndex].name,
        reference: mockPatients[patientIndex].reference,
        phone: mockPatients[patientIndex].phone,
        email: mockPatients[patientIndex].email,
        treatments: [...mockPatients[patientIndex].treatments, treatment],
        paymentHistory: mockPatients[patientIndex].paymentHistory,
      );
    }
  }

  static void addPaymentToPatient(String patientReference, PaymentRecord payment) {
    final patientIndex = mockPatients.indexWhere((p) => p.reference == patientReference);
    if (patientIndex != -1) {
      mockPatients[patientIndex] = PatientWithTreatments(
        name: mockPatients[patientIndex].name,
        reference: mockPatients[patientIndex].reference,
        phone: mockPatients[patientIndex].phone,
        email: mockPatients[patientIndex].email,
        treatments: mockPatients[patientIndex].treatments,
        paymentHistory: [...mockPatients[patientIndex].paymentHistory, payment],
      );
    }
  }

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
}

