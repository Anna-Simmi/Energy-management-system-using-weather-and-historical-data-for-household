import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'predict_screen.dart';
import 'optimize_energy_usage.dart';
import 'more_screen.dart'; 
import 'account_screen.dart'; // <<< ADD THIS IMPORT

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Placeholder Screens (must be defined in your files or kept minimal)
  static final OptimizeEnergyUsageScreen _optimizeScreen = OptimizeEnergyUsageScreen();

  // Removed the placeholder for AccountScreen

  // The list of screens tied to the bottom navigation bar indices
  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    EnergyPredictionScreen(), 
    _optimizeScreen,
    const MoreScreen(),       
    const AccountScreen(),  // <<< ACCOUNT SCREEN INTEGRATED HERE
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Predict',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Optimize',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }
}

// A generic screen to serve as a placeholder for uncompleted pages
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '$title Page',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}