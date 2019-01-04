class FastingStatus {
  DateTime _dateTime = new DateTime.now();
  int _fastStart = 20;
  int _fastEnd = 12;

  DateTime get dateTime => _dateTime;
  DateTime get fastStart => new DateTime(
      _dateTime.year,
      _dateTime.month,
      _dateTime.day,
      _fastStart
  );
  DateTime get fastEnd => new DateTime(
      _dateTime.year,
      _dateTime.month,
      _dateTime.day,
      _fastEnd
  );

  bool get isFasting => _dateTime.isAfter(fastStart) && dateTime.isBefore(fastEnd);
  Duration get timeUntilFastStarts => fastStart.difference(_dateTime);
  Duration get timeUntilFastEnds => fastEnd.difference(_dateTime);
}