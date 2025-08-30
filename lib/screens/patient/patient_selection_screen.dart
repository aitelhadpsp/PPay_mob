import 'package:flutter/material.dart';
import '../../models/patient.dart';

class PatientSelectionScreen extends StatefulWidget {
  const PatientSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PatientSelectionScreen> createState() => _PatientSelectionScreenState();
}

class _PatientSelectionScreenState extends State<PatientSelectionScreen> {
  String searchQuery = '';
  Patient? selectedPatient;

  List<Patient> mockPatients = [
    Patient(name: "Abdelhak Ait elhad", reference: "9090"),
    Patient(name: "Sarah El Mansouri", reference: "8821"),
    Patient(name: "Mohamed Benali", reference: "7755"),
    Patient(name: "Fatima Zahra", reference: "6644"),
    Patient(name: "Omar Alaoui", reference: "5533"),
  ];

  List<Patient> get filteredPatients {
    if (searchQuery.isEmpty) return mockPatients;
    return mockPatients
        .where(
          (patient) =>
              patient.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              patient.reference.contains(searchQuery),
        )
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
          // Search and Create Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Choisissez un patient',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _navigateToCreateUser,
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Color(0xFF8B5CF6),
                      ),
                      label: const Text(
                        'Nouveau',
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF8B5CF6,
                        ).withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom ou référence...',
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Patient List
          Expanded(
            child:
                filteredPatients.isEmpty
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
                              color:
                                  isSelected
                                      ? const Color(0xFF4F46E5)
                                      : const Color(0xFFE2E8F0),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow:
                                isSelected
                                    ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF4F46E5,
                                        ).withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                    : [],
                          ),
                          child: ListTile(
                            onTap:
                                () => setState(() => selectedPatient = patient),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  isSelected
                                      ? const Color(0xFF4F46E5)
                                      : const Color(0xFFF1F5F9),
                              child: Text(
                                patient.name[0].toUpperCase(),
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : const Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            title: Text(
                              patient.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                    isSelected
                                        ? const Color(0xFF4F46E5)
                                        : const Color(0xFF1E293B),
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.badge_outlined,
                                      size: 14,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Ref: ${patient.reference}',
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Info button to view patient details
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/patient-details',
                                      arguments: patient.reference,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  tooltip: 'Voir détails',
                                ),
                                const SizedBox(width: 8),
                                // Selection indicator
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4F46E5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  )
                                else
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey[400],
                                    size: 16,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),

          // Continue Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Quick stats
                if (filteredPatients.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${filteredPatients.length} patient${filteredPatients.length > 1 ? 's' : ''} trouvé${filteredPatients.length > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Action Buttons Row
                Row(
                  children: [
                    // Payment Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            selectedPatient != null
                                ? () {
                                  Navigator.pushNamed(
                                    context,
                                    '/treatment-payment-selection',
                                    arguments: selectedPatient!.reference,
                                  );
                                }
                                : null,
                        icon: const Icon(Icons.payment, size: 18),
                        label: const Text(
                          'Paiement',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          disabledBackgroundColor: const Color(0xFFE2E8F0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Details Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            selectedPatient != null
                                ? () {
                                  Navigator.pushNamed(
                                    context,
                                    '/patient-details',
                                    arguments: selectedPatient!.reference,
                                  );
                                }
                                : null,
                        icon: const Icon(Icons.person_outline, size: 18),
                        label: const Text(
                          'Détails',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          disabledBackgroundColor: const Color(0xFFE2E8F0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Helper text
                if (selectedPatient != null)
                  Text(
                    'Patient sélectionné: ${selectedPatient!.name}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_search,
                size: 40,
                color: Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucun patient trouvé',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.isNotEmpty
                  ? 'Aucun résultat pour "$searchQuery"'
                  : 'Commencez par créer votre premier patient',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _navigateToCreateUser,
              icon: const Icon(Icons.person_add, size: 20),
              label: const Text('Créer un nouveau patient'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateUser() async {
    final result = await Navigator.pushNamed(context, '/create-user');

    if (result != null && result is Patient) {
      setState(() {
        mockPatients.insert(0, result);
        selectedPatient = result;
        searchQuery = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text('${result.name} ajouté et sélectionné!')),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'Voir Détails',
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/patient-details',
                arguments: result.reference,
              );
            },
          ),
        ),
      );
    }
  }
}