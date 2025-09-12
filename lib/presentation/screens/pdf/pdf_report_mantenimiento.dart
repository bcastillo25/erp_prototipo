import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:erp_prototipo/infrastructure/JSON/mantenimientodb.dart';

class PdfReportMantenimiento {
  static Future<void> generate(List<Mantenimientodb> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) => [
          pw.Center(
            child: pw.Text('Reporte de Mantenimiento',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold
            )),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(width: 1),
            headers: ['Equipo', 'Ultima revisión', 'Estado'],
            data: data.map((e) => [e.equipo, e.fechaSal, e.estado]).toList(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
              cellAlignment: pw.Alignment.center,
              cellStyle: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}