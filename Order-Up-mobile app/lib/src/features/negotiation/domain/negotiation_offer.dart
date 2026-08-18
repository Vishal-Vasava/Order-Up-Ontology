class NegotiationOffer {
  const NegotiationOffer({
    required this.offerId,
    required this.storeName,
    required this.subtotal,
    required this.offeredPercent,
    required this.discountAmount,
    required this.offeredTotal,
    required this.expiresAt,
    required this.eligible,
    this.reason,
  });

  factory NegotiationOffer.fromJson(Map<String, dynamic> json) {
    double number(dynamic value) => (value as num?)?.toDouble() ?? 0;
    return NegotiationOffer(
      offerId: json['offerId']?.toString() ?? '',
      storeName: json['storeName']?.toString() ?? 'Store',
      subtotal: number(json['subtotal']),
      offeredPercent: number(json['offeredPercent']),
      discountAmount: number(json['discountAmount']),
      offeredTotal: number(json['offeredTotal']),
      expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? ''),
      eligible: json['eligible'] == true,
      reason: json['reason']?.toString(),
    );
  }

  final String offerId;
  final String storeName;
  final double subtotal;
  final double offeredPercent;
  final double discountAmount;
  final double offeredTotal;
  final DateTime? expiresAt;
  final bool eligible;
  final String? reason;
}
