import 'package:denta_incomes/models/treatment.dart';
import 'package:denta_incomes/services/treatment_service.dart';
import 'package:flutter/material.dart';

class CreateTreatmentScreen extends StatefulWidget {
  const CreateTreatmentScreen({Key? key}) : super(key: key);

  @override
  State<CreateTreatmentScreen> createState() => _CreateTreatmentScreenState();
}

class _CreateTreatmentScreenState extends State<CreateTreatmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _totalPriceController = TextEditingController();

  List<Installment> _installments = [
    Installment(id: "0", order: 1, amount: 0.0, isObligatory: true),
    Installment(id:"1",order: 2, amount: 0.0, isObligatory: true),
  ];

  bool _isLoading = false;
  String? _patientReference;
  bool _useTemplate = false;
  Treatment? _selectedTemplate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _patientReference = ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Nouveau Traitement'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isFormValid() ? _saveTreatment : null,
            child: Text(
              'Enregistrer',
              style: TextStyle(
                color:
                    _isFormValid()
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Template Selection
                    Container(
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
                              const Icon(
                                Icons.library_books,
                                color: Color(0xFF8B5CF6),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Modèles de Traitement',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                value: _useTemplate,
                                onChanged: (value) {
                                  setState(() {
                                    _useTemplate = value;
                                    if (!value) {
                                      _selectedTemplate = null;
                                      _clearForm();
                                    }
                                  });
                                },
                                activeColor: const Color(0xFF8B5CF6),
                              ),
                            ],
                          ),
                          if (_useTemplate) ...[
                            const SizedBox(height: 12),
                            ...TreatmentService.getAvailableTreatmentTemplates()
                                .map(
                                  (template) => _buildTemplateCard(template),
                                ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

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
                          const Row(
                            children: [
                              Icon(
                                Icons.medical_services,
                                color: Color(0xFF4F46E5),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Informations du Traitement',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
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

                          _buildTextField(
                            controller: _totalPriceController,
                            label: 'Prix Total (DH)',
                            hint: '0',
                            keyboardType: TextInputType.number,
                            onChanged: _updateInstallmentCalculations,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        color:
                                            _getFreePaymentAmount() < 0
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

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton:
          _isFormValid()
              ? FloatingActionButton.extended(
                onPressed: _isLoading ? null : _saveTreatment,
                backgroundColor: const Color(0xFF4F46E5),
                icon:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Icon(Icons.save),
                label: Text(
                  _isLoading ? 'Enregistrement...' : 'Créer Traitement',
                ),
              )
              : null,
    );
  }

  Widget _buildTemplateCard(Treatment template) {
    final isSelected = _selectedTemplate?.id == template.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => _selectTemplate(template),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color(0xFF8B5CF6).withOpacity(0.1)
                    : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${template.totalPrice.toInt()} DH - ${template.obligatoryInstallments.length} échéances',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Color(0xFF8B5CF6)),
            ],
          ),
        ),
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
                  color:
                      installment.isObligatory
                          ? const Color(0xFFEF4444).withOpacity(0.1)
                          : const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${installment.order}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color:
                        installment.isObligatory
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
                          value: installment.isObligatory,
                          onChanged: (value) {
                            setState(() {
                              _installments[index] = installment.copyWith(
                                isObligatory: value,
                              );
                            });
                          },
                          activeColor: const Color(0xFFEF4444),
                        ),
                        Text(
                          installment.isObligatory
                              ? 'Obligatoire'
                              : 'Optionnelle',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                installment.isObligatory
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
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final amount = double.tryParse(value) ?? 0.0;
              setState(() {
                _installments[index] = installment.copyWith(amount: amount);
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

  void _selectTemplate(Treatment template) {
    setState(() {
      _selectedTemplate = template;
      _nameController.text = template.name;
      _descriptionController.text = template.description;
      _totalPriceController.text = template.totalPrice.toString();

      // Setup installments from template
      _installments =
          template.obligatoryInstallments
              .map(
                (installment) => Installment(
                  id:installment.id ,
                  order: installment.order,
                  amount: installment.amount,
                  isObligatory: installment.isObligatory,
                ),
              )
              .toList();
    });
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _totalPriceController.clear();
    setState(() {
      _installments = [
        Installment(id: "0", order: 1, amount: 0.0, isObligatory: true),
        Installment(id: "1", order: 2, amount: 0.0, isObligatory: true),
      ];
    });
  }

  void _addInstallment() {
    setState(() {
      _installments.add(
        Installment(
          id:"p" ,
          order: _installments.length + 1,
          amount: 0.0,
          isObligatory: false,
        ),
      );
    });
  }

  void _removeInstallment(int index) {
    if (_installments.length > 2) {
      setState(() {
        _installments.removeAt(index);
        // Reorder remaining installments
        for (int i = 0; i < _installments.length; i++) {
          _installments[i] = _installments[i].copyWith(order: i + 1);
        }
      });
    }
  }

  void _updateInstallmentCalculations(String value) {
    // This can be used for auto-calculating installment suggestions
    setState(() {});
  }

  double _getTotalInstallments() {
    return _installments.fold(
      0.0,
      (sum, installment) => sum + installment.amount,
    );
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

  Future<void> _saveTreatment() async {
    if (!_formKey.currentState!.validate() || _patientReference == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    // Create new treatment
    final treatmentId = DateTime.now().millisecondsSinceEpoch.toString();
    final newTreatment = Treatment(
      id: treatmentId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      totalPrice: double.parse(_totalPriceController.text),
      createdDate: DateTime.now(),
      installments:
          _installments.map((installment) {
            return Installment(
              id: '${treatmentId}_${installment.order}',
              order: installment.order,
              amount: installment.amount,
              isObligatory: installment.isObligatory,
            );
          }).toList(),
    );

    // Add treatment to patient
    TreatmentService.assignTreatmentToPatient(_patientReference!, newTreatment.id);

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Traitement "${newTreatment.name}" créé avec succès!'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, newTreatment);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _totalPriceController.dispose();
    super.dispose();
  }
}
