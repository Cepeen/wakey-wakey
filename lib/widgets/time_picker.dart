import '../imports.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.pickedTime; // Set the initial selected time from the Host object
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
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
}
