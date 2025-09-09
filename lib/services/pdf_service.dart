import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:denta_incomes/models/patient_dto.dart';
import 'package:denta_incomes/models/treatment_dto.dart';
import 'package:denta_incomes/models/payment_dto.dart';
import 'package:flutter/services.dart';

class PDFService {
  static Future<String> generatePaymentReceipt({
    required PatientWithTreatmentsDto patient,
    required PatientTreatmentDto treatment,
    required PaymentRecordDto paymentRecord,
    required double paymentAmount,
    String? signatureBase64,
    required bool isCustomPayment,
    PatientInstallmentDto? installment,
  }) async {
    try {
      final pdf = pw.Document();
      final now = DateTime.now();

      // Load fonts - using system fonts as fallback
      late pw.Font font;
      late pw.Font fontBold;
      
      try {
        final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
        final fontBoldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
        font = pw.Font.ttf(fontData);
        fontBold = pw.Font.ttf(fontBoldData);
      } catch (e) {
        // Use system fonts if custom fonts are not available
        font = await PdfGoogleFonts.notoSansRegular();
        fontBold = await PdfGoogleFonts.notoSansBold();
      }

      // Decode signature if available
      pw.MemoryImage? signatureImage;
      if (signatureBase64 != null && signatureBase64.isNotEmpty) {
        try {
          final signatureBytes = base64Decode(signatureBase64);
          signatureImage = pw.MemoryImage(signatureBytes);
        } catch (e) {
          print('Error decoding signature: $e');
          // Continue without signature
        }
      }

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(font, fontBold),
                pw.SizedBox(height: 30),

                // Receipt Title
                pw.Center(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(
                      'REÇU DE PAIEMENT',
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 18,
                        color: PdfColors.blue800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),

                // Payment Amount (Highlighted)
                pw.Center(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(20),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.green50,
                      border: pw.Border.all(color: PdfColors.green300, width: 2),
                      borderRadius: pw.BorderRadius.circular(12),
                    ),
                    child: pw.Text(
                      '${paymentAmount.toInt()} DH',
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 32,
                        color: PdfColors.green800,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 30),

                // Payment Details Section
                _buildSectionHeader('DÉTAILS DU PAIEMENT', fontBold),
                pw.SizedBox(height: 15),
                _buildDetailsTable(
                  patient: patient,
                  treatment: treatment,
                  paymentRecord: paymentRecord,
                  paymentAmount: paymentAmount,
                  isCustomPayment: isCustomPayment,
                  installment: installment,
                  now: now,
                  font: font,
                  fontBold: fontBold,
                ),
                pw.SizedBox(height: 25),

                // Treatment Progress Section
                _buildSectionHeader('PROGRESSION DU TRAITEMENT', fontBold),
                pw.SizedBox(height: 15),
                _buildTreatmentProgress(treatment, paymentAmount, font, fontBold),
                pw.SizedBox(height: 25),

                // Signature Section
                if (signatureImage != null) ...[
                  _buildSectionHeader('SIGNATURE DU PATIENT', fontBold),
                  pw.SizedBox(height: 15),
                  pw.Container(
                    height: 80,
                    width: double.infinity,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Image(signatureImage),
                    ),
                  ),
                  pw.SizedBox(height: 25),
                ],

                pw.Spacer(),

                // Footer
                _buildFooter(paymentRecord, now, font, fontBold),
              ],
            );
          },
        ),
      );

      // Get directory with better error handling
      Directory? directory;
      try {
        directory = await getApplicationDocumentsDirectory();
      } catch (e) {
        // Fallback to temporary directory if documents directory is not available
        directory = await getTemporaryDirectory();
      }

      // Create receipts subdirectory
      final receiptsDir = Directory('${directory.path}/receipts');
      if (!await receiptsDir.exists()) {
        await receiptsDir.create(recursive: true);
      }

      // Save PDF with timestamp
      final fileName = 'recu_paiement_${paymentRecord.id}_${now.millisecondsSinceEpoch}.pdf';
      final file = File('${receiptsDir.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      return file.path;
    } catch (e) {
      print('Error generating PDF: $e');
      throw Exception('Erreur lors de la génération du PDF: $e');
    }
  }

  static pw.Widget _buildHeader(pw.Font font, pw.Font fontBold) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'CABINET DENTAIRE',
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 20,
                color: PdfColors.blue800,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Adresse du cabinet',
              style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey600),
            ),
            pw.Text(
              'Téléphone: +212 XXX XXX XXX',
              style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'Date d\'impression:',
              style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600),
            ),
            pw.Text(
              _formatDateTime(DateTime.now()),
              style: pw.TextStyle(font: fontBold, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSectionHeader(String title, pw.Font fontBold) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          font: fontBold,
          fontSize: 14,
          color: PdfColors.grey800,
        ),
      ),
    );
  }

  static pw.Widget _buildDetailsTable({
    required PatientWithTreatmentsDto patient,
    required PatientTreatmentDto treatment,
    required PaymentRecordDto paymentRecord,
    required double paymentAmount,
    required bool isCustomPayment,
    PatientInstallmentDto? installment,
    required DateTime now,
    required pw.Font font,
    required pw.Font fontBold,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(120),
        1: const pw.FlexColumnWidth(),
      },
      children: [
        _buildTableRow('Patient', patient.name, font, fontBold),
        _buildTableRow('Référence', patient.reference, font, fontBold),
        _buildTableRow('Traitement', treatment.treatmentName, font, fontBold),
        _buildTableRow(
          'Type de paiement',
          isCustomPayment
              ? 'Paiement libre'
              : 'Échéance ${installment?.order ?? 'N/A'}${installment?.isObligatory == true ? ' (Obligatoire)' : ''}',
          font,
          fontBold,
        ),
        _buildTableRow('Montant payé', '${paymentAmount.toInt()} DH', font, fontBold, 
            valueColor: PdfColors.green700),
        _buildTableRow('Méthode', paymentRecord.paymentMethod, font, fontBold),
        _buildTableRow('Date de paiement', _formatDateTime(paymentRecord.paymentDate), font, fontBold),
        _buildTableRow('Référence paiement', paymentRecord.id.toString(), font, fontBold),
        if (paymentRecord.notes?.isNotEmpty == true)
          _buildTableRow('Notes', paymentRecord.notes!, font, fontBold),
      ],
    );
  }

  static pw.TableRow _buildTableRow(
    String label,
    String value,
    pw.Font font,
    pw.Font fontBold, {
    PdfColor? valueColor,
  }) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          color: PdfColors.grey50,
          child: pw.Text(
            label,
            style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.grey700),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              font: font,
              fontSize: 11,
              color: valueColor ?? PdfColors.black,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTreatmentProgress(
    PatientTreatmentDto treatment,
    double paymentAmount,
    pw.Font font,
    pw.Font fontBold,
  ) {
    final totalCost = treatment.totalPaidAmount + treatment.remainingAmount;
    final paidBefore = treatment.totalPaidAmount;
    final paidAfter = treatment.totalPaidAmount + paymentAmount;
    final progressBefore = totalCost > 0 ? paidBefore / totalCost : 0.0;
    final progressAfter = totalCost > 0 ? paidAfter / totalCost : 0.0;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Coût total du traitement:',
              style: pw.TextStyle(font: font, fontSize: 11),
            ),
            pw.Text(
              '${totalCost.toInt()} DH',
              style: pw.TextStyle(font: fontBold, fontSize: 11),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Payé avant ce paiement:',
              style: pw.TextStyle(font: font, fontSize: 11),
            ),
            pw.Text(
              '${paidBefore.toInt()} DH (${(progressBefore * 100).toInt()}%)',
              style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.orange700),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Payé après ce paiement:',
              style: pw.TextStyle(font: font, fontSize: 11),
            ),
            pw.Text(
              '${paidAfter.toInt()} DH (${(progressAfter * 100).toInt()}%)',
              style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.green700),
            ),
          ],
        ),
        pw.SizedBox(height: 15),
        
        // Progress bar
        pw.Container(
          width: double.infinity,
          height: 20,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.ClipRRect(
            horizontalRadius: 10,
            verticalRadius: 10,
            child: pw.Stack(
              children: [
                // Background
                pw.Container(color: PdfColors.grey100),
                
                // Center text
                pw.Center(
                  child: pw.Text(
                    '${(progressAfter * 100).toInt()}% payé',
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 10,
                      color: PdfColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Montant restant:',
              style: pw.TextStyle(font: font, fontSize: 11),
            ),
            pw.Text(
              '${(totalCost - paidAfter).toInt()} DH',
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 11,
                color: (totalCost - paidAfter) <= 0 ? PdfColors.green700 : PdfColors.red700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildFooter(
    PaymentRecordDto paymentRecord,
    DateTime now,
    pw.Font font,
    pw.Font fontBold,
  ) {
    return pw.Column(
      children: [
        pw.Container(
          width: double.infinity,
          height: 1,
          color: PdfColors.grey300,
        ),
        pw.SizedBox(height: 15),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Reçu généré automatiquement',
                  style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600),
                ),
                pw.Text(
                  'ID Transaction: ${paymentRecord.id}',
                  style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey500),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Cabinet Dentaire',
                  style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.grey700),
                ),
                pw.Text(
                  'www.cabinet-dentaire.ma',
                  style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey500),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year à $hour:$minute';
  }

  // Additional utility methods for sharing and printing
  static Future<void> sharePDF(String pdfPath) async {
    try {
      await Share.shareXFiles(
        [XFile(pdfPath)],
        text: 'Reçu de paiement - Cabinet Dentaire',
        subject: 'Reçu de paiement',
      );
    } catch (e) {
      throw Exception('Erreur lors du partage du PDF: $e');
    }
  }

  static Future<void> printPDF(String pdfPath) async {
    try {
      final file = File(pdfPath);
      final bytes = await file.readAsBytes();
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => bytes,
        name: 'Reçu de paiement',
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'impression: $e');
    }
  }

  static Future<void> openPDF(String pdfPath) async {
    try {
      await Printing.sharePdf(
        bytes: await File(pdfPath).readAsBytes(),
        filename: 'recu_paiement.pdf',
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ouverture du PDF: $e');
    }
  }

  // Method to get saved PDFs directory
  static Future<String> getPDFsDirectory() async {
    Directory? directory;
    try {
      directory = await getApplicationDocumentsDirectory();
    } catch (e) {
      directory = await getTemporaryDirectory();
    }
    
    final pdfDir = Directory('${directory.path}/receipts');
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }
    return pdfDir.path;
  }

  // Method to list all saved receipts
  static Future<List<File>> getSavedReceipts() async {
    try {
      final directory = await getPDFsDirectory();
      final dir = Directory(directory);
      final files = await dir.list().toList();
      return files
          .whereType<File>()
          .where((file) => file.path.endsWith('.pdf'))
          .toList()
        ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    } catch (e) {
      return [];
    }
  }

  // Method to delete a receipt
  static Future<bool> deleteReceipt(String pdfPath) async {
    try {
      final file = File(pdfPath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}