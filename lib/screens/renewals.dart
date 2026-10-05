import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/demo_data.dart';
import '../widgets/ui.dart';

/// Screen 3 from the reel: auto renewal.
/// "Expiry se 7 din pehle auto-reminder + one-tap payment. No manual follow-up."
class RenewalsScreen extends StatefulWidget {
  const RenewalsScreen({super.key});

  @override
  State<RenewalsScreen> createState() => _RenewalsScreenState();
}

class _RenewalsScreenState extends State<RenewalsScreen> {
  @override
  Widget build(BuildContext context) {
    final list = DemoData.expiring;
    final sent = list.where((m) => m.reminderSent).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('SCREEN 03 · ZERO-CHASE RENEWALS',
            style: AppTheme.mono(11, color: AppTheme.warning)),
        const SizedBox(height: 6),
        Text('Renewals\non autopilot.', style: AppTheme.display(34)),
        const SizedBox(height: 8),
        Text(
          'Seven days before expiry the member gets a payment link automatically. You stop chasing fees — the app does it.',
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
                AppTheme.warning.withOpacity(0.20),
                AppTheme.warning.withOpacity(0.05),
              ],
            ),
            border:
                Border.all(color: AppTheme.warning.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.autorenew_rounded,
                  color: AppTheme.warning, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DemoData.inr(DemoData.renewalRevenueAtStake),
                        style: AppTheme.display(26,
                            color: AppTheme.warning)),
                    Text('in renewals due within 7 days',
                        style: AppTheme.body(12.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

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
                    Text('Payment links sent',
                        style: AppTheme.body(12.5,
                            weight: FontWeight.w600,
                            color: AppTheme.textPrimary)),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value:
                            list.isEmpty ? 0 : sent / list.length,
                        minHeight: 7,
                        backgroundColor: Colors.white10,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                                AppTheme.volt),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Text('$sent/${list.length}',
                  style: AppTheme.title(15, color: AppTheme.volt)),
            ],
          ),
        ),
        const SizedBox(height: 18),

        SectionHeader(
          title: 'Expiring soon',
          subtitle: 'One tap sends the payment link',
        ),
        const SizedBox(height: 12),
        ...list.map((m) => _RenewRow(
              member: m,
              onSend: () => setState(() => m.reminderSent = true),
            )),
      ],
    );
  }
}

class _RenewRow extends StatelessWidget {
  const _RenewRow({required this.member, required this.onSend});

  final Member member;
  final VoidCallback onSend;

  Color get _urgency {
    if (member.membershipEndsInDays <= 2) return AppTheme.danger;
    if (member.membershipEndsInDays <= 5) return AppTheme.warning;
    return AppTheme.info;
  }

  String get _label {
    final d = member.membershipEndsInDays;
    if (d <= 0) return 'Expired';
    if (d == 1) return 'Tomorrow';
    return 'In $d days';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        blur: false,
        child: Row(
          children: [
            MemberAvatar(initials: member.initials, accent: _urgency),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name, style: AppTheme.title(15)),
                  const SizedBox(height: 2),
                  Text(
                    '${member.plan} · ${DemoData.inr(member.monthlyFee)}/mo',
                    style: AppTheme.body(12),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: _urgency.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: _urgency.withOpacity(0.45)),
                    ),
                    child: Text(_label,
                        style:
                            AppTheme.mono(10, color: _urgency)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            member.reminderSent
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 9),
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
                            color: AppTheme.success, size: 15),
                        const SizedBox(width: 5),
                        Text('Link sent',
                            style: AppTheme.body(12.5,
                                color: AppTheme.success,
                                weight: FontWeight.w600)),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      onSend();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Payment link sent to ${member.name} — ${DemoData.inr(member.monthlyFee)} one-tap renew.'),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.volt,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt_rounded,
                              size: 15, color: AppTheme.bgDeep),
                          const SizedBox(width: 5),
                          Text('Send link',
                              style: AppTheme.body(13,
                                  weight: FontWeight.w700,
                                  color: AppTheme.bgDeep)),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
