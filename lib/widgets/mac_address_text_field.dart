import '../imports.dart';

class MacAddressTextField extends StatefulWidget {
  const MacAddressTextField(
      {Key? key, required this.onChanged, required this.macAddress, required this.errorText})
      : super(key: key);

  final ValueChanged<String> onChanged;
  final String macAddress;
  final String? errorText;

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
        LengthLimitingTextInputFormatter(12),
        _MacAddressInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: 'MAC Address',
        errorText: widget.errorText,
      ),
      maxLength: 17, // Maximum length of the MAC address with colons.
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
