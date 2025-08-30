import 'package:denta_incomes/models/patient.dart';
import 'package:denta_incomes/models/treatment.dart';
import 'package:denta_incomes/services/treatment_service.dart';
import 'package:flutter/material.dart';

class TreatmentAssignmentScreen extends StatefulWidget {
  const TreatmentAssignmentScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentAssignmentScreen> createState() =>
      _TreatmentAssignmentScreenState();
}

class _TreatmentAssignmentScreenState extends State<TreatmentAssignmentScreen> {
  String? patientReference;
  PatientWithTreatments? patient;
  TreatmentTemplate? selectedTreatment;
  String selectedCategory = 'Tous';

  List<String> get categories => [
    'Tous',
    ...TreatmentService.getTreatmentCategories(),
  ];

  List<TreatmentTemplate> get filteredTreatments {
    if (selectedCategory == 'Tous') {
      return TreatmentService.treatmentTemplates
          .where((t) => t.isActive)
          .toList();
    }
    return TreatmentService.getTreatmentTemplatesByCategory(selectedCategory);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    patientReference = ModalRoute.of(context)?.settings.arguments as String?;
    if (patientReference != null) {
      patient = TreatmentService.getPatientByReference(patientReference!);
    }
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
        title: const Text('Assigner un Traitement'),
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
              ],
            ),
          ),

          // Category Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choisir une Catégorie',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        categories.map((category) {
                          final isSelected = selectedCategory == category;
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedCategory = category;
                                  selectedTreatment = null; // Reset selection
                                });
                              },
                              selectedColor: const Color(
                                0xFF4F46E5,
                              ).withOpacity(0.1),
                              checkmarkColor: const Color(0xFF4F46E5),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Treatment Selection
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTreatments.length,
              itemBuilder: (context, index) {
                final treatment = filteredTreatments[index];
                final isSelected = selectedTreatment?.id == treatment.id;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTreatment = treatment),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF4F46E5)
                                  : const Color(0xFFE2E8F0),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(
                                    treatment.category,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getCategoryIcon(treatment.category),
                                  color: _getCategoryColor(treatment.category),
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
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            isSelected
                                                ? const Color(0xFF4F46E5)
                                                : const Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      treatment.description,
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 13,
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
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          isSelected
                                              ? const Color(0xFF4F46E5)
                                              : const Color(0xFF1E293B),
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF4F46E5),
                                      size: 20,
                                    ),
                                ],
                              ),
                            ],
                          ),

                          if (isSelected) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF4F46E5,
                                ).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Plan de Paiement Prévu',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...treatment.installmentTemplates.map((
                                    installment,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color:
                                                  installment.isObligatory
                                                      ? const Color(0xFFEF4444)
                                                      : const Color(0xFF3B82F6),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${installment.order}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              installment.description,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${installment.amount.toInt()} DH',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  installment.isObligatory
                                                      ? const Color(
                                                        0xFFEF4444,
                                                      ).withOpacity(0.1)
                                                      : const Color(
                                                        0xFF3B82F6,
                                                      ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              installment.isObligatory
                                                  ? 'OBL'
                                                  : 'OPT',
                                              style: TextStyle(
                                                fontSize: 9,
                                                color:
                                                    installment.isObligatory
                                                        ? const Color(
                                                          0xFFEF4444,
                                                        )
                                                        : const Color(
                                                          0xFF3B82F6,
                                                        ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Assign Button
          if (selectedTreatment != null)
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
                        const Text(
                          'Traitement Sélectionné',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          '${selectedTreatment!.totalPrice.toInt()} DH',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4F46E5),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _assignTreatment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Assigner "${selectedTreatment!.name}" à ${patient!.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
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

  void _assignTreatment() {
    if (selectedTreatment == null || patientReference == null) return;

    // Assign treatment to patient
    TreatmentService.assignTreatmentToPatient(
      patientReference!,
      selectedTreatment!.id,
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Traitement "${selectedTreatment!.name}" assigné à ${patient!.name}',
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate back to patient details
    Navigator.pop(context, true); // Return true to indicate success
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
}
