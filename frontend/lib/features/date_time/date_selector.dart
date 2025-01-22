// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/core/api/chopper.dart';
// import 'package:flutter_application_1/core/api/services/forecast.dart';
// import 'package:intl/intl.dart';

// class DateSelector extends StatefulWidget {
//   const DateSelector({super.key, required this.currentDate});
//   final DateTime currentDate;

//   @override
//   State<DateSelector> createState() => _DateSelectorState();
// }

// class _DateSelectorState extends State<DateSelector> {
//   Map<String, dynamic>? _forecastData;
//   bool _isLoading = true;
//   bool _fetchError = false;
//   Future<void> _fetchForecastToday() async {
//     try {
//       final response = await api
//           .getService<ForecastService>()
//           .forecastToday("2023-01-01 14:00");
//       if (response.isSuccessful) {
//         setState(() {
//           _forecastData = Map<String, dynamic>.from(response.body);
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _fetchError = true;
//         });
//       }
//     } catch (error) {
//       setState(
//         () {
//           _isLoading = false;
//           _fetchError = true;
//         },
//       );
//     }
//   }

//   Future<void> _loadData() async {
//     await Future.delayed(const Duration(milliseconds: 500));

//     if (_userData != null) {
//       await _fetchForecastToday();
//     } else {
//       setState(() {
//         _isLoading = false;
//         _fetchError = true;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoButton(
//       child: Text(
//         DateFormat("yyyy-MM-dd").format(widget.currentDate),
//       ),
//       onPressed: () {
//         showDatePicker(
//           context: context,
//           initialDate: widget.currentDate,
//           firstDate: widget.currentDate,
//           lastDate: widget.currentDate.add(const Duration(days: 30)),
//         );
//       },
//     );
//   }
// }
