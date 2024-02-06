import 'package:flutter_test/flutter_test.dart';
import 'package:wakey_wakey/widgets/host_validator.dart';

void main() {
  group('HostValidator', () {
    test('validateMacAddress', () {
      // Test case 1: Valid MAC address
      expect(HostValidator.validateMacAddress('AA:BB:CC:DD:EE:FF'), isNull);

      // Test case 2: Invalid MAC address
      expect(
          HostValidator.validateMacAddress('AA:BB:CC:DD'), equals('Provide a valid MAC address.'));
    });

    test('validateIpAddress', () {
      // Test case 1: Valid IP address
      expect(HostValidator.validateIpAddress('192.168.1.1'), isNull);

      // Test case 2: Empty IP address
      expect(HostValidator.validateIpAddress(''), equals('IP and MAC addresses are required.'));

      // Test case 3: Invalid IP address
      expect(HostValidator.validateIpAddress('300.168.1.1'),
          equals('Please provide a valid 32-bit IP address.'));
    });
  });
}
