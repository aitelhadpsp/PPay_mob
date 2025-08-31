import 'package:denta_incomes/models/patient_dto.dart';
import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../../services/patient_service.dart';
import '../../models/api_response_dto.dart';

class PatientSelectionScreen extends StatefulWidget {
  const PatientSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PatientSelectionScreen> createState() => _PatientSelectionScreenState();
}

class _PatientSelectionScreenState extends State<PatientSelectionScreen> {
  String searchQuery = '';
  PatientSummaryDto? selectedPatient;
  bool isLoading = true;
  List<PatientSummaryDto> patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() => isLoading = true);

    try {
      final response = await PatientService.getActivePatients();
      if (response.success) {
        final data = response.data ?? [];
        setState(() {
          patients = data.toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading patients: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<PatientSummaryDto> get filteredPatients {
    if (searchQuery.isEmpty) return patients;
    return patients
        .where((p) =>
            p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.reference.contains(searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Sélectionner Patient'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: _navigateToCreateUser,
            tooltip: 'Créer nouveau patient',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom ou référence...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          // Patient List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredPatients.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredPatients.length,
                        itemBuilder: (context, index) {
                          final patient = filteredPatients[index];
                          final isSelected =
                              selectedPatient?.reference == patient.reference;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
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
                            child: ListTile(
                              onTap: () =>
                                  setState(() => selectedPatient = patient),
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: isSelected
                                    ? const Color(0xFF4F46E5)
                                    : const Color(0xFFF1F5F9),
                                child: Text(
                                  patient.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF64748B),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              title: Text(patient.name),
                              subtitle: Text('Ref: ${patient.reference}'),
                              trailing: isSelected
                                  ? const Icon(Icons.check,
                                      color: Color(0xFF4F46E5))
                                  : null,
                            ),
                          );
                        },
                      ),
          ),

          // Action buttons
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedPatient != null
                        ? () {
                            Navigator.pushNamed(
                              context,
                              '/treatment-payment-selection',
                              arguments: selectedPatient!.id,
                            );
                          }
                        : null,
                    child: const Text('Paiement'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedPatient != null
                        ? () {
                            Navigator.pushNamed(
                              context,
                              '/patient-details',
                              arguments: selectedPatient!.id,
                            );
                          }
                        : null,
                    child: const Text('Détails'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_search, size: 80, color: Color(0xFF8B5CF6)),
            const SizedBox(height: 16),
            const Text('Aucun patient trouvé'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _navigateToCreateUser,
              child: const Text('Créer un nouveau patient'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateUser() async {
    final result = await Navigator.pushNamed(context, '/create-user');

    if (result != null && result is PatientSummaryDto) {
      setState(() {
        patients.insert(0, result);
        selectedPatient = result;
        searchQuery = '';
      });
    }
  }
}
