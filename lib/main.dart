import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/dashboard.dart';
import 'screens/red_list.dart';
import 'screens/checkin.dart';
import 'screens/renewals.dart';
import 'screens/addons.dart';

void main() {
  runApp(const RetainFitApp());
}

class RetainFitApp extends StatelessWidget {
  const RetainFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RetainFit — Gym Retention OS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _tab = 0;

  void _go(int i) => setState(() => _tab = i);

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onGoRedList: () => _go(1)),
      const RedListScreen(),
      const CheckInScreen(),
      const RenewalsScreen(),
      const AddOnsScreen(),
    ];
    const labels = ['Home', 'Red List', 'Check-in', 'Renewals', 'Add-ons'];
    const icons = [
      Icons.home_rounded,
      Icons.warning_amber_rounded,
      Icons.qr_code_scanner_rounded,
      Icons.autorenew_rounded,
      Icons.add_box_rounded,
    ];

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              title: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.volt,
                    ),
                    alignment: Alignment.center,
                    child: Text('R',
                        style: AppTheme.display(19,
                            color: AppTheme.bgDeep)),
                  ),
                  const SizedBox(width: 10),
                  Text('RetainFit', style: AppTheme.title(18)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.volt.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                          color: AppTheme.volt.withOpacity(0.4)),
                    ),
                    child: Text('DEMO',
                        style: AppTheme.mono(9.5,
                            color: AppTheme.volt)),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.5, -0.35),
            radius: 1.1,
            colors: [Color(0xFF14202E), AppTheme.bg],
            stops: [0.0, 0.55],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: IndexedStack(index: _tab, children: screens),
        ),
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xB30D1119),
              border: Border(
                top: BorderSide(
                    color: Colors.white.withOpacity(0.08)),
              ),
            ),
            child: SafeArea(
              top: false,
              child: BottomNavigationBar(
                currentIndex: _tab,
                onTap: _go,
                backgroundColor: Colors.transparent,
                items: List.generate(
                  5,
                  (i) => BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Icon(icons[i], size: 23),
                    ),
                    label: labels[i],
                  ),
                ),
                selectedLabelStyle:
                    AppTheme.body(10.5, weight: FontWeight.w700),
                unselectedLabelStyle: AppTheme.body(10.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
