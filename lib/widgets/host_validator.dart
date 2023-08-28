import '../imports.dart';

class HostValidator {
  static String? validateMacAddress(String macAddress) {
    if (macAddress.trim().replaceAll(":", "").length != 12) {
      return 'Provide a valid MAC address.';
    }
    return null;
  }

  static String? validateIpAddress(String ipAddress) {
    if (ipAddress.trim().isEmpty) {
      return 'IP and MAC addresses are required.';
    } else if (!isIPv4Address32Bit(ipAddress)) {
      return 'Please provide a valid 32-bit IP address.';
    }
    return null;
  }
}
