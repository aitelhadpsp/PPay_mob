class RevenueComparisonDto {
  final double currentPeriodRevenue;
  final double previousPeriodRevenue;
  final double growthAmount;
  final double growthPercentage;
  final String growthDirection; // "up", "down", "stable"

  RevenueComparisonDto({
    required this.currentPeriodRevenue,
    required this.previousPeriodRevenue,
    required this.growthAmount,
    required this.growthPercentage,
    required this.growthDirection,
  });

  factory RevenueComparisonDto.fromJson(Map<String, dynamic> json) {
    return RevenueComparisonDto(
      currentPeriodRevenue: (json['currentPeriodRevenue'] ?? 0).toDouble(),
      previousPeriodRevenue: (json['previousPeriodRevenue'] ?? 0).toDouble(),
      growthAmount: (json['growthAmount'] ?? 0).toDouble(),
      growthPercentage: (json['growthPercentage'] ?? 0).toDouble(),
      growthDirection: json['growthDirection'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'currentPeriodRevenue': currentPeriodRevenue,
        'previousPeriodRevenue': previousPeriodRevenue,
        'growthAmount': growthAmount,
        'growthPercentage': growthPercentage,
        'growthDirection': growthDirection,
      };
}

class MonthlyRevenueDto {
  final int month;
  final String monthName;
  final double revenue;
  final int paymentCount;
  final double target;
  final double achievement;

  MonthlyRevenueDto({
    required this.month,
    required this.monthName,
    required this.revenue,
    required this.paymentCount,
    required this.target,
    required this.achievement,
  });

  factory MonthlyRevenueDto.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenueDto(
      month: json['month'] ?? 0,
      monthName: json['monthName'] ?? '',
      revenue: (json['revenue'] ?? 0).toDouble(),
      paymentCount: json['paymentCount'] ?? 0,
      target: (json['target'] ?? 0).toDouble(),
      achievement: (json['achievement'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'month': month,
        'monthName': monthName,
        'revenue': revenue,
        'paymentCount': paymentCount,
        'target': target,
        'achievement': achievement,
      };
}

class PatientAnalyticsDto {
  final int totalPatients;
  final int activePatients;
  final int newPatientsThisMonth;
  final int newPatientsLastMonth;
  final double patientGrowthRate;
  final double averagePatientValue;
  final int patientsWithOutstandingBalance;

  PatientAnalyticsDto({
    required this.totalPatients,
    required this.activePatients,
    required this.newPatientsThisMonth,
    required this.newPatientsLastMonth,
    required this.patientGrowthRate,
    required this.averagePatientValue,
    required this.patientsWithOutstandingBalance,
  });

  factory PatientAnalyticsDto.fromJson(Map<String, dynamic> json) {
    return PatientAnalyticsDto(
      totalPatients: json['totalPatients'] ?? 0,
      activePatients: json['activePatients'] ?? 0,
      newPatientsThisMonth: json['newPatientsThisMonth'] ?? 0,
      newPatientsLastMonth: json['newPatientsLastMonth'] ?? 0,
      patientGrowthRate: (json['patientGrowthRate'] ?? 0).toDouble(),
      averagePatientValue: (json['averagePatientValue'] ?? 0).toDouble(),
      patientsWithOutstandingBalance: json['patientsWithOutstandingBalance'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalPatients': totalPatients,
        'activePatients': activePatients,
        'newPatientsThisMonth': newPatientsThisMonth,
        'newPatientsLastMonth': newPatientsLastMonth,
        'patientGrowthRate': patientGrowthRate,
        'averagePatientValue': averagePatientValue,
        'patientsWithOutstandingBalance': patientsWithOutstandingBalance,
      };
}

class NewPatientTrendDto {
  final DateTime month;
  final int newPatients;
  final double revenueFromNewPatients;

  NewPatientTrendDto({
    required this.month,
    required this.newPatients,
    required this.revenueFromNewPatients,
  });

  factory NewPatientTrendDto.fromJson(Map<String, dynamic> json) {
    return NewPatientTrendDto(
      month: DateTime.parse(json['month']),
      newPatients: json['newPatients'] ?? 0,
      revenueFromNewPatients: (json['revenueFromNewPatients'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'month': month.toIso8601String(),
        'newPatients': newPatients,
        'revenueFromNewPatients': revenueFromNewPatients,
      };
}

class PatientRetentionDto {
  final double retentionRate;
  final int returnPatients;
  final int oneTimePatients;
  final double averagePatientLifetime;

  PatientRetentionDto({
    required this.retentionRate,
    required this.returnPatients,
    required this.oneTimePatients,
    required this.averagePatientLifetime,
  });

  factory PatientRetentionDto.fromJson(Map<String, dynamic> json) {
    return PatientRetentionDto(
      retentionRate: (json['retentionRate'] ?? 0).toDouble(),
      returnPatients: json['returnPatients'] ?? 0,
      oneTimePatients: json['oneTimePatients'] ?? 0,
      averagePatientLifetime: (json['averagePatientLifetime'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'retentionRate': retentionRate,
        'returnPatients': returnPatients,
        'oneTimePatients': oneTimePatients,
        'averagePatientLifetime': averagePatientLifetime,
      };
}

class TreatmentAnalyticsDto {
  final int totalTreatments;
  final int activeTreatments;
  final int completedTreatments;
  final double completionRate;
  final double averageTreatmentValue;
  final String mostPopularTreatment;

  TreatmentAnalyticsDto({
    required this.totalTreatments,
    required this.activeTreatments,
    required this.completedTreatments,
    required this.completionRate,
    required this.averageTreatmentValue,
    required this.mostPopularTreatment,
  });

  factory TreatmentAnalyticsDto.fromJson(Map<String, dynamic> json) {
    return TreatmentAnalyticsDto(
      totalTreatments: json['totalTreatments'] ?? 0,
      activeTreatments: json['activeTreatments'] ?? 0,
      completedTreatments: json['completedTreatments'] ?? 0,
      completionRate: (json['completionRate'] ?? 0).toDouble(),
      averageTreatmentValue: (json['averageTreatmentValue'] ?? 0).toDouble(),
      mostPopularTreatment: json['mostPopularTreatment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'totalTreatments': totalTreatments,
        'activeTreatments': activeTreatments,
        'completedTreatments': completedTreatments,
        'completionRate': completionRate,
        'averageTreatmentValue': averageTreatmentValue,
        'mostPopularTreatment': mostPopularTreatment,
      };
}

class TreatmentCategoryPerformanceDto {
  final String category;
  final int count;
  final double revenue;
  final double averageValue;
  final double completionRate;
  final double growthRate;

  TreatmentCategoryPerformanceDto({
    required this.category,
    required this.count,
    required this.revenue,
    required this.averageValue,
    required this.completionRate,
    required this.growthRate,
  });

  factory TreatmentCategoryPerformanceDto.fromJson(Map<String, dynamic> json) {
    return TreatmentCategoryPerformanceDto(
      category: json['category'] ?? '',
      count: json['count'] ?? 0,
      revenue: (json['revenue'] ?? 0).toDouble(),
      averageValue: (json['averageValue'] ?? 0).toDouble(),
      completionRate: (json['completionRate'] ?? 0).toDouble(),
      growthRate: (json['growthRate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'count': count,
        'revenue': revenue,
        'averageValue': averageValue,
        'completionRate': completionRate,
        'growthRate': growthRate,
      };
}

class TreatmentCompletionTrendDto {
  final DateTime month;
  final int completedTreatments;
  final double completionRate;
  final double averageCompletionTime; // in days

  TreatmentCompletionTrendDto({
    required this.month,
    required this.completedTreatments,
    required this.completionRate,
    required this.averageCompletionTime,
  });

  factory TreatmentCompletionTrendDto.fromJson(Map<String, dynamic> json) {
    return TreatmentCompletionTrendDto(
      month: DateTime.parse(json['month']),
      completedTreatments: json['completedTreatments'] ?? 0,
      completionRate: (json['completionRate'] ?? 0).toDouble(),
      averageCompletionTime: (json['averageCompletionTime'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'month': month.toIso8601String(),
        'completedTreatments': completedTreatments,
        'completionRate': completionRate,
        'averageCompletionTime': averageCompletionTime,
      };
}

class AppointmentAnalyticsDto {
  final int totalAppointments;
  final int todayAppointments;
  final int thisWeekAppointments;
  final double showRate;
  final double cancellationRate;
  final Duration averageAppointmentDuration;

  AppointmentAnalyticsDto({
    required this.totalAppointments,
    required this.todayAppointments,
    required this.thisWeekAppointments,
    required this.showRate,
    required this.cancellationRate,
    required this.averageAppointmentDuration,
  });

  factory AppointmentAnalyticsDto.fromJson(Map<String, dynamic> json) {
    // Parse TimeSpan string (e.g., "01:30:00") to Duration
    Duration parseDuration(String timeSpanString) {
      final parts = timeSpanString.split(':');
      if (parts.length >= 3) {
        final hours = int.tryParse(parts[0]) ?? 0;
        final minutes = int.tryParse(parts[1]) ?? 0;
        final seconds = int.tryParse(parts[2].split('.')[0]) ?? 0;
        return Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
      return Duration.zero;
    }

    return AppointmentAnalyticsDto(
      totalAppointments: json['totalAppointments'] ?? 0,
      todayAppointments: json['todayAppointments'] ?? 0,
      thisWeekAppointments: json['thisWeekAppointments'] ?? 0,
      showRate: (json['showRate'] ?? 0).toDouble(),
      cancellationRate: (json['cancellationRate'] ?? 0).toDouble(),
      averageAppointmentDuration: json['averageAppointmentDuration'] != null
          ? parseDuration(json['averageAppointmentDuration'])
          : Duration.zero,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalAppointments': totalAppointments,
        'todayAppointments': todayAppointments,
        'thisWeekAppointments': thisWeekAppointments,
        'showRate': showRate,
        'cancellationRate': cancellationRate,
        'averageAppointmentDuration': averageAppointmentDuration.toString(),
      };
}

class AppointmentVolumeDto {
  final DateTime date;
  final int scheduledCount;
  final int completedCount;
  final int cancelledCount;
  final int noShowCount;

  AppointmentVolumeDto({
    required this.date,
    required this.scheduledCount,
    required this.completedCount,
    required this.cancelledCount,
    required this.noShowCount,
  });

  factory AppointmentVolumeDto.fromJson(Map<String, dynamic> json) {
    return AppointmentVolumeDto(
      date: DateTime.parse(json['date']),
      scheduledCount: json['scheduledCount'] ?? 0,
      completedCount: json['completedCount'] ?? 0,
      cancelledCount: json['cancelledCount'] ?? 0,
      noShowCount: json['noShowCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'scheduledCount': scheduledCount,
        'completedCount': completedCount,
        'cancelledCount': cancelledCount,
        'noShowCount': noShowCount,
      };
}

class PerformanceMetricsDto {
  final double revenuePerDay;
  final double revenuePerPatient;
  final double revenuePerTreatment;
  final double conversionRate;
  final Duration averagePaymentTime;
  final double collectionEfficiency;

  PerformanceMetricsDto({
    required this.revenuePerDay,
    required this.revenuePerPatient,
    required this.revenuePerTreatment,
    required this.conversionRate,
    required this.averagePaymentTime,
    required this.collectionEfficiency,
  });

  factory PerformanceMetricsDto.fromJson(Map<String, dynamic> json) {
    // Parse TimeSpan string to Duration
    Duration parseDuration(String timeSpanString) {
      final parts = timeSpanString.split(':');
      if (parts.length >= 3) {
        final hours = int.tryParse(parts[0]) ?? 0;
        final minutes = int.tryParse(parts[1]) ?? 0;
        final seconds = int.tryParse(parts[2].split('.')[0]) ?? 0;
        return Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
      return Duration.zero;
    }

    return PerformanceMetricsDto(
      revenuePerDay: (json['revenuePerDay'] ?? 0).toDouble(),
      revenuePerPatient: (json['revenuePerPatient'] ?? 0).toDouble(),
      revenuePerTreatment: (json['revenuePerTreatment'] ?? 0).toDouble(),
      conversionRate: (json['conversionRate'] ?? 0).toDouble(),
      averagePaymentTime: json['averagePaymentTime'] != null
          ? parseDuration(json['averagePaymentTime'])
          : Duration.zero,
      collectionEfficiency: (json['collectionEfficiency'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'revenuePerDay': revenuePerDay,
        'revenuePerPatient': revenuePerPatient,
        'revenuePerTreatment': revenuePerTreatment,
        'conversionRate': conversionRate,
        'averagePaymentTime': averagePaymentTime.toString(),
        'collectionEfficiency': collectionEfficiency,
      };
}

class KpiDto {
  final String name;
  final double value;
  final double target;
  final double achievement;
  final String unit;
  final String trend; // "up", "down", "stable"
  final String color;

  KpiDto({
    required this.name,
    required this.value,
    required this.target,
    required this.achievement,
    required this.unit,
    required this.trend,
    this.color = "#4F46E5",
  });

  factory KpiDto.fromJson(Map<String, dynamic> json) {
    return KpiDto(
      name: json['name'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      target: (json['target'] ?? 0).toDouble(),
      achievement: (json['achievement'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      trend: json['trend'] ?? '',
      color: json['color'] ?? "#4F46E5",
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
        'target': target,
        'achievement': achievement,
        'unit': unit,
        'trend': trend,
        'color': color,
      };
}

class DashboardAlertDto {
  final String type; // "warning", "error", "info", "success"
  final String title;
  final String message;
  final String? actionUrl;
  final String? actionText;
  final DateTime createdDate;
  final bool isRead;
  final String priority; // "low", "normal", "high", "urgent"

  DashboardAlertDto({
    required this.type,
    required this.title,
    required this.message,
    this.actionUrl,
    this.actionText,
    required this.createdDate,
    required this.isRead,
    this.priority = "normal",
  });

  factory DashboardAlertDto.fromJson(Map<String, dynamic> json) {
    return DashboardAlertDto(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      actionUrl: json['actionUrl'],
      actionText: json['actionText'],
      createdDate: DateTime.parse(json['createdDate']),
      isRead: json['isRead'] ?? false,
      priority: json['priority'] ?? "normal",
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'title': title,
        'message': message,
        'actionUrl': actionUrl,
        'actionText': actionText,
        'createdDate': createdDate.toIso8601String(),
        'isRead': isRead,
        'priority': priority,
      };
}

class QuickStatsDto {
  final double todayRevenue;
  final int todayPatients;
  final int todayAppointments;
  final int pendingPayments;
  final int overduePayments;
  final double thisMonthRevenue;
  final int thisMonthNewPatients;

  QuickStatsDto({
    required this.todayRevenue,
    required this.todayPatients,
    required this.todayAppointments,
    required this.pendingPayments,
    required this.overduePayments,
    required this.thisMonthRevenue,
    required this.thisMonthNewPatients,
  });

  factory QuickStatsDto.fromJson(Map<String, dynamic> json) {
    return QuickStatsDto(
      todayRevenue: (json['todayRevenue'] ?? 0).toDouble(),
      todayPatients: json['todayPatients'] ?? 0,
      todayAppointments: json['todayAppointments'] ?? 0,
      pendingPayments: json['pendingPayments'] ?? 0,
      overduePayments: json['overduePayments'] ?? 0,
      thisMonthRevenue: (json['thisMonthRevenue'] ?? 0).toDouble(),
      thisMonthNewPatients: json['thisMonthNewPatients'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'todayRevenue': todayRevenue,
        'todayPatients': todayPatients,
        'todayAppointments': todayAppointments,
        'pendingPayments': pendingPayments,
        'overduePayments': overduePayments,
        'thisMonthRevenue': thisMonthRevenue,
        'thisMonthNewPatients': thisMonthNewPatients,
      };
}

// Additional DTOs that might be needed for the main dashboard
class DashboardDto {
  final QuickStatsDto quickStats;
  final List<KpiDto> kpis;
  final List<DashboardAlertDto> alerts;
  final RevenueComparisonDto revenueComparison;
  final PatientAnalyticsDto patientAnalytics;
  final TreatmentAnalyticsDto treatmentAnalytics;

  DashboardDto({
    required this.quickStats,
    required this.kpis,
    required this.alerts,
    required this.revenueComparison,
    required this.patientAnalytics,
    required this.treatmentAnalytics,
  });

  factory DashboardDto.fromJson(Map<String, dynamic> json) {
    return DashboardDto(
      quickStats: QuickStatsDto.fromJson(json['quickStats'] ?? {}),
      kpis: (json['kpis'] as List<dynamic>?)
              ?.map((e) => KpiDto.fromJson(e))
              .toList() ??
          [],
      alerts: (json['alerts'] as List<dynamic>?)
              ?.map((e) => DashboardAlertDto.fromJson(e))
              .toList() ??
          [],
      revenueComparison: RevenueComparisonDto.fromJson(json['revenueComparison'] ?? {}),
      patientAnalytics: PatientAnalyticsDto.fromJson(json['patientAnalytics'] ?? {}),
      treatmentAnalytics: TreatmentAnalyticsDto.fromJson(json['treatmentAnalytics'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'quickStats': quickStats.toJson(),
        'kpis': kpis.map((e) => e.toJson()).toList(),
        'alerts': alerts.map((e) => e.toJson()).toList(),
        'revenueComparison': revenueComparison.toJson(),
        'patientAnalytics': patientAnalytics.toJson(),
        'treatmentAnalytics': treatmentAnalytics.toJson(),
      };
}

class DailyStatsDto {
  final DateTime date;
  final double revenue;
  final int patients;
  final int appointments;
  final int payments;
  final double averagePayment;

  DailyStatsDto({
    required this.date,
    required this.revenue,
    required this.patients,
    required this.appointments,
    required this.payments,
    required this.averagePayment,
  });

  factory DailyStatsDto.fromJson(Map<String, dynamic> json) {
    return DailyStatsDto(
      date: DateTime.parse(json['date']),
      revenue: (json['revenue'] ?? 0).toDouble(),
      patients: json['patients'] ?? 0,
      appointments: json['appointments'] ?? 0,
      payments: json['payments'] ?? 0,
      averagePayment: (json['averagePayment'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'revenue': revenue,
        'patients': patients,
        'appointments': appointments,
        'payments': payments,
        'averagePayment': averagePayment,
      };
}

class MonthlyStatsDto {
  final int year;
  final int month;
  final String monthName;
  final double revenue;
  final int patients;
  final int newPatients;
  final int appointments;
  final int treatments;
  final double averageRevenue;
  final double growthRate;

  MonthlyStatsDto({
    required this.year,
    required this.month,
    required this.monthName,
    required this.revenue,
    required this.patients,
    required this.newPatients,
    required this.appointments,
    required this.treatments,
    required this.averageRevenue,
    required this.growthRate,
  });

  factory MonthlyStatsDto.fromJson(Map<String, dynamic> json) {
    return MonthlyStatsDto(
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      monthName: json['monthName'] ?? '',
      revenue: (json['revenue'] ?? 0).toDouble(),
      patients: json['patients'] ?? 0,
      newPatients: json['newPatients'] ?? 0,
      appointments: json['appointments'] ?? 0,
      treatments: json['treatments'] ?? 0,
      averageRevenue: (json['averageRevenue'] ?? 0).toDouble(),
      growthRate: (json['growthRate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'year': year,
        'month': month,
        'monthName': monthName,
        'revenue': revenue,
        'patients': patients,
        'newPatients': newPatients,
        'appointments': appointments,
        'treatments': treatments,
        'averageRevenue': averageRevenue,
        'growthRate': growthRate,
      };
}

class DailyRevenueDto {
  final DateTime date;
  final double revenue;
  final int paymentCount;
  final double averagePayment;

  DailyRevenueDto({
    required this.date,
    required this.revenue,
    required this.paymentCount,
    required this.averagePayment,
  });

  factory DailyRevenueDto.fromJson(Map<String, dynamic> json) {
    return DailyRevenueDto(
      date: DateTime.parse(json['date']),
      revenue: (json['revenue'] ?? 0).toDouble(),
      paymentCount: json['paymentCount'] ?? 0,
      averagePayment: (json['averagePayment'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'revenue': revenue,
        'paymentCount': paymentCount,
        'averagePayment': averagePayment,
      };
}