import 'package:custom_calendar_date_picker/custom_calendar_date_picker.dart';
import 'package:custom_calendar_date_picker/utils/enums.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar Date Picker')),
      body: Container(
        constraints: BoxConstraints.tightFor(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(selectedDate.toString()),
            ElevatedButton(
              onPressed: () async {
                DateTime? date = await showCustomCalendarDatePicker(
                  minWidth: 300,
                  viewMode: CalendarDatePickerViewMode.dialog,
                  context: context,
                  selectedDate: DateTime.now(),
                  firstDate: DateTime.now().add(Duration(days: -1)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );

                setState(() {
                  selectedDate = date;
                });
              },
              child: Text('Open Date Picker'),
            ),
          ],
        ),
      ),
    );
  }
}
