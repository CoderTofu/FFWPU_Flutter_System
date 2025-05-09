import 'package:ffwpu_flutter_view/api/ApiService.dart';
import 'package:ffwpu_flutter_view/components/data_table.dart';
import 'package:ffwpu_flutter_view/components/end_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ffwpu_flutter_view/components/app_bar.dart';
import 'package:ffwpu_flutter_view/components/table_config.dart';
import 'package:ffwpu_flutter_view/pages/member_detail_page.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final _apiService = ApiService();
  List<Map<String, dynamic>> _originalData = [];
  List<Map<String, dynamic>> _filteredData = [];
  bool _isLoading = true;
  String _error = '';
  String _searchQuery = '';
  String _sortColumn = 'Full Name';
  bool _sortAscending = true;
  Map<String, String?> _activeFilters = {};

  final TableConfig _tableConfig = TableConfig(
    columns: [
      TableColumn(
        key: 'ID',
        header: 'Member ID',
        width: 100,
        textAlign: TextAlign.center,
        isSortable: true,
      ),
      TableColumn(
        key: 'Full Name',
        header: 'Full Name',
        width: 200,
        isSortable: true,
      ),
      TableColumn(
        key: 'Gender',
        header: 'Gender',
        width: 100,
        textAlign: TextAlign.center,
        isSortable: false,
      ),
      TableColumn(
        key: 'Date_Of_Birth',
        header: 'Date Of\nBirth',
        width: 120,
        textAlign: TextAlign.center,
        isSortable: true,
      ),
      TableColumn(
        key: 'Age',
        header: 'Age',
        width: 80,
        textAlign: TextAlign.center,
        isSortable: true,
      ),
      TableColumn(
        key: 'Marital_Status',
        header: 'Marital\nStatus',
        width: 100,
        textAlign: TextAlign.center,
        isSortable: false,
      ),
      TableColumn(
        key: 'Address',
        header: 'Address',
        width: 200,
        isSortable: false,
      ),
      TableColumn(
        key: 'Nation',
        header: 'Nation',
        width: 150,
        textAlign: TextAlign.center,
        isSortable: true,
      ),
      TableColumn(
        key: 'Region',
        header: 'Region',
        width: 150,
        textAlign: TextAlign.center,
        isSortable: true,
      ),
      TableColumn(
        key: 'Membership_Category',
        header: 'Membership\nCategory',
        width: 120,
        textAlign: TextAlign.center,
        isSortable: false,
      ),
      TableColumn(
        key: 'Generation',
        header: 'Generation',
        width: 120,
        textAlign: TextAlign.center,
        isSortable: false,
      ),
      TableColumn(
        key: 'Blessing_Status',
        header: 'Blessing\nStatus',
        width: 120,
        textAlign: TextAlign.center,
        isSortable: false,
      ),
      TableColumn(
        key: 'Spiritual_Birthday',
        header: 'Spiritual\nBirthday',
        width: 120,
        textAlign: TextAlign.center,
        isSortable: true,
      ),
    ],
    responsiveColumns: {
      'lg': [
        'ID',
        'Title',
        'Full Name',
        'Gender',
        'Birthday',
        'Age',
        'Marital Status',
        'Address',
        'Nation',
        'Region',
        'Membership Category',
        'Generation',
        'Blessing Status',
        'Spiritual Birthday'
      ],
      'md': ['ID', 'Full Name', 'Gender', 'Age', 'Nation', 'Region'],
      'sm': ['ID', 'Full Name', 'Gender'],
    },
    filterOptions: [
      FilterOption(
        label: 'Gender',
        field: 'Gender',
        options: ['Male', 'Female'],
      ),
      FilterOption(
        label: 'Region',
        field: 'Region',
        options: ['Asia Pacific', 'East Asia', 'North America', 'Europe'],
      ),
      FilterOption(
        label: 'Marital Status',
        field: 'Marital_Status',
        options: ['Single', 'Married'],
      ),
      FilterOption(
        label: 'Generation',
        field: 'Generation',
        options: ['1st Generation', '2nd Generation'],
      ),
      FilterOption(
        label: 'Blessing Status',
        field: 'Blessing_Status',
        options: ['Blessed', 'Matching'],
      ),
      FilterOption(
        label: 'Membership',
        field: 'Membership_Category',
        options: ['Regular', 'Premium', 'VIP'],
      ),
    ],
  );

  Future<void> _fetchMembers() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final members = await _apiService.fetchAllMembers();

      if (members != null) {
        setState(() {
          _originalData = members;
          _filteredData = List.from(_originalData);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to fetch members. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred while fetching members.';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMembers();
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
      _sortColumn = 'Full Name';
      _sortAscending = true;
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
                      color: const Color.fromRGBO(28, 92, 168, 1),
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
                                                          28, 92, 168, 1)
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              28, 92, 168, 1)),
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
                                                              28, 92, 168, 1),
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
                                                                28, 92, 168, 1),
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
                                                          28, 92, 168, 1)
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              28, 92, 168, 1)),
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
                                                              28, 92, 168, 1),
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
                                                                28, 92, 168, 1),
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
                                  const Color.fromRGBO(28, 92, 168, 1),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(color: Colors.white),
                            ),
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
      appBar: CustomAppBar(title: "MEMBER INFORMATION"),
      backgroundColor: const Color.fromRGBO(248, 250, 252, 1),
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
                      backgroundColor: const Color.fromRGBO(28, 92, 168, 1),
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
                      final memberId = row['ID'].toString();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberDetailPage(
                            memberID: memberId,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
