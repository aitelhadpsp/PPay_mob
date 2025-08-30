import 'package:denta_incomes/models/treatment.dart';
import 'package:denta_incomes/services/treatment_service.dart';
import 'package:flutter/material.dart';

class TreatmentManagementScreen extends StatefulWidget {
  const TreatmentManagementScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentManagementScreen> createState() =>
      _TreatmentManagementScreenState();
}

class _TreatmentManagementScreenState extends State<TreatmentManagementScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Gestion des Traitements'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to create new treatment template
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catégories de Traitements',
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
                                });
                              },
                              selectedColor: const Color(
                                0xFF4F46E5,
                              ).withOpacity(0.1),
                              checkmarkColor: const Color(0xFF4F46E5),
                              labelStyle: TextStyle(
                                color:
                                    isSelected
                                        ? const Color(0xFF4F46E5)
                                        : const Color(0xFF64748B),
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Treatments List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTreatments.length,
              itemBuilder: (context, index) {
                final treatment = filteredTreatments[index];
                return _buildTreatmentCard(treatment);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentCard(TreatmentTemplate treatment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getCategoryColor(treatment.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(treatment.category),
            color: _getCategoryColor(treatment.category),
            size: 20,
          ),
        ),
        title: Text(
          treatment.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              treatment.description,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      treatment.category,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    treatment.category,
                    style: TextStyle(
                      fontSize: 10,
                      color: _getCategoryColor(treatment.category),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${treatment.totalPrice.toInt()} DH',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4F46E5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plan de Paiement',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                ...treatment.installmentTemplates.map((installment) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color:
                                installment.isObligatory
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                installment.isObligatory
                                    ? 'Obligatoire'
                                    : 'Optionnel',
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      installment.isObligatory
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFF3B82F6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${installment.amount.toInt()} DH',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
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
      ),
    );
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
