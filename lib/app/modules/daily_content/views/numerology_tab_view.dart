import 'package:flutter/material.dart';
import 'numerology_screen.dart';

/// Numerology tab wrapper that preserves state when switching tabs.
class NumerologyTabView extends StatefulWidget {
  const NumerologyTabView({super.key});

  @override
  State<NumerologyTabView> createState() => _NumerologyTabViewState();
}

class _NumerologyTabViewState extends State<NumerologyTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const NumerologyScreen();
  }
}
