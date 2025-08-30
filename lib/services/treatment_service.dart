import '../models/patient.dart';
import '../models/treatment.dart';
import '../models/payment.dart';
import '../models/enums.dart';

class TreatmentService {
  // Mock patient data with treatments
  static List<PatientWithTreatments> mockPatients = [
    PatientWithTreatments(
      name: "Abdelhak Ait elhad",
      reference: "9090",
      phone: "+212 6 12 34 56 78",
      email: "abdelhak@email.com",
      treatments: [
        PatientTreatment(
          id: "pt1",
          patientReference: "9090",
          treatmentTemplateId: "tmpl_orthodontie",
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          installments: [
            PatientInstallment(
              id: "pi1",
              order: 1,
              amount: 5000.0,
              isObligatory: true,
              description: 'Premier paiement - Pose des appareils',
              isPaid: true,
              paidDate: DateTime.now().subtract(const Duration(days: 30)),
            ),
            PatientInstallment(
              id: "pi2",
              order: 2,
              amount: 3000.0,
              isObligatory: true,
              description: 'Deuxième paiement - Suivi 3 mois',
            ),
            PatientInstallment(
              id: "pi3",
              order: 3,
              amount: 2000.0,
              isObligatory: false,
              description: 'Paiement optionnel - Suivi 6 mois',
            ),
          ],
        ),
      ],
      paymentHistory: [
        PaymentRecord(
          id: "p1",
          treatmentId: "pt1",
          installmentId: "pi1",
          amount: 5000.0,
          date: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ],
    ),
    PatientWithTreatments(
      name: "Sarah El Mansouri",
      reference: "8821",
      phone: "+212 6 87 65 43 21",
      treatments: [
        PatientTreatment(
          id: "pt2",
          patientReference: "8821",
          treatmentTemplateId: "tmpl_implant",
          startDate: DateTime.now().subtract(const Duration(days: 15)),
          installments: [
            PatientInstallment(
              id: "pi4",
              order: 1,
              amount: 4000.0,
              isObligatory: true,
              description: 'Pose de l\'implant',
              isPaid: true,
              paidDate: DateTime.now().subtract(const Duration(days: 15)),
            ),
            PatientInstallment(
              id: "pi5",
              order: 2,
              amount: 2000.0,
              isObligatory: true,
              description: 'Pose de la couronne',
            ),
          ],
        ),
      ],
      paymentHistory: [
        PaymentRecord(
          id: "p2",
          treatmentId: "pt2",
          installmentId: "pi4",
          amount: 4000.0,
          date: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ],
    ),
  ];

  // Global treatment templates
  static List<TreatmentTemplate> treatmentTemplates = [
    TreatmentTemplate(
      id: 'tmpl_orthodontie',
      name: 'Orthodontie Complète',
      description: 'Traitement orthodontique avec appareils dentaires complet',
      totalPrice: 15000.0,
      category: 'Orthodontie',
      installmentTemplates: [
        InstallmentTemplate(
          order: 1,
          amount: 5000.0,
          isObligatory: true,
          description: 'Premier paiement - Pose des appareils',
        ),
        InstallmentTemplate(
          order: 2,
          amount: 3000.0,
          isObligatory: true,
          description: 'Deuxième paiement - Suivi 3 mois',
        ),
        InstallmentTemplate(
          order: 3,
          amount: 2000.0,
          isObligatory: false,
          description: 'Paiement optionnel - Suivi 6 mois',
        ),
      ],
    ),
    TreatmentTemplate(
      id: 'tmpl_implant',
      name: 'Implant Dentaire',
      description: 'Pose d\'implant avec couronne céramique',
      totalPrice: 8000.0,
      category: 'Chirurgie',
      installmentTemplates: [
        InstallmentTemplate(
          order: 1,
          amount: 4000.0,
          isObligatory: true,
          description: 'Pose de l\'implant',
        ),
        InstallmentTemplate(
          order: 2,
          amount: 2000.0,
          isObligatory: true,
          description: 'Pose de la couronne',
        ),
      ],
    ),
    TreatmentTemplate(
      id: 'tmpl_blanchiment',
      name: 'Blanchiment Dentaire',
      description: 'Blanchiment dentaire professionnel complet',
      totalPrice: 2500.0,
      category: 'Esthétique',
      installmentTemplates: [
        InstallmentTemplate(
          order: 1,
          amount: 1500.0,
          isObligatory: true,
          description: 'Première séance',
        ),
        InstallmentTemplate(
          order: 2,
          amount: 1000.0,
          isObligatory: true,
          description: 'Séance de rappel',
        ),
      ],
    ),
    TreatmentTemplate(
      id: 'tmpl_nettoyage',
      name: 'Nettoyage Complet',
      description: 'Détartrage et nettoyage dentaire professionnel',
      totalPrice: 800.0,
      category: 'Prévention',
      installmentTemplates: [
        InstallmentTemplate(
          order: 1,
          amount: 800.0,
          isObligatory: true,
          description: 'Paiement unique',
        ),
      ],
    ),
    TreatmentTemplate(
      id: 'tmpl_couronne',
      name: 'Couronne Céramique',
      description: 'Pose de couronne céramique sur dent',
      totalPrice: 3500.0,
      category: 'Prothèse',
      installmentTemplates: [
        InstallmentTemplate(
          order: 1,
          amount: 2000.0,
          isObligatory: true,
          description: 'Préparation et empreinte',
        ),
        InstallmentTemplate(
          order: 2,
          amount: 1500.0,
          isObligatory: true,
          description: 'Pose de la couronne',
        ),
      ],
    ),
  ];

  // Treatment template methods
  static List<Treatment> getAvailableTreatmentTemplates() {
    return treatmentTemplates.where((t) => t.isActive).map((template) {
      return Treatment(
        id: template.id,
        name: template.name,
        description: template.description,
        totalPrice: template.totalPrice,
        createdDate: DateTime.now(),
        installments: template.installmentTemplates.map((installmentTemplate) {
          return Installment(
            id: '${template.id}_${installmentTemplate.order}',
            order: installmentTemplate.order,
            amount: installmentTemplate.amount,
            isObligatory: installmentTemplate.isObligatory,
          );
        }).toList(),
      );
    }).toList();
  }

  static PatientWithTreatments? getPatientByReference(String reference) {
    try {
      return mockPatients.firstWhere((patient) => patient.reference == reference);
    } catch (e) {
      return null;
    }
  }

  static TreatmentTemplate? getTreatmentTemplate(String templateId) {
    try {
      return treatmentTemplates.firstWhere((template) => template.id == templateId);
    } catch (e) {
      return null;
    }
  }

  static List<TreatmentTemplate> getTreatmentTemplatesByCategory(String category) {
    return treatmentTemplates.where((template) => 
        template.category == category && template.isActive).toList();
  }

  static List<String> getTreatmentCategories() {
    return treatmentTemplates
        .where((template) => template.isActive)
        .map((template) => template.category)
        .toSet()
        .toList();
  }

  // Create a new global treatment template
  static String createTreatmentTemplate(Treatment treatment) {
    final templateId = 'tmpl_${DateTime.now().millisecondsSinceEpoch}';
    
    final newTemplate = TreatmentTemplate(
      id: templateId,
      name: treatment.name,
      description: treatment.description,
      totalPrice: treatment.totalPrice,
      category: 'Personnalisé',
      installmentTemplates: treatment.installments.map((installment) {
        return InstallmentTemplate(
          order: installment.order,
          amount: installment.amount,
          isObligatory: installment.isObligatory,
          description: 'Échéance ${installment.order}',
        );
      }).toList(),
    );

    // Add to global templates list
    treatmentTemplates.add(newTemplate);
    return templateId;
  }

  // Assign an existing treatment template to a patient (used by CreateTreatmentScreen)
  static void addTreatmentToPatient(String patientReference, Treatment treatment) {
    // First create the global template
    final templateId = createTreatmentTemplate(treatment);
    
    // Then assign it to the patient
    assignTreatmentToPatient(patientReference, templateId);
  }

  static void assignTreatmentToPatient(String patientReference, String treatmentTemplateId) {
    final template = getTreatmentTemplate(treatmentTemplateId);
    if (template == null) return;

    final patientIndex = mockPatients.indexWhere((p) => p.reference == patientReference);
    if (patientIndex == -1) return;

    // Create patient treatment with installments from template
    final treatmentId = DateTime.now().millisecondsSinceEpoch.toString();
    final patientTreatment = PatientTreatment(
      id: treatmentId,
      patientReference: patientReference,
      treatmentTemplateId: treatmentTemplateId,
      startDate: DateTime.now(),
      installments: template.installmentTemplates.map((installmentTemplate) {
        return PatientInstallment(
          id: '${treatmentId}_${installmentTemplate.order}',
          order: installmentTemplate.order,
          amount: installmentTemplate.amount,
          isObligatory: installmentTemplate.isObligatory,
          description: installmentTemplate.description,
        );
      }).toList(),
    );

    // Add to patient
    final currentPatient = mockPatients[patientIndex];
    mockPatients[patientIndex] = PatientWithTreatments(
      name: currentPatient.name,
      reference: currentPatient.reference,
      phone: currentPatient.phone,
      email: currentPatient.email,
      treatments: [...currentPatient.treatments, patientTreatment],
      paymentHistory: currentPatient.paymentHistory,
    );
  }

  static void addPaymentToPatient(String patientReference, PaymentRecord payment) {
    final patientIndex = mockPatients.indexWhere((p) => p.reference == patientReference);
    if (patientIndex == -1) return;

    final currentPatient = mockPatients[patientIndex];
    
    // Also update the installment as paid if it's an installment payment
    List<PatientTreatment> updatedTreatments = currentPatient.treatments.map((treatment) {
      if (treatment.id == payment.treatmentId) {
        List<PatientInstallment> updatedInstallments = treatment.installments.map((installment) {
          if (installment.id == payment.installmentId) {
            return installment.copyWith(
              isPaid: true,
              paidDate: payment.date,
              paymentId: payment.id,
            );
          }
          return installment;
        }).toList();
        
        return PatientTreatment(
          id: treatment.id,
          patientReference: treatment.patientReference,
          treatmentTemplateId: treatment.treatmentTemplateId,
          startDate: treatment.startDate,
          installments: updatedInstallments,
          status: treatment.status,
        );
      }
      return treatment;
    }).toList();

    mockPatients[patientIndex] = PatientWithTreatments(
      name: currentPatient.name,
      reference: currentPatient.reference,
      phone: currentPatient.phone,
      email: currentPatient.email,
      treatments: updatedTreatments,
      paymentHistory: [...currentPatient.paymentHistory, payment],
    );
  }
}