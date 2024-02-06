import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wakey_wakey/widgets/ip_address_text_field.dart';
 // Adjust the import path accordingly

void main() {
  testWidgets('IPAddressTextField widget test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IPAddressTextField(
            ipAddress: '192.168.1.1',
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
    await tester.enterText(textFieldFinder, '192.168.1.2');

    // Verify the entered text
    expect(find.text('192.168.1.2'), findsOneWidget);

    // Verify the input formatters
    final textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.inputFormatters, hasLength(3));
    expect(textField.inputFormatters?[0], isA<TextInputFormatter>());
    expect(textField.inputFormatters?[1], isA<LengthLimitingTextInputFormatter>());


    // Verify the decoration
    final decoration = textField.decoration as InputDecoration;
    expect(decoration.labelText, 'IP Address');
    expect(decoration.errorText, null); // Change null if you expect an error message
    
  });
}
