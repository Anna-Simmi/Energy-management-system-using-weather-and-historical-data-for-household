import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Allowed package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'More Options',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF333333)),
          titleTextStyle: TextStyle(
            color: Color(0xFF333333),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        scaffoldBackgroundColor: const Color(
          0xFFF0F2F5,
        ), // Light grey background
      ),
      home: const MoreScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Data model for a single option item in the "More" screen
class MoreOption {
  final String title;
  final IconData iconData;
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  MoreOption({
    required this.title,
    required this.iconData,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.onTap,
  });
}

// Data model for a section in the "More" screen
class MoreSection {
  final String title;
  final String subtitle;
  final List<MoreOption> options;

  MoreSection({
    required this.title,
    required this.subtitle,
    required this.options,
  });
}

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  // Define custom colors based on the image
  static const Color _primaryBlue = Color(0xFF2563EB);
  static const Color _lightBlueIconBg = Color(0xFFEBF2FF);
  static const Color _blueIcon = Color(0xFF3C82F6);
  static const Color _lightGreenIconBg = Color(0xFFE0FFF5);
  static const Color _greenIcon = Color(0xFF10B981);
  static const Color _lightPurpleIconBg = Color(0xFFF5ECFF);
  static const Color _purpleIcon = Color(0xFF8B5CF6);
  static const Color _lightYellowIconBg = Color(0xFFFFF7E0);
  static const Color _yellowIcon = Color(0xFFF59E0B);
  static const Color _lightTealIconBg = Color(0xFFE0FFF7);
  static const Color _tealIcon = Color(0xFF06B6D4);
  static const Color _lightGreyIconBg = Color(0xFFF3F4F6);
  static const Color _greyIcon = Color(0xFF6B7280);
  static const Color _chevronColor = Color(0xFF9CA3AF);
  static const Color _darkText = Color(0xFF333333);
  static const Color _mediumGreyText = Color(0xFF6B7280);

  // Initialize data for sections and options
  late final List<MoreSection> _moreSections;

  @override
  void initState() {
    super.initState();
    _moreSections = <MoreSection>[
      MoreSection(
        title: 'Calculators',
        subtitle: 'Estimate your costs and usage.',
        options: <MoreOption>[
          MoreOption(
            title: 'Energy Charges Calculator',
            iconData: Icons.calculate_outlined,
            iconBackgroundColor: _lightBlueIconBg,
            iconColor: _blueIcon,
            onTap: () {
              // Handle navigation to Energy Charges Calculator
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      EnergyChargesCalculatorScreen(),
                ),
              );
              debugPrint('Navigating to Energy Charges Calculator');
            },
          ),
          MoreOption(
            title: 'Power Consumption Calculator',
            iconData: Icons.power_outlined,
            iconBackgroundColor: _lightGreenIconBg,
            iconColor: _greenIcon,
            onTap: () {
              // Handle navigation to Power Consumption Calculator
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      const PowerConsumptionCalculatorScreen(),
                ),
              );
              debugPrint('Navigating to Power Consumption Calculator');
            },
          ),
        ],
      ),
      MoreSection(
        title: 'Resources & Information',
        subtitle: 'Stay informed and save energy.',
        options: <MoreOption>[
          MoreOption(
            title: 'Schemes',
            iconData: Icons.article_outlined,
            iconBackgroundColor: _lightPurpleIconBg,
            iconColor: _purpleIcon,
            onTap: () {
              // Handle navigation to Schemes
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const SchemesScreen(),
                ),
              );
              debugPrint('Navigating to Schemes');
            },
          ),
          MoreOption(
            title: 'Safety Guidelines',
            iconData: Icons.verified_user_outlined,
            iconBackgroundColor: _lightYellowIconBg,
            iconColor: _yellowIcon,
            onTap: () {
              // Handle navigation to Safety Guidelines
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      const SafetyGuidelinesScreen(),
                ),
              );
              debugPrint('Navigating to Safety Guidelines');
            },
          ),
          MoreOption(
            title: 'Energy Saving Tips',
            iconData: Icons.lightbulb_outline,
            iconBackgroundColor: _lightTealIconBg,
            iconColor: _tealIcon,
            onTap: () {
              // Handle navigation to Energy Saving Tips
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      const EnergySavingTipsScreen(),
                ),
              );
              debugPrint('Navigating to Energy Saving Tips');
            },
          ),
          MoreOption(
            title: 'About Us',
            iconData: Icons.info_outline,
            iconBackgroundColor: _lightGreyIconBg,
            iconColor: _greyIcon,
            onTap: () {
              // Handle navigation to About Us
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AboutUsScreen(),
                ),
              );
              debugPrint('Navigating to About Us');
            },
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Removed leading IconButton
        title: const Text('More'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _moreSections.map<Widget>((MoreSection section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  section.subtitle,
                  style: const TextStyle(fontSize: 14, color: _mediumGreyText),
                ),
                const SizedBox(height: 16),
                _MoreOptionList(options: section.options),
                const SizedBox(height: 24), // Spacing between sections
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MoreOptionList extends StatelessWidget {
  final List<MoreOption> options;

  const _MoreOptionList({required this.options});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map<Widget>((MoreOption option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _MoreOptionItem(option: option),
        );
      }).toList(),
    );
  }
}

class _MoreOptionItem extends StatelessWidget {
  final MoreOption option;

  const _MoreOptionItem({required this.option});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: option.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: option.iconBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(option.iconData, color: option.iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 24),
          ],
        ),
      ),
    );
  }
}

// Data model for an appliance in the power consumption calculator
class Appliance {
  final String name;
  final int fixedWatts;
  String quantity; // User input
  String avgHoursPerDay; // User input
  double? calculatedUnitsPerMonth; // Calculated

  Appliance({
    required this.name,
    required this.fixedWatts,
    this.quantity = '0', // Default to '0' as string
    this.avgHoursPerDay = '0', // Default to '0' as string
    this.calculatedUnitsPerMonth,
  });

  // Helper to create a copy for state updates
  Appliance copyWith({
    String? quantity,
    String? avgHoursPerDay,
    double? calculatedUnitsPerMonth,
  }) {
    return Appliance(
      name: name,
      fixedWatts: fixedWatts,
      quantity: quantity ?? this.quantity,
      avgHoursPerDay: avgHoursPerDay ?? this.avgHoursPerDay,
      calculatedUnitsPerMonth:
          calculatedUnitsPerMonth ?? this.calculatedUnitsPerMonth,
    );
  }
}

// Data model for Power Consumption Calculator Screen
class PowerConsumptionCalculatorData extends ChangeNotifier {
  late List<Appliance> _appliances;
  double _totalUnits = 0.0;
  double _estimatedCharges = 0.0;

  // Define MESCOM tariff slabs and fixed charge for consistency
  static const double _fixedCharge = 60.0;
  static const List<double> _slabRates = <double>[4.00, 5.45, 7.00, 8.05];
  static const List<int> _slabThresholds = <int>[30, 100, 200];

  PowerConsumptionCalculatorData() {
    _appliances = <Appliance>[
      Appliance(name: 'Incandescent Lamps (Bulb)', fixedWatts: 44),
      Appliance(name: 'Lamps (CFL)', fixedWatts: 22),
      Appliance(name: 'Tube Lights', fixedWatts: 40),
      Appliance(name: 'Electric Iron', fixedWatts: 800),
      Appliance(name: 'Immersion Heater', fixedWatts: 1500),
      Appliance(name: 'Water Heater', fixedWatts: 1000),
      Appliance(name: 'Toaster', fixedWatts: 800),
      Appliance(name: 'Electric Stove', fixedWatts: 1000),
      Appliance(name: 'Oven', fixedWatts: 400),
      Appliance(name: 'Water Geyser', fixedWatts: 2000),
    ];
    _calculateAllApplianceUnits(); // Initial calculation of individual units
  }

  List<Appliance> get appliances => _appliances;
  double get totalUnits => _totalUnits;
  double get estimatedCharges => _estimatedCharges;

  void updateApplianceQuantity(int index, String value) {
    if (index >= 0 && index < _appliances.length) {
      _appliances[index] = _appliances[index].copyWith(quantity: value);
      _calculateApplianceUnits(index);
      // Not calling notifyListeners here as total calculation is explicit.
    }
  }

  void updateApplianceAvgHoursPerDay(int index, String value) {
    if (index >= 0 && index < _appliances.length) {
      _appliances[index] = _appliances[index].copyWith(avgHoursPerDay: value);
      _calculateApplianceUnits(index);
      // Not calling notifyListeners here.
    }
  }

  void _calculateApplianceUnits(int index) {
    final Appliance appliance = _appliances[index];
    final int? quantity = int.tryParse(appliance.quantity);
    final int? avgHours = int.tryParse(appliance.avgHoursPerDay);

    if (quantity != null &&
        quantity >= 0 &&
        avgHours != null &&
        avgHours >= 0 &&
        avgHours <= 24) {
      final double units =
          (appliance.fixedWatts * quantity * avgHours * 30) / 1000;
      _appliances[index] = appliance.copyWith(
        calculatedUnitsPerMonth: double.parse(units.toStringAsFixed(2)),
      );
    } else {
      _appliances[index] = appliance.copyWith(calculatedUnitsPerMonth: 0.0);
    }
  }

  void _calculateAllApplianceUnits() {
    for (int i = 0; i < _appliances.length; i++) {
      _calculateApplianceUnits(i);
    }
    _totalUnits = _appliances
        .map<double>((Appliance a) => a.calculatedUnitsPerMonth ?? 0.0)
        .fold(0.0, (double sum, double units) => sum + units);
  }

  void calculateTotal() {
    _calculateAllApplianceUnits(); // Ensure all individual units are up to date
    if (_totalUnits >= 0) {
      _estimatedCharges = _calculateMescomBill(_totalUnits);
    } else {
      _estimatedCharges = 0.0;
    }
    notifyListeners();
  }

  static double _calculateMescomBill(double kwh) {
    if (kwh < 0) return 0.0;

    double energy = 0.0;
    if (kwh <= _slabThresholds[0]) {
      // 0-30 units
      energy = kwh * _slabRates[0];
    } else if (kwh <= _slabThresholds[1]) {
      // 31-100 units
      energy = _slabThresholds[0] * _slabRates[0] +
          (kwh - _slabThresholds[0]) * _slabRates[1];
    } else if (kwh <= _slabThresholds[2]) {
      // 101-200 units
      energy = _slabThresholds[0] * _slabRates[0] +
          (_slabThresholds[1] - _slabThresholds[0]) * _slabRates[1] +
          (kwh - _slabThresholds[1]) * _slabRates[2];
    } else {
      // Above 200 units
      energy = _slabThresholds[0] * _slabRates[0] +
          (_slabThresholds[1] - _slabThresholds[0]) * _slabRates[1] +
          (_slabThresholds[2] - _slabThresholds[1]) * _slabRates[2] +
          (kwh - _slabThresholds[2]) * _slabRates[3];
    }
    return double.parse((energy + _fixedCharge).toStringAsFixed(2));
  }

  void clearAll() {
    _appliances = _appliances.map<Appliance>((Appliance a) {
      return a.copyWith(
          quantity: '0', avgHoursPerDay: '0', calculatedUnitsPerMonth: 0.0);
    }).toList();
    _totalUnits = 0.0;
    _estimatedCharges = 0.0;
    notifyListeners();
  }
}

// --- Data Model for Energy Charges Calculator Screen ---
class EnergyChargesCalculatorData extends ChangeNotifier {
  String _unitsInput = '';
  double? _calculatedBill;
  final String _tariffCategory = 'LT-1'; // Fixed as per requirement

  String get unitsInput => _unitsInput;
  String get tariffCategory => _tariffCategory;
  double? get calculatedBill => _calculatedBill;

  void updateUnitsInput(String value) {
    _unitsInput = value;
    // Note: notifyListeners() is not called here because input changes
    // don't immediately trigger UI rebuild; calculation is explicit.
  }

  void calculateBill() {
    final int? kwh = int.tryParse(_unitsInput);
    if (kwh != null && kwh >= 0) {
      // Use the static _calculateMescomBill from PowerConsumptionCalculatorData
      _calculatedBill =
          PowerConsumptionCalculatorData._calculateMescomBill(kwh.toDouble());
    } else {
      _calculatedBill = null; // Clear result if input is invalid or negative
    }
    notifyListeners(); // Notify UI to rebuild with new calculated bill
  }
}

// --- New Screen for Energy Charges Calculator ---
class EnergyChargesCalculatorScreen extends StatelessWidget {
  EnergyChargesCalculatorScreen({super.key});

  final TextEditingController _unitsController = TextEditingController();

  // Define custom colors (re-using from MoreScreenState for consistency)
  static const Color _primaryBlue = Color(0xFF2563EB);
  static const Color _darkText = Color(0xFF333333);
  static const Color _mediumGreyText = Color(0xFF6B7280);
  static const Color _borderColor = Color(
    0xFFE5E7EB,
  ); // Light grey border for text fields

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EnergyChargesCalculatorData>(
      create: (BuildContext context) => EnergyChargesCalculatorData(),
      builder: (BuildContext context, Widget? child) {
        final EnergyChargesCalculatorData calculatorData =
            context.watch<EnergyChargesCalculatorData>();

        _unitsController.text = calculatorData.unitsInput;
        // Ensure cursor is at the end
        if (_unitsController.text.isNotEmpty) {
          _unitsController.selection = TextSelection.fromPosition(
            TextPosition(offset: _unitsController.text.length),
          );
        }

        return Scaffold(
          appBar: AppBar(
            // Removed leading IconButton
            title: const Text('Energy Charges Calculator'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Tariff Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _darkText,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  readOnly:
                      true, // As per requirement, fixed value, not a dropdown
                  initialValue: calculatorData.tariffCategory,
                  style: const TextStyle(color: _darkText),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: _primaryBlue,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Units',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _darkText,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _unitsController,
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    context
                        .read<EnergyChargesCalculatorData>()
                        .updateUnitsInput(value);
                  },
                  style: const TextStyle(color: _darkText),
                  decoration: InputDecoration(
                    hintText: 'Enter units consumed',
                    hintStyle: const TextStyle(color: _mediumGreyText),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: _primaryBlue,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<EnergyChargesCalculatorData>()
                          .calculateBill();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Calculate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (calculatorData.calculatedBill != null) ...<Widget>[
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Estimated Bill: ₹${calculatorData.calculatedBill}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _darkText,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- New Screen for Power Consumption Calculator ---
class PowerConsumptionCalculatorScreen extends StatefulWidget {
  const PowerConsumptionCalculatorScreen({super.key});

  @override
  State<PowerConsumptionCalculatorScreen> createState() =>
      _PowerConsumptionCalculatorScreenState();
}

class _PowerConsumptionCalculatorScreenState
    extends State<PowerConsumptionCalculatorScreen> {
  // Define custom colors (re-using from MoreScreenState for consistency)
  static const Color _primaryBlue = Color(0xFF2563EB);
  static const Color _darkText = Color(0xFF333333);
  static const Color _mediumGreyText = Color(0xFF6B7280);
  static const Color _borderColor = Color(0xFFE5E7EB);

  late final List<TextEditingController> _quantityControllers;
  late final List<TextEditingController> _hoursControllers;

  @override
  void initState() {
    super.initState();
    // Create a temporary instance to get the initial number of appliances
    // This instance is immediately discarded after reading its appliances.length.
    final PowerConsumptionCalculatorData tempCalculatorData =
        PowerConsumptionCalculatorData();
    final int numberOfAppliances = tempCalculatorData.appliances.length;

    _quantityControllers = List<TextEditingController>.generate(
      numberOfAppliances,
      (int index) => TextEditingController(
          text: tempCalculatorData.appliances[index].quantity),
    );
    _hoursControllers = List<TextEditingController>.generate(
      numberOfAppliances,
      (int index) => TextEditingController(
          text: tempCalculatorData.appliances[index].avgHoursPerDay),
    );
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _quantityControllers) {
      controller.dispose();
    }
    for (final TextEditingController controller in _hoursControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PowerConsumptionCalculatorData>(
      create: (BuildContext context) => PowerConsumptionCalculatorData(),
      builder: (BuildContext context, Widget? child) {
        final PowerConsumptionCalculatorData calculatorData =
            context.watch<PowerConsumptionCalculatorData>();

        // Update controllers from model data
        for (int i = 0; i < calculatorData.appliances.length; i++) {
          final Appliance appliance = calculatorData.appliances[i];
          // Update quantity controller
          if (_quantityControllers[i].text != appliance.quantity) {
            _quantityControllers[i].text = appliance.quantity;
            _quantityControllers[i].selection = TextSelection.fromPosition(
              TextPosition(offset: _quantityControllers[i].text.length),
            );
          }
          // Update hours controller
          if (_hoursControllers[i].text != appliance.avgHoursPerDay) {
            _hoursControllers[i].text = appliance.avgHoursPerDay;
            _hoursControllers[i].selection = TextSelection.fromPosition(
              TextPosition(offset: _hoursControllers[i].text.length),
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Power Consumption Calculator'),
            // Using default AppBarTheme colors (white background, dark text)
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: _primaryBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Appliances',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Replaced _ApplianceTable with a list of _ApplianceItem
                      Column(
                        children: calculatorData.appliances
                            .asMap()
                            .entries
                            .map<Widget>((MapEntry<int, Appliance> entry) {
                          final int index = entry.key;
                          final Appliance appliance = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _ApplianceItem(
                              appliance: appliance,
                              quantityController: _quantityControllers[index],
                              hoursController: _hoursControllers[index],
                              onQuantityChanged: (String value) {
                                context
                                    .read<PowerConsumptionCalculatorData>()
                                    .updateApplianceQuantity(index, value);
                              },
                              onHoursChanged: (String value) {
                                context
                                    .read<PowerConsumptionCalculatorData>()
                                    .updateApplianceAvgHoursPerDay(index, value);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Total Units: ${calculatorData.totalUnits.toStringAsFixed(2)} kWh',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _darkText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Estimated Charges: ₹${calculatorData.estimatedCharges.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _darkText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<PowerConsumptionCalculatorData>()
                              .calculateTotal();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Calculate',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<PowerConsumptionCalculatorData>()
                              .clearAll();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryBlue.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ApplianceItem extends StatelessWidget {
  final Appliance appliance;
  final TextEditingController quantityController;
  final TextEditingController hoursController;
  final void Function(String) onQuantityChanged;
  final void Function(String) onHoursChanged;

  const _ApplianceItem({
    required this.appliance,
    required this.quantityController,
    required this.hoursController,
    required this.onQuantityChanged,
    required this.onHoursChanged,
  });

  static const Color _primaryBlue = Color(0xFF2563EB);
  static const Color _darkText = Color(0xFF333333);
  static const Color _mediumGreyText = Color(0xFF6B7280);
  static const Color _borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.electrical_services_outlined, color: _primaryBlue, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  appliance.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _darkText,
                  ),
                ),
              ),
              Text(
                '${appliance.fixedWatts} W',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _mediumGreyText,
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1, color: _borderColor),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _mediumGreyText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildInputField(
                      controller: quantityController,
                      onChanged: onQuantityChanged,
                      hintText: 'No. of units',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Avg hrs/Day',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _mediumGreyText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildInputField(
                      controller: hoursController,
                      onChanged: onHoursChanged,
                      hintText: 'Hours (0-24)',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Approx Units/Month: ${appliance.calculatedUnitsPerMonth != null ? appliance.calculatedUnitsPerMonth!.toStringAsFixed(2) : '0.00'} kWh',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required void Function(String) onChanged,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      style: const TextStyle(color: _darkText, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: _mediumGreyText, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 12.0,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: _primaryBlue,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB), // Lightest grey for input background
      ),
    );
  }
}

// --- Data Model for Schemes ---
class Scheme {
  final String title;
  final String subtitle;

  Scheme({required this.title, required this.subtitle});
}

// --- New Screen for Schemes ---
class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  // Define custom colors (re-using from MoreScreenState for consistency)
  static const Color _primaryBlue = Color(0xFF2563EB);
  static const Color _darkText = Color(0xFF333333);
  static const Color _mediumGreyText = Color(0xFF6B7280);

  // Initialize data for schemes
  static final List<Scheme> _schemes = <Scheme>[
    Scheme(
      title: 'Integrated Power Development Scheme (IPDS)',
      subtitle: 'Strengthening urban power infrastructure.',
    ),
    Scheme(
      title: 'Deen Dayal Upadhyaya Gram Jyoti Yojana (DDUGJY)',
      subtitle: 'Rural electrification and feeder separation.',
    ),
    Scheme(
      title: 'Pradhan Mantri Sahaj Bijli Har Ghar Yojana (SAUBHAGYA)',
      subtitle: 'Universal household electrification.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Removed leading IconButton
        title: const Text('Schemes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options for schemes if needed
              debugPrint('More options tapped for schemes');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Icon(Icons.flash_on, color: _primaryBlue, size: 24),
                SizedBox(width: 8),
                Text(
                  'Electricity Schemes',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _darkText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: _schemes.map<Widget>((Scheme scheme) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _SchemeCard(scheme: scheme),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SchemeCard extends StatelessWidget {
  final Scheme scheme;

  const _SchemeCard({required this.scheme});

  // Define custom colors (re-using from MoreScreenState for consistency)
  static const Color _darkText = Color(0xFF333333);
  static const Color _mediumGreyText = Color(0xFF6B7280);
  static const Color _chevronColor = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                SchemeDetailScreen(title: scheme.title),
          ),
        );
        debugPrint('Navigating to detail for scheme: ${scheme.title}');
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    scheme.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight
                          .bold, // Using bold for consistency with image
                      color: _darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scheme.subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: _mediumGreyText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _chevronColor, size: 24),
          ],
        ),
      ),
    );
  }
}

// --- Blank Screen for Scheme Details ---
class SchemeDetailScreen extends StatelessWidget {
  final String title;

  const SchemeDetailScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Removed leading IconButton
        title: Text(title),
      ),
      body: const Center(
        child: Text(
          'Scheme description will be added here.',
          style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
        ),
      ),
    );
  }
}

// --- New Screen for Safety Guidelines ---
class SafetyGuidelinesScreen extends StatelessWidget {
  const SafetyGuidelinesScreen({super.key});

  // Define custom colors for this screen
  static const Color _dosHeaderColor = Color(0xFF2563EB); // Primary blue
  static const Color _dontsHeaderColor = Color(
    0xFF1D4ED8,
  ); // Slightly deeper blue
  static const Color _contentBackgroundColor = Color(
    0xFFF0F8FF,
  ); // Very light blue
  static const Color _darkText = Color(0xFF333333); // From MoreScreenState

  // Data for Safety Guidelines
  static const List<String> _dos = <String>[
    'Use proper insulation: Always ensure wires and appliances are properly insulated.',
    'Switch off when not in use: Turn off lights, fans, and appliances to save energy and prevent overheating.',
    'Dry hands before touching: Always keep your hands dry when plugging/unplugging devices.',
    'Check appliances regularly: Inspect wires, plugs, and sockets for wear and tear. Replace damaged ones immediately.',
    'Use proper rating fuses/circuit breakers: Protects against overload and short circuits.',
    'Follow load limits: Don\'t connect too many devices to a single socket (avoid overloading).',
    'Use certified appliances: Look for ISI/CE/BIS marks or trusted standards for safety.',
    'Unplug during storms: Lightning can cause surges — unplug appliances to prevent damage.',
    'Call a professional: For repairs or new wiring, rely on a licensed electrician.',
    'Educate kids: Teach them not to play with switches, sockets, or wires.',
  ];

  static const List<String> _donts = <String>[
    'Don\'t touch appliances with wet hands or bare feet.',
    'Don\'t pull cords to unplug. Always pull the plug, not the wire.',
    'Don\'t overload sockets. It can cause overheating and fire.',
    'Don\'t use damaged cords, wires, or plugs. Replace them immediately.',
    'Don\'t insert objects into sockets. Especially important around children.',
    'Don\'t run wires under carpets or rugs. Heat buildup can cause fire.',
    'Don\'t charge devices overnight (especially cheap chargers) — risk of overheating and fire.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Removed leading IconButton
        title: const Text('Safety Guidelines'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: <Widget>[
            _GuidelineSection(
              title: 'DOs',
              headerBackgroundColor: _dosHeaderColor,
              contentBackgroundColor: _contentBackgroundColor,
              guidelines: _dos,
            ),
            _GuidelineSection(
              title: 'DON\'Ts',
              headerBackgroundColor: _dontsHeaderColor,
              contentBackgroundColor: _contentBackgroundColor,
              guidelines: _donts,
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidelineSection extends StatelessWidget {
  final String title;
  final Color headerBackgroundColor;
  final Color contentBackgroundColor;
  final List<String> guidelines;

  const _GuidelineSection({
    required this.title,
    required this.headerBackgroundColor,
    required this.contentBackgroundColor,
    required this.guidelines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0), // Spacing between sections
      decoration: BoxDecoration(
        color: contentBackgroundColor, // Overall card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: headerBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: guidelines.map<Widget>((String text) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        '• ', // Bullet point
                        style: TextStyle(
                          fontSize: 14,
                          color: SafetyGuidelinesScreen
                              ._darkText, // Dark text color
                        ),
                      ),
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontSize: 14,
                            color: SafetyGuidelinesScreen
                                ._darkText, // Dark text color
                            height: 1.4, // Line height for readability
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Data Model for Energy Saving Tips ---
class EnergySavingTipsData extends ChangeNotifier {
  // Use the placeholder URL for all images as per instructions
  final List<String> _imageUrls = <String>[
    'assets/images/imagebulb.jpg',
    // Added a second placeholder for demonstration of navigation.
    // Replace with actual second image URL later.
    'assets/images/imagecapacito.jpg',
    'assets/images/imagehouse.jpg',
    'assets/images/imagelight.jpg',
    'assets/images/imagesolar.jpg',
    'assets/images/imagestreet.jpg',
    'assets/images/imagewire.jpg',
  ];
  int _currentIndex = 0;
  late final PageController _pageController;

  EnergySavingTipsData() {
    _pageController = PageController(initialPage: _currentIndex);
  }

  int get currentIndex => _currentIndex;
  String get currentImageUrl => _imageUrls[_currentIndex];
  int get totalTips => _imageUrls.length;
  bool get canGoNext => _currentIndex < _imageUrls.length - 1;
  bool get canGoPrevious => _currentIndex > 0;

  void updatePageIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void nextPage() {
    if (canGoNext) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void previousPage() {
    if (canGoPrevious) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// --- New Screen for Energy Saving Tips ---
class EnergySavingTipsScreen extends StatelessWidget {
  const EnergySavingTipsScreen({super.key});

  static const Color _primaryBlue = Color(0xFF2563EB); // From MoreScreenState
  static const Color _chevronColor = Color(
    0xFF9CA3AF,
  ); // From MoreScreenState

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EnergySavingTipsData>(
      create: (BuildContext context) => EnergySavingTipsData(),
      builder: (BuildContext context, Widget? child) {
        final EnergySavingTipsData tipsData =
            context.watch<EnergySavingTipsData>();

        return Scaffold(
          appBar: AppBar(
            // Removed leading IconButton
            title: const Text('Energy Saving Tips'),
          ),
          body: Stack(
            children: <Widget>[
              PageView.builder(
                controller: tipsData._pageController,
                itemCount: tipsData.totalTips,
                onPageChanged: tipsData.updatePageIndex,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Image.asset(
                      tipsData._imageUrls[index],
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Text(
                          'Could not load image',
                          style: TextStyle(color: Colors.red),
                        );
                      },
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, size: 48),
                    color: tipsData.canGoPrevious
                        ? _primaryBlue
                        : _chevronColor.withOpacity(0.5),
                    onPressed:
                        tipsData.canGoPrevious ? tipsData.previousPage : null,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right, size: 48),
                    color: tipsData.canGoNext
                        ? _primaryBlue
                        : _chevronColor.withOpacity(0.5),
                    onPressed: tipsData.canGoNext ? tipsData.nextPage : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- New Screen for About Us ---
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const Color _primaryBlue = Color(0xFF2563EB);
  static const Color _darkText = Color(0xFF333333);
  static const Color _mediumGreyText = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Removed leading IconButton
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // App Name & Tagline
            const Row(
              children: <Widget>[
                Icon(Icons.flash_on, color: _primaryBlue, size: 36),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'EnergyManager',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _darkText,
                        ),
                      ),
                      Text(
                        'Your Energy Strategist',
                        style: TextStyle(
                          fontSize: 16,
                          color: _mediumGreyText,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Introduction Section
            const Text(
              'At EnergyManager, we’re redefining how people interact with energy—turning electricity bills into intelligent insights.',
              style: TextStyle(
                fontSize: 16,
                color: _darkText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Core Features/How it works
            const Text(
              'What we do:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            const _FeatureTile(
              icon: Icons.lightbulb_outline,
              title: 'Intelligent Insights',
              description: 'Turning bills into smart, actionable information.',
            ),
            const _FeatureTile(
              icon: Icons.auto_awesome_outlined,
              title: 'Smart Forecasting',
              description:
                  'Machine learning & real-time weather predict consumption.',
            ),
            const _FeatureTile(
              icon: Icons.wallet_travel_outlined,
              title: 'Budget Optimization',
              description:
                  'Set targets (e.g., ₹3000) and identify wallet-draining appliances.',
            ),
            const _FeatureTile(
              icon: Icons.tips_and_updates_outlined,
              title: 'Efficiency Suggestions',
              description:
                  'Get recommendations for efficient alternatives and optimized energy distribution.',
            ),
            const SizedBox(height: 24),

            // Empowerment / Target Audience
            const Text(
              'Whether you\'re a tech-savvy homeowner or just tired of unpredictable bills, EnergyManager empowers you to take control with precision, personalization, and a touch of innovation, all through a sleek, intuitive mobile interface.',
              style: TextStyle(
                fontSize: 16,
                color: _darkText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Closing Statement
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: _primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'It\'s not just an app—it’s your energy strategist.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _primaryBlue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for feature tiles
class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  static const Color _darkText = Color(0xFF333333);
  static const Color _mediumGreyText = Color(0xFF6B7280);
  static const Color _primaryBlue = Color(0xFF2563EB); // For icon background

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _primaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _mediumGreyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}