import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1A237E);

    return MaterialApp(
      title: 'Energy Optimizer',
      theme: ThemeData(
        primaryColor: primaryBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: const OptimizeEnergyUsageScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OptimizeEnergyUsageScreen extends StatefulWidget {
  const OptimizeEnergyUsageScreen({super.key});

  @override
  State<OptimizeEnergyUsageScreen> createState() => _OptimizeEnergyUsageScreenState();
}

class _OptimizeEnergyUsageScreenState extends State<OptimizeEnergyUsageScreen> {
  String _selectedYear = DateTime.now().year.toString();
  String _selectedMonth = 'January';
  final TextEditingController _targetBillController = TextEditingController();
  bool _isLoading = false;

  final List<String> _months = const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _selectedMonth = _months[DateTime.now().month - 1];
  }

  @override
  void dispose() {
    _targetBillController.dispose();
    super.dispose();
  }

  Future<void> _showYearPickerDialog(BuildContext context) async {
    final controller = TextEditingController(text: _selectedYear);

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Year'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: const InputDecoration(hintText: 'e.g., 2024'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );

    if (result != null) setState(() => _selectedYear = result);
  }

  Future<void> _showMonthPickerDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Select Month'),
        children: _months.map((month) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, month),
            child: Text(month),
          );
        }).toList(),
      ),
    );

    if (result != null) setState(() => _selectedMonth = result);
  }

  /// ------------------------ API CALL ------------------------
  Future<void> _optimize() async {
    if (_targetBillController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter target bill")),
      );
      return;
    }

    final int year = int.parse(_selectedYear);
    final int month = _months.indexOf(_selectedMonth) + 1;
    final double targetBill = double.parse(_targetBillController.text);

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("http://10.41.82.142:8000/optimize"), // <-- Change if real device
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "year": year,
          "month": month,
          "target_bill": targetBill,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(data: resData["data"]),
          ),
        );
      } else {
        throw Exception("Backend Error");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// ------------------------ UI BUILD ------------------------
  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1A237E);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Optimize Energy Usage', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: blue))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildSelectionField(label: "Year", value: _selectedYear, onTap: () => _showYearPickerDialog(context))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildSelectionField(label: "Month", value: _selectedMonth, onTap: () => _showMonthPickerDialog(context))),
                    ],
                  ),

                  const SizedBox(height: 22),

                  /// Target Bill
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Target Bill", style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: blue, width: 1.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          controller: _targetBillController,
                          decoration: const InputDecoration(border: InputBorder.none, hintText: "e.g., 2500"),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// Optimize Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _optimize,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Optimize", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSelectionField({required String label, required String value, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF1A237E), width: 1.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600)),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
