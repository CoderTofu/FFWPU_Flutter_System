import 'package:ffwpu_flutter_view/api/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:ffwpu_flutter_view/components/app_bar.dart';
import 'package:ffwpu_flutter_view/components/end_drawer.dart';
import 'package:ffwpu_flutter_view/components/data_table.dart';
import 'package:ffwpu_flutter_view/components/table_config.dart';
import 'package:ffwpu_flutter_view/pages/worship_detail_page.dart';

class WorshipPage extends StatefulWidget {
  const WorshipPage({super.key});

  @override
  State<WorshipPage> createState() => _WorshipPageState();
}

class _WorshipPageState extends State<WorshipPage> {
  final _apiService = ApiService();
  List<Map<String, dynamic>> _originalData = [];
  List<Map<String, dynamic>> _filteredData = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _sortColumn = 'Date';
  bool _sortAscending = false;
  Map<String, String?> _activeFilters = {};

  @override
  void initState() {
    super.initState();
    _fetchWorshipData();
  }

  Future<void> _fetchWorshipData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _apiService.fetchWorshipEvents();

      if (data != null) {
        setState(() {
          _originalData = data;
          _filteredData = List.from(_originalData);
          _isLoading = false;
        });
        _applyFilters();
      } else {
        setState(() {
          _error = 'Failed to load worship events';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred while loading worship events';
        _isLoading = false;
      });
    }
  }

  final TableConfig _tableConfig = TableConfig(
    columns: [
      TableColumn(
        key: 'ID',
        header: 'ID',
        width: 120,
        textAlign: TextAlign.left,
        isSortable: true,
      ),
      TableColumn(
        key: 'Event Name',
        header: 'Event Name',
        width: 300,
        textAlign: TextAlign.left,
        isSortable: true,
      ),
      TableColumn(
        key: 'Date',
        header: 'Date',
        width: 150,
        textAlign: TextAlign.left,
        isSortable: true,
      ),
      TableColumn(
        key: 'Church',
        header: 'Church',
        width: 150,
        textAlign: TextAlign.left,
        isSortable: true,
      ),
      TableColumn(
        key: 'Worship Type',
        header: 'Worship Type',
        width: 150,
        textAlign: TextAlign.left,
        isSortable: true,
      ),
    ],
    responsiveColumns: {
      'lg': ['ID', 'Event Name', 'Date', 'Church', 'Worship Type'],
      'md': ['ID', 'Event Name', 'Date', 'Worship Type'],
      'sm': ['Event Name', 'Date'],
    },
    filterOptions: [
      FilterOption(
        label: 'Church',
        field: 'Church Name',
        options: ['Test', 'Test1'],
      ),
      FilterOption(
        label: 'Worship Type',
        field: 'Worship Type',
        options: ['Online', 'Onsite'],
      ),
    ],
  );

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _applyFilters();
    });
  }

  void _handleSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
      _sortData();
    });
  }

  void _sortData() {
    setState(() {
      _filteredData.sort((a, b) {
        var aValue = a[_sortColumn];
        var bValue = b[_sortColumn];

        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return _sortAscending ? 1 : -1;
        if (bValue == null) return _sortAscending ? -1 : 1;

        int comparison;
        if (aValue is num && bValue is num) {
          comparison = aValue.compareTo(bValue);
        } else {
          comparison = aValue.toString().compareTo(bValue.toString());
        }

        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredData = _originalData.where((item) {
        // Search filter
        final matchSearch = _searchQuery.isEmpty ||
            item.values.any(
              (value) => value.toString().toLowerCase().contains(_searchQuery),
            );

        // Apply all active filters
        final matchFilters = _activeFilters.entries.every((filter) {
          if (filter.value == null) return true;
          return item[filter.key]?.toString() == filter.value;
        });

        return matchSearch && matchFilters;
      }).toList();

      _sortData();
    });
  }

  void _clearFilters() {
    setState(() {
      _activeFilters.clear();
      _searchQuery = '';
      _sortColumn = 'Date';
      _sortAscending = false;
      _applyFilters();
    });
  }

  Widget _buildFilterDropdown(FilterOption filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _activeFilters[filter.field],
        decoration: InputDecoration(
          labelText: filter.label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          setState(() {
            if (value == null) {
              _activeFilters.remove(filter.field);
            } else {
              _activeFilters[filter.field] = value;
            }
            _applyFilters();
          });
        },
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('All'),
          ),
          ...filter.options.map((option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              )),
        ],
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(1, 118, 178, 1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filters & Sort',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sort By',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Field',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        value: _sortColumn,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        items: _tableConfig.columns
                                            .where((col) => col.isSortable)
                                            .map((col) {
                                          return DropdownMenuItem(
                                            value: col.key,
                                            child: Text(col.header
                                                .replaceAll('\n', ' ')),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            setModalState(() {
                                              _sortColumn = value;
                                              _sortData();
                                            });
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Direction',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setModalState(() {
                                                  _sortAscending = true;
                                                  _sortData();
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: _sortAscending
                                                      ? const Color.fromRGBO(
                                                          1, 118, 178, 1)
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              1, 118, 178, 1)),
                                                  borderRadius:
                                                      const BorderRadius
                                                          .horizontal(
                                                          left: Radius.circular(
                                                              8)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.arrow_upward,
                                                      color: _sortAscending
                                                          ? Colors.white
                                                          : const Color
                                                              .fromRGBO(
                                                              1, 118, 178, 1),
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Ascending',
                                                      style: TextStyle(
                                                        color: _sortAscending
                                                            ? Colors.white
                                                            : const Color
                                                                .fromRGBO(
                                                                1, 118, 178, 1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setModalState(() {
                                                  _sortAscending = false;
                                                  _sortData();
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: !_sortAscending
                                                      ? const Color.fromRGBO(
                                                          1, 118, 178, 1)
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              1, 118, 178, 1)),
                                                  borderRadius:
                                                      const BorderRadius
                                                          .horizontal(
                                                          right:
                                                              Radius.circular(
                                                                  8)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.arrow_downward,
                                                      color: !_sortAscending
                                                          ? Colors.white
                                                          : const Color
                                                              .fromRGBO(
                                                              1, 118, 178, 1),
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Descending',
                                                      style: TextStyle(
                                                        color: !_sortAscending
                                                            ? Colors.white
                                                            : const Color
                                                                .fromRGBO(
                                                                1, 118, 178, 1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._tableConfig.filterOptions
                              .map((filter) => _buildFilterDropdown(filter)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, -2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              _clearFilters();
                              setModalState(() {});
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            child: const Text('Clear All'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _applyFilters();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(1, 118, 178, 1),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Apply',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Navigate to ViewWorshipEvent when a row is tapped
  void _navigateToEventDetails(Map<String, dynamic> row) {
    if (row.containsKey('ID')) {
      final eventId = row['ID'].toString();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewWorshipEvent(eventId: eventId),
        ),
      );
    } else {
      // Show an error if the ID is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to view event details: Event ID not found'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "WORSHIP EVENT INFORMATION"),
      backgroundColor: const Color(0xFFD9D9D9),
      endDrawer: EndDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Search',
                      hintText: 'Enter search term...',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      constraints: const BoxConstraints(maxHeight: 48),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: _handleSearch,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _showFilterModal,
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    label: const Text("Filters"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(1, 118, 178, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Text(_error!,
                                style: const TextStyle(color: Colors.red)))
                        : CustomTable(
                            data: _filteredData,
                            config: _tableConfig,
                            onRowTap: (row) {
                              if (row != null) {
                                // Navigate to the ViewWorshipEvent screen when a row is tapped
                                _navigateToEventDetails(row);
                              }
                            },
                          ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
