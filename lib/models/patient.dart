import 'treatment.dart';
import 'payment.dart';

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

// Enhanced Patient model with treatments and payment history
class PatientWithTreatments extends Patient {
  final List<PatientTreatment> treatments;
  final List<PaymentRecord> paymentHistory;

  PatientWithTreatments({
    required String name,
    required String reference,
    String? phone,
    String? email,
    this.treatments = const [],
    this.paymentHistory = const [],
  }) : super(name: name, reference: reference, phone: phone, email: email);

  double get totalAmountPaid {
    return paymentHistory.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  double get totalTreatmentCost {
    double total = 0.0;
    for (var treatment in treatments) {
      // This would typically call a service to get template price
      // For now, we'll calculate based on installments
      total += treatment.installments.fold(0.0, (sum, inst) => sum + inst.amount);
    }
    return total;
  }

  double get remainingBalance {
    return totalTreatmentCost - totalAmountPaid;
  }
}