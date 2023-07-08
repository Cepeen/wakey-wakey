import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() {
  runApp(const WakeWake());
}

class WakeWake extends StatelessWidget {
  const WakeWake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wake! Wake!',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Wake! Wake!'),
    );
  }
}

String macAddress = "macadress";
String ipAddress = 'ipadress';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int port = 9;

  void _wakewake() {
    sendMagicPacket(macAddress); //target mac
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          child: MacAddressTextField(
            onChanged: (value) {
              setState(() {
                macAddress = value;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20.0),
          child: IPAddressTextField(
            onChanged: (value) {
              setState(() {
                ipAddress = value;
              });
            },
          ),
        ),
        ElevatedButton(
          onPressed: _wakewake,
          child: const Text('Wake! Wake!'),
        )
      ]),
    );
  }
}

void sendMagicPacket(String macAddress) {
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

class IPAddressTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const IPAddressTextField({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'IP Address',
      ),
      onChanged: onChanged,
    );
  }
}

class MacAddressTextField extends StatelessWidget {
  const MacAddressTextField({Key? key, required this.onChanged}) : super(key: key);

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-fA-F0-9-]')),
        _MacAddressInputFormatter(),
      ],
      decoration: const InputDecoration(
        labelText: 'MAC Address',
      ),
    );
  }
}

class _MacAddressInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formattedText = formatMacAddress(newValue.text);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

// Getting MAC and checking if the format is correct
String formatMacAddress(String input) {
  // Remove any existing ":" characters from the input
  final sanitizedInput = input.replaceAll(":", "");

  // Ensure the input length is valid for a MAC address
  if (sanitizedInput.length != 12) {
    // Invalid input length
    return input;
  }

  // Split the input into pairs of symbols
  final pairs = <String>[];
  for (var i = 0; i < sanitizedInput.length; i += 2) {
    pairs.add(sanitizedInput.substring(i, i + 2));
  }

  // Join the pairs with ":"
  final formattedMacAddress = pairs.join(":");

  return formattedMacAddress;
}
