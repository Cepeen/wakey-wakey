import '../imports.dart';
import 'dart:math' as math;

class TimeTextField extends StatefulWidget {
  const TimeTextField({Key? key, required this.onChanged, required this.time}) : super(key: key);

  final ValueChanged<String> onChanged;
  final String time;

  @override
  State<TimeTextField> createState() => _TimeTextFieldState();
}

class _TimeTextFieldState extends State<TimeTextField> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.time);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      keyboardType: TextInputType.datetime,
      inputFormatters: [TimeInputFormatter( hourMaxValue: 23, minuteMaxValue: 59)],
      onChanged: (value) {
        widget.onChanged(value);
      },
      decoration: const InputDecoration(
        labelText: 'Time',
      ),
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {
  TimeInputFormatter({required this.hourMaxValue, required this.minuteMaxValue}) {
    _exp = RegExp(r'^$|[0-9:]+$');
  }
  late RegExp _exp;

  final int hourMaxValue;
  final int minuteMaxValue;
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text)) {
      final String value = newValue.text;
      String newText = '';
      TextSelection newSelection = newValue.selection;

      if (value.length > 1 && (int.tryParse(value.substring(0, 2)) ?? 0) == hourMaxValue) {
        if (oldValue.text.contains(':')) {
          newText = value.substring(0, 1);
        } else {
          newText = '${value.substring(0, 2)}:00';
        }
      } else if (value.length > 5) {
        newText = oldValue.text;
      } else if (value.length == 5) {
        if ((int.tryParse(value.substring(3)) ?? 0) > minuteMaxValue) {
          newText = oldValue.text;
        } else {
          newText = value;
        }
      } else if (value.length == 2) {
        if (oldValue.text.contains(':')) {
          newText = value.substring(0, 1);
        } else {
          if ((int.tryParse(value) ?? 0) > hourMaxValue) {
            newText = oldValue.text;
          } else {
            newText = '${value.substring(0, 2)}:';
          }
        }
      } else {
        newText = value;
      }

      final int selectionIndex = math.min(newValue.selection.start, newText.length);
      newSelection = TextSelection.collapsed(offset: selectionIndex);

      return TextEditingValue(
        text: newText,
        selection: newSelection,
      );
    }
    return oldValue;
  }
}
