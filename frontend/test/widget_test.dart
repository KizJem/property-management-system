import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/login.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  // Test 1: Verify login page widgets are rendered
  testWidgets('Login page renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Verify all required widgets are present
    expect(find.text('Login'), findsOneWidget); // AppBar title
    expect(find.byType(TextFormField), findsNWidgets(3)); // 3 input fields
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Student\'s Name'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget); // Login button
  });

  // Test 2: Validate form submission with empty fields
  testWidgets('Shows validation errors for empty fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Tap the login button without entering any text
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify error messages appear
    expect(find.text('Please enter username'), findsOneWidget);
    expect(find.text('Please enter password'), findsOneWidget);
    expect(find.text('Please enter your name'), findsOneWidget);
  });

  // Test 3: Test successful form submission (with mock client)
  testWidgets('Successful login navigation', (WidgetTester tester) async {
    // Create a mock client
    final client = MockClient();

    // Mock the response
    when(
      client.post(
        Uri.parse('http://localhost:3000/api/v1/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => http.Response(
        '{"token": "mock_token", "user": {"id": 1, "name": "Test User"}}',
        200,
      ),
    );

    // Build our app with mock client
    await tester.pumpWidget(
      MaterialApp(
        home: const LoginPage(),
        routes: {
          '/home': (context) =>
              const Scaffold(body: Center(child: Text('Home Screen'))),
        },
      ),
    );

    // Enter text in all fields
    await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.enterText(find.byType(TextFormField).at(2), 'Test User');

    // Tap the login button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Verify navigation to home screen
    expect(find.text('Home Screen'), findsOneWidget);
  });

  // Test 4: Test failed login (with mock client)
  testWidgets('Failed login shows error message', (WidgetTester tester) async {
    final client = MockClient();

    // Mock a failed response
    when(
      client.post(
        Uri.parse('http://localhost:3000/api/v1/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => http.Response('{"message": "Invalid credentials"}', 401),
    );

    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Enter text in all fields
    await tester.enterText(find.byType(TextFormField).at(0), 'wronguser');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');
    await tester.enterText(find.byType(TextFormField).at(2), 'Test User');

    // Tap the login button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Wait for the response

    // Verify error message appears
    expect(
      find.text('Login failed: {"message": "Invalid credentials"}'),
      findsOneWidget,
    );
  });
}
