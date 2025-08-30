import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/patient.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get payment data from navigation arguments
    final Map<String, dynamic>? paymentData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Fallback to default data if no arguments passed
    final Patient patient =
        paymentData?['patient'] ??
        Patient(name: "Abdelhak Ait elhad", reference: "9090");
    final double amount = paymentData?['amount'] ?? 1500.0;
    final String? signaturePath = paymentData?['signaturePath'];
    final DateTime date = paymentData?['date'] ?? DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Encaissement Réussi'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Partage du reçu...')),
              );
            },
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
                      child:
                          signaturePath != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(signaturePath),
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                  },
                                ),
                              )
                              : const Center(
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
                              ),
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
            Row(
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
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
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
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
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
}