import 'dart:convert';
import 'package:denta_incomes/models/patient_dto.dart';
import 'package:denta_incomes/models/payment_dto.dart';
import 'package:denta_incomes/services/pdf_service.dart';
import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get payment data from navigation arguments
    final Map<String, dynamic>? paymentData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Extract data with fallbacks
    final PatientDto patient = paymentData?['patient'];
    final PaymentRecordDto? paymentRecord = paymentData?['paymentRecord'];
    final double amount = paymentData?['amount'] ?? 1500.0;
    final String? signatureBase64 = paymentData?['signatureBase64'];
    final String? pdfPath = paymentData?['pdfPath'];
    final DateTime date = paymentData?['date'] ?? DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Paiement Réussi'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (pdfPath != null)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) => _handleMenuAction(context, value, pdfPath),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, size: 20),
                      SizedBox(width: 8),
                      Text('Partager PDF'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'print',
                  child: Row(
                    children: [
                      Icon(Icons.print, size: 20),
                      SizedBox(width: 8),
                      Text('Imprimer'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'open',
                  child: Row(
                    children: [
                      Icon(Icons.open_in_new, size: 20),
                      SizedBox(width: 8),
                      Text('Ouvrir PDF'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Success Animation/Icon
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),

            const Text(
              'Paiement Confirmé!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Reçu généré le ${_formatDate(date)}',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),

            // PDF Status Banner
            if (pdfPath != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF4F46E5).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf,
                      color: Color(0xFF4F46E5),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reçu PDF généré avec succès',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                          Text(
                            pdfPath.split('/').last,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _handleMenuAction(context, 'open', pdfPath),
                      icon: const Icon(
                        Icons.open_in_new,
                        color: Color(0xFF4F46E5),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),

            // Payment Receipt Card
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with amount
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'REÇU DE PAIEMENT',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              '${amount.toInt()} DH',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Payment Details
                    _buildDetailRow(
                      'Patient',
                      patient.name,
                      Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Référence',
                      patient.reference,
                      Icons.badge_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Date',
                      _formatDateTime(date),
                      Icons.access_time_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Montant',
                      '${amount.toInt()} DH',
                      Icons.payments_outlined,
                    ),
                    if (paymentRecord != null) ...[
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Référence Paiement',
                        paymentRecord.id.toString(),
                        Icons.receipt_long_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Méthode',
                        paymentRecord.paymentMethod,
                        Icons.payment_outlined,
                      ),
                    ],

                    const SizedBox(height: 30),

                    // Signature Section
                    const Text(
                      'Signature du Patient',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: _buildSignatureWidget(signatureBase64),
                    ),

                    const Spacer(),

                    // Footer
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 1,
                            width: 80,
                            color: const Color(0xFFE2E8F0),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Cabinet Dentaire',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            _buildActionButtons(context, pdfPath),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureWidget(String? signatureBase64) {
    if (signatureBase64 != null && signatureBase64.isNotEmpty) {
      try {
        // Decode base64 to bytes
        final bytes = base64Decode(signatureBase64);
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            bytes,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildSignaturePlaceholder();
            },
          ),
        );
      } catch (e) {
        // If decoding fails, show placeholder
        return _buildSignaturePlaceholder();
      }
    } else {
      return _buildSignaturePlaceholder();
    }
  }

  Widget _buildSignaturePlaceholder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Color(0xFF10B981),
            size: 32,
          ),
          SizedBox(height: 8),
          Text(
            'Signature capturée',
            style: TextStyle(
              color: Color(0xFF10B981),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String? pdfPath) {
    if (pdfPath != null) {
      // Show PDF-specific buttons
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleMenuAction(context, 'share', pdfPath),
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Partager'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5EDFF),
                    foregroundColor: const Color(0xFF4F46E5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleMenuAction(context, 'print', pdfPath),
                  icon: const Icon(Icons.print_outlined, size: 18),
                  label: const Text('Imprimer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home_outlined, size: 18),
              label: const Text('Retour à l\'Accueil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Show basic buttons when no PDF
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home_outlined, size: 18),
              label: const Text('Accueil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5EDFF),
                foregroundColor: const Color(0xFF4F46E5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Impression en cours...'),
                    backgroundColor: Color(0xFF4F46E5),
                  ),
                );
              },
              icon: const Icon(Icons.print_outlined, size: 18),
              label: const Text('Imprimer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year à $hour:$minute';
  }

  Future<void> _handleMenuAction(BuildContext context, String action, String pdfPath) async {
    try {
      switch (action) {
        case 'share':
          await PDFService.sharePDF(pdfPath);
          break;
        case 'print':
          await PDFService.printPDF(pdfPath);
          break;
        case 'open':
          await PDFService.openPDF(pdfPath);
          break;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}