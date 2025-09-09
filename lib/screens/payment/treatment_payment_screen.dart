import 'package:denta_incomes/models/enums.dart';
import 'package:denta_incomes/models/patient_dto.dart';
import 'package:denta_incomes/models/treatment_dto.dart';
import 'package:denta_incomes/models/payment_dto.dart';
import 'package:denta_incomes/services/payment_service.dart';
import 'package:denta_incomes/services/pdf_service.dart'; // Add this import
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
  String? signatureBase64;
  PatientWithTreatmentsDto? patient;
  PatientTreatmentDto? treatment;
  PatientInstallmentDto? installment;
  double paymentAmount = 0.0;
  bool isCustomPayment = false;
  bool isProcessing = false;

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

  void _onSignatureSaved(String base64) {
    setState(() {
      signatureBase64 = base64;
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
                        _buildSummaryRow('Référence', patient!.reference),
                        const SizedBox(height: 12),
                        _buildSummaryRow('Traitement', treatment!.treatmentName),
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
                    onPressed: (hasSignature && !isProcessing) ? _confirmPayment : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      disabledBackgroundColor: const Color(0xFFE2E8F0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isProcessing
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Traitement en cours...',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        : Text(
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

  Future<void> _confirmPayment() async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    try {
      if (isCustomPayment) {
        // Custom payment
        await _processCustomPayment();
      } else {
        // Installment payment
        await _processInstallmentPayment();
      }
    } catch (e) {
      _showErrorMessage('Erreur lors du traitement du paiement: ${e.toString()}');
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<void> _processInstallmentPayment() async {
    if (installment == null) {
      _showErrorMessage('Données d\'échéance manquantes');
      return;
    }

    // First validate the installment payment
    final validationResponse = await PaymentService.validateInstallmentPayment(installment!.id);
    
    if (!validationResponse.success) {
      _showErrorMessage(validationResponse.message ?? 'Erreur de validation');
      return;
    }

    if (!validationResponse.data!.isValid) {
      _showErrorMessage(validationResponse.data!.errorMessage ?? 'Paiement invalide');
      return;
    }

    // Create installment payment DTO
    final paymentDto = CreateInstallmentPaymentDto(
      patientId: patient!.id,
      patientTreatmentId: treatment!.id,
      paymentMethod: 'Cash', // You can make this configurable
      signatureBase64: signatureBase64,
      notes: 'Paiement échéance ${installment!.order}',
    );

    // Process the payment
    final response = await PaymentService.payInstallment(installment!.id, paymentDto);
    
    if (response.success && response.data != null) {
      await _showSuccessAndNavigate(response.data!);
    } else {
      _showErrorMessage(response.message ?? 'Erreur lors du traitement du paiement');
    }
  }

  Future<void> _processCustomPayment() async {
    // Validate custom payment amount
    final validationResponse = await PaymentService.validatePaymentAmount(
      treatment!.id, 
      paymentAmount
    );
    
    if (!validationResponse.success) {
      _showErrorMessage(validationResponse.message ?? 'Erreur de validation');
      return;
    }

    if (!validationResponse.data!) {
      _showErrorMessage('Montant de paiement invalide');
      return;
    }

    // Create custom payment DTO
    final paymentDto = CreateCustomPaymentDto(
      patientId: patient!.id,
      patientTreatmentId: treatment!.id,
      amount: paymentAmount,
      totalTreatmentCost: treatment!.totalPrice,
      paymentMethod: 'Cash', // You can make this configurable
      signatureBase64: signatureBase64,
      notes: 'Paiement libre de ${paymentAmount.toInt()} DH',
    );

    // Process the payment
    final response = await PaymentService.payCustomAmount(paymentDto);
    
    if (response.success && response.data != null) {
      await _showSuccessAndNavigate(response.data!);
    } else {
      _showErrorMessage(response.message ?? 'Erreur lors du traitement du paiement');
    }
  }

  Future<void> _showSuccessAndNavigate(PaymentRecordDto paymentRecord) async {
    try {
      // Generate PDF receipt
      final pdfPath = await PDFService.generatePaymentReceipt(
        patient: patient!,
        treatment: treatment!,
        paymentRecord: paymentRecord,
        paymentAmount: paymentAmount,
        signatureBase64: signatureBase64,
        isCustomPayment: isCustomPayment,
        installment: installment,
      );

      // Show success dialog with PDF options
      if (mounted) {
        await _showSuccessDialog(paymentRecord, pdfPath);
      }
    } catch (pdfError) {
      // If PDF generation fails, still show success but without PDF
      if (mounted) {
        _showSuccessMessage(paymentRecord);
        _navigateToPatientDetails();
      }
    }
  }

  Future<void> _showSuccessDialog(PaymentRecordDto paymentRecord, String pdfPath) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),

              // Success Message
              const Text(
                'Paiement Confirmé!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                'Paiement de ${paymentAmount.toInt()} DH enregistré avec succès',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              Text(
                'Référence: ${paymentRecord.id}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // PDF Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf,
                      color: Color(0xFF4F46E5),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reçu PDF généré',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                          Text(
                            pdfPath.split('/').last,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF64748B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await PDFService.sharePDF(pdfPath);
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Partager'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await PDFService.printPDF(pdfPath);
                    },
                    icon: const Icon(Icons.print, size: 18),
                    label: const Text('Imprimer'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _navigateToPatientDetails();
                    },
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Terminé'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage(PaymentRecordDto paymentRecord) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Paiement de ${paymentAmount.toInt()} DH enregistré avec succès!\nRéférence: ${paymentRecord.id}',
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _navigateToPatientDetails() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/patient-details',
      (route) => route.settings.name == '/home',
      arguments: patient!.id,
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}