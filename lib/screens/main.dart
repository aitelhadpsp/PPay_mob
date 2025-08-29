import 'dart:io';

import 'package:denta_incomes/screens/models.dart';
import 'package:denta_incomes/widgets/SignatureBox.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Model Classes


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
// Updated PatientSelectionScreen class - replace the existing one in your screens/main.dart

// Replace your existing PatientSelectionScreen with this updated version in screens/main.dart

class PatientSelectionScreen extends StatefulWidget {
  const PatientSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PatientSelectionScreen> createState() => _PatientSelectionScreenState();
}

class _PatientSelectionScreenState extends State<PatientSelectionScreen> {
  String searchQuery = '';
  Patient? selectedPatient;

  List<Patient> mockPatients = [
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
        title: const Text('Sélectionner Patient'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: _navigateToCreateUser,
            tooltip: 'Créer nouveau patient',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Create Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Choisissez un patient',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _navigateToCreateUser,
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Color(0xFF8B5CF6),
                      ),
                      label: const Text(
                        'Nouveau',
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6).withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      ),
                    ),
                  ],
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
            child: filteredPatients.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = filteredPatients[index];
                      final isSelected = selectedPatient?.reference == patient.reference;
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: ListTile(
                          onTap: () => setState(() => selectedPatient = patient),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: isSelected 
                                ? const Color(0xFF4F46E5)
                                : const Color(0xFFF1F5F9),
                            child: Text(
                              patient.name[0].toUpperCase(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          title: Text(
                            patient.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF1E293B),
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.badge_outlined,
                                    size: 14,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Ref: ${patient.reference}',
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Info button to view patient details
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/patient-details',
                                    arguments: patient.reference,
                                  );
                                },
                                icon: Icon(
                                  Icons.info_outline,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                tooltip: 'Voir détails',
                              ),
                              const SizedBox(width: 8),
                              // Selection indicator
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4F46E5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              else
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          // Continue Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Quick stats
                if (filteredPatients.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${filteredPatients.length} patient${filteredPatients.length > 1 ? 's' : ''} trouvé${filteredPatients.length > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Action Buttons Row
                Row(
                  children: [
                    // Payment Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: selectedPatient != null
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  '/treatment-payment-selection',
                                  arguments: selectedPatient!.reference,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.payment, size: 18),
                        label: const Text(
                          'Paiement',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          disabledBackgroundColor: const Color(0xFFE2E8F0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Details Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: selectedPatient != null
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  '/patient-details',
                                  arguments: selectedPatient!.reference,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.person_outline, size: 18),
                        label: const Text(
                          'Détails',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          disabledBackgroundColor: const Color(0xFFE2E8F0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Helper text
                if (selectedPatient != null)
                  Text(
                    'Patient sélectionné: ${selectedPatient!.name}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_search,
                size: 40,
                color: Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucun patient trouvé',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.isNotEmpty
                  ? 'Aucun résultat pour "$searchQuery"'
                  : 'Commencez par créer votre premier patient',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _navigateToCreateUser,
              icon: const Icon(Icons.person_add, size: 20),
              label: const Text('Créer un nouveau patient'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateUser() async {
    final result = await Navigator.pushNamed(context, '/create-user');
    
    if (result != null && result is Patient) {
      setState(() {
        mockPatients.insert(0, result);
        selectedPatient = result;
        searchQuery = '';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text('${result.name} ajouté et sélectionné!'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'Voir Détails',
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/patient-details',
                arguments: result.reference,
              );
            },
          ),
        ),
      );
    }
  }
}// New Payment Screen - Keep original SignatureBox
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

// Updated HomeScreen class - replace the existing one in your screens/main.dart

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
        title: const Text('Mes Projets'),
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
            // Top Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildCompactStatCard(
                    'Recette Jour',
                    '${totalToday.toInt()} DH',
                    const Color(0xFF10B981),
                    '86% Done',
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
            
            // Progress Section
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
            
            // Quick Actions - Updated with Create Patient
            Row(
              children: [
                const Text(
                  'Actions Rapides',
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
            
            // Updated Actions Grid - 3 buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Nouveau\nEncaissement',
                    Icons.add_circle_outline,
                    const Color(0xFF4F46E5),
                    () => Navigator.pushNamed(context, '/patient-selection'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Créer\nPatient',
                    Icons.person_add_outlined,
                    const Color(0xFF8B5CF6),
                    () => Navigator.pushNamed(context, '/create-user'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Recettes\nJour',
                    Icons.bar_chart,
                    const Color(0xFF10B981),
                    () => Navigator.pushNamed(context, '/daily-receipts'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Team Members section
            _buildTeamSection(todayPayments),
            
            const SizedBox(height: 20),
            
            // Bottom Navigation
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
                '17',
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
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
          _buildNavItem(Icons.person_add_outlined, 'Patients', false,
              () => Navigator.pushNamed(context, '/create-user')),
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
}// Add this CreateUserScreen class to your screens/main.dart file

// Updated CreateUserScreen class - replace the existing one in your screens/main.dart

// Updated CreateUserScreen class - replace the existing one in your screens/main.dart

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _referenceController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedGender;
  DateTime? _selectedBirthDate;
  bool _isLoading = false;

  final List<String> _genderOptions = ['Homme', 'Femme'];

  @override
  void initState() {
    super.initState();
    // Auto-generate reference number
    _generateReference();
  }

  void _generateReference() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    _referenceController.text = timestamp.substring(timestamp.length - 6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Nouveau Patient'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isFormValid() ? _savePatient : null,
            child: Text(
              'Enregistrer',
              style: TextStyle(
                color: _isFormValid() 
                    ? const Color(0xFF4F46E5) 
                    : const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator - now only tracks required fields
                    _buildProgressIndicator(),
                    
                    const SizedBox(height: 24),
                    
                    // Required Information Section
                    _buildSectionCard(
                      title: 'Informations Obligatoires',
                      icon: Icons.star,
                      isRequired: true,
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nom complet *',
                          hint: 'Ex: Ahmed Ben Ali',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Le nom est obligatoire';
                            }
                            if (value.trim().length < 2) {
                              return 'Le nom doit contenir au moins 2 caractères';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildTextField(
                                controller: _referenceController,
                                label: 'Référence *',
                                hint: 'Ex: 123456',
                                icon: Icons.badge_outlined,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'La référence est obligatoire';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Regenerate button
                            Container(
                              margin: const EdgeInsets.only(top: 24),
                              child: IconButton(
                                onPressed: _generateReference,
                                icon: const Icon(Icons.refresh),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F46E5).withOpacity(0.1),
                                  foregroundColor: const Color(0xFF4F46E5),
                                ),
                                tooltip: 'Générer nouvelle référence',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Optional Personal Information
                    _buildSectionCard(
                      title: 'Informations Personnelles (Optionnelles)',
                      icon: Icons.person_outline,
                      isRequired: false,
                      children: [
                        // Gender Selection
                        const Text(
                          'Genre',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: _genderOptions.map((gender) {
                            final isSelected = _selectedGender == gender;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedGender = gender),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: gender == _genderOptions.first ? 8 : 0,
                                    left: gender == _genderOptions.last ? 8 : 0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? const Color(0xFF4F46E5).withOpacity(0.1)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected 
                                          ? const Color(0xFF4F46E5)
                                          : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        gender == 'Homme' ? Icons.male : Icons.female,
                                        color: isSelected 
                                            ? const Color(0xFF4F46E5)
                                            : const Color(0xFF64748B),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        gender,
                                        style: TextStyle(
                                          color: isSelected 
                                              ? const Color(0xFF4F46E5)
                                              : const Color(0xFF64748B),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Birth Date
                        GestureDetector(
                          onTap: _selectBirthDate,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Color(0xFF64748B),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _selectedBirthDate != null
                                      ? 'Date de naissance: ${_formatDate(_selectedBirthDate!)}'
                                      : 'Sélectionner la date de naissance',
                                  style: TextStyle(
                                    color: _selectedBirthDate != null
                                        ? const Color(0xFF1E293B)
                                        : const Color(0xFF94A3B8),
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Optional Contact Information
                    _buildSectionCard(
                      title: 'Informations de Contact (Optionnelles)',
                      icon: Icons.contact_phone_outlined,
                      isRequired: false,
                      children: [
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Téléphone',
                          hint: '+212 6 00 00 00 00',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'patient@email.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _addressController,
                          label: 'Adresse',
                          hint: 'Rue, Ville, Code postal',
                          icon: Icons.location_on_outlined,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Optional Notes Section
                    _buildSectionCard(
                      title: 'Notes Médicales (Optionnelles)',
                      icon: Icons.note_outlined,
                      isRequired: false,
                      children: [
                        _buildTextField(
                          controller: _notesController,
                          label: 'Notes',
                          hint: 'Allergies, conditions médicales, remarques...',
                          icon: Icons.note_outlined,
                          maxLines: 3,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 100), // Space for floating button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Floating Action Button - only shows when required fields are filled
      floatingActionButton: _isFormValid()
          ? FloatingActionButton.extended(
              onPressed: _isLoading ? null : _savePatient,
              backgroundColor: const Color(0xFF4F46E5),
              icon: _isLoading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_isLoading ? 'Enregistrement...' : 'Enregistrer'),
            )
          : null,
    );
  }

  Widget _buildProgressIndicator() {
    final completedFields = _getCompletedRequiredFieldsCount();
    final totalRequiredFields = 2; // Only name and reference are required
    final progress = completedFields / totalRequiredFields;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Champs Obligatoires',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Row(
                children: [
                  Text(
                    '$completedFields/$totalRequiredFields',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: completedFields == totalRequiredFields 
                          ? const Color(0xFF10B981)
                          : const Color(0xFF64748B),
                    ),
                  ),
                  if (completedFields == totalRequiredFields)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                        size: 18,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(
              completedFields == totalRequiredFields 
                  ? const Color(0xFF10B981)
                  : const Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            completedFields == totalRequiredFields 
                ? 'Prêt à enregistrer!'
                : 'Veuillez remplir tous les champs obligatoires',
            style: TextStyle(
              fontSize: 12,
              color: completedFields == totalRequiredFields 
                  ? const Color(0xFF10B981)
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isRequired,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isRequired 
            ? Border.all(color: const Color(0xFF4F46E5).withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isRequired ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isRequired ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                  ),
                ),
              ),
              if (isRequired)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Obligatoire',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF4F46E5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          onChanged: (value) => setState(() {}), // Update progress
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  bool _isFormValid() {
    return _nameController.text.trim().isNotEmpty &&
           _referenceController.text.trim().isNotEmpty;
  }

  int _getCompletedRequiredFieldsCount() {
    int count = 0;
    if (_nameController.text.trim().isNotEmpty) count++;
    if (_referenceController.text.trim().isNotEmpty) count++;
    return count;
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Create new patient with only name and reference (required fields)
    final newPatient = Patient(
      name: _nameController.text.trim(),
      reference: _referenceController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Patient ${newPatient.name} créé avec succès!'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Navigate back with result
    Navigator.pop(context, newPatient);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _referenceController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

// Add this CreateTreatmentScreen class to your screens/main.dart file

class CreateTreatmentScreen extends StatefulWidget {
  const CreateTreatmentScreen({Key? key}) : super(key: key);

  @override
  State<CreateTreatmentScreen> createState() => _CreateTreatmentScreenState();
}

class _CreateTreatmentScreenState extends State<CreateTreatmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _totalPriceController = TextEditingController();
  
  List<InstallmentData> _installments = [
    InstallmentData(order: 1, amount: 0.0, isObligatory: true),
    InstallmentData(order: 2, amount: 0.0, isObligatory: true),
  ];
  
  bool _isLoading = false;
  String? _patientReference;
  bool _useTemplate = false;
  Treatment? _selectedTemplate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _patientReference = ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Nouveau Traitement'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isFormValid() ? _saveTreatment : null,
            child: Text(
              'Enregistrer',
              style: TextStyle(
                color: _isFormValid() 
                    ? const Color(0xFF4F46E5) 
                    : const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Template Selection
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.library_books, color: Color(0xFF8B5CF6)),
                              const SizedBox(width: 8),
                              const Text(
                                'Modèles de Traitement',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                value: _useTemplate,
                                onChanged: (value) {
                                  setState(() {
                                    _useTemplate = value;
                                    if (!value) {
                                      _selectedTemplate = null;
                                      _clearForm();
                                    }
                                  });
                                },
                                activeColor: const Color(0xFF8B5CF6),
                              ),
                            ],
                          ),
                          if (_useTemplate) ...[
                            const SizedBox(height: 12),
                            ...TreatmentService.getAvailableTreatmentTemplates()
                                .map((template) => _buildTemplateCard(template)),
                          ],
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Treatment Information
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.medical_services, color: Color(0xFF4F46E5)),
                              SizedBox(width: 8),
                              Text(
                                'Informations du Traitement',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          _buildTextField(
                            controller: _nameController,
                            label: 'Nom du Traitement',
                            hint: 'Ex: Orthodontie, Implant...',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Le nom est obligatoire';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          _buildTextField(
                            controller: _descriptionController,
                            label: 'Description',
                            hint: 'Description détaillée du traitement...',
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'La description est obligatoire';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          _buildTextField(
                            controller: _totalPriceController,
                            label: 'Prix Total (DH)',
                            hint: '0',
                            keyboardType: TextInputType.number,
                            onChanged: _updateInstallmentCalculations,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Le prix est obligatoire';
                              }
                              final price = double.tryParse(value);
                              if (price == null || price <= 0) {
                                return 'Prix invalide';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Installments Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.payments, color: Color(0xFF10B981)),
                              const SizedBox(width: 8),
                              const Text(
                                'Échéances de Paiement',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: _addInstallment,
                                icon: const Icon(Icons.add, size: 16),
                                label: const Text('Ajouter'),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          ...List.generate(_installments.length, (index) {
                            return _buildInstallmentCard(index);
                          }),
                          
                          const SizedBox(height: 16),
                          
                          // Summary
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Échéances:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${_getTotalInstallments().toInt()} DH',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Paiement Libre:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${_getFreePaymentAmount().toInt()} DH',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: _getFreePaymentAmount() < 0 
                                            ? const Color(0xFFEF4444) 
                                            : const Color(0xFF10B981),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: _isFormValid()
          ? FloatingActionButton.extended(
              onPressed: _isLoading ? null : _saveTreatment,
              backgroundColor: const Color(0xFF4F46E5),
              icon: _isLoading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(_isLoading ? 'Enregistrement...' : 'Créer Traitement'),
            )
          : null,
    );
  }

  Widget _buildTemplateCard(Treatment template) {
    final isSelected = _selectedTemplate?.id == template.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => _selectTemplate(template),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF8B5CF6).withOpacity(0.1) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${template.totalPrice.toInt()} DH - ${template.obligatoryInstallments.length} échéances',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF8B5CF6),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstallmentCard(int index) {
    final installment = _installments[index];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: installment.isObligatory 
                      ? const Color(0xFFEF4444).withOpacity(0.1)
                      : const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${installment.order}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: installment.isObligatory 
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF3B82F6),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Échéance ${installment.order}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Row(
                      children: [
                        Switch(
                          value: installment.isObligatory,
                          onChanged: (value) {
                            setState(() {
                              _installments[index] = installment.copyWith(isObligatory: value);
                            });
                          },
                          activeColor: const Color(0xFFEF4444),
                        ),
                        Text(
                          installment.isObligatory ? 'Obligatoire' : 'Optionnelle',
                          style: TextStyle(
                            fontSize: 12,
                            color: installment.isObligatory 
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_installments.length > 2)
                IconButton(
                  onPressed: () => _removeInstallment(index),
                  icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final amount = double.tryParse(value) ?? 0.0;
              setState(() {
                _installments[index] = installment.copyWith(amount: amount);
              });
            },
            decoration: InputDecoration(
              labelText: 'Montant (DH)',
              hintText: '0',
              prefixIcon: const Icon(Icons.attach_money, size: 20),
              suffix: const Text('DH'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  void _selectTemplate(Treatment template) {
    setState(() {
      _selectedTemplate = template;
      _nameController.text = template.name;
      _descriptionController.text = template.description;
      _totalPriceController.text = template.totalPrice.toString();
      
      // Setup installments from template
      _installments = template.obligatoryInstallments
          .map((installment) => InstallmentData(
                order: installment.order,
                amount: installment.amount,
                isObligatory: installment.isObligatory,
              ))
          .toList();
    });
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _totalPriceController.clear();
    setState(() {
      _installments = [
        InstallmentData(order: 1, amount: 0.0, isObligatory: true),
        InstallmentData(order: 2, amount: 0.0, isObligatory: true),
      ];
    });
  }

  void _addInstallment() {
    setState(() {
      _installments.add(
        InstallmentData(
          order: _installments.length + 1,
          amount: 0.0,
          isObligatory: false,
        ),
      );
    });
  }

  void _removeInstallment(int index) {
    if (_installments.length > 2) {
      setState(() {
        _installments.removeAt(index);
        // Reorder remaining installments
        for (int i = 0; i < _installments.length; i++) {
          _installments[i] = _installments[i].copyWith(order: i + 1);
        }
      });
    }
  }

  void _updateInstallmentCalculations(String value) {
    // This can be used for auto-calculating installment suggestions
    setState(() {});
  }

  double _getTotalInstallments() {
    return _installments.fold(0.0, (sum, installment) => sum + installment.amount);
  }

  double _getFreePaymentAmount() {
    final totalPrice = double.tryParse(_totalPriceController.text) ?? 0.0;
    return totalPrice - _getTotalInstallments();
  }

  bool _isFormValid() {
    return _nameController.text.trim().isNotEmpty &&
           _descriptionController.text.trim().isNotEmpty &&
           _totalPriceController.text.trim().isNotEmpty &&
           (double.tryParse(_totalPriceController.text) ?? 0) > 0 &&
           _getFreePaymentAmount() >= 0;
  }

  Future<void> _saveTreatment() async {
    if (!_formKey.currentState!.validate() || _patientReference == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    // Create new treatment
    final treatmentId = DateTime.now().millisecondsSinceEpoch.toString();
    final newTreatment = Treatment(
      id: treatmentId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      totalPrice: double.parse(_totalPriceController.text),
      createdDate: DateTime.now(),
      installments: _installments.map((installmentData) {
        return Installment(
          id: '${treatmentId}_${installmentData.order}',
          order: installmentData.order,
          amount: installmentData.amount,
          isObligatory: installmentData.isObligatory,
        );
      }).toList(),
    );

    // Add treatment to patient
    TreatmentService.addTreatmentToPatient(_patientReference!, newTreatment);

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Traitement "${newTreatment.name}" créé avec succès!'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, newTreatment);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _totalPriceController.dispose();
    super.dispose();
  }
}

// Helper class for installment data
class InstallmentData {
  final int order;
  final double amount;
  final bool isObligatory;

  InstallmentData({
    required this.order,
    required this.amount,
    required this.isObligatory,
  });

  InstallmentData copyWith({
    int? order,
    double? amount,
    bool? isObligatory,
  }) {
    return InstallmentData(
      order: order ?? this.order,
      amount: amount ?? this.amount,
      isObligatory: isObligatory ?? this.isObligatory,
    );
  }
}

// Add this TreatmentPaymentSelectionScreen class to your screens/main.dart file

class TreatmentPaymentSelectionScreen extends StatefulWidget {
  const TreatmentPaymentSelectionScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentPaymentSelectionScreen> createState() => _TreatmentPaymentSelectionScreenState();
}

class _TreatmentPaymentSelectionScreenState extends State<TreatmentPaymentSelectionScreen> {
  PatientWithTreatments? patient;
  Treatment? selectedTreatment;
  Installment? selectedInstallment;
  double customPaymentAmount = 0.0;
  final TextEditingController _customAmountController = TextEditingController();
  bool isCustomPayment = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String patientReference = ModalRoute.of(context)?.settings.arguments as String? ?? "9090";
    patient = TreatmentService.getPatientByReference(patientReference);
  }

  @override
  Widget build(BuildContext context) {
    if (patient == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(title: const Text('Patient Introuvable')),
        body: const Center(child: Text('Patient non trouvé')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Nouveau Paiement'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Patient Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF4F46E5),
                  child: Text(
                    patient!.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient!.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Ref: ${patient!.reference}',
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/create-treatment',
                      arguments: patient!.reference,
                    );
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nouveau'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: patient!.treatments.isEmpty
                ? _buildNoTreatmentsState()
                : _buildTreatmentsList(),
          ),
          
          // Continue Button
          if (selectedTreatment != null && _canProceedToPayment())
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Payment Summary
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getPaymentSummaryText(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          '${_getPaymentAmount().toInt()} DH',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4F46E5),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _proceedToPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Procéder au Paiement',
                        style: TextStyle(
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

  Widget _buildNoTreatmentsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                size: 40,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucun Traitement',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ce patient n\'a pas encore de traitement.\nCréez un nouveau traitement pour commencer.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/create-treatment',
                  arguments: patient!.reference,
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Créer un Traitement'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patient!.treatments.length,
      itemBuilder: (context, index) {
        final treatment = patient!.treatments[index];
        final isSelected = selectedTreatment?.id == treatment.id;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              // Treatment Header
              ListTile(
                onTap: () => _selectTreatment(treatment),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTreatmentStatusColor(treatment).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.medical_services,
                    color: _getTreatmentStatusColor(treatment),
                    size: 20,
                  ),
                ),
                title: Text(
                  treatment.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF1E293B),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatment.description,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Prix: ${treatment.totalPrice.toInt()} DH - Payé: ${treatment.totalPaidAmount.toInt()} DH',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getTreatmentStatusColor(treatment).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getTreatmentStatusText(treatment),
                        style: TextStyle(
                          color: _getTreatmentStatusColor(treatment),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.check_circle,
                          color: Color(0xFF4F46E5),
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
              
              // Payment Options (shown when treatment is selected)
              if (isSelected) _buildPaymentOptions(treatment),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOptions(Treatment treatment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Options de Paiement',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          
          // Obligatory Installments
          if (treatment.unpaidObligatoryInstallments.isNotEmpty) ...[
            const Text(
              'Échéances Obligatoires',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 8),
            ...treatment.unpaidObligatoryInstallments.map((installment) {
              final isInstallmentSelected = selectedInstallment?.id == installment.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => _selectInstallment(installment),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isInstallmentSelected 
                          ? const Color(0xFFEF4444).withOpacity(0.1)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isInstallmentSelected 
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Échéance ${installment.order} (Obligatoire)',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          '${installment.amount.toInt()} DH',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                        if (isInstallmentSelected)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xFFEF4444),
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
          
          // Custom Payment (only if obligatory installments are paid)
          if (treatment.areObligatoryInstallmentsPaid && treatment.remainingAmount > 0) ...[
            const Text(
              'Paiement Libre',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF10B981),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectCustomPayment(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCustomPayment 
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCustomPayment 
                        ? const Color(0xFF10B981)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Montant Personnalisé',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          'Max: ${treatment.remainingAmount.toInt()} DH',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                        if (isCustomPayment)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xFF10B981),
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                    if (isCustomPayment) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _customAmountController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            customPaymentAmount = double.tryParse(value) ?? 0.0;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Montant à payer (DH)',
                          prefixIcon: const Icon(Icons.attach_money, size: 20),
                          suffix: const Text('DH'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
          
          // Treatment completed message
          if (treatment.remainingAmount <= 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF10B981)),
                  SizedBox(width: 8),
                  Text(
                    'Traitement entièrement payé',
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _selectTreatment(Treatment treatment) {
    setState(() {
      selectedTreatment = treatment;
      selectedInstallment = null;
      isCustomPayment = false;
      customPaymentAmount = 0.0;
      _customAmountController.clear();
    });
  }

  void _selectInstallment(Installment installment) {
    setState(() {
      selectedInstallment = installment;
      isCustomPayment = false;
      customPaymentAmount = 0.0;
      _customAmountController.clear();
    });
  }

  void _selectCustomPayment() {
    setState(() {
      selectedInstallment = null;
      isCustomPayment = true;
    });
  }

  bool _canProceedToPayment() {
    if (selectedTreatment == null) return false;
    
    if (selectedInstallment != null) return true;
    
    if (isCustomPayment && customPaymentAmount > 0 && 
        customPaymentAmount <= selectedTreatment!.remainingAmount) {
      return true;
    }
    
    return false;
  }

  double _getPaymentAmount() {
    if (selectedInstallment != null) {
      return selectedInstallment!.amount;
    }
    if (isCustomPayment) {
      return customPaymentAmount;
    }
    return 0.0;
  }

  String _getPaymentSummaryText() {
    if (selectedInstallment != null) {
      return 'Échéance ${selectedInstallment!.order} - ${selectedTreatment!.name}';
    }
    if (isCustomPayment) {
      return 'Paiement libre - ${selectedTreatment!.name}';
    }
    return '';
  }

  Color _getTreatmentStatusColor(Treatment treatment) {
    if (treatment.remainingAmount <= 0) {
      return const Color(0xFF10B981);
    } else if (treatment.areObligatoryInstallmentsPaid) {
      return const Color(0xFF3B82F6);
    } else {
      return const Color(0xFFEF4444);
    }
  }

  String _getTreatmentStatusText(Treatment treatment) {
    if (treatment.remainingAmount <= 0) {
      return 'Terminé';
    } else if (treatment.areObligatoryInstallmentsPaid) {
      return 'En cours';
    } else {
      return 'En attente';
    }
  }

  void _proceedToPayment() {
    if (!_canProceedToPayment()) return;
    
    // Create payment data
    final paymentData = {
      'patient': patient!,
      'treatment': selectedTreatment!,
      'installment': selectedInstallment,
      'amount': _getPaymentAmount(),
      'isCustomPayment': isCustomPayment,
    };
    
    Navigator.pushNamed(
      context,
      '/treatment-payment',
      arguments: paymentData,
    );
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }
}

// Add this TreatmentPaymentScreen class to your screens/main.dart file

class TreatmentPaymentScreen extends StatefulWidget {
  const TreatmentPaymentScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentPaymentScreen> createState() => _TreatmentPaymentScreenState();
}

class _TreatmentPaymentScreenState extends State<TreatmentPaymentScreen> {
  bool hasSignature = false;
  String? signaturePath;
  PatientWithTreatments? patient;
  Treatment? treatment;
  Installment? installment;
  double paymentAmount = 0.0;
  bool isCustomPayment = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> paymentData = 
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    
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
                        _buildSummaryRow('Traitement', treatment!.name),
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
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            Text(
                              'Après paiement: ${(treatment!.totalPaidAmount + paymentAmount).toInt()} DH',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF10B981)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: (treatment!.totalPaidAmount + paymentAmount) / treatment!.totalPrice,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
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
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasSignature 
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
                        color: hasSignature 
                            ? const Color(0xFF10B981) 
                            : const Color(0xFFE2E8F0),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Signature obtenue',
                        style: TextStyle(
                          fontSize: 12,
                          color: hasSignature 
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
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
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
    final paymentRecord = PaymentRecord(
      id: paymentId,
      treatmentId: treatment!.id,
      installmentId: installment?.id ?? 'custom_${DateTime.now().millisecondsSinceEpoch}',
      amount: paymentAmount,
      date: DateTime.now(),
      signature: signaturePath,
      type: isCustomPayment ? PaymentType.partial : PaymentType.installment,
    );

    // Add payment to patient
    TreatmentService.addPaymentToPatient(patient!.reference, paymentRecord);

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

// Updated main.dart with all new routes
// Replace your current main.dart routes section with this:

// Add this PatientDetailsScreen class to your screens/main.dart file

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PatientWithTreatments? patient;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String patientReference = ModalRoute.of(context)?.settings.arguments as String? ?? "9090";
    patient = TreatmentService.getPatientByReference(patientReference);
  }

  @override
  Widget build(BuildContext context) {
    if (patient == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(
          title: const Text('Patient Introuvable'),
          backgroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Patient non trouvé'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(patient!.name),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Navigate to edit patient
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Informations'),
            Tab(text: 'Traitements'),
            Tab(text: 'Paiements'),
          ],
          labelColor: const Color(0xFF4F46E5),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF4F46E5),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(),
          _buildTreatmentsTab(),
          _buildPaymentsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/treatment-payment-selection',
            arguments: patient!.reference,
          );
        },
        backgroundColor: const Color(0xFF4F46E5),
        child: const Icon(Icons.payment),
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Patient Summary Card
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
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF4F46E5),
                  child: Text(
                    patient!.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  patient!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Ref: ${patient!.reference}',
                    style: const TextStyle(
                      color: Color(0xFF4F46E5),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Financial Overview
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Traitements',
                  '${patient!.totalTreatmentCost.toInt()} DH',
                  Icons.medical_services_outlined,
                  const Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total Payé',
                  '${patient!.totalAmountPaid.toInt()} DH',
                  Icons.account_balance_wallet_outlined,
                  const Color(0xFF10B981),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Reste à Payer',
                  '${patient!.remainingBalance.toInt()} DH',
                  Icons.trending_up,
                  patient!.remainingBalance > 0 ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Traitements',
                  '${patient!.treatments.length}',
                  Icons.list_alt,
                  const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Contact Information
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.contact_phone, color: Color(0xFF4F46E5)),
                    SizedBox(width: 8),
                    Text(
                      'Informations de Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (patient!.phone != null)
                  _buildContactRow(Icons.phone, 'Téléphone', patient!.phone!),
                if (patient!.email != null) ...[
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.email, 'Email', patient!.email!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentsTab() {
    return Column(
      children: [
        // Add Treatment Button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/create-treatment',
                arguments: patient!.reference,
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Nouveau Traitement'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        
        // Treatments List
        Expanded(
          child: patient!.treatments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.medical_services_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun traitement',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Créez le premier traitement pour ce patient',
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: patient!.treatments.length,
                  itemBuilder: (context, index) {
                    final treatment = patient!.treatments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      treatment.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      treatment.description,
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${treatment.totalPrice.toInt()} DH',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF4F46E5),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(treatment).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _getStatusText(treatment),
                                      style: TextStyle(
                                        color: _getStatusColor(treatment),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Progress bar
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payé: ${treatment.totalPaidAmount.toInt()} DH',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    'Reste: ${treatment.remainingAmount.toInt()} DH',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: treatment.totalPaidAmount / treatment.totalPrice,
                                backgroundColor: const Color(0xFFE2E8F0),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getStatusColor(treatment),
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
    );
  }

  Widget _buildPaymentsTab() {
    return Column(
      children: [
        // Payment Summary
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.history, color: Color(0xFF4F46E5)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Historique des Paiements',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      '${patient!.paymentHistory.length} paiement${patient!.paymentHistory.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${patient!.totalAmountPaid.toInt()} DH',
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Payments List
        Expanded(
          child: patient!.paymentHistory.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.payment_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun paiement',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: patient!.paymentHistory.length,
                  itemBuilder: (context, index) {
                    final payment = patient!.paymentHistory[index];
                    final treatment = patient!.treatments
                        .firstWhere((t) => t.id == payment.treatmentId);
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.payment,
                              color: Color(0xFF10B981),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  treatment.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(payment.date),
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 12,
                                  ),
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
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF10B981),
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Payé',
                                  style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontSize: 10,
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
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
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

  Color _getStatusColor(Treatment treatment) {
    if (treatment.remainingAmount <= 0) {
      return const Color(0xFF10B981);
    } else if (treatment.areObligatoryInstallmentsPaid) {
      return const Color(0xFF3B82F6);
    } else {
      return const Color(0xFFEF4444);
    }
  }

  String _getStatusText(Treatment treatment) {
    if (treatment.remainingAmount <= 0) {
      return 'Terminé';
    } else if (treatment.areObligatoryInstallmentsPaid) {
      return 'En cours';
    } else {
      return 'En attente';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}