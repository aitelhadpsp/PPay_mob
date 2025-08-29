import 'dart:io';

import 'package:denta_incomes/widgets/SignatureBox.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Model Classes
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

// Mock Data
class MockData {
  static List<Patient> patients = [
    Patient(name: "Abdelhak Ait elhad", reference: "9090", phone: "+212 6 12 34 56 78", email: "abdelhak@email.com"),
    Patient(name: "Sarah El Mansouri", reference: "8821", phone: "+212 6 87 65 43 21", email: "sarah@email.com"),
    Patient(name: "Mohamed Benali", reference: "7755", phone: "+212 6 55 44 33 22", email: "mohamed@email.com"),
    Patient(name: "Fatima Zahra", reference: "6644", phone: "+212 6 99 88 77 66", email: "fatima@email.com"),
    Patient(name: "Omar Alaoui", reference: "5533", phone: "+212 6 11 22 33 44", email: "omar@email.com"),
  ];

  static List<Payment> getTodayPayments() {
    final today = DateTime.now();
    return [
      Payment(patient: patients[0], amount: 1500.0, date: today.subtract(Duration(hours: 2))),
      Payment(patient: patients[1], amount: 800.0, date: today.subtract(Duration(hours: 4))),
      Payment(patient: patients[2], amount: 2200.0, date: today.subtract(Duration(hours: 6))),
      Payment(patient: patients[3], amount: 950.0, date: today.subtract(Duration(hours: 8))),
    ];
  }
}

// Custom App Bar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3F5C9E)),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF3F5C9E),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

// Custom Card Widget
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Add these updated screen classes to your screens/main.dart file
// These maintain your original SignatureBox import and have smaller, cleaner design

// Patient Selection Screen - Compact design
class PatientSelectionScreen extends StatefulWidget {
  const PatientSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PatientSelectionScreen> createState() => _PatientSelectionScreenState();
}

class _PatientSelectionScreenState extends State<PatientSelectionScreen> {
  String searchQuery = '';
  Patient? selectedPatient;

  final List<Patient> mockPatients = [
    Patient(name: "Abdelhak Ait elhad", reference: "9090"),
    Patient(name: "Sarah El Mansouri", reference: "8821"),
    Patient(name: "Mohamed Benali", reference: "7755"),
    Patient(name: "Fatima Zahra", reference: "6644"),
    Patient(name: "Omar Alaoui", reference: "5533"),
  ];

  List<Patient> get filteredPatients {
    if (searchQuery.isEmpty) return mockPatients;
    return mockPatients
        .where((patient) =>
            patient.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            patient.reference.contains(searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Nouveau Encaissement'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sélectionner un Patient',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom ou référence...',
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          
          // Patient List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
                final isSelected = selectedPatient?.reference == patient.reference;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    onTap: () => setState(() => selectedPatient = patient),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: isSelected 
                          ? const Color(0xFF4F46E5)
                          : const Color(0xFFF1F5F9),
                      child: Text(
                        patient.name[0].toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    title: Text(
                      patient.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Ref: ${patient.reference}',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFF4F46E5),
                            size: 20,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          
          // Continue Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedPatient != null
                    ? () {
                        Navigator.pushNamed(
                          context,
                          '/new-payment',
                          arguments: selectedPatient,
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
                  selectedPatient != null
                      ? 'Continuer'
                      : 'Sélectionner un patient',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// New Payment Screen - Keep original SignatureBox
// Replace your NewPaymentScreen class in screens/main.dart with this updated version
// This works with your existing SignatureBox widget

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
    final Patient patient = ModalRoute.of(context)?.settings.arguments as Patient? 
        ?? Patient(name: "Abdelhak Ait elhad", reference: "9090");

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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        color: _hasSignature 
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
                          color: _amountController.text.isNotEmpty 
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
                          color: _hasSignature 
                              ? const Color(0xFF10B981) 
                              : const Color(0xFFE2E8F0),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Signature obtenue',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_amountController.text.isNotEmpty && _hasSignature)
                        ? () {
                            // Create payment data with signature path
                            final paymentData = {
                              'patient': patient,
                              'amount': double.tryParse(_amountController.text) ?? 0.0,
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
                        color: (_amountController.text.isNotEmpty && _hasSignature)
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
// Payment Success Screen - Compact design
// Replace your PaymentSuccessScreen class with this updated version
// This can display the actual signature image

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get payment data from navigation arguments
    final Map<String, dynamic>? paymentData = 
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    // Fallback to default data if no arguments passed
    final Patient patient = paymentData?['patient'] ?? 
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
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 40,
              ),
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
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
              ),
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
                    _buildDetailRow('Patient', patient.name, Icons.person_outline),
                    const SizedBox(height: 16),
                    _buildDetailRow('Référence', patient.reference, Icons.badge_outlined),
                    const SizedBox(height: 16),
                    _buildDetailRow('Date', _formatDateTime(date), Icons.access_time_outlined),
                    const SizedBox(height: 16),
                    _buildDetailRow('Montant', '${amount.toInt()} DH', Icons.payments_outlined),
                    
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
                      child: signaturePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(signaturePath),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
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
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF64748B),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
          ),
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
// Daily Receipts Screen - List style like in image
class DailyReceiptsScreen extends StatelessWidget {
  const DailyReceiptsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todayPayments = [
      Payment(
        patient: Patient(name: "Abdelhak Ait elhad", reference: "9090"),
        amount: 1500.0,
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Payment(
        patient: Patient(name: "Sarah El Mansouri", reference: "8821"),
        amount: 800.0,
        date: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      Payment(
        patient: Patient(name: "Mohamed Benali", reference: "7755"),
        amount: 2200.0,
        date: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      Payment(
        patient: Patient(name: "Fatima Zahra", reference: "6644"),
        amount: 950.0,
        date: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ];
    
    final total = todayPayments.fold(0.0, (sum, payment) => sum + payment.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Recette du Jour'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with date and total
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${todayPayments.length} paiement${todayPayments.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${total.toInt()} DH',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Payments list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: todayPayments.length,
              itemBuilder: (context, index) {
                final payment = todayPayments[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFF4F46E5),
                        child: Text(
                          payment.patient.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payment.patient.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTime(payment.date),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Ref: ${payment.patient.reference}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${payment.amount.toInt()} DH',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Payé',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todayPayments = [
      Payment(
        patient: Patient(name: "Abdelhak Ait elhad", reference: "9090"),
        amount: 1500.0,
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Payment(
        patient: Patient(name: "Sarah El Mansouri", reference: "8821"),
        amount: 800.0,
        date: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      Payment(
        patient: Patient(name: "Mohamed Benali", reference: "7755"),
        amount: 2200.0,
        date: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
    
    final totalToday = todayPayments.fold(0.0, (sum, payment) => sum + payment.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Mes Projets'), // Changed to match image style
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFE2E8F0),
              child: Icon(
                Icons.notifications_outlined,
                size: 18,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stats Row - More compact like in image
            Row(
              children: [
                Expanded(
                  child: _buildCompactStatCard(
                    'Recette Jour',
                    '${totalToday.toInt()} DH',
                    const Color(0xFF10B981),
                    '86% Done', // Progress like in image
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCompactStatCard(
                    'Patients',
                    '${todayPayments.length}',
                    const Color(0xFF4F46E5),
                    'En cours',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Progress Section - Like in the image
            const Text(
              'Mes Progrès',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            
            _buildProgressSection(todayPayments.length, totalToday),
            
            const SizedBox(height: 20),
            
            // Quick Actions - More compact
            Row(
              children: [
                const Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Nouveau Encaissement',
                    Icons.add_circle_outline,
                    const Color(0xFF4F46E5),
                    () => Navigator.pushNamed(context, '/patient-selection'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Recettes du Jour',
                    Icons.bar_chart,
                    const Color(0xFF10B981),
                    () => Navigator.pushNamed(context, '/daily-receipts'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Team Members section (adapted from image)
            _buildTeamSection(todayPayments),
            
            const SizedBox(height: 20),
            
            // Bottom Navigation-like buttons (like in image)
            _buildBottomNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStatCard(String title, String value, Color color, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(int patientCount, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$patientCount Encaissements',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '${total.toInt()} DH',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Collectif',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              const Text(
                '${17}',  // Like in the image
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection(List<Payment> payments) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Derniers Patients',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Espace Collaboratif',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...payments.take(3).map((payment) => Container(
                margin: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF4F46E5),
                  child: Text(
                    payment.patient.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )).toList(),
              if (payments.length > 3)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '${payments.length - 3}+',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Accueil', true, () {}),
          _buildNavItem(Icons.task_outlined, 'Tâches', false, 
              () => Navigator.pushNamed(context, '/daily-receipts')),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', false, () {}),
          _buildNavItem(Icons.calendar_today_outlined, 'Calendrier', false, () {}),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF4F46E5).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8),
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
