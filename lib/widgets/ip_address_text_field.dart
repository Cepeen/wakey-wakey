import '../imports.dart';

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
