import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  final Function(TimeOfDay) onTimePicked;
  final TimeOfDay pickedTime; // Add the pickedTime parameter

  const TimePickerWidget({
    Key? key,
    required this.onTimePicked,
    required this.pickedTime,
  }) : super(key: key);

  @override
  TimePickerWidgetState createState() => TimePickerWidgetState();
}

class TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay _selectedTime = TimeOfDay.now(); // Initialize with the current time
  bool _runOnTime = false; // Initialize the checkbox value

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.pickedTime; // Set the initial selected time from the Host object
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // Wrap the widget with a Card
      elevation: 4,
      child: ListTile(
        leading: Checkbox(
          value: _runOnTime,
          onChanged: (value) {
            setState(() {
              _runOnTime = value!;
            });
            // Call your function here, replace 'anyFunction' with the actual function you want to call
            if (_runOnTime) {
              anyFunction();
            }
          },
        ),
        title: const Text('Run on time'),
        trailing: Text(
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 16),
        ),
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: _selectedTime,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                child: child!,
              );
            },
          );
          if (pickedTime != null) {
            setState(() {
              _selectedTime = pickedTime;
            });
            widget.onTimePicked(pickedTime);
          }
        },
      ),
    );
  }

  void anyFunction() {
    print("Checkbox is checked");
  }
}
