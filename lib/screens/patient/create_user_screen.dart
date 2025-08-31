import 'package:flutter/material.dart';
import '../../models/patient_dto.dart';
import '../../services/patient_service.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _referenceController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedBirthDate;
  bool _isLoading = false;
  bool _isGeneratingReference = false;
  bool _isValidatingReference = false;
  String? _referenceError;

  final List<String> _genderOptions = ['Homme', 'Femme'];

  @override
  void initState() {
    super.initState();
    // Auto-generate reference number
    _generateReference();
  }

  Future<void> _generateReference() async {
    setState(() {
      _isGeneratingReference = true;
      _referenceError = null;
    });

    try {
      final response = await PatientService.generateReference();
      if (response.success && response.data != null) {
        setState(() {
          _referenceController.text = response.data!;
        });
      } else {
        // Fallback to timestamp-based generation
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        setState(() {
          _referenceController.text = timestamp.substring(timestamp.length - 6);
        });
      }
    } catch (e) {
      // Fallback to timestamp-based generation
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      setState(() {
        _referenceController.text = timestamp.substring(timestamp.length - 6);
      });
    } finally {
      setState(() {
        _isGeneratingReference = false;
      });
    }
  }

  Future<void> _validateReference(String reference) async {
    if (reference.isEmpty) {
      setState(() {
        _referenceError = null;
      });
      return;
    }

    setState(() {
      _isValidatingReference = true;
      _referenceError = null;
    });

    try {
      final response = await PatientService.validateReference(reference, null);
      if (response.success) {
        if (response.data != true) {
          setState(() {
            _referenceError = 'Cette référence existe déjà';
          });
        }
      }
    } catch (e) {
      // Ignore validation errors to avoid blocking the user
    } finally {
      setState(() {
        _isValidatingReference = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Nouveau Patient'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: (_isFormValid() && !_isLoading) ? _savePatient : null,
            child: Text(
              'Enregistrer',
              style: TextStyle(
                color:
                    (_isFormValid() && !_isLoading)
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
                    // Progress indicator - now only tracks required fields
                    _buildProgressIndicator(),

                    const SizedBox(height: 24),

                    // Required Information Section
                    _buildSectionCard(
                      title: 'Informations Obligatoires',
                      icon: Icons.star,
                      isRequired: true,
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nom complet *',
                          hint: 'Ex: Ahmed Ben Ali',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Le nom est obligatoire';
                            }
                            if (value.trim().length < 2) {
                              return 'Le nom doit contenir au moins 2 caractères';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTextField(
                                    controller: _referenceController,
                                    label: 'Référence *',
                                    hint: 'Ex: 123456',
                                    icon: Icons.badge_outlined,
                                    onChanged: _validateReference,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'La référence est obligatoire';
                                      }
                                      if (_referenceError != null) {
                                        return _referenceError;
                                      }
                                      return null;
                                    },
                                    suffixIcon: _isValidatingReference
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : null,
                                  ),
                                  if (_referenceError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        _referenceError!,
                                        style: const TextStyle(
                                          color: Color(0xFFEF4444),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Regenerate button
                            Container(
                              margin: const EdgeInsets.only(top: 24),
                              child: IconButton(
                                onPressed: _isGeneratingReference ? null : _generateReference,
                                icon: _isGeneratingReference
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.refresh),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFF4F46E5,
                                  ).withOpacity(0.1),
                                  foregroundColor: const Color(0xFF4F46E5),
                                ),
                                tooltip: 'Générer nouvelle référence',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Optional Personal Information
                    _buildSectionCard(
                      title: 'Informations Personnelles (Optionnelles)',
                      icon: Icons.person_outline,
                      isRequired: false,
                      children: [
                        // Gender Selection
                        const Text(
                          'Genre',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children:
                              _genderOptions.map((gender) {
                                final isSelected = _selectedGender == gender;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap:
                                        () => setState(
                                          () => _selectedGender = gender,
                                        ),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        right:
                                            gender == _genderOptions.first
                                                ? 8
                                                : 0,
                                        left:
                                            gender == _genderOptions.last
                                                ? 8
                                                : 0,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? const Color(
                                                  0xFF4F46E5,
                                                ).withOpacity(0.1)
                                                : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? const Color(0xFF4F46E5)
                                                  : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            gender == 'Homme'
                                                ? Icons.male
                                                : Icons.female,
                                            color:
                                                isSelected
                                                    ? const Color(0xFF4F46E5)
                                                    : const Color(0xFF64748B),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            gender,
                                            style: TextStyle(
                                              color:
                                                  isSelected
                                                      ? const Color(0xFF4F46E5)
                                                      : const Color(0xFF64748B),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),

                        const SizedBox(height: 16),

                        // Birth Date
                        GestureDetector(
                          onTap: _selectBirthDate,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Color(0xFF64748B),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _selectedBirthDate != null
                                      ? 'Date de naissance: ${_formatDate(_selectedBirthDate!)}'
                                      : 'Sélectionner la date de naissance',
                                  style: TextStyle(
                                    color:
                                        _selectedBirthDate != null
                                            ? const Color(0xFF1E293B)
                                            : const Color(0xFF94A3B8),
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Optional Contact Information
                    _buildSectionCard(
                      title: 'Informations de Contact (Optionnelles)',
                      icon: Icons.contact_phone_outlined,
                      isRequired: false,
                      children: [
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Téléphone',
                          hint: '+212 6 00 00 00 00',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'patient@email.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Format d\'email invalide';
                              }
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _addressController,
                          label: 'Adresse',
                          hint: 'Rue, Ville, Code postal',
                          icon: Icons.location_on_outlined,
                          maxLines: 2,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Optional Notes Section
                    _buildSectionCard(
                      title: 'Notes Médicales (Optionnelles)',
                      icon: Icons.note_outlined,
                      isRequired: false,
                      children: [
                        _buildTextField(
                          controller: _notesController,
                          label: 'Notes',
                          hint: 'Allergies, conditions médicales, remarques...',
                          icon: Icons.note_outlined,
                          maxLines: 3,
                        ),
                      ],
                    ),

                    const SizedBox(height: 100), // Space for floating button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button - only shows when required fields are filled
      floatingActionButton:
          (_isFormValid() && !_isLoading)
              ? FloatingActionButton.extended(
                onPressed: _savePatient,
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
                        : const Icon(Icons.save_outlined),
                label: Text(_isLoading ? 'Enregistrement...' : 'Enregistrer'),
              )
              : null,
    );
  }

  Widget _buildProgressIndicator() {
    final completedFields = _getCompletedRequiredFieldsCount();
    final totalRequiredFields = 2; // Only name and reference are required
    final progress = completedFields / totalRequiredFields;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Champs Obligatoires',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Row(
                children: [
                  Text(
                    '$completedFields/$totalRequiredFields',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          completedFields == totalRequiredFields
                              ? const Color(0xFF10B981)
                              : const Color(0xFF64748B),
                    ),
                  ),
                  if (completedFields == totalRequiredFields)
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
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(
              completedFields == totalRequiredFields
                  ? const Color(0xFF10B981)
                  : const Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            completedFields == totalRequiredFields
                ? 'Prêt à enregistrer!'
                : 'Veuillez remplir tous les champs obligatoires',
            style: TextStyle(
              fontSize: 12,
              color:
                  completedFields == totalRequiredFields
                      ? const Color(0xFF10B981)
                      : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isRequired,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            isRequired
                ? Border.all(color: const Color(0xFF4F46E5).withOpacity(0.3))
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color:
                    isRequired
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFF64748B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        isRequired
                            ? const Color(0xFF1E293B)
                            : const Color(0xFF64748B),
                  ),
                ),
              ),
              if (isRequired)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Obligatoire',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF4F46E5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    Widget? suffixIcon,
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
          onChanged: (value) {
            setState(() {}); // Update progress
            if (onChanged != null) {
              onChanged(value);
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF4F46E5),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF4F46E5)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  bool _isFormValid() {
    return _nameController.text.trim().isNotEmpty &&
        _referenceController.text.trim().isNotEmpty &&
        _referenceError == null &&
        !_isValidatingReference;
  }

  int _getCompletedRequiredFieldsCount() {
    int count = 0;
    if (_nameController.text.trim().isNotEmpty) count++;
    if (_referenceController.text.trim().isNotEmpty && _referenceError == null) count++;
    return count;
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if reference validation is still in progress
    if (_isValidatingReference) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Validation de la référence en cours...'),
          backgroundColor: Color(0xFFF59E0B),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create patient DTO
      final createPatientDto = CreatePatientDto(
        name: _nameController.text.trim(),
        reference: _referenceController.text.trim(),
        phone: _phoneController.text.trim().isNotEmpty 
            ? _phoneController.text.trim() 
            : null,
        email: _emailController.text.trim().isNotEmpty 
            ? _emailController.text.trim() 
            : null,
        address: _addressController.text.trim().isNotEmpty 
            ? _addressController.text.trim() 
            : null,
        gender: _selectedGender,
        birthDate: _selectedBirthDate,
        medicalNotes: _notesController.text.trim().isNotEmpty 
            ? _notesController.text.trim() 
            : null,
      );

      // Call API
      final response = await PatientService.createPatient(createPatientDto);

      if (response.success && response.data != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Patient ${response.data!.name} créé avec succès!'),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );

        // Navigate back with result
        Navigator.pop(context, response.data);
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
                    response.message ?? 'Erreur lors de la création du patient',
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Erreur inattendue: ${e.toString()}'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _referenceController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}