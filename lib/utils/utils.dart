import 'dart:io';
import '../imports.dart';
import '../models/hosts.dart';

void sendMagicPacket(String macAddress, String ipAddress) {
  final List<int> macBytes = macAddress.split(':').map((e) => int.parse(e, radix: 16)).toList();
  final List<int> packet = [];

  // Add 6 bytes with a value of 0xFF as the packet's initial part
  for (int i = 0; i < 6; i++) {
    packet.add(0xFF);
  }

  // Repeat the MAC address in byte form 16 times
  for (int i = 0; i < 16; i++) {
    packet.addAll(macBytes);
  }

  // Create a UDP socket and send the packet to the broadcast address
  RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
    socket.send(packet, InternetAddress(ipAddress), 9);
    socket.close();
  });
}

bool isIPv4Address32Bit(String ipAddress) {
  List<String> octets = ipAddress.split('.');

  if (octets.length != 4) {
    return false;
  }
  for (String octet in octets) {
    int value;
    try {
      value = int.parse(octet);
    } catch (e) {
      return false;
    }
    if (value < 0 || value > 255) {
      return false;
    }
  }
  return true;
}

void checkAndExecuteOrNot(String macAddress, String ipAddress, BuildContext context) async {
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    sendMagicPacket(macAddress, ipAddress);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wake! Wake! Packet sent!')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connection error.')),
    );
  }
}

String formatMacAddress(String input) {
  final sanitizedInput = input.replaceAll(":", "");
  if (sanitizedInput.length != 12) {
    return input;
  }
  final pairs = <String>[];
  for (var i = 0; i < sanitizedInput.length; i += 2) {
    pairs.add(sanitizedInput.substring(i, i + 2));
  }
  final formattedMacAddress = pairs.join(":");
  return formattedMacAddress;
}

String formatIPAddress(TextEditingValue newValue) {
  var text = newValue.text;

  if (newValue.selection.baseOffset == 0) {
    return newValue.text;
  }

  int dotCounter = 0;
  var buffer = StringBuffer();
  String ipField = "";

  for (int i = 0; i < text.length; i++) {
    if (dotCounter < 4) {
      if (text[i] != ".") {
        ipField += text[i];
        if (ipField.length < 3) {
          buffer.write(text[i]);
        } else if (ipField.length == 3) {
          if (int.parse(ipField) <= 255) {
            buffer.write(text[i]);
          } else {
            if (dotCounter < 3) {
              buffer.write(".");
              dotCounter++;
              buffer.write(text[i]);
              ipField = text[i];
            }
          }
        } else if (ipField.length == 4) {
          if (dotCounter < 3) {
            buffer.write(".");
            dotCounter++;
            buffer.write(text[i]);
            ipField = text[i];
          }
        }
      } else {
        if (dotCounter < 3) {
          buffer.write(".");
          dotCounter++;
          ipField = "";
        }
      }
    }
  }

  var string = buffer.toString();
  return string;
}

// void executeWakeFunctionAtTime(Host host) {
//   if (host.time == null) {
//     debugPrint('Host does not have a specific time to start.');
//     return;
//   }

//   DateTime scheduledTime = DateTime.parse(host.time); // Convert time string to DateTime object
//   DateTime now = DateTime.now();

//   if (scheduledTime.isBefore(now)) {
//     debugPrint('Scheduled time is in the past.');
//     return;
//   }

//   Duration delay = scheduledTime.difference(now);

//   // Schedule the start function to run after the specified delay
//   Future.delayed(delay, () {
//     checkAndExecuteOrNot; // Call the start function
//   });
// }

String formatTimeInput(String input) {
  final RegExp timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
  if (timeRegex.hasMatch(input)) {
    return input;
  } else {
    // Format the input to 'HH:MM' if it doesn't match the required format
    final String formattedInput = input.replaceAll(RegExp(r'[^0-9:]'), '');

    if (formattedInput.length >= 3) {
      // Add the ':' after the first two characters
      final String hours = formattedInput.substring(0, 2);
      final String minutes = formattedInput.substring(2);
      return '$hours:$minutes';
    } else {
      return formattedInput;
    }
  }
}
