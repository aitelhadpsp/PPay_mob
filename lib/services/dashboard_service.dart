import 'package:denta_incomes/models/api_response_dto.dart';
import 'package:denta_incomes/models/dashboard_dto.dart';
import 'package:denta_incomes/utils/api_client.dart';

class DashboardService {
  static const String _baseEndpoint = '/dashboard';

  // Main Dashboard Data
  static Future<ApiResponse<DashboardDto>> getDashboardData() async {
    return ApiClient.get<DashboardDto>(
      _baseEndpoint,
      fromJson: (data) => DashboardDto.fromJson(data),
    );
  }

  static Future<ApiResponse<DailyStatsDto>> getDailyStats({
    DateTime? date,
  }) async {
    final queryParams = <String, String>{};
    if (date != null) {
      queryParams['date'] = date.toIso8601String();
    }

    return ApiClient.get<DailyStatsDto>(
      '$_baseEndpoint/daily',
      queryParams: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => DailyStatsDto.fromJson(data),
    );
  }

  static Future<ApiResponse<MonthlyStatsDto>> getMonthlyStats({
    required int year,
    required int month,
  }) async {
    return ApiClient.get<MonthlyStatsDto>(
      '$_baseEndpoint/monthly',
      queryParams: {
        'year': year.toString(),
        'month': month.toString(),
      },
      fromJson: (data) => MonthlyStatsDto.fromJson(data),
    );
  }

  static Future<ApiResponse<QuickStatsDto>> getQuickStats() async {
    return ApiClient.get<QuickStatsDto>(
      '$_baseEndpoint/quick-stats',
      fromJson: (data) => QuickStatsDto.fromJson(data),
    );
  }

  // Revenue Analytics
  static Future<ApiResponse<List<DailyRevenueDto>>> getRevenueByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return ApiClient.get<List<DailyRevenueDto>>(
      '$_baseEndpoint/revenue/period',
      queryParams: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
      fromJson: (data) => (data as List)
          .map((e) => DailyRevenueDto.fromJson(e))
          .toList(),
    );
  }

  static Future<ApiResponse<RevenueComparisonDto>> getRevenueComparison({
    required DateTime currentStart,
    required DateTime currentEnd,
    required DateTime previousStart,
    required DateTime previousEnd,
  }) async {
    return ApiClient.get<RevenueComparisonDto>(
      '$_baseEndpoint/revenue/comparison',
      queryParams: {
        'currentStart': currentStart.toIso8601String(),
        'currentEnd': currentEnd.toIso8601String(),
        'previousStart': previousStart.toIso8601String(),
        'previousEnd': previousEnd.toIso8601String(),
      },
      fromJson: (data) => RevenueComparisonDto.fromJson(data),
    );
  }

  static Future<ApiResponse<List<MonthlyRevenueDto>>> getYearlyRevenueBreakdown(
      int year) async {
    return ApiClient.get<List<MonthlyRevenueDto>>(
      '$_baseEndpoint/revenue/yearly/$year',
      fromJson: (data) => (data as List)
          .map((e) => MonthlyRevenueDto.fromJson(e))
          .toList(),
    );
  }

  // Analytics
  static Future<ApiResponse<PatientAnalyticsDto>> getPatientAnalytics() async {
    return ApiClient.get<PatientAnalyticsDto>(
      '$_baseEndpoint/analytics/patients',
      fromJson: (data) => PatientAnalyticsDto.fromJson(data),
    );
  }

  static Future<ApiResponse<TreatmentAnalyticsDto>> getTreatmentAnalytics() async {
    return ApiClient.get<TreatmentAnalyticsDto>(
      '$_baseEndpoint/analytics/treatments',
      fromJson: (data) => TreatmentAnalyticsDto.fromJson(data),
    );
  }

  static Future<ApiResponse<List<TreatmentCategoryPerformanceDto>>> getTreatmentCategoryPerformance() async {
    return ApiClient.get<List<TreatmentCategoryPerformanceDto>>(
      '$_baseEndpoint/analytics/treatment-categories',
      fromJson: (data) => (data as List)
          .map((e) => TreatmentCategoryPerformanceDto.fromJson(e))
          .toList(),
    );
  }

  // Current Period Shortcuts
  static Future<ApiResponse<List<DailyRevenueDto>>> getThisWeekRevenue() async {
    return ApiClient.get<List<DailyRevenueDto>>(
      '$_baseEndpoint/this-week',
      fromJson: (data) => (data as List)
          .map((e) => DailyRevenueDto.fromJson(e))
          .toList(),
    );
  }

  static Future<ApiResponse<List<DailyRevenueDto>>> getThisMonthRevenue() async {
    return ApiClient.get<List<DailyRevenueDto>>(
      '$_baseEndpoint/this-month',
      fromJson: (data) => (data as List)
          .map((e) => DailyRevenueDto.fromJson(e))
          .toList(),
    );
  }

  static Future<ApiResponse<List<DailyRevenueDto>>> getLast30DaysRevenue() async {
    return ApiClient.get<List<DailyRevenueDto>>(
      '$_baseEndpoint/last-30-days',
      fromJson: (data) => (data as List)
          .map((e) => DailyRevenueDto.fromJson(e))
          .toList(),
    );
  }

  // Current vs Previous Period Comparisons
  static Future<ApiResponse<RevenueComparisonDto>> getThisMonthVsLastMonth() async {
    return ApiClient.get<RevenueComparisonDto>(
      '$_baseEndpoint/comparison/this-month-vs-last',
      fromJson: (data) => RevenueComparisonDto.fromJson(data),
    );
  }

  static Future<ApiResponse<RevenueComparisonDto>> getThisWeekVsLastWeek() async {
    return ApiClient.get<RevenueComparisonDto>(
      '$_baseEndpoint/comparison/this-week-vs-last',
      fromJson: (data) => RevenueComparisonDto.fromJson(data),
    );
  }

  // Convenience methods for common date calculations
  static DateTime getStartOfWeek([DateTime? date]) {
    final target = date ?? DateTime.now();
    final startOfWeek = target.subtract(Duration(days: target.weekday - 1));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }

  static DateTime getEndOfWeek([DateTime? date]) {
    final startOfWeek = getStartOfWeek(date);
    return startOfWeek.add(const Duration(days: 6));
  }

  static DateTime getStartOfMonth([DateTime? date]) {
    final target = date ?? DateTime.now();
    return DateTime(target.year, target.month, 1);
  }

  static DateTime getEndOfMonth([DateTime? date]) {
    final startOfMonth = getStartOfMonth(date);
    return DateTime(startOfMonth.year, startOfMonth.month + 1, 0);
  }

  static DateTime getLast30DaysStart([DateTime? date]) {
    final target = date ?? DateTime.now();
    return target.subtract(const Duration(days: 29));
  }

  // Custom period methods
  static Future<ApiResponse<List<DailyRevenueDto>>> getCustomPeriodRevenue({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return getRevenueByPeriod(startDate: startDate, endDate: endDate);
  }

  static Future<ApiResponse<RevenueComparisonDto>> getCustomPeriodComparison({
    required DateTime currentStart,
    required DateTime currentEnd,
    required DateTime previousStart,
    required DateTime previousEnd,
  }) async {
    return getRevenueComparison(
      currentStart: currentStart,
      currentEnd: currentEnd,
      previousStart: previousStart,
      previousEnd: previousEnd,
    );
  }
}