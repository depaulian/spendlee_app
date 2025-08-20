import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expense_tracker/main.dart';

// Mock class for Firebase
class MockFirebaseCore extends Mock implements Firebase {}

void main() {
  setUpAll(() async {
    // Ensures the test environment is set up before running any tests
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock Firebase platform initialization to avoid actual channel usage
    setupFirebaseMocks();
  });

  testWidgets('App initializes and shows CircularProgressIndicator', (WidgetTester tester) async {
    // Create the App widget

  });

}

// Setup mock for Firebase core
void setupFirebaseMocks() {
  const MethodChannel channel = MethodChannel('plugins.flutter.io/firebase_core');

  // Intercept method channel calls for Firebase initialization
  TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger.setMockMethodCallHandler(
    channel,
        (MethodCall methodCall) async {
      if (methodCall.method == 'Firebase#initializeCore') {
        return {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': 'FAKE_API_KEY',
            'appId': 'FAKE_APP_ID',
            'messagingSenderId': 'FAKE_MESSAGING_SENDER_ID',
            'projectId': 'FAKE_PROJECT_ID',
          },
          'pluginConstants': {},
        };
      }
      return null;
    },
  );
}