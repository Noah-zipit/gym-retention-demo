import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme.dart';

/// Frosted glass card. BackdropFilter is used sparingly (headers, hero stats)
/// to keep the frame budget healthy on the web build.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.blur = true,
    this.borderColor,
    this.background,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool blur;
  final Color? borderColor;
  final Color? background;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? AppTheme.card.withOpacity(0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor ?? AppTheme.cardEdge,
          width: 1,
        ),
      ),
      child: child,
    );

    final content = blur
        ? ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: card,
            ),
          )
        : card;

    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }
}

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    super.key,
    required this.initials,
    this.size = 48,
    this.accent,
  });

  final String initials;
  final double size;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final a = accent ?? AppTheme.volt;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [a.withOpacity(0.35), AppTheme.surface],
        ),
        border: Border.all(color: a.withOpacity(0.5), width: 1.2),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTheme.title(size * 0.34, color: AppTheme.textPrimary),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.title(17)),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(subtitle!, style: AppTheme.body(12.5)),
                ),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class RiskBadge extends StatelessWidget {
  const RiskBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final Color c;
    switch (label) {
      case 'CRITICAL':
        c = AppTheme.danger;
        break;
      case 'HIGH':
        c = AppTheme.warning;
        break;
      default:
        c = AppTheme.info;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withOpacity(0.45)),
      ),
      child: Text(
        label,
        style: AppTheme.mono(10, color: c),
      ),
    );
  }
}
