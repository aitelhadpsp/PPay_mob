import 'package:denta_incomes/models/auth.dart';
import 'package:denta_incomes/models/dashboard_dto.dart';
import 'package:denta_incomes/services/auth_service.dart';
import 'package:denta_incomes/services/dashboard_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;
  QuickStatsDto? _quickStats;
  List<DailyRevenueDto> _recentRevenue = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load quick stats and recent revenue data
      final quickStatsResponse = await DashboardService.getQuickStats();
      final recentRevenueResponse = await DashboardService.getLast30DaysRevenue();

      if (quickStatsResponse.success && quickStatsResponse.data != null) {
        setState(() {
          _quickStats = quickStatsResponse.data;
        });
      } else {
        setState(() {
          _errorMessage = quickStatsResponse.message ?? 'Failed to load dashboard data';
        });
      }

      if (recentRevenueResponse.success && recentRevenueResponse.data != null) {
        setState(() {
          _recentRevenue = recentRevenueResponse.data!.take(5).toList();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading dashboard: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFE2E8F0),
              child: Icon(
                Icons.notifications_outlined,
                size: 18,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorWidget()
              : RefreshIndicator(
                  onRefresh: _loadDashboardData,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserProfileSection(context),
                        
                        const SizedBox(height: 16),
                        
                        // Top Stats Row
                        _buildStatsRow(),

                        const SizedBox(height: 20),

                        // Progress Section
                        const Text(
                          'Aperçu Rapide',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildProgressSection(),

                        const SizedBox(height: 20),

                        // Quick Actions
                        Row(
                          children: [
                            const Text(
                              'Actions Rapides',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_vert, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Actions Grid
                        _buildActionsGrid(),

                        const SizedBox(height: 20),

                        // Recent Activity section
                        _buildRecentActivitySection(),

                        // Add bottom padding to account for bottom navigation
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Une erreur inattendue s\'est produite',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadDashboardData,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildCompactStatCard(
            'Recette Jour',
            '${_quickStats?.todayRevenue.toInt() ?? 0} DH',
            const Color(0xFF10B981),
            'Aujourd\'hui',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCompactStatCard(
            'Patients',
            '${_quickStats?.todayPatients ?? 0}',
            const Color(0xFF4F46E5),
            'Aujourd\'hui',
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ce mois',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_quickStats?.thisMonthRevenue.toInt() ?? 0} DH',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Nouveaux patients',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_quickStats?.thisMonthNewPatients ?? 0}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildQuickStat(
                'Paiements en attente',
                '${_quickStats?.pendingPayments ?? 0}',
                const Color(0xFFF59E0B),
              ),
              const SizedBox(width: 16),
              _buildQuickStat(
                'Paiements en retard',
                '${_quickStats?.overduePayments ?? 0}',
                const Color(0xFFEF4444),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Nouveau\nEncaissement',
                Icons.add_circle_outline,
                const Color(0xFF4F46E5),
                () => Navigator.pushNamed(context, '/patient-selection'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                'Créer\nPatient',
                Icons.person_add_outlined,
                const Color(0xFF8B5CF6),
                () => Navigator.pushNamed(context, '/create-user'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Gérer\nTraitements',
                Icons.medical_services_outlined,
                const Color(0xFFEF4444),
                () => Navigator.pushNamed(context, '/treatment-management'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                'Recettes\nJour',
                Icons.bar_chart,
                const Color(0xFF10B981),
                () => Navigator.pushNamed(context, '/daily-receipts'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    if (_recentRevenue.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Aucune activité récente',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Activité Récente',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/daily-receipts'),
                child: const Text(
                  'Voir tout',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...(_recentRevenue.take(3).map((revenue) => _buildRevenueItem(revenue))),
        ],
      ),
    );
  }

  Widget _buildRevenueItem(DailyRevenueDto revenue) {
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.attach_money,
              color: Color(0xFF10B981),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(revenue.date),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  '${revenue.paymentCount} paiements',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${revenue.revenue.toInt()} DH',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context) {
    return FutureBuilder<UserDto?>(
      future: AuthService.getCurrentUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF4F46E5),
                backgroundImage: user?.profileImagePath != null 
                    ? NetworkImage(user!.profileImagePath!) 
                    : null,
                child: user?.profileImagePath == null
                    ? Text(
                        user?.fullName.isNotEmpty == true ? user!.fullName[0] : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.fullName ?? 'Utilisateur',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      user?.roleDisplay ?? 'Dentiste',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4F46E5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'change-password':
                      Navigator.pushNamed(context, '/change-password');
                      break;
                    case 'logout':
                      _handleLogout(context);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'change-password',
                    child: Row(
                      children: [
                        Icon(Icons.lock_outline, size: 18),
                        SizedBox(width: 8),
                        Text('Changer mot de passe'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Se déconnecter', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await AuthService.logout();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Widget _buildCompactStatCard(
    String title,
    String value,
    Color color,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }
}