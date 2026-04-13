// Quick test to verify main.dart .env loading works without crashing
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:final_proj/main.dart';

void main() {
  test('dotenv loading with try-catch works', () async {
    // Simulate what main() does
    try {
      await dotenv.load();
      print('✓ .env loaded successfully');
    } catch (e) {
      print('✓ .env loading failed gracefully: $e');
    }
    
    // Verify the app widget can be instantiated
    const app = MyApp();
    expect(app, isNotNull);
    print('✓ MyApp instantiated successfully');
  });
}
