import 'dart:async';
import 'package:denta_incomes/models/patient_dto.dart';
import 'package:flutter/material.dart';
import '../../services/patient_service.dart';
import '../../models/api_response_dto.dart';

class PatientSelectionScreen extends StatefulWidget {
  const PatientSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PatientSelectionScreen> createState() => _PatientSelectionScreenState();
}

class _PatientSelectionScreenState extends State<PatientSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  String _searchQuery = '';
  PatientDto? selectedPatient;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  String? _errorMessage;
  
  List<PatientDto> patients = [];
  int _currentPage = 1;
  static const int _pageSize = 20;
  
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _loadPatients();
    _setupScrollListener();
    _setupSearchListener();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent - 200) {
        _loadMorePatients();
      }
    });
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (query != _searchQuery) {
        _searchTimer?.cancel();
        _searchTimer = Timer(const Duration(milliseconds: 500), () {
          _performSearch(query);
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _searchQuery = query;
      _currentPage = 1;
      _hasMoreData = true;
      patients.clear();
      selectedPatient = null;
    });
    
    await _loadPatients();
  }

  Future<void> _loadPatients() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await PatientService.getPatients(
        searchTerm: _searchQuery.isEmpty ? "" : _searchQuery,
        page: _currentPage,
        pageSize: _pageSize,
        sortBy: 'name',
        sortDescending: false,
      );

      if (response.success && response.data != null) {
        final paginatedData = response.data!;
        setState(() {
          if (_currentPage == 1) {
            patients = paginatedData.data;
          } else {
            patients.addAll(paginatedData.data);
          }
          _hasMoreData = paginatedData.hasNextPage;
          _currentPage = paginatedData.currentPage + 1;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? 'Failed to load patients';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading patients: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMorePatients() async {
    if (_isLoadingMore || !_hasMoreData || _isLoading) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = await PatientService.getPatients(
        searchTerm: _searchQuery.isEmpty ? null : _searchQuery,
        page: _currentPage,
        pageSize: _pageSize,
        sortBy: 'name',
        sortDescending: false,
      );

      if (response.success && response.data != null) {
        final paginatedData = response.data!;
        setState(() {
          patients.addAll(paginatedData.data);
          _hasMoreData = paginatedData.hasNextPage;
          _currentPage = paginatedData.currentPage + 1;
        });
      }
    } catch (e) {
      debugPrint('Error loading more patients: $e');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshPatients() async {
    setState(() {
      _currentPage = 1;
      _hasMoreData = true;
      patients.clear();
      selectedPatient = null;
    });
    
    await _loadPatients();
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
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom ou référence...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                // Search results summary
                if (_searchQuery.isNotEmpty || patients.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _searchQuery.isNotEmpty
                              ? '${patients.length} résultat${patients.length != 1 ? 's' : ''} pour "${_searchQuery}"'
                              : '${patients.length} patient${patients.length != 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (_hasMoreData) ...[
                          const Spacer(),
                          Text(
                            'Plus de résultats disponibles',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Patient List
          Expanded(
            child: _buildPatientList(),
          ),

          // Action buttons
          if (selectedPatient != null)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/treatment-payment-selection',
                          arguments: selectedPatient!.id,
                        );
                      },
                      icon: const Icon(Icons.payment, size: 18),
                      label: const Text('Paiement'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/patient-details',
                          arguments: selectedPatient!.id,
                        );
                      },
                      icon: const Icon(Icons.info, size: 18),
                      label: const Text('Détails'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
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

  Widget _buildPatientList() {
    if (_isLoading && patients.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && patients.isEmpty) {
      return _buildErrorState();
    }

    if (patients.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshPatients,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: patients.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          // Loading indicator at the end
          if (index == patients.length) {
            return _buildLoadingMoreIndicator();
          }

          final patient = patients[index];
          final isSelected = selectedPatient?.id == patient.id;

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
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: ListTile(
              onTap: () => setState(() => selectedPatient = patient),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: isSelected
                    ? const Color(0xFF4F46E5)
                    : const Color(0xFFF1F5F9),
                child: Text(
                  patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: isSelected
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
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected 
                      ? const Color(0xFF4F46E5) 
                      : const Color(0xFF1E293B),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ref: ${patient.reference}'),
                  if (patient.phone != null && patient.phone!.isNotEmpty)
                    Text(
                      patient.phone!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  if (patient.remainingBalance > 0)
                    Text(
                      'Solde: ${patient.remainingBalance.toInt()} DH',
                      style: const TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Color(0xFF4F46E5))
                  else
                    Icon(Icons.radio_button_unchecked, color: Colors.grey[400]),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: _isLoadingMore
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(
                  'Chargement...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            )
          : TextButton(
              onPressed: _loadMorePatients,
              child: const Text('Charger plus'),
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Une erreur inattendue s\'est produite',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _refreshPatients,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isSearching = _searchQuery.isNotEmpty;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.person_search,
              size: 80,
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(height: 16),
            Text(
              isSearching 
                  ? 'Aucun résultat pour "${_searchQuery}"'
                  : 'Aucun patient trouvé',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Essayez avec d\'autres mots-clés'
                  : 'Commencez par créer votre premier patient',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _navigateToCreateUser,
              icon: const Icon(Icons.person_add),
              label: const Text('Créer un nouveau patient'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
              ),
            ),
            if (isSearching) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  _performSearch('');
                },
                child: const Text('Effacer la recherche'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToCreateUser() async {
    final result = await Navigator.pushNamed(context, '/create-user');

    if (result != null && result is PatientDto) {
   
      setState(() {
        patients.insert(0, result);
        selectedPatient = result;
        _searchController.clear();
        _searchQuery = '';
      });
    }
  }
}