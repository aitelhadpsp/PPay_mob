import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../../widgets/signature_box.dart';

class NewPaymentScreen extends StatefulWidget {
  const NewPaymentScreen({super.key});

  @override
  State<NewPaymentScreen> createState() => _NewPaymentScreenState();
}

class _NewPaymentScreenState extends State<NewPaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? _signaturePath; // Store the signature file path
  bool _hasSignature = false;

  // Callback function for when signature is saved
  void _onSignatureSaved(String path) {
    setState(() {
      _signaturePath = path;
      _hasSignature = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Patient patient =
        ModalRoute.of(context)?.settings.arguments as Patient? ??
        Patient(name: "Abdelhak Ait elhad", reference: "9090");

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Nouveau Encaissement'),
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
                  // Patient Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFF4F46E5),
                          child: Text(
                            patient.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patient.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ref: ${patient.reference}',
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Amount Section
                  const Text(
                    'Montant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F46E5),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Entrer le montant',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                        ),
                        suffix: const Text(
                          'DH',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => setState(() {}),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      if (_hasSignature)
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
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            _hasSignature
                                ? const Color(0xFF10B981)
                                : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SignatureBox(
                        onSaved: _onSignatureSaved, // Pass the callback
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress indicator
                if (_amountController.text.isNotEmpty || _hasSignature)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Icon(
                          _amountController.text.isNotEmpty
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color:
                              _amountController.text.isNotEmpty
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFE2E8F0),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Montant saisi',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Icon(
                          _hasSignature
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color:
                              _hasSignature
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
                                _hasSignature
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
                    onPressed:
                        (_amountController.text.isNotEmpty && _hasSignature)
                            ? () {
                              // Create payment data with signature path
                              final paymentData = {
                                'patient': patient,
                                'amount':
                                    double.tryParse(_amountController.text) ??
                                    0.0,
                                'signaturePath': _signaturePath,
                                'date': DateTime.now(),
                              };

                              Navigator.pushReplacementNamed(
                                context,
                                '/payment-success',
                                arguments: paymentData,
                              );
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      disabledBackgroundColor: const Color(0xFFE2E8F0),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      (_amountController.text.isNotEmpty && _hasSignature)
                          ? 'Confirmer l\'Encaissement (${_amountController.text} DH)'
                          : _amountController.text.isEmpty
                          ? 'Saisir le montant'
                          : 'Obtenir la signature',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color:
                            (_amountController.text.isNotEmpty && _hasSignature)
                                ? Colors.white
                                : const Color(0xFF94A3B8),
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

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}