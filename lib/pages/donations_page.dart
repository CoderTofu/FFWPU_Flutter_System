import 'package:ffwpu_flutter_view/components/data_table.dart';
import 'package:ffwpu_flutter_view/components/end_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ffwpu_flutter_view/components/app_bar.dart';
import 'package:ffwpu_flutter_view/components/table_config.dart';

class DonationsPage extends StatefulWidget {
  const DonationsPage({super.key});

  @override
  State<DonationsPage> createState() => _DonationsPageState();
}

class _DonationsPageState extends State<DonationsPage> {
  final List<Map<String, dynamic>> _originalData = [
    {
      "Donation_ID": "1",
      "Member_ID": "1",
      "Full_Name": "Test Test Test",
      "Date": "2025-03-15",
      "Church": "Test",
      "Amount": 502.00,
      "Currency": "EUR"
    },
    {
      "Donation_ID": "2",
      "Member_ID": "5",
      "Full_Name": "Rafael Sebastian de la Cruz Torres",
      "Date": "2024-02-20",
      "Church": "Main Church",
      "Amount": 750.00,
      "Currency": "USD"
    },
    {
      "Donation_ID": "3",
      "Member_ID": "1",
      "Full_Name": "Test Test Test",
      "Date": "2003-09-08",
      "Church": "Test",
      "Amount": 1000.00,
      "Currency": "PHP"
    },
    {
      "Donation_ID": "4",
      "Member_ID": "5",
      "Full_Name": "Rafael Sebastian de la Cruz Torres",
      "Date": "2003-09-08",
      "Church": "Test",
      "Amount": 500.00,
      "Currency": "USD"
    },
    {
      "Donation_ID": "5",
      "Member_ID": "8",
      "Full_Name": "Maria Santos",
      "Date": "2024-01-15",
      "Church": "Seoul Center",
      "Amount": 100000.00,
      "Currency": "KRW"
    },
    {
      "Donation_ID": "6",
      "Member_ID": "12",
      "Full_Name": "Sarah Johnson",
      "Date": "2024-02-01",
      "Church": "New York Center",
      "Amount": 1000.00,
      "Currency": "USD"
    },
    {
      "Donation_ID": "7",
      "Member_ID": "15",
      "Full_Name": "John Smith",
      "Date": "2024-02-05",
      "Church": "London Center",
      "Amount": 800.00,
      "Currency": "GBP"
    },
    {
      "Donation_ID": "8",
      "Member_ID": "18",
      "Full_Name": "Emily Chen",
      "Date": "2024-02-10",
      "Church": "Singapore Center",
      "Amount": 1500.00,
      "Currency": "CNY"
    },
    {
      "Donation_ID": "9",
      "Member_ID": "8",
      "Full_Name": "Maria Santos",
      "Date": "2024-02-15",
      "Church": "Seoul Center",
      "Amount": 150000.00,
      "Currency": "KRW"
    },
    {
      "Donation_ID": "10",
      "Member_ID": "12",
      "Full_Name": "Sarah Johnson",
      "Date": "2024-02-20",
      "Church": "New York Center",
      "Amount": 1200.00,
      "Currency": "USD"
    },
    {
      "Donation_ID": "11",
      "Member_ID": "15",
      "Full_Name": "John Smith",
      "Date": "2024-02-25",
      "Church": "London Center",
      "Amount": 1000.00,
      "Currency": "JPY"
    },
    {
      "Donation_ID": "12",
      "Member_ID": "18",
      "Full_Name": "Emily Chen",
      "Date": "2024-03-01",
      "Church": "Singapore Center",
      "Amount": 2000.00,
      "Currency": "JPY"
    },
    {
      "Donation_ID": "13",
      "Member_ID": "8",
      "Full_Name": "Maria Santos",
      "Date": "2024-03-05",
      "Church": "Seoul Center",
      "Amount": 80000.00,
      "Currency": "KRW"
    },
    {
      "Donation_ID": "14",
      "Member_ID": "12",
      "Full_Name": "Sarah Johnson",
      "Date": "2024-03-10",
      "Church": "New York Center",
      "Amount": 800.00,
      "Currency": "USD"
    },
    {
      "Donation_ID": "15",
      "Member_ID": "15",
      "Full_Name": "John Smith",
      "Date": "2024-03-15",
      "Church": "London Center",
      "Amount": 600.00,
      "Currency": "GBP"
    },
    {
      "Donation_ID": "16",
      "Member_ID": "18",
      "Full_Name": "Emily Chen",
      "Date": "2024-03-20",
      "Church": "Singapore Center",
      "Amount": 1000.00,
      "Currency": "JPY"
    },
    {
      "Donation_ID": "17",
      "Member_ID": "8",
      "Full_Name": "Maria Santos",
      "Date": "2024-03-25",
      "Church": "Seoul Center",
      "Amount": 120000.00,
      "Currency": "KRW"
    },
    {
      "Donation_ID": "18",
      "Member_ID": "12",
      "Full_Name": "Sarah Johnson",
      "Date": "2024-04-01",
      "Church": "New York Center",
      "Amount": 1500.00,
      "Currency": "USD"
    },
    {
      "Donation_ID": "19",
      "Member_ID": "15",
      "Full_Name": "John Smith",
      "Date": "2024-04-05",
      "Church": "London Center",
      "Amount": 750.00,
      "Currency": "GBP"
    },
    {
      "Donation_ID": "20",
      "Member_ID": "18",
      "Full_Name": "Emily Chen",
      "Date": "2024-04-10",
      "Church": "Singapore Center",
      "Amount": 2500.00,
      "Currency": "CNY"
    },
    {
      "Donation_ID": "21",
      "Member_ID": "8",
      "Full_Name": "Maria Santos",
      "Date": "2024-04-15",
      "Church": "Seoul Center",
      "Amount": 90000.00,
      "Currency": "KRW"
    },
    {
      "Donation_ID": "22",
      "Member_ID": "12",
      "Full_Name": "Sarah Johnson",
      "Date": "2024-04-20",
      "Church": "New York Center",
      "Amount": 900.00,
      "Currency": "USD"
    },
    {
      "Donation_ID": "23",
      "Member_ID": "15",
      "Full_Name": "John Smith",
      "Date": "2024-04-25",
      "Church": "London Center",
      "Amount": 850.00,
      "Currency": "GBP"
    },
    {
      "Donation_ID": "24",
      "Member_ID": "18",
      "Full_Name": "Emily Chen",
      "Date": "2024-05-01",
      "Church": "Singapore Center",
      "Amount": 1800.00,
      "Currency": "KRW"
    },
    {
      "Donation_ID": "25",
      "Member_ID": "8",
      "Full_Name": "Maria Santos",
      "Date": "2024-05-05",
      "Church": "Seoul Center",
      "Amount": 130000.00,
      "Currency": "KRW"
    },
    {
      "Donation_ID": "26",
      "Member_ID": "12",
      "Full_Name": "Sarah Johnson",
      "Date": "2024-05-10",
      "Church": "New York Center",
      "Amount": 1100.00,
      "Currency": "USD"
    },
    {
      "Donation_ID": "27",
      "Member_ID": "15",
      "Full_Name": "John Smith",
      "Date": "2024-05-15",
      "Church": "London Center",
      "Amount": 950.00,
      "Currency": "GBP"
    },
    {
      "Donation_ID": "28",
      "Member_ID": "18",
      "Full_Name": "Emily Chen",
      "Date": "2024-05-20",
      "Church": "Singapore Center",
      "Amount": 2200.00,
      "Currency": "CNY"
    },
    {
      "Donation_ID": "29",
      "Member_ID": "8",
      "Full_Name": "Maria Santos",
      "Date": "2024-05-25",
      "Church": "Seoul Center",
      "Amount": 110000.00,
      "Currency": "KRW"
    },
    {
      "Donation_ID": "30",
      "Member_ID": "12",
      "Full_Name": "Sarah Johnson",
      "Date": "2024-06-01",
      "Church": "New York Center",
      "Amount": 1300.00,
      "Currency": "USD"
    }
  ];

  late List<Map<String, dynamic>> _filteredData;
  String _searchQuery = '';
  String _sortColumn = 'Date';
  bool _sortAscending = false;
  Map<String, String?> _activeFilters = {};

  final TableConfig _tableConfig = TableConfig(
    columns: [
      TableColumn(
        key: 'Donation_ID',
        header: 'Donation ID',
        width: 100,
        textAlign: TextAlign.center,
        isSortable: true,
      ),
      TableColumn(
        key: 'Member_ID',
        header: 'Member ID',
        width: 100,
        textAlign: TextAlign.center,
        isSortable: true,
      ),
      TableColumn(
        key: 'Full_Name',
        header: 'Full Name',
        width: 200,
        isSortable: true,
      ),
      TableColumn(
        key: 'Date',
        header: 'Date',
        width: 120,
        textAlign: TextAlign.center,
        isSortable: true,
      ),
      TableColumn(
        key: 'Church',
        header: 'Church',
        width: 150,
        textAlign: TextAlign.center,
        isSortable: true,
      ),
      TableColumn(
        key: 'Amount',
        header: 'Amount',
        width: 120,
        textAlign: TextAlign.right,
        isSortable: true,
      ),
      TableColumn(
        key: 'Currency',
        header: 'Currency',
        width: 100,
        textAlign: TextAlign.center,
        isSortable: true,
      ),
    ],
    responsiveColumns: {
      'lg': ['Donation_ID', 'Member_ID', 'Full_Name', 'Date', 'Church', 'Amount', 'Currency'],
      'md': ['Donation_ID', 'Full_Name', 'Date', 'Amount', 'Currency'],
      'sm': ['Donation_ID', 'Full_Name', 'Amount'],
    },
    filterOptions: [
      FilterOption(
        label: 'Church',
        field: 'Church',
        options: ['Test', 'Main Church', 'Seoul Center', 'New York Center', 'London Center', 'Singapore Center'],
      ),
      FilterOption(
        label: 'Currency',
        field: 'Currency',
        options: ['USD', 'PHP', 'EUR', 'JPY', 'KRW', 'CNY'],
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(_originalData);
  }

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
        final matchSearch = _searchQuery.isEmpty || item.values.any(
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
                      color: const Color(0xFF003876),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        items: _tableConfig.columns
                                            .where((col) => col.isSortable)
                                            .map((col) {
                                          return DropdownMenuItem(
                                            value: col.key,
                                            child: Text(col.header.replaceAll('\n', ' ')),
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
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: _sortAscending ? const Color(0xFF003876) : Colors.white,
                                                  border: Border.all(color: const Color(0xFF003876)),
                                                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.arrow_upward,
                                                      color: _sortAscending ? Colors.white : const Color(0xFF003876),
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Ascending',
                                                      style: TextStyle(
                                                        color: _sortAscending ? Colors.white : const Color(0xFF003876),
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
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: !_sortAscending ? const Color(0xFF003876) : Colors.white,
                                                  border: Border.all(color: const Color(0xFF003876)),
                                                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.arrow_downward,
                                                      color: !_sortAscending ? Colors.white : const Color(0xFF003876),
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Descending',
                                                      style: TextStyle(
                                                        color: !_sortAscending ? Colors.white : const Color(0xFF003876),
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
                          ..._tableConfig.filterOptions.map((filter) => 
                            _buildFilterDropdown(filter)
                          ),
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
                              backgroundColor: const Color(0xFF003876),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Apply', style: TextStyle(color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "DONATION INFORMATION"),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                      backgroundColor: const Color(0xFF003876),
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
                child: CustomTable(
                  data: _filteredData,
                  config: _tableConfig,
                  onRowTap: (row) {
                    if (row != null) {
                      print("Selected row: $row");
                    } else {
                      print("No row selected");
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}