import '../imports.dart';

class IPAddressTextField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String ipAddress;

  const IPAddressTextField({Key? key, this.onChanged, required this.ipAddress}) : super(key: key);

  @override
  
  State<IPAddressTextField> createState() => _IPAddressTextFieldState();
}

class _IPAddressTextFieldState extends State<IPAddressTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.ipAddress);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
      inputFormatters: [
        MyInputFormatters.ipAddressInputFilter(),
        LengthLimitingTextInputFormatter(15),
        _IPAddressInputFormatter(), // Using the custom IP address input formatter
      ],
      decoration: const InputDecoration(
        labelText: 'IP Address',
      ),
    );
  }
}


class _IPAddressInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final formattedText = formatIPAddress(newValue);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}


class MyInputFormatters {
  static TextInputFormatter ipAddressInputFilter() {
    return FilteringTextInputFormatter.allow(RegExp("[0-9.]"));
  }
}
