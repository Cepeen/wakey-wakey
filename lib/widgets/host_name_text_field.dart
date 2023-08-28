import '../imports.dart';

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
