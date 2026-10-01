import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:smart_energy_app/services/prediction_storage.dart';

class DownloadReportPage extends StatelessWidget {

  Future<void> generatePdf(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final latest = await PredictionStorage.getLatestPrediction("user123");

    if (latest == null) {
      messenger.showSnackBar(
        SnackBar(content: Text("No prediction found!")),
      );
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Energy Prediction Report",
                style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),

            pw.Text("Mode: ${latest['mode']}"),
            pw.Text("Total Consumption: ${latest['totalConsumption']}"),
            pw.Text("Bill: ₹${latest['predictedBill']}"),
            pw.Text("Peak Hour: ${latest['peakHour']}"),
            pw.Text("Peak Day: ${latest['peakDay']}"),
            pw.Text("Peak Week: ${latest['peakWeek']}"),

            pw.SizedBox(height: 20),
            pw.Text("Appliance Usage:", style: pw.TextStyle(fontSize: 18)),
            ...((latest['applianceUsage'] as List).map((a) {
              return pw.Text(
                  "${a['name']} → ${a['usage']} kWh (Priority ${a['priority']})");
            }).toList()),
          ],
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "energy_report.pdf",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download Report")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => generatePdf(context),
          child: Text("Download Latest Prediction"),
        ),
      ),
    );
  }
}
