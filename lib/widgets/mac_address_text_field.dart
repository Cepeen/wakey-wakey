import '../imports.dart';

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
