import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/user.dart';
import 'package:flutter_application_1/navigation/navigator.dart';

class CitySelector extends StatefulWidget {
  final int? selectedCity;

  const CitySelector({
    super.key,
    this.selectedCity,
  });

  @override
  State<CitySelector> createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  List<Map> _cities = [];
  int? _selectedCityId;

  Future<void> _fetchCities() async {
    try {
      final cities = await api.getService<UserService>().citiesView();
      _cities = List<Map>.from(cities.body);

      if (_selectedCityId == null) {
        final response = await api.getService<UserService>().userMeView();
        final userData = Map<String, dynamic>.from(response.body);
        _selectedCityId = userData["city_id"];
      }

      setState(() {});
    } catch (_) {}
  }

  @override
  void initState() {
    _selectedCityId = widget.selectedCity;
    _fetchCities();
    super.initState();
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
          expandedInsets: const EdgeInsets.only(top: 8, bottom: 8 * 2 + 120),
          menuHeight: 150 * 2,
          width: 360 - 16 * 2,
          requestFocusOnTap: true,
          enableFilter: false,
          label: const Text('Город'),
          initialSelection: _selectedCityId,
          onSelected: (citiesId) {
            AppNavigator.openHome(
              cityId: citiesId,
            );
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
