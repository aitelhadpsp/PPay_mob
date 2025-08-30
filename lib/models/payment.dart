import 'patient.dart';
import 'enums.dart';

// Simple payment model (legacy, for basic payments)
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

// Payment record model (for treatment-based payments)
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