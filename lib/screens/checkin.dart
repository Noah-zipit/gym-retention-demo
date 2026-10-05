import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme.dart';
import '../data/demo_data.dart';
import '../widgets/ui.dart';

/// Screen 2 from the reel: QR check-in with streaks.
/// "Har entry par QR scan — streaks members ko wapas kheench laate hain."
class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen>
    with SingleTickerProviderStateMixin {
  final _rand = Random();
  late final AnimationController _pulse;
  String? _lastCheckIn;
  int _todayCount = 0;

  @override
  void initState() {
    super.initState();
    _todayCount =
        DemoData.members.where((m) => m.daysAbsent <= 1).length;
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _simulateScan() {
    final candidates =
        DemoData.members.where((m) => m.name != _lastCheckIn).toList();
    final m = candidates[_rand.nextInt(candidates.length)];
    setState(() {
      _lastCheckIn = m.name;
      _todayCount++;
      m.contacted = m.contacted; // no-op, keeps demo state local
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${m.name} checked in — streak extended. They will not want to break it tomorrow.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final streakLeaders = DemoData.members.toList()
      ..sort((a, b) => b.streak.compareTo(a.streak));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('SCREEN 02 · DAILY HABIT LOOP',
            style: AppTheme.mono(11, color: AppTheme.volt)),
        const SizedBox(height: 6),
        Text('Scan.\nStreak. Return.', style: AppTheme.display(34)),
        const SizedBox(height: 8),
        Text(
          'Every entry is a QR scan. Streaks turn workouts into a habit members refuse to break.',
          style: AppTheme.body(13.5, height: 1.5),
        ),
        const SizedBox(height: 18),

        // QR card
        GlassCard(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) => Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.volt.withOpacity(
                            0.25 + _pulse.value * 0.35),
                        blurRadius: 24 + _pulse.value * 18,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: 'retainfit://checkin/iron-paradise-gym',
                    version: QrVersions.auto,
                    size: 190,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('IRON PARADISE · ENTRY GATE',
                  style: AppTheme.mono(11, color: AppTheme.textSecondary)),
              const SizedBox(height: 4),
              Text('Point the member app camera here',
                  style: AppTheme.title(15)),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _simulateScan,
                  icon: const Icon(Icons.qr_code_scanner_rounded,
                      color: AppTheme.bgDeep),
                  label: Text('Simulate a scan',
                      style: AppTheme.body(14,
                          weight: FontWeight.w700,
                          color: AppTheme.bgDeep)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.volt,
                    foregroundColor: AppTheme.bgDeep,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              if (_lastCheckIn != null) ...[
                const SizedBox(height: 10),
                Text('Last scan: $_lastCheckIn · $_todayCount today',
                    style:
                        AppTheme.body(12.5, color: AppTheme.success)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        SectionHeader(
          title: 'Streak leaders',
          subtitle: 'Your most habitual members',
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 132,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: streakLeaders.take(6).length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final m = streakLeaders[i];
              return GlassCard(
                blur: false,
                padding: const EdgeInsets.all(14),
                child: SizedBox(
                  width: 118,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MemberAvatar(
                          initials: m.initials,
                          size: 44,
                          accent: AppTheme.volt),
                      const SizedBox(height: 8),
                      Text(m.name.split(' ').first,
                          style: AppTheme.title(13),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${m.streak} day streak',
                            style: AppTheme.mono(10,
                                color: AppTheme.warning)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
