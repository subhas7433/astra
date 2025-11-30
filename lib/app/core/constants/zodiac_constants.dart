class ZodiacSign {
  final String id;
  final String name;
  final String nameHindi;
  final String symbol;
  final String icon;
  final String dateRange;
  final String element;

  const ZodiacSign({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.symbol,
    required this.icon,
    required this.dateRange,
    required this.element,
  });
}

class ZodiacConstants {
  static const List<ZodiacSign> signs = [
    ZodiacSign(
      id: 'aries',
      name: 'Aries',
      nameHindi: 'मेष',
      symbol: '♈️',
      icon: 'assets/icons/zodiac/aries.svg',
      dateRange: 'Mar 21 - Apr 19',
      element: 'Fire',
    ),
    ZodiacSign(
      id: 'taurus',
      name: 'Taurus',
      nameHindi: 'वृषभ',
      symbol: '♉️',
      icon: 'assets/icons/zodiac/taurus.svg',
      dateRange: 'Apr 20 - May 20',
      element: 'Earth',
    ),
    ZodiacSign(
      id: 'gemini',
      name: 'Gemini',
      nameHindi: 'मिथुन',
      symbol: '♊️',
      icon: 'assets/icons/zodiac/gemini.svg',
      dateRange: 'May 21 - Jun 20',
      element: 'Air',
    ),
    ZodiacSign(
      id: 'cancer',
      name: 'Cancer',
      nameHindi: 'कर्क',
      symbol: '♋️',
      icon: 'assets/icons/zodiac/cancer.svg',
      dateRange: 'Jun 21 - Jul 22',
      element: 'Water',
    ),
    ZodiacSign(
      id: 'leo',
      name: 'Leo',
      nameHindi: 'सिंह',
      symbol: '♌️',
      icon: 'assets/icons/zodiac/leo.svg',
      dateRange: 'Jul 23 - Aug 22',
      element: 'Fire',
    ),
    ZodiacSign(
      id: 'virgo',
      name: 'Virgo',
      nameHindi: 'कन्या',
      symbol: '♍️',
      icon: 'assets/icons/zodiac/virgo.svg',
      dateRange: 'Aug 23 - Sep 22',
      element: 'Earth',
    ),
    ZodiacSign(
      id: 'libra',
      name: 'Libra',
      nameHindi: 'तुला',
      symbol: '♎️',
      icon: 'assets/icons/zodiac/libra.svg',
      dateRange: 'Sep 23 - Oct 22',
      element: 'Air',
    ),
    ZodiacSign(
      id: 'scorpio',
      name: 'Scorpio',
      nameHindi: 'वृश्चिक',
      symbol: '♏️',
      icon: 'assets/icons/zodiac/scorpio.svg',
      dateRange: 'Oct 23 - Nov 21',
      element: 'Water',
    ),
    ZodiacSign(
      id: 'sagittarius',
      name: 'Sagittarius',
      nameHindi: 'धनु',
      symbol: '♐️',
      icon: 'assets/icons/zodiac/sagittarius.svg',
      dateRange: 'Nov 22 - Dec 21',
      element: 'Fire',
    ),
    ZodiacSign(
      id: 'capricorn',
      name: 'Capricorn',
      nameHindi: 'मकर',
      symbol: '♑️',
      icon: 'assets/icons/zodiac/capricorn.svg',
      dateRange: 'Dec 22 - Jan 19',
      element: 'Earth',
    ),
    ZodiacSign(
      id: 'aquarius',
      name: 'Aquarius',
      nameHindi: 'कुंभ',
      symbol: '♒️',
      icon: 'assets/icons/zodiac/aquarius.svg',
      dateRange: 'Jan 20 - Feb 18',
      element: 'Air',
    ),
    ZodiacSign(
      id: 'pisces',
      name: 'Pisces',
      nameHindi: 'मीन',
      symbol: '♓️',
      icon: 'assets/icons/zodiac/pisces.svg',
      dateRange: 'Feb 19 - Mar 20',
      element: 'Water',
    ),
  ];
}
