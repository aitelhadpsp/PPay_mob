import 'package:denta_incomes/models/patient.dart';
import 'package:denta_incomes/models/treatment.dart';
import 'package:denta_incomes/services/treatment_service.dart';
import 'package:flutter/material.dart';

class TreatmentPaymentSelectionScreen extends StatefulWidget {
  const TreatmentPaymentSelectionScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentPaymentSelectionScreen> createState() => _TreatmentPaymentSelectionScreenState();
}

class _TreatmentPaymentSelectionScreenState extends State<TreatmentPaymentSelectionScreen> {
  PatientWithTreatments? patient;
  PatientTreatment? selectedTreatment;
  PatientInstallment? selectedInstallment;
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
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/treatment-assignment',
                      arguments: patient!.reference,
                    );
                    if (result == true) {
                      setState(() {
                        patient = TreatmentService.getPatientByReference(patient!.reference);
                      });
                    }
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Assigner'),
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
              'Aucun Traitement Assigné',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ce patient n\'a pas encore de traitement assigné.\nAssignez un traitement pour commencer les paiements.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/treatment-assignment',
                  arguments: patient!.reference,
                );
                if (result == true) {
                  setState(() {
                    patient = TreatmentService.getPatientByReference(patient!.reference);
                  });
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Assigner un Traitement'),
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
        final patientTreatment = patient!.treatments[index];
        final template = TreatmentService.getTreatmentTemplate(patientTreatment.treatmentTemplateId);
        final isSelected = selectedTreatment?.id == patientTreatment.id;
        
        if (template == null) return const SizedBox.shrink();
        
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
                onTap: () => _selectTreatment(patientTreatment),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTreatmentStatusColor(patientTreatment, template).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.medical_services,
                    color: _getTreatmentStatusColor(patientTreatment, template),
                    size: 20,
                  ),
                ),
                title: Text(
                  template.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF1E293B),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.description,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Prix: ${template.totalPrice.toInt()} DH - Payé: ${patientTreatment.totalPaidAmount.toInt()} DH',
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
                        color: _getTreatmentStatusColor(patientTreatment, template).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getTreatmentStatusText(patientTreatment, template),
                        style: TextStyle(
                          color: _getTreatmentStatusColor(patientTreatment, template),
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
              if (isSelected) _buildPaymentOptions(patientTreatment, template),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOptions(PatientTreatment patientTreatment, TreatmentTemplate template) {
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
          if (patientTreatment.unpaidObligatoryInstallments.isNotEmpty) ...[
            const Text(
              'Échéances Obligatoires',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 8),
            ...patientTreatment.unpaidObligatoryInstallments.map((installment) {
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
                            '${installment.description} (Obligatoire)',
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
          if (patientTreatment.areObligatoryInstallmentsPaid && patientTreatment.remainingAmount > 0) ...[
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
                          'Max: ${patientTreatment.remainingAmount.toInt()} DH',
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
          if (patientTreatment.remainingAmount <= 0)
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

  void _selectTreatment(PatientTreatment treatment) {
    setState(() {
      selectedTreatment = treatment;
      selectedInstallment = null;
      isCustomPayment = false;
      customPaymentAmount = 0.0;
      _customAmountController.clear();
    });
  }

  void _selectInstallment(PatientInstallment installment) {
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
      final template = TreatmentService.getTreatmentTemplate(selectedTreatment!.treatmentTemplateId);
      return '${selectedInstallment!.description} - ${template?.name ?? 'Traitement'}';
    }
    if (isCustomPayment) {
      final template = TreatmentService.getTreatmentTemplate(selectedTreatment!.treatmentTemplateId);
      return 'Paiement libre - ${template?.name ?? 'Traitement'}';
    }
    return '';
  }

  Color _getTreatmentStatusColor(PatientTreatment patientTreatment, TreatmentTemplate template) {
    if (patientTreatment.remainingAmount <= 0) {
      return const Color(0xFF10B981);
    } else if (patientTreatment.areObligatoryInstallmentsPaid) {
      return const Color(0xFF3B82F6);
    } else {
      return const Color(0xFFEF4444);
    }
  }

  String _getTreatmentStatusText(PatientTreatment patientTreatment, TreatmentTemplate template) {
    if (patientTreatment.remainingAmount <= 0) {
      return 'Terminé';
    } else if (patientTreatment.areObligatoryInstallmentsPaid) {
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
