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
    // Don't show full loading state when just changing dates
    if (_dailyStats == null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      // Load daily stats for selected date
      final dailyStatsResponse = await DashboardService.getDailyStats(
        date: _selectedDate.copyWith(hour: 0),
      );

      // Load this week's revenue for context
      final weekRevenueResponse = await DashboardService.getThisWeekRevenue();

      if (dailyStatsResponse.success && dailyStatsResponse.data != null) {
        setState(() {
          _dailyStats = dailyStatsResponse.data;
          _errorMessage = null;
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
        title: const Text('Recettes Journalières'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDailyData,
          ),
        ],
      ),
      body: _isLoading && _dailyStats == null
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null && _dailyStats == null
              ? _buildErrorWidget()
              : RefreshIndicator(
                  onRefresh: _loadDailyData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Persistent Header with date selection
                        _buildPersistentHeader(),
                        
                        const SizedBox(height: 16),

                        // Main content area
                        if (_dailyStats != null) _buildMainContent(),
                        
                        if (_weekRevenue.isNotEmpty) _buildWeeklyChart(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Une erreur inattendue s\'est produite',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadDailyData,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersistentHeader() {
    final isToday = _isToday(_selectedDate);
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Date selector row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: const Color(0xFF4F46E5),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(_selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              isToday ? 'Aujourd\'hui' : _formatDateLong(_selectedDate),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.edit_calendar,
                          size: 18,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Revenue highlight
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF10B981),
                  const Color(0xFF059669),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Recette du jour',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_dailyStats?.revenue.toInt() ?? 0} DH',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (_dailyStats?.payments != null && _dailyStats!.payments > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${_dailyStats!.payments} paiement${_dailyStats!.payments > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
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

  Widget _buildMainContent() {
    final stats = _dailyStats!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Stats grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Patients',
                  '${stats.patients}',
                  Icons.people,
                  const Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Rendez-vous',
                  '${stats.appointments}',
                  Icons.event,
                  const Color(0xFF06B6D4),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Paiements',
                  '${stats.payments}',
                  Icons.receipt_long,
                  const Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Paiement moyen',
                  '${stats.averagePayment.toInt()} DH',
                  Icons.trending_up,
                  const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Insights card
          if (stats.revenue > 0 || stats.payments > 0)
            _buildInsightsCard(stats),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsCard(DailyStatsDto stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights,
                color: const Color(0xFF4F46E5),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Analyse du jour',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (stats.revenue > 0) ...[
            _buildInsightRow(
              'Performance financière',
              _getPerformanceInsight(stats),
              _getPerformanceColor(stats),
            ),
          ],
          
          if (stats.payments > 0) ...[
            const SizedBox(height: 8),
            _buildInsightRow(
              'Activité',
              '${stats.payments} transaction${stats.payments > 1 ? 's' : ''} traitée${stats.payments > 1 ? 's' : ''}',
              const Color(0xFF10B981),
            ),
          ],
          
          if (stats.patients > 0) ...[
            const SizedBox(height: 8),
            _buildInsightRow(
              'Patients vus',
              '${stats.patients} patient${stats.patients > 1 ? 's' : ''} reçu${stats.patients > 1 ? 's' : ''}',
              const Color(0xFF8B5CF6),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tendance hebdomadaire',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _weekRevenue.length,
              itemBuilder: (context, index) {
                final revenue = _weekRevenue[index];
                final isSelected = _isSameDay(revenue.date, _selectedDate);
                final isToday = _isToday(revenue.date);
                final maxRevenue = _weekRevenue.map((e) => e.revenue).reduce((a, b) => a > b ? a : b);
                double barHeight = maxRevenue > 0 ? (revenue.revenue / maxRevenue) * 40 : 0;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = revenue.date;
                    });
                    _loadDailyData();
                  },
                  child: Container(
                    width: 45,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        // Bar chart
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 20,
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? const Color(0xFF4F46E5)
                                    : isToday 
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Day label
                        Text(
                          _getWeekdayShort(revenue.date),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isSelected 
                                ? const Color(0xFF4F46E5)
                                : isToday
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF64748B),
                          ),
                        ),
                        // Amount
                        Text(
                          '${revenue.revenue.toInt()}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected 
                                ? const Color(0xFF4F46E5)
                                : const Color(0xFF94A3B8),
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

  String _getPerformanceInsight(DailyStatsDto stats) {
    if (stats.totalRevenue >= 5000) return 'Excellente journée';
    if (stats.totalRevenue >= 3000) return 'Bonne performance';
    if (stats.totalRevenue >= 1000) return 'Journée correcte';
    return 'Activité faible';
  }

  Color _getPerformanceColor(DailyStatsDto stats) {
    if (stats.totalRevenue >= 5000) return const Color(0xFF10B981);
    if (stats.totalRevenue >= 3000) return const Color(0xFF059669);
    if (stats.totalRevenue >= 1000) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
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