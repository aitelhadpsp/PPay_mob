import 'package:flutter/material.dart';
import 'package:denta_incomes/models/patient_dto.dart';
import 'package:denta_incomes/models/payment_dto.dart';
import 'package:denta_incomes/models/treatment_dto.dart';
import 'package:denta_incomes/services/patient_service.dart';
import 'package:denta_incomes/services/payment_service.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PatientWithTreatmentsDto? patient;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int patientReference =
        ModalRoute.of(context)?.settings.arguments as int? ?? 9090;
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
        appBar: AppBar(
          title: const Text('Patient Introuvable'),
          backgroundColor: Colors.white,
        ),
        body: Center(child: Text(errorMessage ?? 'Patient non trouvé')),
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
            arguments: patient!.id,
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
          // Patient Card
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
          _buildFinancialOverview(),
          
          const SizedBox(height: 20),

          // Contact Information
          _buildContactInfo(),

          const SizedBox(height: 20),

          // Personal Information
          _buildPersonalInfo(),

          const SizedBox(height: 20),

          // Quick Stats
          _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Color(0xFF4F46E5)),
              SizedBox(width: 8),
              Text(
                'Situation Financière',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFinancialCard(
                  'Total Payé',
                  '${patient!.totalAmountPaid.toInt()} DH',
                  const Color(0xFF10B981),
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFinancialCard(
                  'Restant',
                  '${patient!.remainingBalance.toInt()} DH',
                  const Color(0xFFF59E0B),
                  Icons.pending,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Coût Total des Traitements',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  '${patient!.totalTreatmentCost.toInt()} DH',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(String title, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.contact_phone, color: Color(0xFF4F46E5)),
              SizedBox(width: 8),
              Text(
                'Coordonnées',
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
            _buildInfoRow(Icons.phone, 'Téléphone', patient!.phone!),
          if (patient!.email != null)
            _buildInfoRow(Icons.email, 'Email', patient!.email!),
          if (patient!.address != null)
            _buildInfoRow(Icons.location_on, 'Adresse', patient!.address!),
          if (patient!.phone == null && patient!.email == null && patient!.address == null)
            const Text(
              'Aucune information de contact disponible',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person, color: Color(0xFF4F46E5)),
              SizedBox(width: 8),
              Text(
                'Informations Personnelles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.calendar_today, 'Âge', '${patient!.age} ans'),
          if (patient!.gender != null)
            _buildInfoRow(Icons.person_outline, 'Genre', patient!.gender!),
          if (patient!.birthDate != null)
            _buildInfoRow(Icons.cake, 'Date de naissance', _formatDate(patient!.birthDate!)),
          _buildInfoRow(Icons.access_time, 'Patient depuis', _formatDate(patient!.createdDate)),
          if (patient!.medicalNotes != null && patient!.medicalNotes!.isNotEmpty)
            _buildInfoRow(Icons.medical_information, 'Notes médicales', patient!.medicalNotes!),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics, color: Color(0xFF4F46E5)),
              SizedBox(width: 8),
              Text(
                'Statistiques Rapides',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Traitements',
                  patient!.treatments.length.toString(),
                  Icons.medical_services,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Paiements',
                  patient!.paymentHistory.length.toString(),
                  Icons.payment,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF4F46E5), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4F46E5),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentsTab() {
    if (patient!.treatments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun traitement',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ce patient n\'a pas encore de traitement assigné',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patient!.treatments.length,
      itemBuilder: (context, index) {
        final treatment = patient!.treatments[index];
        return _buildTreatmentCard(treatment);
      },
    );
  }

  Widget _buildTreatmentCard(PatientTreatmentDto treatment) {
    final progress = treatment.totalPrice > 0 
        ? (treatment.totalPaidAmount / treatment.totalPrice)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(treatment.status).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  treatment.treatmentName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(treatment.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  treatment.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(treatment.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            treatment.treatmentDescription,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prix: ${treatment.totalPrice.toInt()} DH',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                'Payé: ${treatment.totalPaidAmount.toInt()} DH',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(
              _getStatusColor(treatment.status),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% complété',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          if (treatment.installments.isNotEmpty) ...[
            const SizedBox(height: 12),
            ExpansionTile(
              title: Text(
                'Échéances (${treatment.installments.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              children: treatment.installments.map((installment) {
                return ListTile(
                  dense: true,
                  leading: Icon(
                    installment.isPaid ? Icons.check_circle : Icons.pending,
                    color: installment.isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    size: 20,
                  ),
                  title: Text(
                    installment.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    '${installment.amount.toInt()} DH${installment.isObligatory ? ' (Obligatoire)' : ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: installment.isPaid
                      ? Text(
                          _formatDate(installment.paidDate!),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        )
                      : null,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentsTab() {
    if (patient!.paymentHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payment_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun paiement',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ce patient n\'a pas encore effectué de paiement',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patient!.paymentHistory.length,
      itemBuilder: (context, index) {
        final payment = patient!.paymentHistory[index];
        return _buildPaymentCard(payment);
      },
    );
  }

  Widget _buildPaymentCard(PaymentRecordDto payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${payment.amount.toInt()} DH',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF10B981),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPaymentTypeColor(payment.paymentType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  payment.paymentType,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getPaymentTypeColor(payment.paymentType),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                _formatDateTime(payment.paymentDate),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.payment,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                payment.paymentMethod,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (payment.notes != null && payment.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              payment.notes!,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (payment.transactionReference != null) ...[
            const SizedBox(height: 4),
            Text(
              'Réf: ${payment.transactionReference}',
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'terminé':
        return const Color(0xFF10B981);
      case 'active':
      case 'actif':
        return const Color(0xFF4F46E5);
      case 'cancelled':
      case 'annulé':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Color _getPaymentTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'full':
      case 'complet':
        return const Color(0xFF10B981);
      case 'installment':
      case 'échéance':
        return const Color(0xFF4F46E5);
      case 'partial':
      case 'partiel':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}