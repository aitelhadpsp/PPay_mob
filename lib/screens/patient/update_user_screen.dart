import 'package:flutter/material.dart';
import '../../models/patient_dto.dart';
import '../../services/patient_service.dart';

class EditPatientScreen extends StatefulWidget {
  const EditPatientScreen({Key? key}) : super(key: key);

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedBirthDate;
  bool _isLoading = false;
  bool _hasChanges = false;

  late PatientDto? patient;

  final List<String> _genderOptions = ['Homme', 'Femme'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get patient from arguments or widget parameter
    var p = ModalRoute.of(context)?.settings.arguments;
    if (p == null) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      patient = p as PatientDto;
      _initializeFields();
    }
  }

  void _initializeFields() {
    _nameController.text = patient!.name;
    _phoneController.text = patient!.phone ?? '';
    _emailController.text = patient!.email ?? '';
    _addressController.text = patient!.address ?? '';
    _notesController.text = patient!.medicalNotes ?? '';
    _selectedGender = patient!.gender;
    _selectedBirthDate = patient!.birthDate;

    // Add listeners to detect changes
    _nameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _addressController.addListener(_onFieldChanged);
    _notesController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasChanges =
        _nameController.text != patient!.name ||
        _phoneController.text != (patient!.phone ?? '') ||
        _emailController.text != (patient!.email ?? '') ||
        _addressController.text != (patient!.address ?? '') ||
        _notesController.text != (patient!.medicalNotes ?? '') ||
        _selectedGender != patient!.gender ||
        _selectedBirthDate != patient!.birthDate;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Modifier Patient'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed:
                (_isFormValid() && _hasChanges && !_isLoading)
                    ? _saveChanges
                    : null,
            child: Text(
              'Enregistrer',
              style: TextStyle(
                color:
                    (_isFormValid() && _hasChanges && !_isLoading)
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body:
          patient == null
              ? Container()
              : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Patient Info Card
                            _buildPatientInfoCard(),

                            const SizedBox(height: 20),

                            // Changes Indicator
                            if (_hasChanges) _buildChangesIndicator(),
                            if (_hasChanges) const SizedBox(height: 20),

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
                                        final isSelected =
                                            _selectedGender == gender;
                                        return Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedGender = gender;
                                              });
                                              _onFieldChanged();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                right:
                                                    gender ==
                                                            _genderOptions.first
                                                        ? 8
                                                        : 0,
                                                left:
                                                    gender ==
                                                            _genderOptions.last
                                                        ? 8
                                                        : 0,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color:
                                                      isSelected
                                                          ? const Color(
                                                            0xFF4F46E5,
                                                          )
                                                          : const Color(
                                                            0xFFE2E8F0,
                                                          ),
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
                                                            ? const Color(
                                                              0xFF4F46E5,
                                                            )
                                                            : const Color(
                                                              0xFF64748B,
                                                            ),
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    gender,
                                                    style: TextStyle(
                                                      color:
                                                          isSelected
                                                              ? const Color(
                                                                0xFF4F46E5,
                                                              )
                                                              : const Color(
                                                                0xFF64748B,
                                                              ),
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                      final emailRegex = RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      );
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
                                  hint:
                                      'Allergies, conditions médicales, remarques...',
                                  icon: Icons.note_outlined,
                                  maxLines: 3,
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 100,
                            ), // Space for floating button
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

      // Floating Action Button - only shows when there are changes and form is valid
      floatingActionButton:
          (_hasChanges && _isFormValid() && !_isLoading)
              ? FloatingActionButton.extended(
                onPressed: _saveChanges,
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
                label: Text(_isLoading ? 'Sauvegarde...' : 'Sauvegarder'),
              )
              : null,
    );
  }

  Widget _buildPatientInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: Color(0xFF4F46E5), size: 24),
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 4),
                Text(
                  'Réf: ${patient!.reference}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (patient!.phone != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    patient!.phone!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Patient',
              style: TextStyle(
                color: Color(0xFF4F46E5),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangesIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.edit, color: Color(0xFFF59E0B), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Modifications détectées',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF59E0B),
                  ),
                ),
                Text(
                  'N\'oubliez pas de sauvegarder vos changements',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
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
            _onFieldChanged();
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
      initialDate:
          _selectedBirthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
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

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
      _onFieldChanged();
    }
  }

  bool _isFormValid() {
    return _nameController.text.trim().isNotEmpty;
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatePatientDto = UpdatePatientDto(
        name: _nameController.text.trim(),
        phone:
            _phoneController.text.trim().isNotEmpty
                ? _phoneController.text.trim()
                : null,
        email:
            _emailController.text.trim().isNotEmpty
                ? _emailController.text.trim()
                : null,
        address:
            _addressController.text.trim().isNotEmpty
                ? _addressController.text.trim()
                : null,
        gender: _selectedGender,
        birthDate: _selectedBirthDate,
        medicalNotes:
            _notesController.text.trim().isNotEmpty
                ? _notesController.text.trim()
                : null,
      );

      final response = await PatientService.updatePatient(
        patient!.id,
        updatePatientDto,
      );

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
                    'Patient ${response.data!.name} modifié avec succès!',
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        setState(() {
          _hasChanges = false;
        });

        Navigator.pop(context);
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
                    response.message ??
                        'Erreur lors de la modification du patient',
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
              Expanded(child: Text('Erreur inattendue: ${e.toString()}')),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleBack() async {
    if (_hasChanges) {
      final shouldDiscard = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: Color(0xFFF59E0B),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Modifications non sauvegardées',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              content: const Text(
                'Vous avez des modifications non sauvegardées. Si vous quittez maintenant, tous vos changements seront perdus.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              actionsPadding: const EdgeInsets.all(16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF64748B),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continuer l\'édition',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_outline, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Abandonner les changements',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      );

      if (shouldDiscard == true) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
