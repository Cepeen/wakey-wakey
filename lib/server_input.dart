import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ServerInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String value;
  final String label;
  final List<TextInputFormatter>? inputFormatters;

  const ServerInput({
    Key? key,
    this.onChanged,
    required this.value,
    required this.label,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<ServerInput> createState() => _ServerInputState();
}

class _ServerInputState extends State<ServerInput> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: widget.label,
        ),
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatters,
      ),
    );
  }
}
