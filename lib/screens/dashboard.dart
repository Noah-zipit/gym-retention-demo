import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/demo_data.dart';
import '../widgets/ui.dart';
import '../widgets/hero_art.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onGoRedList});

  final VoidCallback onGoRedList;

  @override
  Widget build(BuildContext context) {
    final redList = DemoData.redList;
    final expiring = DemoData.expiring;
    final checkInsToday = DemoData.members.where((m) => m.daysAbsent <= 1).length;
    final total = DemoData.members.length;
    final atRisk = redList.length;
    final retention = ((total - atRisk) / total * 100).round();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        // Greeting
        Text('IRON PARADISE GYM', style: AppTheme.mono(11, color: AppTheme.volt)),
        const SizedBox(height: 6),
        Text('Good evening,\nCoach.', style: AppTheme.display(34)),
        const SizedBox(height: 18),

        // Hero: prebuilt image + animated art + glass stat
        _HeroCard(retention: retention, checkInsToday: checkInsToday),
        const SizedBox(height: 16),

        // Stat row
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Revenue at risk',
                value: DemoData.inr(DemoData.revenueAtRisk),
                sub: '$atRisk members slipping',
                accent: AppTheme.danger,
                icon: Icons.trending_down_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Renewals due',
                value: '${expiring.length}',
                sub: '${DemoData.inr(DemoData.renewalRevenueAtStake)} at stake',
                accent: AppTheme.warning,
                icon: Icons.autorenew_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        SectionHeader(
          title: 'Call today',
          subtitle: 'Longest-absent members first',
          action: TextButton(
            onPressed: onGoRedList,
            child: Text('Red list',
                style: AppTheme.body(13,
                    color: AppTheme.volt, weight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 12),
        ...redList.take(3).map((m) => _CallRow(member: m)),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.retention, required this.checkInsToday});

  final int retention;
  final int checkInsToday;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          // Prebuilt gym photography
          Image.network(
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1200&auto=format&fit=crop',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 250,
              color: AppTheme.surface,
            ),
          ),
          // Animated code-built energy layer
          const Positioned.fill(
            child: HeroArt(height: 250),
          ),
          // Dark gradient for legibility
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.bgDeep.withOpacity(0.55),
                    AppTheme.bgDeep.withOpacity(0.92),
                  ],
                  stops: const [0.25, 0.62, 1.0],
                ),
              ),
            ),
          ),
          // Glass stat overlay
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  _Ring(retention: retention),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Retention score',
                            style: AppTheme.body(12, color: AppTheme.textSecondary)),
                        const SizedBox(height: 2),
                        Text('$retention% holding strong',
                            style: AppTheme.title(16)),
                        const SizedBox(height: 6),
                        Text('$checkInsToday check-ins today',
                            style: AppTheme.body(12.5, color: AppTheme.volt)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.retention});

  final int retention;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: retention / 100,
              strokeWidth: 7,
              backgroundColor: Colors.white12,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.volt),
            ),
          ),
          Text('$retention',
              style: AppTheme.title(16, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.accent,
    required this.icon,
  });

  final String label;
  final String value;
  final String sub;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      blur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTheme.display(21)),
          const SizedBox(height: 4),
          Text(label, style: AppTheme.body(12.5, weight: FontWeight.w600, color: AppTheme.textPrimary)),
          Text(sub, style: AppTheme.body(11.5)),
        ],
      ),
    );
  }
}

class _CallRow extends StatelessWidget {
  const _CallRow({required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        blur: false,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            MemberAvatar(initials: member.initials, accent: AppTheme.danger),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name, style: AppTheme.title(14.5)),
                  Text('${member.daysAbsent} days absent · ${member.plan}',
                      style: AppTheme.body(12)),
                ],
              ),
            ),
            RiskBadge(label: member.riskLabel),
          ],
        ),
      ),
    );
  }
}
