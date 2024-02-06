import 'package:flutter_test/flutter_test.dart';
import 'package:wakey_wakey/imports.dart';
// Adjust the import path accordingly

void main() {
  testWidgets('MacAddressTextField widget test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MacAddressTextField(
            macAddress: 'AA:BB:CC:DD:EE:FF',
            onChanged: (value) {
              // Add your onChanged callback test logic here if needed
            },
            errorText: null,
          ),
        ),
      ),
    );

    // Find the TextField widget
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    // Enter text into the TextField
    await tester.enterText(textFieldFinder, 'AA:BB:CC:DD:EE:FF');

    // Verify the entered text
    expect(find.text('AA:BB:CC:DD:EE:FF'), findsOneWidget);

    // Verify the input formatters
    final textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.inputFormatters, hasLength(3));
    expect(textField.inputFormatters![0], isA<TextInputFormatter>());
    expect(textField.inputFormatters![1], isA<LengthLimitingTextInputFormatter>());

    // Verify the decoration
    final decoration = textField.decoration as InputDecoration;
    expect(decoration.labelText, 'MAC Address');
    expect(decoration.errorText, null); // Change null if you expect an error message

    // Verify the initial value of the TextField
    expect(find.text('AA:BB:CC:DD:EE:FF'), findsOneWidget);
  });
}
