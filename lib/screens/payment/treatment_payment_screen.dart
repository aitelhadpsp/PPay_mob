import 'package:denta_incomes/models/enums.dart';
import 'package:denta_incomes/models/patient.dart';
import 'package:denta_incomes/models/patient_dto.dart';
import 'package:denta_incomes/models/payment.dart';
import 'package:denta_incomes/models/treatment.dart';
import 'package:denta_incomes/models/treatment_dto.dart';
import 'package:denta_incomes/services/treatment_service.dart';
import 'package:denta_incomes/widgets/signature_box.dart';
import 'package:flutter/material.dart';

class TreatmentPaymentScreen extends StatefulWidget {
  const TreatmentPaymentScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentPaymentScreen> createState() => _TreatmentPaymentScreenState();
}

class _TreatmentPaymentScreenState extends State<TreatmentPaymentScreen> {
  bool hasSignature = false;
  String? signaturePath;
  PatientWithTreatmentsDto? patient;
  PatientTreatmentDto? treatment;
  PatientInstallmentDto? installment;
  double paymentAmount = 0.0;
  bool isCustomPayment = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> paymentData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};

    patient = paymentData['patient'];
    treatment = paymentData['treatment'];
    installment = paymentData['installment'];
    paymentAmount = paymentData['amount'] ?? 0.0;
    isCustomPayment = paymentData['isCustomPayment'] ?? false;
  }

  void _onSignatureSaved(String path) {
    setState(() {
      signaturePath = path;
      hasSignature = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (patient == null || treatment == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(title: const Text('Erreur')),
        body: const Center(child: Text('Données manquantes')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Confirmer Paiement'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Summary Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF4F46E5).withOpacity(0.1),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.receipt_long, color: Color(0xFF4F46E5)),
                            SizedBox(width: 8),
                            Text(
                              'Résumé du Paiement',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _buildSummaryRow('Patient', patient!.name),
                        const SizedBox(height: 12),
                        _buildSummaryRow('Traitement', treatment!.id.toString()),
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                          'Type de Paiement',
                          isCustomPayment
                              ? 'Paiement libre'
                              : 'Échéance ${installment!.order}${installment!.isObligatory ? ' (Obligatoire)' : ''}',
                        ),
                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Montant à Payer',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                '${paymentAmount.toInt()} DH',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Treatment Progress
                        const Text(
                          'Progression du Traitement',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payé: ${treatment!.totalPaidAmount.toInt()} DH',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            Text(
                              'Après paiement: ${(treatment!.totalPaidAmount + paymentAmount).toInt()} DH',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value:
                              (treatment!.totalPaidAmount + paymentAmount) /
                              ((treatment!.totalPaidAmount + treatment!.remainingAmount) == 0 ? 1 :(treatment!.totalPaidAmount + treatment!.remainingAmount) ),
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Signature Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Signature du Patient',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      if (hasSignature)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Color(0xFF10B981),
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Signée',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            hasSignature
                                ? const Color(0xFF10B981)
                                : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SignatureBox(onSaved: _onSignatureSaved),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Confirm Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress indicator
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: const Color(0xFF10B981),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Montant confirmé',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Icon(
                        hasSignature
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color:
                            hasSignature
                                ? const Color(0xFF10B981)
                                : const Color(0xFFE2E8F0),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Signature obtenue',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              hasSignature
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: hasSignature ? _confirmPayment : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      disabledBackgroundColor: const Color(0xFFE2E8F0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      hasSignature
                          ? 'Confirmer le Paiement (${paymentAmount.toInt()} DH)'
                          : 'Obtenir la signature du patient',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
        Expanded(
          child: Text(
            value.toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _confirmPayment() {
    // Create payment record
    final paymentId = DateTime.now().millisecondsSinceEpoch.toString();
  /*   final paymentRecord = PaymentRecord(
      id: paymentId,
      treatmentId: treatment!.id.toString(),
      installmentId:
          installment?.id ?? 'custom_${DateTime.now().millisecondsSinceEpoch}',
      amount: paymentAmount,
      date: DateTime.now(),
      signature: signaturePath,
      type: isCustomPayment ? PaymentType.partial : PaymentType.installment,
    ); */

    // Add payment to patient
    //TreatmentService.addPaymentToPatient(patient!.reference, paymentRecord);

    // Show success and navigate
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Paiement de ${paymentAmount.toInt()} DH enregistré!'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate back to patient details
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/patient-details',
      (route) => route.settings.name == '/home',
      arguments: patient!.reference,
    );
  }
}
