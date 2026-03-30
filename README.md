# custom_calendar_date_picker

`CustomCalendarDatePicker` is a customizable calendar date picker widget for Flutter.


## Features

 - `dialog` and `bottomsheet` view modes
 - can select only year, month or date.
 - can select a date
 - can customize visuals, dimentions, opening position
 - can restrict date range selection

## Getting started

To use this package, add custom_calendar_date_picker as a dependency in your pubspec.yaml file.

## Usage

Minimal example:

```dart
       DateTime? date = await showCustomCalendarDatePicker(
                              context: context,
                              selectedDate: DateTime.now(),
                        );
```

Custom settings:

```dart
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
              child: Text('Select Date'),
            ),
```
