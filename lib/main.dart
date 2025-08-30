import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home_screen.dart';
import 'screens/patient/patient_selection_screen.dart';
import 'screens/patient/patient_details_screen.dart';
import 'screens/patient/create_user_screen.dart';
import 'screens/payment/new_payment_screen.dart';
import 'screens/payment/payment_success_screen.dart';
import 'screens/payment/daily_receipts_screen.dart';
import 'screens/payment/treatment_payment_selection_screen.dart';
import 'screens/payment/treatment_payment_screen.dart';
import 'screens/treatment/create_treatment_screen.dart';
import 'screens/treatment/treatment_management_screen.dart';
import 'screens/treatment/treatment_assignment_screen.dart';

void main() {
  runApp(const MedicalPaymentApp());
}

class MedicalPaymentApp extends StatelessWidget {
  const MedicalPaymentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Encaissements Dentaires',
      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
      locale: const Locale('fr', 'FR'),

      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF4F46E5),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E293B),
          titleTextStyle: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(12),
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        ),

        // Card Theme
        cardTheme: CardTheme(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          margin: const EdgeInsets.all(4),
        ),

        // Text Theme - Smaller fonts
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: Color(0xFF475569),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(color: Color(0xFF475569), fontSize: 14),
          bodyMedium: TextStyle(color: Color(0xFF64748B), fontSize: 12),
          labelMedium: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          primary: const Color(0xFF4F46E5),
          secondary: const Color(0xFF10B981),
          surface: Colors.white,
          background: const Color(0xFFF1F5F9),
          error: const Color(0xFFEF4444),
        ),
      ),

      home: const HomeScreen(),

      routes: {
        '/home': (context) => const HomeScreen(),
        '/patient-selection': (context) => const PatientSelectionScreen(),
        '/payment-success': (context) => const PaymentSuccessScreen(),
        '/new-payment': (context) => const NewPaymentScreen(),
        '/daily-receipts': (context) => const DailyReceiptsScreen(),
        '/create-user': (context) => const CreateUserScreen(),
        '/patient-details': (context) => const PatientDetailsScreen(),
        '/treatment-management': (context) => const TreatmentManagementScreen(),
        '/treatment-assignment': (context) => const TreatmentAssignmentScreen(),
        '/treatment-payment-selection':
            (context) => const TreatmentPaymentSelectionScreen(),
        '/treatment-payment': (context) => const TreatmentPaymentScreen(),
        '/create-treatment': (context) => const CreateTreatmentScreen(),
      },
    );
  }
}