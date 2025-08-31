import 'package:flutter/material.dart';
import '../../models/patient_dto.dart';
import '../../models/treatment_dto.dart';
import '../../services/patient_service.dart';
import '../../services/treatment_service.dart';

class TreatmentAssignmentScreen extends StatefulWidget {
  const TreatmentAssignmentScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentAssignmentScreen> createState() =>
      _TreatmentAssignmentScreenState();
}

class _TreatmentAssignmentScreenState extends State<TreatmentAssignmentScreen> {
  String? patientReference;
  PatientDto? patient;
  TreatmentTemplateDto? selectedTreatment;
  String selectedCategory = 'Tous';
  
  List<TreatmentTemplateDto> _treatments = [];
  List<String> _categories = ['Tous'];
  bool _isLoading = true;
  bool _isAssigning = false;

  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (patientReference == null) {
      patientReference = ModalRoute.of(context)?.settings.arguments as String?;
      if (patientReference != null) {
        _loadData();
      }
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // Load patient data
      final patientResponse = await PatientService.getPatientByReference(patientReference!);
      if (patientResponse.success && patientResponse.data != null) {
        setState(() {
          patient = patientResponse.data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Patient non trouvé: ${patientResponse.message}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
        Navigator.pop(context);
        return;
      }

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
        final response = await TreatmentService.getActiveTreatmentTemplates();
        if (response.success && response.data != null) {
          setState(() {
            _treatments = response.data!;
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(
          title: const Text('Assigner un Traitement'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
                              selectedTreatment = null; // Reset selection
                            });
                            _loadTreatments();
                          },
                          selectedColor: const Color(0xFF4F46E5).withOpacity(0.1),
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
                          'Aucun traitement disponible',
                          style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _treatments.length,
                    itemBuilder: (context, index) {
                      final treatment = _treatments[index];
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
                                color: isSelected
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
                                        color: _getCategoryColor(treatment.category).withOpacity(0.1),
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
                                              color: isSelected
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
                                            color: isSelected
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
                                      color: const Color(0xFF4F46E5).withOpacity(0.05),
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
                                        ...treatment.installmentTemplates.map((installment) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 6),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: installment.isObligatory
                                                        ? const Color(0xFFEF4444)
                                                        : const Color(0xFF3B82F6),
                                                    borderRadius: BorderRadius.circular(3),
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
                                                    color: installment.isObligatory
                                                        ? const Color(0xFFEF4444).withOpacity(0.1)
                                                        : const Color(0xFF3B82F6).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    installment.isObligatory ? 'OBL' : 'OPT',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      color: installment.isObligatory
                                                          ? const Color(0xFFEF4444)
                                                          : const Color(0xFF3B82F6),
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

          // Assign Button and Notes
          if (selectedTreatment != null)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Notes input
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: 'Notes (optionnel)',
                      hintText: 'Ajouter des notes sur ce traitement...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 16),
                  
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
                      onPressed: _isAssigning ? null : _assignTreatment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isAssigning
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
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

  Future<void> _assignTreatment() async {
    if (selectedTreatment == null || patient == null) return;

    setState(() => _isAssigning = true);

    try {
      // Create assignment request
      final request = AssignTreatmentRequest(
        patientId: patient!.id,
        treatmentTemplateId: selectedTreatment!.id,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      );

      // Call API
      final response = await TreatmentService.assignTreatmentToPatient(request);

      if (response.success && response.data != null) {
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
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    response.message ?? 'Erreur lors de l\'assignation du traitement',
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur inattendue: ${e.toString()}'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    } finally {
      setState(() => _isAssigning = false);
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'orthodontie':
        return const Color(0xFF8B5CF6);
      case 'chirurgie':
        return const Color(0xFFEF4444);
      case 'esthetique':
        return const Color(0xFF06B6D4);
      case 'prevention':
        return const Color(0xFF10B981);
      case 'prothese':
        return const Color(0xFFF59E0B);
      case 'personnalise':
        return const Color(0xFF8B5CF6);
      case 'general':
        return const Color(0xFF4F46E5);
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
      case 'esthetique':
        return Icons.auto_awesome;
      case 'prevention':
        return Icons.shield;
      case 'prothese':
        return Icons.construction;
      case 'personnalise':
        return Icons.tune;
      case 'general':
        return Icons.medical_services;
      default:
        return Icons.medical_services;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}