import '../imports.dart';


class TimePickerWidget extends StatefulWidget {
  final Function(TimeOfDay) onTimePicked;

  TimePickerWidget({required this.onTimePicked});

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListTile(
        title: const Text('Pick a time'),
        trailing: Text(
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 16),
        ),
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: _selectedTime,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                child: child!,
              );
            },
          );
          if (pickedTime != null) {
            setState(() {
              _selectedTime = pickedTime;
            });
            widget.onTimePicked(_selectedTime);
          }
        },
      ),
    );
  }
}
