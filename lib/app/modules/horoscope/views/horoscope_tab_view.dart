import 'package:flutter/material.dart';
import 'zodiac_picker_screen.dart';

/// Horoscope tab wrapper that preserves state when switching tabs.
class HoroscopeTabView extends StatefulWidget {
  const HoroscopeTabView({super.key});

  @override
  State<HoroscopeTabView> createState() => _HoroscopeTabViewState();
}

class _HoroscopeTabViewState extends State<HoroscopeTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const ZodiacPickerScreen();
  }
}
