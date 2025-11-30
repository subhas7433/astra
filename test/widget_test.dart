// Basic widget test for Astro GPT app

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:astra/main.dart';

void main() {
  setUpAll(() async {
    // Load test environment
    TestWidgetsFlutterBinding.ensureInitialized();
    dotenv.testLoad(fileInput: '''
APP_NAME=Astro GPT
APP_ENV=test
DEBUG=true
''');
  });

  testWidgets('App renders placeholder screen', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const AstroGptApp());

    // Verify placeholder screen displays
    expect(find.text('Astro GPT'), findsOneWidget);
    expect(find.text('Foundation Ready'), findsOneWidget);
    expect(find.text('Session 2 Complete'), findsOneWidget);
  });
}
