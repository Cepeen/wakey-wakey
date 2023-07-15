import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'hosts.dart';
import 'package:provider/provider.dart';
import 'main.dart';


class AddHost extends StatefulWidget {
  const AddHost({Key? key, required this.title, this.host}) : super(key: key);

  final String title;
  final Hosts? host; // Add the host parameter

  @override
  State<AddHost> createState() => _AddHostState();
}

class _AddHostState extends State<AddHost> {
  final int port = 9;
  String macAddress = '';
  String ipAddress = '';
  String hostName = '';

  @override
  void initState() {
    super.initState();
    if (widget.host != null) {
      final hostProvider = context.read<HostListProvider>();
      final host = widget.host!;
      hostName = host.hostName;
      ipAddress = host.ipAddress;
      macAddress = host.macAddress;
    }
    loadPreferences();
  }

  Future<void> savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final hostProvider = context.read<HostListProvider>();
    List<String> hostList =
        hostProvider.savedHosts.map((host) => jsonEncode(host.toJson())).toList();
    prefs.setStringList('hosts', hostList);
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final hostProvider = context.read<HostListProvider>();
    List<String> hostList = prefs.getStringList('hosts') ?? [];
    hostProvider.savedHosts = hostList.map((item) => Hosts.fromJson(jsonDecode(item))).toList();
  }

  void _wakewake() {
    sendMagicPacket(macAddress, ipAddress);
  }

  void _saveHost() {
    final hostProvider = context.read<HostListProvider>();
    Hosts newHost = Hosts(hostName, ipAddress, macAddress);
    hostProvider.savedHosts.add(newHost);
    savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20.0),
              child: HostNameTextField(
                onChanged: (value) {
                  setState(() {
                    hostName = value;
                  });
                },
                hostName: hostName,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: MacAddressTextField(
                onChanged: (value) {
                  setState(() {
                    macAddress = value;
                  });
                },
                macAddress: macAddress,
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
                ipAddress: ipAddress,
              ),
            ),
            ElevatedButton(
              onPressed: _wakewake,
              child: const Text('Wake! Wake!'),
            ),
            ElevatedButton(
              onPressed: () {
                savePreferences();
                _saveHost();
              },
              child: const Text('Save'),
            ),
          ],
        )));
  }
}

class HostNameTextField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String hostName;

  const HostNameTextField({Key? key, this.onChanged, required this.hostName}) : super(key: key);

  @override
  State<HostNameTextField> createState() => _HostNameTextFieldState();
}

class _HostNameTextFieldState extends State<HostNameTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      controller: TextEditingController.fromValue(
        TextEditingValue(
            text: widget.hostName,
            selection: TextSelection(
              baseOffset: widget.hostName.length,
              extentOffset: widget.hostName.length,
            )),
      ),
      decoration: const InputDecoration(
        labelText: 'Host Name',
      ),
    );
  }
}

class IPAddressTextField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String ipAddress;

  const IPAddressTextField({Key? key, this.onChanged, required this.ipAddress}) : super(key: key);

  @override
  State<IPAddressTextField> createState() => _IPAddressTextFieldState();
}

class _IPAddressTextFieldState extends State<IPAddressTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      controller: TextEditingController.fromValue(
        TextEditingValue(
            text: widget.ipAddress,
            selection: TextSelection(
              baseOffset: widget.ipAddress.length,
              extentOffset: widget.ipAddress.length,
            )),
      ),
      decoration: const InputDecoration(
        labelText: 'IP Address',
      ),
    );
  }
}

class MacAddressTextField extends StatefulWidget {
  const MacAddressTextField({Key? key, required this.onChanged, required this.macAddress})
      : super(key: key);

  final ValueChanged<String> onChanged;
  final String macAddress;

  @override
  State<MacAddressTextField> createState() => _MacAddressTextFieldState();
}

class _MacAddressTextFieldState extends State<MacAddressTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      controller: TextEditingController.fromValue(
        TextEditingValue(
            text: widget.macAddress,
            selection: TextSelection(
              baseOffset: widget.macAddress.length,
              extentOffset: widget.macAddress.length,
            )),
      ),
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

sendMagicPacket(String macAddress, String ipAddress) {
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