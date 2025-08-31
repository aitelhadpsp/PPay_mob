import 'package:denta_incomes/models/patient_dto.dart';
import 'package:denta_incomes/models/treatment_dto.dart';
import 'package:denta_incomes/services/patient_service.dart';
import 'package:flutter/material.dart';

class TreatmentPaymentSelectionScreen extends StatefulWidget {
  const TreatmentPaymentSelectionScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentPaymentSelectionScreen> createState() => 
      _TreatmentPaymentSelectionScreenState();
}

class _TreatmentPaymentSelectionScreenState 
    extends State<TreatmentPaymentSelectionScreen> {
  PatientWithTreatmentsDto? patient;
  PatientTreatmentDto? selectedTreatment;
  PatientInstallmentDto? selectedInstallment;
  double customPaymentAmount = 0.0;
  final TextEditingController _customAmountController = TextEditingController();
  bool isCustomPayment = false;
  bool isLoading = true;
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int patientReference = 
        ModalRoute.of(context)?.settings.arguments as int? ?? 0;
    if (patientReference != 0) {
      _fetchPatient(patientReference);
    }
  }

  Future<void> _fetchPatient(int reference) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await PatientService.getPatientWithTreatments(reference);
      if (response.success && response.data != null) {
        // Convert PatientDto to PatientWithTreatmentsDto if needed
        // For now, assuming you have the treatments data
        setState(() {
          patient = PatientWithTreatmentsDto(
            id: response.data!.id,
            name: response.data!.name,
            reference: response.data!.reference,
            phone: response.data!.phone,
            email: response.data!.email,
            address: response.data!.address,
            gender: response.data!.gender,
            birthDate: response.data!.birthDate,
            medicalNotes: response.data!.medicalNotes,
            createdDate: response.data!.createdDate,
            isActive: response.data!.isActive,
            age: response.data!.age,
            totalAmountPaid: response.data!.totalAmountPaid,
            totalTreatmentCost: response.data!.totalTreatmentCost,
            remainingBalance: response.data!.remainingBalance,
            treatments: response.data!.treatments, // This should come from a separate API call
            paymentHistory: response.data!.paymentHistory, // This should come from a separate API call
          );
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Patient non trouvé';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur lors du chargement du patient';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF1F5F9),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null || patient == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(
          title: const Text('Patient Introuvable'),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage ?? 'Patient non trouvé',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Nouveau Paiement'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Add Treatment button in app bar
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Assigner un traitement',
            onPressed: () => _navigateToAssignTreatment(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPatientHeader(),
          Expanded(
            child: patient!.treatments.isEmpty
                ? _buildNoTreatmentsState()
                : _buildTreatmentsList(),
          ),
          if (selectedTreatment != null && _canProceedToPayment())
            _buildContinuePaymentSection(),
        ],
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Container(
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
          // Financial summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: patient!.remainingBalance > 0
                  ? const Color(0xFFEF4444).withOpacity(0.1)
                  : const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Reste: ${patient!.remainingBalance.toInt()} DH',
              style: TextStyle(
                color: patient!.remainingBalance > 0
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF10B981),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
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
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                size: 60,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Aucun Traitement Assigné',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ce patient n\'a pas encore de traitement assigné.\nAssignez un traitement pour commencer les paiements.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _navigateToAssignTreatment,
                icon: const Icon(Icons.add),
                label: const Text('Assigner un Traitement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
        final hasPayableAmount = treatment.remainingAmount > 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4F46E5)
                  : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                onTap: hasPayableAmount ? () => _selectTreatment(treatment) : null,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTreatmentStatusColor(treatment).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.medical_services,
                    color: _getTreatmentStatusColor(treatment),
                  ),
                ),
                title: Text(
                  treatment.treatmentName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFF1E293B),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Total: ${treatment.totalPrice.toInt()} DH • Payé: ${treatment.totalPaidAmount.toInt()} DH',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: treatment.totalPrice > 0
                                ? treatment.totalPaidAmount / treatment.totalPrice
                                : 0,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getTreatmentStatusColor(treatment),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${((treatment.totalPaidAmount / treatment.totalPrice) * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTreatmentStatusColor(treatment).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        treatment.remainingAmount > 0 ? 'En cours' : 'Terminé',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: _getTreatmentStatusColor(treatment),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (treatment.remainingAmount > 0)
                      Text(
                        'Reste: ${treatment.remainingAmount.toInt()} DH',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF4F46E5),
                        size: 18,
                      ),
                  ],
                ),
              ),
              if (isSelected && hasPayableAmount) 
                _buildPaymentOptions(treatment),
            ],
          ),
        );
      },
    );
  }

Widget _buildPaymentOptions(PatientTreatmentDto treatment) {
  // Get unpaid installments sorted by order
  final unpaidInstallments = treatment.installments
      .where((installment) => !installment.isPaid)
      .toList()
    ..sort((a, b) => a.order.compareTo(b.order));

  // Find the next installment to pay (first unpaid)
  final nextInstallment = unpaidInstallments.isNotEmpty ? unpaidInstallments.first : null;
  
  // Check if all obligatory installments are paid
  final allObligatoryPaid = treatment.areObligatoryInstallmentsPaid;

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

        // Show next installment if available
        if (nextInstallment != null) ...[
          _buildInstallmentOption(nextInstallment, true), // Next to pay
          const SizedBox(height: 8),
        ],

        // Show other unpaid installments (not payable yet if obligatory order matters)
        if (unpaidInstallments.length > 1) ...[
          ...unpaidInstallments.skip(1).map((installment) => 
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildInstallmentOption(installment, false), // Not next
            )
          ),
        ],

        // Show custom payment option only if all obligatory installments are paid
        if (allObligatoryPaid && treatment.remainingAmount > 0) ...[
          if (unpaidInstallments.isNotEmpty) const SizedBox(height: 8),
          _buildCustomPaymentOption(treatment),
        ],
      ],
    ),
  );
}

Widget _buildInstallmentOption(PatientInstallmentDto installment, bool isNextToPay) {
  final isSelected = selectedInstallment?.id == installment.id;
  
  return GestureDetector(
    onTap: isNextToPay ? () => _selectInstallment(installment) : null,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF4F46E5).withOpacity(0.1)
            : isNextToPay
                ? const Color(0xFFF8FAFC)
                : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF4F46E5)
              : isNextToPay
                  ? const Color(0xFFE2E8F0)
                  : const Color(0xFFD1D5DB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: installment.isObligatory
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '${installment.order}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  installment.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isNextToPay ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: installment.isObligatory
                            ? const Color(0xFFEF4444).withOpacity(0.1)
                            : const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        installment.isObligatory ? 'Obligatoire' : 'Optionnel',
                        style: TextStyle(
                          fontSize: 10,
                          color: installment.isObligatory
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF3B82F6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (!isNextToPay) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF64748B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'En attente',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${installment.amount.toInt()} DH',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isNextToPay ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4F46E5),
                  size: 18,
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildCustomPaymentOption(PatientTreatmentDto treatment) {
  return GestureDetector(
    onTap: _selectCustomPayment,
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
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF10B981),
                  size: 18,
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
  );
}
  Widget _buildContinuePaymentSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectTreatment(PatientTreatmentDto treatment) {
    setState(() {
      selectedTreatment = treatment;
      selectedInstallment = null;
      isCustomPayment = false;
      customPaymentAmount = 0.0;
      _customAmountController.clear();
    });
  }

  void _selectInstallment(PatientInstallmentDto installment) {
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
    
    // Can pay if an installment is selected
    if (selectedInstallment != null) return true;
    
    // Can pay custom amount if all obligatory installments are paid and amount is valid
    if (isCustomPayment &&
        customPaymentAmount > 0 &&
        customPaymentAmount <= selectedTreatment!.remainingAmount) {
      return true;
    }
    
    return false;
  }

  double _getPaymentAmount() {
    if (selectedInstallment != null) return selectedInstallment!.amount;
    if (isCustomPayment) return customPaymentAmount;
    return 0.0;
  }

  String _getPaymentSummaryText() {
    if (selectedInstallment != null) {
      return 'Échéance ${selectedInstallment!.order}: ${selectedInstallment!.description}';
    }
    if (isCustomPayment) return 'Paiement libre';
    return '';
  }

  Color _getTreatmentStatusColor(PatientTreatmentDto treatment) {
    if (treatment.remainingAmount <= 0) {
      return const Color(0xFF10B981); // Green for completed
    } else if (treatment.areObligatoryInstallmentsPaid) {
      return const Color(0xFF3B82F6); // Blue for in progress
    } else {
      return const Color(0xFFEF4444); // Red for pending
    }
  }

  Future<void> _navigateToAssignTreatment() async {
    final result = await Navigator.pushNamed(
      context,
      '/treatment-assignment',
      arguments: patient!.id,
    );

    // Refresh patient data if a treatment was assigned
    if (result == true) {
      _fetchPatient(patient!.id);
    }
  }

  void _proceedToPayment() {
    if (!_canProceedToPayment()) return;

    final paymentData = {
      'patient': patient!,
      'treatment': selectedTreatment!,
      'installment': selectedInstallment, // Can be null for custom payments
      'amount': _getPaymentAmount(),
      'isCustomPayment': isCustomPayment,
      'isInstallmentPayment': selectedInstallment != null,
    };

    Navigator.pushNamed(context, '/treatment-payment', arguments: paymentData);
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }
}