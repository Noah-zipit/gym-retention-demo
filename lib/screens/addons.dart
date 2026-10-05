import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/demo_data.dart';
import '../widgets/ui.dart';

/// Screen 4 from the reel: add-on earning.
/// "PT + diet + protein — upsells the owner never had time to pitch."
class AddOnsScreen extends StatelessWidget {
  const AddOnsScreen({super.key});

  IconData _iconFor(String key) {
    switch (key) {
      case 'pt':
        return Icons.fitness_center_rounded;
      case 'diet':
        return Icons.restaurant_menu_rounded;
      case 'protein':
        return Icons.local_drink_rounded;
      default:
        return Icons.add_box_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthlyUpside =
        DemoData.addOns.fold(0, (s, a) => s + a.price * a.interested);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('SCREEN 04 · HIDDEN REVENUE',
            style: AppTheme.mono(11, color: AppTheme.success)),
        const SizedBox(height: 6),
        Text('Sell more\nto members.', style: AppTheme.display(34)),
        const SizedBox(height: 8),
        Text(
          'The app flags who is ready for PT, diet coaching, or protein — and hands the owner the exact pitch. New revenue, zero extra floor time.',
          style: AppTheme.body(13.5, height: 1.5),
        ),
        const SizedBox(height: 18),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.success.withOpacity(0.20),
                AppTheme.success.withOpacity(0.05),
              ],
            ),
            border:
                Border.all(color: AppTheme.success.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.attach_money_rounded,
                  color: AppTheme.success, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DemoData.inr(monthlyUpside),
                        style: AppTheme.display(26,
                            color: AppTheme.success)),
                    Text('in flagged upsells this month',
                        style: AppTheme.body(12.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        SectionHeader(
          title: 'Add-on menu',
          subtitle: 'Tap a card to pitch it',
        ),
        const SizedBox(height: 12),
        ...DemoData.addOns.map((a) => _AddOnCard(
              addOn: a,
              icon: _iconFor(a.icon),
              onPitch: () {
                final names = DemoData.members
                    .where((m) => m.addOns.contains(a.name))
                    .take(3)
                    .map((m) => m.name.split(' ').first)
                    .join(', ');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${a.name} pitched — starting with $names.'),
                  ),
                );
              },
            )),
      ],
    );
  }
}

class _AddOnCard extends StatelessWidget {
  const _AddOnCard({
    required this.addOn,
    required this.icon,
    required this.onPitch,
  });

  final AddOn addOn;
  final IconData icon;
  final VoidCallback onPitch;

  @override
  Widget build(BuildContext context) {
    final interestedNames = DemoData.members
        .where((m) => m.addOns.contains(addOn.name))
        .take(3)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        onTap: onPitch,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.volt.withOpacity(0.30),
                        AppTheme.volt.withOpacity(0.08),
                      ],
                    ),
                    border: Border.all(
                        color: AppTheme.volt.withOpacity(0.4)),
                  ),
                  child: Icon(icon,
                      color: AppTheme.volt, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(addOn.name, style: AppTheme.title(16)),
                      Text(addOn.tagline, style: AppTheme.body(12.5)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(DemoData.inr(addOn.price),
                        style: AppTheme.display(19,
                            color: AppTheme.volt)),
                    Text(addOn.period, style: AppTheme.body(11)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(addOn.blurb,
                style: AppTheme.body(13, height: 1.5)),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    '${addOn.interested} members flagged',
                    style: AppTheme.mono(10.5,
                        color: AppTheme.success),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: interestedNames
                          .map((m) => Padding(
                                padding:
                                    const EdgeInsets.only(right: 6),
                                child: MemberAvatar(
                                  initials: m.initials,
                                  size: 30,
                                  accent: AppTheme.volt,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
