import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../../models/treatment.dart';
import '../../services/treatment_service.dart';

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
    final String patientReference =
        ModalRoute.of(context)?.settings.arguments as String? ?? "9090";
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
        body: const Center(child: Text('Patient non trouvé')),
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
        children: [_buildInfoTab(), _buildTreatmentsTab(), _buildPaymentsTab()],
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
                  patient!.remainingBalance > 0
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF10B981),
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
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/treatment-assignment',
                arguments: patient!.reference,
              );
              if (result == true) {
                // Refresh patient data
                setState(() {
                  patient = TreatmentService.getPatientByReference(
                    patient!.reference,
                  );
                });
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Assigner un Traitement'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),

        // Treatments List
        Expanded(
          child:
              patient!.treatments.isEmpty
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
                          'Aucun traitement assigné',
                          style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Assignez un traitement prédéfini à ce patient',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: patient!.treatments.length,
                    itemBuilder: (context, index) {
                      final patientTreatment = patient!.treatments[index];
                      final template = TreatmentService.getTreatmentTemplate(
                        patientTreatment.treatmentTemplateId,
                      );

                      if (template == null) return const SizedBox.shrink();

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
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(
                                      template.category,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    _getCategoryIcon(template.category),
                                    color: _getCategoryColor(template.category),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        template.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        template.description,
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
                                      '${template.totalPrice.toInt()} DH',
                                      style: const TextStyle(
                                        fontSize: 16,
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
                                        color: _getPatientTreatmentStatusColor(
                                          patientTreatment,
                                          template,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _getPatientTreatmentStatusText(
                                          patientTreatment,
                                          template,
                                        ),
                                        style: TextStyle(
                                          color: _getPatientTreatmentStatusColor(
                                            patientTreatment,
                                            template,
                                          ),
                                          fontSize: 10,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payé: ${patientTreatment.totalPaidAmount.toInt()} DH',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    Text(
                                      'Reste: ${patientTreatment.remainingAmount.toInt()} DH',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value:
                                      patientTreatment.totalPaidAmount /
                                      template.totalPrice,
                                  backgroundColor: const Color(0xFFE2E8F0),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getPatientTreatmentStatusColor(
                                      patientTreatment,
                                      template,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
          child:
              patient!.paymentHistory.isEmpty
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
                      final treatment = patient!.treatments.firstWhere(
                        (t) => t.id == payment.treatmentId,
                      );

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
                                    TreatmentService.getTreatmentTemplate(treatment.treatmentTemplateId)?.name ?? 'Traitement',
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
                                    color: const Color(
                                      0xFF10B981,
                                    ).withOpacity(0.1),
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

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
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
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
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

  Color _getPatientTreatmentStatusColor(
    PatientTreatment patientTreatment,
    TreatmentTemplate template,
  ) {
    if (patientTreatment.remainingAmount <= 0) {
      return const Color(0xFF10B981);
    } else if (patientTreatment.areObligatoryInstallmentsPaid) {
      return const Color(0xFF3B82F6);
    } else {
      return const Color(0xFFEF4444);
    }
  }

  String _getPatientTreatmentStatusText(
    PatientTreatment patientTreatment,
    TreatmentTemplate template,
  ) {
    if (patientTreatment.remainingAmount <= 0) {
      return 'Terminé';
    } else if (patientTreatment.areObligatoryInstallmentsPaid) {
      return 'En cours';
    } else {
      return 'En attente';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Orthodontie':
        return const Color(0xFF8B5CF6);
      case 'Chirurgie':
        return const Color(0xFFEF4444);
      case 'Esthétique':
        return const Color(0xFF06B6D4);
      case 'Prévention':
        return const Color(0xFF10B981);
      case 'Prothèse':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF4F46E5);
    }
  }



  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Orthodontie':
        return Icons.straighten;
      case 'Chirurgie':
        return Icons.healing;
      case 'Esthétique':
        return Icons.auto_awesome;
      case 'Prévention':
        return Icons.shield;
      case 'Prothèse':
        return Icons.construction;
      default:
        return Icons.medical_services;
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