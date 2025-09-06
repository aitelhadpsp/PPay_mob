import 'package:flutter/material.dart';
import 'package:denta_incomes/models/dashboard_dto.dart';
import 'package:denta_incomes/services/dashboard_service.dart';

class DailyReceiptsScreen extends StatefulWidget {
  const DailyReceiptsScreen({Key? key}) : super(key: key);

  @override
  State<DailyReceiptsScreen> createState() => _DailyReceiptsScreenState();
}

class _DailyReceiptsScreenState extends State<DailyReceiptsScreen> {
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();
  DailyStatsDto? _dailyStats;
  List<DailyRevenueDto> _weekRevenue = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDailyData();
  }

  Future<void> _loadDailyData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load daily stats for selected date
      final dailyStatsResponse = await DashboardService.getDailyStats(
        date: _selectedDate,
      );

      // Load this week's revenue for context
      final weekRevenueResponse = await DashboardService.getThisWeekRevenue();

      if (dailyStatsResponse.success && dailyStatsResponse.data != null) {
        setState(() {
          _dailyStats = dailyStatsResponse.data;
        });
      } else {
        setState(() {
          _errorMessage = dailyStatsResponse.message ?? 'Failed to load daily data';
        });
      }

      if (weekRevenueResponse.success && weekRevenueResponse.data != null) {
        setState(() {
          _weekRevenue = weekRevenueResponse.data!;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading data: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
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

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadDailyData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Recettes'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDailyData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorWidget()
              : RefreshIndicator(
                  onRefresh: _loadDailyData,
                  child: Column(
                    children: [
                      // Header with date and total
                      _buildHeader(),
                      
                      // Daily stats cards
                      _buildStatsCards(),

                      // Weekly overview
                      if (_weekRevenue.isNotEmpty) _buildWeeklyOverview(),

                      // Revenue breakdown
                      Expanded(child: _buildRevenueBreakdown()),
                    ],
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
            onPressed: _loadDailyData,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isToday = _isToday(_selectedDate);
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _selectDate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _formatDate(_selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: Color(0xFF64748B),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isToday 
                        ? 'Aujourd\'hui' 
                        : _formatDateLong(_selectedDate),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${_dailyStats?.revenue.toInt() ?? 0} DH',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF10B981),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Paiements',
              '${_dailyStats?.payments ?? 0}',
              Icons.receipt_long,
              const Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Patients',
              '${_dailyStats?.patients ?? 0}',
              Icons.people,
              const Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Rendez-vous',
              '${_dailyStats?.appointments ?? 0}',
              Icons.event,
              const Color(0xFF06B6D4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyOverview() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aperçu de la semaine',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _weekRevenue.length,
              itemBuilder: (context, index) {
                final revenue = _weekRevenue[index];
                final isSelected = _isSameDay(revenue.date, _selectedDate);
                final isToday = _isToday(revenue.date);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = revenue.date;
                    });
                    _loadDailyData();
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFF4F46E5)
                          : isToday 
                              ? const Color(0xFF10B981).withOpacity(0.1)
                              : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected 
                            ? const Color(0xFF4F46E5)
                            : isToday
                                ? const Color(0xFF10B981)
                                : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getWeekdayShort(revenue.date),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected 
                                ? Colors.white
                                : isToday
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${revenue.revenue.toInt()}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? Colors.white
                                : isToday
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBreakdown() {
    if (_dailyStats == null) {
      return const Center(
        child: Text(
          'Aucune donnée disponible pour cette date',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
      );
    }

    final stats = _dailyStats!;
    
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          // Summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Résumé financier',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem(
                      'Recette totale',
                      '${stats.revenue.toInt()} DH',
                      const Color(0xFF10B981),
                    ),
                    _buildSummaryItem(
                      'Paiement moyen',
                      '${stats.averagePayment.toInt()} DH',
                      const Color(0xFF4F46E5),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (stats.payments > 0)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${stats.payments} paiement${stats.payments > 1 ? 's' : ''} effectué${stats.payments > 1 ? 's' : ''} ce jour',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quick actions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Actions rapides',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        'Nouveau paiement',
                        Icons.add_circle_outline,
                        const Color(0xFF4F46E5),
                        () => Navigator.pushNamed(context, '/patient-selection'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        'Voir patients',
                        Icons.people_outline,
                        const Color(0xFF8B5CF6),
                        () => Navigator.pushNamed(context, '/patient-selection'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  String _formatDateLong(DateTime date) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getWeekdayShort(DateTime date) {
    const weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return weekdays[date.weekday - 1];
  }
}