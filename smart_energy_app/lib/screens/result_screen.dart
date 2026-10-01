import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ResultScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1A237E);
    const green = Color(0xFF4CAF50);
    const greyBg = Color(0xFFF5F5F5);

    // Extracting data dynamically from backend
    double predictedBill = (data["predicted_bill"] ?? 0).toDouble();
    double optimizedBill = data["optimized_bill"]?.toDouble() ?? 0.0;
    double predictedKwh = data["predicted_kWh"]?.toDouble() ?? 0.0;
    double optimizedKwh = data["optimized_kWh"]?.toDouble() ?? 0.0;

    List applianceData = data["appliance_breakdown"] ?? [];

    // Assign dynamic color shades
    final List<Color> pieColors = [
      Colors.blue.shade900,
      Colors.blue.shade700,
      Colors.blue.shade500,
      Colors.blue.shade300,
      Colors.blue.shade200,
      Colors.blue.shade100,
      Colors.blue.shade50,
    ];

    // Convert appliance list to include color field
    for (int i = 0; i < applianceData.length; i++) {
      applianceData[i]["color"] = pieColors[i % pieColors.length];
    }

    return Scaffold(
      backgroundColor: greyBg,
      appBar: AppBar(
        title: const Text("Optimization Results", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          /// BILL CARDS
          Row(
            children: [
              Expanded(child: _infoCard("Predicted Bill", "₹ ${predictedBill.toStringAsFixed(0)}")),
              const SizedBox(width: 10),
              Expanded(child: _infoCard("Optimized Bill", "₹ ${optimizedBill.toStringAsFixed(0)}",
                bg: const Color(0xFFECF8ED), textColor: green)),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(child: _infoCard("Predicted kWh", predictedKwh.toStringAsFixed(1))),
              const SizedBox(width: 10),
              Expanded(child: _infoCard("Optimized kWh", optimizedKwh.toStringAsFixed(1),
                textColor: blue, bg: Colors.white)),
            ],
          ),

          const SizedBox(height: 20),
          const Text("Optimized Distribution",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),

          const SizedBox(height: 8),

          /// PIE CHART CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [

                SizedBox(
                  height: 220,
                  child: PieChart(
                    PieChartData(
                      sections: applianceData.map((item) {
                        return PieChartSectionData(
                          value: item["optimized_kWh"].toDouble(),
                          color: item["color"],
                          radius: 45,
                          title: "",
                        );
                      }).toList(),
                    ),
                  ),
                ),

                Wrap(
                  spacing: 10,
                  children: applianceData.map((item) =>
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 5, backgroundColor: item["color"]),
                        const SizedBox(width: 4),
                        Text(item["appliance"], style: const TextStyle(fontSize: 12)),
                      ],
                    )
                  ).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),
          const Text("Appliance Breakdown",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          /// TABLE
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: DataTable(
              columnSpacing: 18,
              headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
              columns: const [
                DataColumn(label: Text("Appliance", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Original")),
                DataColumn(label: Text("Factor")),
                DataColumn(label: Text("Optimized")),
              ],
              rows: applianceData.map((row) {
                return DataRow(cells: [
                  DataCell(Text(row["appliance"])),
                  DataCell(Text(row["original_kWh"].toStringAsFixed(1))),
                  DataCell(Text(row["scale_factor"].toStringAsFixed(2))),
                  DataCell(Text(
                    row["optimized_kWh"].toStringAsFixed(1),
                    style: const TextStyle(color: blue, fontWeight: FontWeight.w600),
                  )),
                ]);
              }).toList(),
            ),
          ),

          const SizedBox(height: 30),

          /// DONE BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () { Navigator.pop(context); },
              child: const Text("Done", style: TextStyle(fontSize: 18)),
            ),
          ),
        ]),
      ),
    );
  }

  /// Mini Card Component
  Widget _infoCard(String title, String value, {Color bg = Colors.white, Color textColor = Colors.black}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
      ]),
    );
  }
}
