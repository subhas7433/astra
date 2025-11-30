/// Represents the 12 zodiac signs used in horoscope predictions.
///
/// Each sign has English and Hindi names, date ranges, and icons.
enum ZodiacSign {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces;

  /// Convert to string for Appwrite storage.
  String get value => name;

  /// English display name (capitalized).
  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }

  /// Hindi name for the zodiac sign.
  String get hindiName {
    return switch (this) {
      ZodiacSign.aries => 'Mesh',
      ZodiacSign.taurus => 'Vrishabh',
      ZodiacSign.gemini => 'Mithun',
      ZodiacSign.cancer => 'Kark',
      ZodiacSign.leo => 'Singh',
      ZodiacSign.virgo => 'Kanya',
      ZodiacSign.libra => 'Tula',
      ZodiacSign.scorpio => 'Vrishchik',
      ZodiacSign.sagittarius => 'Dhanu',
      ZodiacSign.capricorn => 'Makar',
      ZodiacSign.aquarius => 'Kumbh',
      ZodiacSign.pisces => 'Meen',
    };
  }

  /// Symbol for the zodiac sign.
  String get symbol {
    return switch (this) {
      ZodiacSign.aries => 'Ram',
      ZodiacSign.taurus => 'Bull',
      ZodiacSign.gemini => 'Twins',
      ZodiacSign.cancer => 'Crab',
      ZodiacSign.leo => 'Lion',
      ZodiacSign.virgo => 'Virgin',
      ZodiacSign.libra => 'Scales',
      ZodiacSign.scorpio => 'Scorpion',
      ZodiacSign.sagittarius => 'Archer',
      ZodiacSign.capricorn => 'Goat',
      ZodiacSign.aquarius => 'Water-bearer',
      ZodiacSign.pisces => 'Fish',
    };
  }

  /// Element associated with this zodiac sign.
  String get element {
    return switch (this) {
      ZodiacSign.aries || ZodiacSign.leo || ZodiacSign.sagittarius => 'Fire',
      ZodiacSign.taurus || ZodiacSign.virgo || ZodiacSign.capricorn => 'Earth',
      ZodiacSign.gemini || ZodiacSign.libra || ZodiacSign.aquarius => 'Air',
      ZodiacSign.cancer || ZodiacSign.scorpio || ZodiacSign.pisces => 'Water',
    };
  }

  /// Date range start (month, day).
  (int month, int day) get startDate {
    return switch (this) {
      ZodiacSign.aries => (3, 21),
      ZodiacSign.taurus => (4, 20),
      ZodiacSign.gemini => (5, 21),
      ZodiacSign.cancer => (6, 21),
      ZodiacSign.leo => (7, 23),
      ZodiacSign.virgo => (8, 23),
      ZodiacSign.libra => (9, 23),
      ZodiacSign.scorpio => (10, 23),
      ZodiacSign.sagittarius => (11, 22),
      ZodiacSign.capricorn => (12, 22),
      ZodiacSign.aquarius => (1, 20),
      ZodiacSign.pisces => (2, 19),
    };
  }

  /// Date range end (month, day).
  (int month, int day) get endDate {
    return switch (this) {
      ZodiacSign.aries => (4, 19),
      ZodiacSign.taurus => (5, 20),
      ZodiacSign.gemini => (6, 20),
      ZodiacSign.cancer => (7, 22),
      ZodiacSign.leo => (8, 22),
      ZodiacSign.virgo => (9, 22),
      ZodiacSign.libra => (10, 22),
      ZodiacSign.scorpio => (11, 21),
      ZodiacSign.sagittarius => (12, 21),
      ZodiacSign.capricorn => (1, 19),
      ZodiacSign.aquarius => (2, 18),
      ZodiacSign.pisces => (3, 20),
    };
  }

  /// Asset path for zodiac icon.
  String get iconPath => 'assets/icons/zodiac/${name}_zodiac.svg';

  /// Parse from Appwrite string value.
  /// Returns null if no match found.
  static ZodiacSign? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return ZodiacSign.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }

  /// Get zodiac sign from date of birth.
  static ZodiacSign fromDate(DateTime date) {
    final month = date.month;
    final day = date.day;

    for (final sign in ZodiacSign.values) {
      final (startMonth, startDay) = sign.startDate;
      final (endMonth, endDay) = sign.endDate;

      // Handle signs that cross year boundary (Capricorn)
      if (startMonth > endMonth) {
        if ((month == startMonth && day >= startDay) ||
            (month == endMonth && day <= endDay)) {
          return sign;
        }
      } else {
        if ((month == startMonth && day >= startDay) ||
            (month == endMonth && day <= endDay) ||
            (month > startMonth && month < endMonth)) {
          return sign;
        }
      }
    }

    // Default fallback (should not reach here)
    return ZodiacSign.aries;
  }
}
