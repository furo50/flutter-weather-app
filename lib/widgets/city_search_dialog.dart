import 'package:flutter/material.dart';

import '../models/saved_city_location.dart';
import '../services/city_search_service.dart';

class CitySearchDialog extends StatefulWidget {
  const CitySearchDialog({super.key});

  @override
  State<CitySearchDialog> createState() => _CitySearchDialogState();
}

class _CitySearchDialogState extends State<CitySearchDialog> {
  final CitySearchService _citySearchService = CitySearchService();
  final TextEditingController _searchTextController = TextEditingController();

  List<SavedCityLocation> _currentSearchResults = [];
  bool _isSearchInProgress = false;

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  Future<void> _performCitySearch() async {
    setState(() {
      _isSearchInProgress = true;
    });

    final List<SavedCityLocation> searchResults = await _citySearchService
        .searchForCitiesByName(_searchTextController.text);

    if (!mounted) {
      return;
    }

    setState(() {
      _currentSearchResults = searchResults;
      _isSearchInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Stadt hinzufügen'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchTextController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Stadtname eingeben'),
              onSubmitted: (_) => _performCitySearch(),
            ),
            const SizedBox(height: 12),
            if (_isSearchInProgress) const CircularProgressIndicator(),
            if (!_isSearchInProgress)
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _currentSearchResults.length,
                  itemBuilder: (context, index) {
                    final SavedCityLocation cityLocation =
                        _currentSearchResults[index];
                    return ListTile(
                      title: Text(cityLocation.cityName),
                      onTap: () => Navigator.of(context).pop(cityLocation),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        TextButton(onPressed: _performCitySearch, child: const Text('Suchen')),
      ],
    );
  }
}
