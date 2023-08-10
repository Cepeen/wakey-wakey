import 'package:flutter/material.dart';

class TimeWithCheck {
  final TimeOfDay time;
  final int isChecked;

  TimeWithCheck(this.time, this.isChecked);
}

class TimePickerWidget extends StatefulWidget {
  final Function(TimeWithCheck) onTimePicked;
  final TimeWithCheck pickedTime;

  const TimePickerWidget({
    Key? key,
    required this.onTimePicked,
    required this.pickedTime,
  }) : super(key: key);

  @override
  TimePickerWidgetState createState() => TimePickerWidgetState();
}

class TimePickerWidgetState extends State<TimePickerWidget> {
  TimeWithCheck _selectedTimeWithCheck = TimeWithCheck(TimeOfDay.now(), 0);

  @override
  void initState() {
    super.initState();
    _selectedTimeWithCheck = widget.pickedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Checkbox(
          value: _selectedTimeWithCheck.isChecked == 1,
          onChanged: (bool? newValue) {
            setState(() {
              _selectedTimeWithCheck = TimeWithCheck(
                _selectedTimeWithCheck.time,
                newValue! ? 1 : 0,
              );
            });
            widget.onTimePicked(_selectedTimeWithCheck);
          },
        ),
        title: const Text('Run on time'),
        trailing: Text(
          '${_selectedTimeWithCheck.time.hour.toString().padLeft(2, '0')}:${_selectedTimeWithCheck.time.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 16),
        ),
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: _selectedTimeWithCheck.time,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                child: child!,
              );
            },
          );
          if (pickedTime != null) {
            setState(() {
              _selectedTimeWithCheck = TimeWithCheck(pickedTime, _selectedTimeWithCheck.isChecked);
            });
            widget.onTimePicked(_selectedTimeWithCheck);
          }
        },
      ),
    );
  }
}
