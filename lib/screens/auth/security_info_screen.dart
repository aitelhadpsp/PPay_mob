/* import 'package:denta_incomes/models/auth.dart';
import 'package:denta_incomes/services/auth_service.dart';
import 'package:flutter/material.dart';

class SecurityInfoScreen extends StatefulWidget {
  const SecurityInfoScreen({Key? key}) : super(key: key);

  @override
  State<SecurityInfoScreen> createState() => _SecurityInfoScreenState();
}

class _SecurityInfoScreenState extends State<SecurityInfoScreen> {
  AccountSecurityInfoDto? securityInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSecurityInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Sécurité du compte'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSecurityInfo,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Security Overview
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.security, color: Color(0xFF4F46E5)),
                            SizedBox(width: 12),
                            Text(
                              'Aperçu de la sécurité',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        if (securityInfo != null) ...[
                          _buildSecurityItem(
                            'Dernière connexion',
                            _formatDateTime(securityInfo!.lastLoginAt),
                            Icons.access_time,
                          ),
                          const SizedBox(height: 16),
                          _buildSecurityItem(
                            'Adresse IP',
                            securityInfo!.lastLoginIp,
                            Icons.public,
                          ),
                          const SizedBox(height: 16),
                          _buildSecurityItem(
                            'Sessions actives',
                            '${securityInfo!.activeSessionsCount}',
                            Icons.devices,
                          ),
                          const SizedBox(height: 16),
                          _buildSecurityItem(
                            'Authentification à deux facteurs',
                            securityInfo!.twoFactorEnabled ? 'Activée' : 'Désactivée',
                            Icons.verified_user,
                            statusColor: securityInfo!.twoFactorEnabled 
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Quick Actions
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Actions rapides',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _buildActionButton(
                          'Changer le mot de passe',
                          'Mettez à jour votre mot de passe',
                          Icons.lock_outline,
                          () => Navigator.pushNamed(context, '/change-password'),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        _buildActionButton(
                          'Se déconnecter',
                          'Fermer toutes les sessions',
                          Icons.logout,
                          _handleLogout,
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Recent Login Attempts
                  if (securityInfo?.recentLoginAttempts.isNotEmpty ?? false)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tentatives de connexion récentes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          ...securityInfo!.recentLoginAttempts
                              .take(5)
                              .map((attempt) => _buildLoginAttemptItem(attempt)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildSecurityItem(String label, String value, IconData icon, {Color? statusColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: statusColor ?? const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, String subtitle, IconData icon, 
      VoidCallback onPressed, {bool isDestructive = false}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive 
              ? const Color(0xFFEF4444).withOpacity(0.1)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF4F46E5),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDestructive ? const Color(0xFFC53030) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginAttemptItem(LoginAttemptDto attempt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            attempt.successful ? Icons.check_circle : Icons.error,
            color: attempt.successful ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDateTime(attempt.attemptedAt),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${attempt.ipAddress} • ${attempt.successful ? 'Succès' : 'Échec'}',
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

  Future<void> _loadSecurityInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.();
      if (result.success && result.data != null) {
        setState(() {
          securityInfo = result.data;
        });
      }
    } catch (e) {
      // Handle error silently or show a message
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
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
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.logout();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} à ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}Dialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} */