bool isApplicationLate({
  required DateTime submittedAt,
  required DateTime now,
}) {
  final difference = now.difference(submittedAt);

  return difference.inDays >= 7;
}