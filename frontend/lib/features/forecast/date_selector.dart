import 'package:flutter/material.dart';
import 'package:flutter_application_1/navigation/navigator.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final int? cityId;
  final DateTime selectedDate;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.cityId,
  });

  String get _selectedDateText {
    final now = DateTime.now();
    final diff = selectedDate
        .difference(DateTime(
          now.year,
          now.month,
          now.day,
        ))
        .inDays;

    if (diff == 0) {
      return 'Сегодня';
    } else if (diff == 1) {
      return 'Завтра';
    } else if (diff == -1) {
      return 'Вчера';
    }

    return DateFormat('dd MMMM yyyy', "ru-RU").format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              AppNavigator.openHome(
                cityId: cityId,
                date: selectedDate.subtract(Duration(days: 1)),
              );
            },
            icon: Icon(Icons.arrow_back_ios)),
        Expanded(
          child: Center(
            child: Text(
              _selectedDateText,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              AppNavigator.openHome(
                cityId: cityId,
                date: selectedDate.add(Duration(days: 1)),
              );
            },
            icon: Icon(Icons.arrow_forward_ios))
      ],
    );
  }
}
