class Payment {
  final int meetingId;
  final String paymentUrl;

  Payment({
    required this.meetingId,
    required this.paymentUrl,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      meetingId: json['meeting_id'],
      paymentUrl: json['payment_url'],
    );
  }
}
