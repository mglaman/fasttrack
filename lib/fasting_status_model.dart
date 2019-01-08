// @todo needs test coverage
class FastingStatus {
  FastingStatus(this._fastStartHour, this._fastStartMinute, this._fastEndHour, this._fastEndMinute);
  DateTime _dateTime = new DateTime.now();
  final int _fastStartHour;
  final int _fastStartMinute;
  final int _fastEndHour;
  final int _fastEndMinute;

  DateTime get dateTime => _dateTime;
  DateTime get fastStart => new DateTime(
      _dateTime.year,
      _dateTime.month,
      _dateTime.day,
      _fastStartHour,
      _fastStartMinute
  );
  DateTime get fastEnd => new DateTime(
      _dateTime.year,
      _dateTime.month,
      _dateTime.day,
      _fastEndHour,
      _fastEndMinute
  );

  tick() => _dateTime = new DateTime.now();
  isFasting() {
    if (_dateTime.isAfter(fastStart)) {
      return true;
    }
    if (dateTime.isBefore(fastEnd)) {
      return true;
    }

    return false;
  }

  // @todo this specifically needs coverage.
  Duration get timeUntilFastStarts => fastStart.difference(_dateTime);
  // @todo this specifically needs coverage.
  Duration get timeUntilFastEnds {
    if (_dateTime.hour < 12) {
      return fastEnd.difference(_dateTime);
    }
    return fastEnd.add(Duration(days: 1)).difference(_dateTime);

  }
}