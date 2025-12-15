class UserApplyLeaveHelper {
  /// yyyy-MM-dd
  static String formatDateForApi(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  /// dd/MM/yyyy
  static String formatDateForUi(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  /// 🔹 Calculate days BETWEEN start & end
  static num calculateDaysBetween({
    required DateTime start,
    required DateTime end,
    required bool isHalfDay,
  }) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);

    if (isHalfDay) return 0.5;

    final diff = e.difference(s).inDays;

    // Same day full leave = 1 day
    return diff;
  }


  /// 🔹 Validate days vs date range
  static String? validateDateAndDays({
    required DateTime? start,
    required DateTime? end,
    required double enteredDays,
    required bool isHalfDay,
  }) {
    if (start == null || end == null) {
      return 'Please select start and end date';
    }

    if (end.isBefore(start)) {
      return 'End date cannot be before start date';
    }

    /// HALF DAY LOGIC
    if (isHalfDay) {
      if (!_isSameDay(start, end)) {
        return 'Half day leave must be for a single day';
      }
      if (enteredDays != 0.5) {
        return 'Half day leave must be 0.5 day';
      }
      return null;
    }

    /// FULL DAY LOGIC
    final calculated = calculateDaysBetween(
      start: start,
      end: end,
      isHalfDay: false,
    );

    if (enteredDays != calculated) {
      return 'Selected date range gives $calculated day(s), '
          'but entered $enteredDays';
    }

    return null;
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}
