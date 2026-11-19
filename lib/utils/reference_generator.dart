String generateReferenceNumber({
  int? year,
  required int sequence,
}) {
  final currentYear = year ?? DateTime.now().year;

  final sequenceText = sequence.toString().padLeft(4, '0');

  return 'FS-$currentYear-$sequenceText';
}