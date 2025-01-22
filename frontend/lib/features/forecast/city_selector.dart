import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/user.dart';

class CitySelector extends StatefulWidget {
  const CitySelector({super.key});

  @override
  State<CitySelector> createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  List<Map> _cities = [];

  Future<void> _fetchCities() async {
    try {
      final cities = await api.getService<UserService>().citiesView();
      _cities = List<Map>.from(cities.body);
      setState(() {});
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 360 - 32,
          minHeight: 72,
        ),
        child: DropdownMenu<int>(
          expandedInsets: const EdgeInsets.only(top: 8, bottom: 8 * 2 + 72),
          menuHeight: 150 * 2,
          width: 360 - 16 * 2,
          requestFocusOnTap: true,
          enableFilter: false,
          label: const Text('Город'),
          onSelected: (citiesId) {
            // _selectedCityId = citiesId;
            setState(() {});
          },
          dropdownMenuEntries: List.generate(
            _cities.length,
            (index) => DropdownMenuEntry(
              value: _cities[index]['id'],
              label: _cities[index]['city'],
            ),
          ),
        ),
      ),
    );
  }
}
