/// Seeded demo data for the RetainFit pitch demo.
/// Dates are relative to "today" so the demo always looks alive.

class Member {
  Member({
    required this.id,
    required this.name,
    required this.plan,
    required this.monthlyFee,
    required this.daysAbsent, // days since last check-in
    required this.membershipEndsInDays, // negative = expired
    required this.streak,
    required this.totalVisits,
    required this.addOns,
    this.contacted = false,
    this.reminderSent = false,
  });

  final String id;
  final String name;
  final String plan;
  final int monthlyFee;
  final int daysAbsent;
  final int membershipEndsInDays;
  final int streak;
  final int totalVisits;
  final List<String> addOns;
  bool contacted;
  bool reminderSent;

  String get initials =>
      name.split(' ').map((p) => p.isEmpty ? '' : p[0]).take(2).join();

  bool get isAtRisk => daysAbsent >= 10;
  bool get expiringSoon => membershipEndsInDays <= 7;

  String get riskLabel {
    if (daysAbsent >= 21) return 'CRITICAL';
    if (daysAbsent >= 14) return 'HIGH';
    return 'WATCH';
  }
}

class AddOn {
  const AddOn({
    required this.name,
    required this.tagline,
    required this.price,
    required this.period,
    required this.icon,
    required this.blurb,
    required this.interested,
  });

  final String name;
  final String tagline;
  final int price;
  final String period;
  final String icon; // emoji-free: we render via _iconFor key
  final String blurb;
  final int interested; // members flagged as interested
}

class DemoData {
  static final List<Member> members = [
    Member(id: 'm01', name: 'Arjun Mehta', plan: 'Annual Pro', monthlyFee: 2500, daysAbsent: 26, membershipEndsInDays: 34, streak: 0, totalVisits: 142, addOns: ['PT Pack', 'Protein']),
    Member(id: 'm02', name: 'Priya Sharma', plan: 'Quarterly', monthlyFee: 3000, daysAbsent: 22, membershipEndsInDays: 12, streak: 0, totalVisits: 96, addOns: ['Diet Plan']),
    Member(id: 'm03', name: 'Rohan Verma', plan: 'Monthly', monthlyFee: 1500, daysAbsent: 19, membershipEndsInDays: 6, streak: 0, totalVisits: 41, addOns: ['Protein']),
    Member(id: 'm04', name: 'Sneha Iyer', plan: 'Half-Yearly', monthlyFee: 2200, daysAbsent: 17, membershipEndsInDays: 58, streak: 0, totalVisits: 120, addOns: ['PT Pack']),
    Member(id: 'm05', name: 'Vikram Singh', plan: 'Annual', monthlyFee: 2000, daysAbsent: 15, membershipEndsInDays: 90, streak: 0, totalVisits: 210, addOns: ['Diet Plan', 'Protein']),
    Member(id: 'm06', name: 'Ananya Rao', plan: 'Monthly', monthlyFee: 1500, daysAbsent: 13, membershipEndsInDays: 4, streak: 0, totalVisits: 28, addOns: ['PT Pack']),
    Member(id: 'm07', name: 'Karan Patel', plan: 'Quarterly', monthlyFee: 2800, daysAbsent: 12, membershipEndsInDays: 20, streak: 0, totalVisits: 77, addOns: ['Protein']),
    Member(id: 'm08', name: 'Divya Nair', plan: 'Monthly', monthlyFee: 1500, daysAbsent: 11, membershipEndsInDays: 9, streak: 0, totalVisits: 33, addOns: ['Diet Plan']),
    Member(id: 'm09', name: 'Aditya Khan', plan: 'Annual Pro', monthlyFee: 2500, daysAbsent: 2, membershipEndsInDays: 120, streak: 9, totalVisits: 188, addOns: ['Protein']),
    Member(id: 'm10', name: 'Meera Joshi', plan: 'Quarterly', monthlyFee: 3000, daysAbsent: 1, membershipEndsInDays: 45, streak: 14, totalVisits: 132, addOns: ['PT Pack', 'Diet Plan']),
    Member(id: 'm11', name: 'Nikhil Bose', plan: 'Monthly', monthlyFee: 1500, daysAbsent: 0, membershipEndsInDays: 16, streak: 21, totalVisits: 64, addOns: []),
    Member(id: 'm12', name: 'Pooja Reddy', plan: 'Half-Yearly', monthlyFee: 2200, daysAbsent: 3, membershipEndsInDays: 70, streak: 6, totalVisits: 98, addOns: ['Diet Plan']),
    Member(id: 'm13', name: 'Sahil Malhotra', plan: 'Monthly', monthlyFee: 1500, daysAbsent: 5, membershipEndsInDays: 2, streak: 3, totalVisits: 22, addOns: ['Protein']),
    Member(id: 'm14', name: 'Ritu Chauhan', plan: 'Quarterly', monthlyFee: 2800, daysAbsent: 0, membershipEndsInDays: 52, streak: 11, totalVisits: 84, addOns: ['PT Pack']),
    Member(id: 'm15', name: 'Farhan Ali', plan: 'Annual', monthlyFee: 2000, daysAbsent: 8, membershipEndsInDays: 5, streak: 0, totalVisits: 156, addOns: ['Diet Plan', 'Protein']),
    Member(id: 'm16', name: 'Kavya Menon', plan: 'Monthly', monthlyFee: 1500, daysAbsent: 4, membershipEndsInDays: 11, streak: 4, totalVisits: 37, addOns: []),
    Member(id: 'm17', name: 'Dev Patel', plan: 'Quarterly', monthlyFee: 3000, daysAbsent: 6, membershipEndsInDays: 1, streak: 2, totalVisits: 71, addOns: ['PT Pack', 'Protein']),
    Member(id: 'm18', name: 'Ishita Das', plan: 'Half-Yearly', monthlyFee: 2200, daysAbsent: 9, membershipEndsInDays: 30, streak: 0, totalVisits: 109, addOns: ['Diet Plan']),
  ];

  static const List<AddOn> addOns = [
    AddOn(
      name: 'PT Pack',
      tagline: '1-on-1 personal training',
      price: 5000,
      period: '/month',
      icon: 'pt',
      blurb: 'Members with a trainer show 3x better retention. Flagged for members who plateaued.',
      interested: 6,
    ),
    AddOn(
      name: 'Diet Plan',
      tagline: 'Custom nutrition coaching',
      price: 2000,
      period: '/month',
      blurb: 'Pairs with every transformation goal. Highest margin add-on in the club.',
      icon: 'diet',
      interested: 7,
    ),
    AddOn(
      name: 'Protein',
      tagline: 'In-house supplement store',
      price: 2800,
      period: '/jar',
      blurb: 'Catch them at the counter after leg day. Zero extra effort, pure margin.',
      icon: 'protein',
      interested: 8,
    ),
  ];

  static List<Member> get redList =>
      members.where((m) => m.isAtRisk).toList()
        ..sort((a, b) => b.daysAbsent.compareTo(a.daysAbsent));

  static List<Member> get expiring =>
      members.where((m) => m.expiringSoon).toList()
        ..sort((a, b) => a.membershipEndsInDays.compareTo(b.membershipEndsInDays));

  static int get revenueAtRisk =>
      redList.fold(0, (sum, m) => sum + m.monthlyFee);

  static int get renewalRevenueAtStake =>
      expiring.fold(0, (sum, m) => sum + m.monthlyFee);

  static String inr(int n) {
    final s = n.toString();
    if (s.length <= 3) return '₹$s';
    final last3 = s.substring(s.length - 3);
    var rest = s.substring(0, s.length - 3);
    final parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);
    return '₹${parts.join(',')},$last3';
  }
}
