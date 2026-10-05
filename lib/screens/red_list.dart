import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/demo_data.dart';
import '../widgets/ui.dart';

/// Screen 1 from the reel: the No-Show Red List.
/// "Members jo 10+ din se nahi aaye — inhe aaj hi call karo."
class RedListScreen extends StatefulWidget {
  const RedListScreen({super.key});

  @override
  State<RedListScreen> createState() => _RedListScreenState();
}

class _RedListScreenState extends State<RedListScreen> {
  @override
  Widget build(BuildContext context) {
    final list = DemoData.redList;
    final contacted =
        list.where((m) => m.contacted).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('SCREEN 01 · RETENTION RADAR', style: AppTheme.mono(11, color: AppTheme.danger)),
        const SizedBox(height: 6),
        Text('No-show\nred list.', style: AppTheme.display(34)),
        const SizedBox(height: 8),
        Text(
          'Members who vanished 10+ days ago. The owner only notices when fees stop renewing — you notice today.',
          style: AppTheme.body(13.5, height: 1.5),
        ),
        const SizedBox(height: 18),

        // Revenue at risk banner
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.danger.withOpacity(0.22),
                AppTheme.danger.withOpacity(0.06),
              ],
            ),
            border: Border.all(color: AppTheme.danger.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppTheme.danger, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DemoData.inr(DemoData.revenueAtRisk),
                        style: AppTheme.display(26, color: AppTheme.danger)),
                    Text('monthly revenue about to walk out the door',
                        style: AppTheme.body(12.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Progress
        GlassCard(
          blur: false,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Outreach today',
                        style: AppTheme.body(12.5, weight: FontWeight.w600, color: AppTheme.textPrimary)),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: list.isEmpty ? 0 : contacted / list.length,
                        minHeight: 7,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.volt),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Text('$contacted/${list.length}',
                  style: AppTheme.title(15, color: AppTheme.volt)),
            ],
          ),
        ),
        const SizedBox(height: 18),

        SectionHeader(
          title: 'Who to call today',
          subtitle: 'Longest absent first',
        ),
        const SizedBox(height: 12),
        ...list.map((m) => _RedRow(
              member: m,
              onContacted: () => setState(() => m.contacted = true),
            )),
      ],
    );
  }
}

class _RedRow extends StatelessWidget {
  const _RedRow({required this.member, required this.onContacted});

  final Member member;
  final VoidCallback onContacted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        blur: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MemberAvatar(
                    initials: member.initials, accent: AppTheme.danger),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.name, style: AppTheme.title(15)),
                      const SizedBox(height: 2),
                      Text(
                        '${member.plan} · ${DemoData.inr(member.monthlyFee)}/mo · ${member.totalVisits} visits',
                        style: AppTheme.body(12),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${member.daysAbsent}d',
                        style: AppTheme.display(20,
                            color: AppTheme.danger)),
                    Text('absent', style: AppTheme.body(11)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                RiskBadge(label: member.riskLabel),
                const Spacer(),
                if (member.contacted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.success.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_rounded,
                            color: AppTheme.success, size: 16),
                        const SizedBox(width: 6),
                        Text('Reached out',
                            style: AppTheme.body(13,
                                color: AppTheme.success,
                                weight: FontWeight.w600)),
                      ],
                    ),
                  )
                else ...[
                  _ActionBtn(
                    label: 'Call',
                    icon: Icons.call_rounded,
                    primary: true,
                    onTap: () {
                      onContacted();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Calling ${member.name}… marked as contacted.')),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _ActionBtn(
                    label: 'WhatsApp',
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () {
                      onContacted();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Win-back message sent to ${member.name}.')),
                      );
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: primary ? AppTheme.volt : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primary
                ? Colors.transparent
                : Colors.white.withOpacity(0.14),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 15,
                color: primary ? AppTheme.bgDeep : AppTheme.textPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTheme.body(13,
                  weight: FontWeight.w700,
                  color:
                      primary ? AppTheme.bgDeep : AppTheme.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
