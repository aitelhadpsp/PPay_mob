import 'package:denta_incomes/models/patient_dto.dart';
import 'package:denta_incomes/models/treatment.dart';
import 'package:denta_incomes/services/patient_service.dart';
import 'package:flutter/material.dart';

class TreatmentPaymentSelectionScreen extends StatefulWidget {
  const TreatmentPaymentSelectionScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentPaymentSelectionScreen> createState() => _TreatmentPaymentSelectionScreenState();
}

class _TreatmentPaymentSelectionScreenState extends State<TreatmentPaymentSelectionScreen> {
  PatientWithTreatmentsDto? patient;
  PatientTreatment? selectedTreatment;
  PatientInstallment? selectedInstallment;
  double customPaymentAmount = 0.0;
  final TextEditingController _customAmountController = TextEditingController();
  bool isCustomPayment = false;
  bool isLoading = true;
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int patientReference = ModalRoute.of(context)?.settings.arguments as int? ?? 0;
    _fetchPatient(patientReference);
  }

  Future<void> _fetchPatient(int reference) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await PatientService.getPatientWithTreatments(reference);
      if (response.success && response.data != null) {
        setState(() {
          patient = response.data;
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
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null || patient == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(title: const Text('Patient Introuvable')),
        body: Center(child: Text(errorMessage ?? 'Patient non trouvé')),
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
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(patient!.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                Text('Ref: ${patient!.reference}',
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
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
              child: const Icon(Icons.medical_services_outlined, size: 40, color: Color(0xFF4F46E5)),
            ),
            const SizedBox(height: 20),
            const Text('Aucun Traitement Assigné',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
            const SizedBox(height: 8),
            const Text(
              'Ce patient n\'a pas encore de traitement assigné.\nAssignez un traitement pour commencer les paiements.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
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
              ListTile(
               // onTap: () => _selectTreatment(treatment),
                leading: Icon(Icons.medical_services,
                    color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF64748B)),
                title: Text(treatment.treatmentName,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF1E293B))),
                subtitle: Text('Prix: ${treatment.totalPrice.toInt()} DH - Payé: ${treatment.totalPrice.toInt()} DH',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ),
              //if (isSelected) _buildPaymentOptions(treatment),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOptions(PatientTreatment treatment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE2E8F0)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Options de Paiement',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          if (treatment.remainingAmount > 0)
            GestureDetector(
              onTap: _selectCustomPayment,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCustomPayment ? const Color(0xFF10B981).withOpacity(0.1) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isCustomPayment ? const Color(0xFF10B981) : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        const Expanded(
                            child: Text('Montant Personnalisé',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
                        Text('Max: ${treatment.remainingAmount.toInt()} DH',
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        if (isCustomPayment) const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
                      ],
                    ),
                    if (isCustomPayment)
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
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
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
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_getPaymentSummaryText(),
                    style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                Text('${_getPaymentAmount().toInt()} DH',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4F46E5), fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _proceedToPayment,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5), padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Procéder au Paiement', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16)),
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

  void _selectCustomPayment() {
    setState(() {
      selectedInstallment = null;
      isCustomPayment = true;
    });
  }

  bool _canProceedToPayment() {
    if (selectedTreatment == null) return false;
    if (isCustomPayment && customPaymentAmount > 0 && customPaymentAmount <= selectedTreatment!.remainingAmount) return true;
    return false;
  }

  double _getPaymentAmount() {
    if (isCustomPayment) return customPaymentAmount;
    return 0.0;
  }

  String _getPaymentSummaryText() {
    if (isCustomPayment) return 'Paiement libre - ';
    return '';
  }

  void _proceedToPayment() {
    if (!_canProceedToPayment()) return;

    final paymentData = {
      'patient': patient!,
      'treatment': selectedTreatment!,
      'installment': selectedInstallment,
      'amount': _getPaymentAmount(),
      'isCustomPayment': isCustomPayment,
    };

    Navigator.pushNamed(context, '/treatment-payment', arguments: paymentData);
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }
}
