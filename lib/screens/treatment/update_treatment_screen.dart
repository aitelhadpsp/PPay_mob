import 'package:flutter/material.dart';
import '../../models/treatment_dto.dart';
import '../../services/treatment_service.dart';

class UpdateTreatmentScreen extends StatefulWidget {
  final TreatmentTemplateDto treatment;

  const UpdateTreatmentScreen({
    Key? key,
    required this.treatment,
  }) : super(key: key);

  @override
  State<UpdateTreatmentScreen> createState() => _UpdateTreatmentScreenState();
}

class _UpdateTreatmentScreenState extends State<UpdateTreatmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _totalPriceController = TextEditingController();

  List<UpdateInstallmentTemplateDto> _installments = [];
  bool _isLoading = false;
  List<String> _categories = [];
  String _selectedCategory = 'Generale';
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _loadCategories();
  }

  void _initializeFormData() {
    // Initialize form with existing treatment data
    _nameController.text = widget.treatment.name;
    _descriptionController.text = widget.treatment.description;
    _totalPriceController.text = widget.treatment.totalPrice.toString();
    
    // Initialize installments from existing data
    _installments = widget.treatment.installmentTemplates
        .map((installment) => UpdateInstallmentTemplateDto(
              id:installment.id ,
              order: installment.order,
              amount: installment.amount,
              isObligatory: installment.isObligatory== true,
              description: installment.description,
            ))
        .toList();

    // Add listeners to detect changes
    _nameController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
    _totalPriceController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    
    try {
      final categoriesResponse = await TreatmentService.getTreatmentCategories();
      if (categoriesResponse.success && categoriesResponse.data != null) {
        setState(() {
          _categories = categoriesResponse.data!;
          // Set the current category from the treatment
          _selectedCategory = widget.treatment.category;
          if (!_categories.contains(_selectedCategory)) {
            _selectedCategory = _categories.isNotEmpty ? _categories.first : 'Generale';
          }
        });
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors du chargement: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(
          title: const Text('Modifier Traitement'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _handleBackPressed(),
          ),
          actions: [
            TextButton(
              onPressed: (_isFormValid() && !_isLoading && _hasChanges) 
                  ? _updateTreatment 
                  : null,
              child: Text(
                'Sauvegarder',
                style: TextStyle(
                  color: (_isFormValid() && !_isLoading && _hasChanges)
                      ? const Color(0xFF4F46E5)
                      : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: _isLoading ? 
          const Center(child: CircularProgressIndicator()) :
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Status indicator
                if (_hasChanges)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: const Color(0xFFFEF3C7),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit,
                          color: Color(0xFFF59E0B),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Modifications non sauvegardées',
                          style: TextStyle(
                            color: Color(0xFFF59E0B),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              Row(
                                children: [
                                  const Icon(
                                    Icons.medical_services,
                                    color: Color(0xFF4F46E5),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Informations du Traitement',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.treatment.isActive
                                          ? const Color(0xFF10B981).withOpacity(0.1)
                                          : const Color(0xFFEF4444).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      widget.treatment.isActive ? 'Actif' : 'Inactif',
                                      style: TextStyle(
                                        color: widget.treatment.isActive
                                            ? const Color(0xFF10B981)
                                            : const Color(0xFFEF4444),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
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

                              // Category Selection
                              const Text(
                                'Catégorie',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                                items: _categories.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                    _onFormChanged();
                                  });
                                },
                              ),

                              const SizedBox(height: 16),

                              _buildTextField(
                                controller: _totalPriceController,
                                label: 'Prix Total (DH)',
                                hint: '0',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  _updateInstallmentCalculations(value);
                                  _onFormChanged();
                                },
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
                                  const Icon(
                                    Icons.payments,
                                    color: Color(0xFF10B981),
                                  ),
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
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${_getTotalInstallments().toInt()} DH',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Paiement Libre:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
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

                        const SizedBox(height: 20),

                        // Action buttons
                        if (!widget.treatment.isActive)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFF59E0B),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.warning,
                                  color: Color(0xFFF59E0B),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Ce traitement est désactivé',
                                  style: TextStyle(
                                    color: Color(0xFFF59E0B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Il ne peut plus être assigné aux patients',
                                  style: TextStyle(
                                    color: Color(0xFFF59E0B),
                                    fontSize: 12,
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

        floatingActionButton: (_isFormValid() && !_isLoading && _hasChanges)
            ? FloatingActionButton.extended(
                onPressed: _updateTreatment,
                backgroundColor: const Color(0xFF4F46E5),
                icon: const Icon(Icons.save),
                label: const Text('Sauvegarder'),
              )
            : null,
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
                  color: installment.isObligatory== true 
                      ? const Color(0xFFEF4444).withOpacity(0.1)
                      : const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${installment.order}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: installment.isObligatory== true 
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
                          value: installment.isObligatory== true,
                          onChanged: (value) {
                            setState(() {
                              _installments[index] = UpdateInstallmentTemplateDto(
                                order: installment.order,
                                amount: installment.amount,
                                isObligatory: value,
                                description: installment.description,
                              );
                              _onFormChanged();
                            });
                          },
                          activeColor: const Color(0xFFEF4444),
                        ),
                        Text(
                          installment.isObligatory== true ? 'Obligatoire' : 'Optionnelle',
                          style: TextStyle(
                            fontSize: 12,
                            color: installment.isObligatory== true
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
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFEF4444),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: installment.amount.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final amount = double.tryParse(value) ?? 0.0;
                    setState(() {
                      _installments[index] = UpdateInstallmentTemplateDto(
                        order: installment.order,
                        amount: amount,
                        isObligatory: installment.isObligatory== true,
                        description: installment.description,
                      );
                      _onFormChanged();
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: installment.description,
                  onChanged: (value) {
                    setState(() {
                      _installments[index] = UpdateInstallmentTemplateDto(
                        order: installment.order,
                        amount: installment.amount,
                        isObligatory: installment.isObligatory== true,
                        description: value,
                      );
                      _onFormChanged();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Ex: Premier versement',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  void _addInstallment() {
    setState(() {
      _installments.add(
        UpdateInstallmentTemplateDto(
          order: _installments.length + 1,
          amount: 0.0,
          isObligatory: false,
          description: "Échéance ${_installments.length + 1}",
        ),
      );
      _onFormChanged();
    });
  }

  void _removeInstallment(int index) {
    if (_installments.length > 2) {
      setState(() {
        _installments.removeAt(index);
        // Reorder remaining installments
        for (int i = 0; i < _installments.length; i++) {
          _installments[i] = UpdateInstallmentTemplateDto(
            order: i + 1,
            amount: _installments[i].amount,
            isObligatory: _installments[i].isObligatory== true,
            description: _installments[i].description,
          );
        }
        _onFormChanged();
      });
    }
  }

  void _updateInstallmentCalculations(String value) {
    setState(() {});
  }

  double _getTotalInstallments() {
    return _installments.fold(0.0, (sum, installment) => sum + (installment.amount ?? 0));
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

  Future<bool> _onWillPop() async {
    if (_hasChanges) {
      return await _showDiscardChangesDialog() ?? false;
    }
    return true;
  }

  void _handleBackPressed() async {
    if (_hasChanges) {
      final shouldDiscard = await _showDiscardChangesDialog();
      if (shouldDiscard == true) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  Future<bool?> _showDiscardChangesDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifications non sauvegardées'),
          content: const Text(
            'Vous avez des modifications non sauvegardées. '
            'Voulez-vous vraiment quitter sans sauvegarder ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
              ),
              child: const Text('Quitter sans sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateTreatment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Parse category enum
      final categoryIndex = _categories.indexOf(_selectedCategory);
      final categoryEnum = categoryIndex >= 0 ? categoryIndex : 0;

      // Create update DTO
      final updateDto = UpdateTreatmentTemplateDto(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        totalPrice: double.parse(_totalPriceController.text),
        category: categoryEnum,
        installmentTemplates: _installments,
      );

      // Call API
      final response = await TreatmentService.updateTreatmentTemplate(
        widget.treatment.id,
        updateDto,
      );

      if (response.success && response.data != null) {
        _showSuccessSnackBar('Traitement "${response.data!.name}" mis à jour avec succès!');
        setState(() {
          _hasChanges = false;
        });
        Navigator.pop(context, response.data);
      } else {
        _showErrorSnackBar(
          response.message ?? 'Erreur lors de la mise à jour du traitement',
        );
      }
    } catch (e) {
      _showErrorSnackBar('Erreur inattendue: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _totalPriceController.dispose();
    super.dispose();
  }
}