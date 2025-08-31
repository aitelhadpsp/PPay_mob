import 'package:flutter/material.dart';
import '../../models/treatment_dto.dart';
import '../../services/treatment_service.dart';

class TreatmentManagementScreen extends StatefulWidget {
  const TreatmentManagementScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentManagementScreen> createState() =>
      _TreatmentManagementScreenState();
}

class _TreatmentManagementScreenState extends State<TreatmentManagementScreen> {
  String selectedCategory = 'Tous';
  List<TreatmentTemplateDto> _treatments = [];
  List<String> _categories = ['Tous'];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // Load categories
      final categoriesResponse = await TreatmentService.getTreatmentCategories();
      if (categoriesResponse.success && categoriesResponse.data != null) {
        setState(() {
          _categories = ['Tous', ...categoriesResponse.data!];
        });
      }

      // Load treatments
      await _loadTreatments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement: ${e.toString()}'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadTreatments() async {
    try {
      if (selectedCategory == 'Tous') {
        final response = await TreatmentService.getTreatmentTemplates();
        if (response.success && response.data != null) {
          setState(() {
            _treatments = response.data!.where((t) => t.isActive).toList();
          });
        }
      } else {
        final response = await TreatmentService.getTreatmentTemplatesByCategory(selectedCategory);
        if (response.success && response.data != null) {
          setState(() {
            _treatments = response.data!;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des traitements: ${e.toString()}'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
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
            onPressed: () async {
              final result = await Navigator.pushNamed(context, "/create-treatment");
              if (result != null) {
                _loadTreatments(); // Refresh the list
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                          children: _categories.map((category) {
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
                                  _loadTreatments(); // Reload treatments for new category
                                },
                                selectedColor: const Color(0xFF4F46E5).withOpacity(0.1),
                                checkmarkColor: const Color(0xFF4F46E5),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF4F46E5)
                                      : const Color(0xFF64748B),
                                  fontWeight: isSelected
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
                  child: _treatments.isEmpty
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
                                'Aucun traitement trouvé',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Créez un nouveau modèle de traitement',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadTreatments,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _treatments.length,
                            itemBuilder: (context, index) {
                              final treatment = _treatments[index];
                              return _buildTreatmentCard(treatment);
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildTreatmentCard(TreatmentTemplateDto treatment) {
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
                    color: _getCategoryColor(treatment.category).withOpacity(0.1),
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
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, treatment),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 8),
                  Text('Modifier'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'deactivate',
              child: Row(
                children: [
                  Icon(Icons.visibility_off, size: 16),
                  SizedBox(width: 8),
                  Text('Désactiver'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Supprimer', style: TextStyle(color: Colors.red)),
                ],
              ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Plan de Paiement',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${treatment.installmentCount} échéances',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                installment.isObligatory ? 'Obligatoire' : 'Optionnel',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: installment.isObligatory
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

  Future<void> _handleMenuAction(String action, TreatmentTemplateDto treatment) async {
    switch (action) {
      case 'edit':
        // Navigate to edit screen (you can implement this)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fonction de modification bientôt disponible')),
        );
        break;
      
      case 'deactivate':
        await _deactivateTreatment(treatment);
        break;
        
      case 'delete':
        await _deleteTreatment(treatment);
        break;
    }
  }

  Future<void> _deactivateTreatment(TreatmentTemplateDto treatment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Désactiver le traitement'),
        content: Text('Voulez-vous vraiment désactiver "${treatment.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Désactiver'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final response = await TreatmentService.deactivateTreatmentTemplate(treatment.id);
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Traitement "${treatment.name}" désactivé'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
          _loadTreatments(); // Refresh list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Erreur lors de la désactivation'),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<void> _deleteTreatment(TreatmentTemplateDto treatment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le traitement'),
        content: Text(
          'Voulez-vous vraiment supprimer "${treatment.name}" ?\n\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final response = await TreatmentService.deleteTreatmentTemplate(treatment.id);
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Traitement "${treatment.name}" supprimé'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
          _loadTreatments(); // Refresh list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Erreur lors de la suppression'),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'orthodontie':
        return const Color(0xFF8B5CF6);
      case 'chirurgie':
        return const Color(0xFFEF4444);
      case 'esthétique':
      case 'esthetique':
        return const Color(0xFF06B6D4);
      case 'prévention':
      case 'prevention':
        return const Color(0xFF10B981);
      case 'prothèse':
      case 'prothese':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF4F46E5);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'orthodontie':
        return Icons.straighten;
      case 'chirurgie':
        return Icons.healing;
      case 'esthétique':
      case 'esthetique':
        return Icons.auto_awesome;
      case 'prévention':
      case 'prevention':
        return Icons.shield;
      case 'prothèse':
      case 'prothese':
        return Icons.construction;
      default:
        return Icons.medical_services;
    }
  }
}