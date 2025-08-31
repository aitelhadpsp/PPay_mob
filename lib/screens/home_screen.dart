import 'package:denta_incomes/models/auth.dart';
import 'package:denta_incomes/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../models/patient.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final todayPayments = [
      Payment(
        patient: Patient(name: "Abdelhak Ait elhad", reference: "9090"),
        amount: 1500.0,
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Payment(
        patient: Patient(name: "Sarah El Mansouri", reference: "8821"),
        amount: 800.0,
        date: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      Payment(
        patient: Patient(name: "Mohamed Benali", reference: "7755"),
        amount: 2200.0,
        date: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];

    final totalToday = todayPayments.fold(
      0.0,
      (sum, payment) => sum + payment.amount,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Mes Projets'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfileSection(context),
            
            const SizedBox(height: 16),
            
            // Top Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildCompactStatCard(
                    'Recette Jour',
                    '${totalToday.toInt()} DH',
                    const Color(0xFF10B981),
                    '86% Done',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCompactStatCard(
                    'Patients',
                    '${todayPayments.length}',
                    const Color(0xFF4F46E5),
                    'En cours',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Progress Section
            const Text(
              'Mes Progrès',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            _buildProgressSection(todayPayments.length, totalToday),

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
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'Nouveau\nEncaissement',
                        Icons.add_circle_outline,
                        const Color(0xFF4F46E5),
                        () =>
                            Navigator.pushNamed(context, '/patient-selection'),
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
                        () => Navigator.pushNamed(
                          context,
                          '/treatment-management',
                        ),
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
            ),

            const SizedBox(height: 20),

            // Team Members section
            _buildTeamSection(todayPayments),

            // Add bottom padding to account for bottom navigation
            const SizedBox(height: 80),
          ],
        ),
      ),
  /*     bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4F46E5),
        unselectedItemColor: const Color(0xFF94A3B8),
        elevation: 8,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _handleNavigation(context, index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_outlined),
            label: 'Tâches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_outlined),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Calendrier',
          ),
        ],
      ),
    */ );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Already on home - do nothing
        break;
      case 1:
        Navigator.pushNamed(context, '/daily-receipts');
        break;
      case 2:
        Navigator.pushNamed(context, '/patient-selection');
        break;
      case 3:
        // Calendar functionality - placeholder
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Calendrier bientôt disponible'),
            backgroundColor: Color(0xFF4F46E5),
          ),
        );
        break;
    }
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
                      user?.role ?? 'Dentiste',
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
                    case 'security':
                      Navigator.pushNamed(context, '/security-info');
                      break;
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
                    value: 'security',
                    child: Row(
                      children: [
                        Icon(Icons.security, size: 18),
                        SizedBox(width: 8),
                        Text('Sécurité'),
                      ],
                    ),
                  ),
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

  Widget _buildProgressSection(int patientCount, double total) {
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
                '$patientCount Encaissements',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '${total.toInt()} DH',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Collectif',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const Spacer(),
              const Text(
                '17',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
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

  Widget _buildTeamSection(List<Payment> payments) {
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
          const Text(
            'Derniers Patients',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Espace Collaboratif',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...payments
                  .take(3)
                  .map(
                    (payment) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFF4F46E5),
                        child: Text(
                          payment.patient.name[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              if (payments.length > 3)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '${payments.length - 3}+',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
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
}