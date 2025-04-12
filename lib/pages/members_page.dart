import 'package:ffwpu_flutter_view/components/data_table.dart';
import 'package:ffwpu_flutter_view/components/end_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ffwpu_flutter_view/components/app_bar.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
final List<Map<String, dynamic>> _originalData = [
  {"Name": "Charlsie", "Age": 28, "Email": "charlie@example.com", "ID": "1", "Gender": "Female"},
  {"Name": "Alice", "Age": 25, "Email": "alice@example.com", "ID": "2", "Gender": "Female"},
  {"Name": "Bob", "Age": 30, "Email": "bob@example.com", "ID": "3", "Gender": "Male"},
  {"Name": "David", "Age": 22, "Email": "david@example.com", "ID": "4", "Gender": "Male"},
  {"Name": "Eva", "Age": 27, "Email": "eva@example.com", "ID": "5", "Gender": "Female"},
  {"Name": "Frank", "Age": 35, "Email": "frank@example.com", "ID": "6", "Gender": "Male"},
  {"Name": "Grace", "Age": 29, "Email": "grace@example.com", "ID": "7", "Gender": "Female"},
  {"Name": "Hannah", "Age": 24, "Email": "hannah@example.com", "ID": "8", "Gender": "Female"},
  {"Name": "Ian", "Age": 31, "Email": "ian@example.com", "ID": "9", "Gender": "Male"},
  {"Name": "Jake", "Age": 26, "Email": "jake@example.com", "ID": "10", "Gender": "Male"},
  {"Name": "Karen", "Age": 32, "Email": "karen@example.com", "ID": "11", "Gender": "Female"},
  {"Name": "Leo", "Age": 23, "Email": "leo@example.com", "ID": "12", "Gender": "Male"},
  {"Name": "Mia", "Age": 27, "Email": "mia@example.com", "ID": "13", "Gender": "Female"},
  {"Name": "Nathan", "Age": 36, "Email": "nathan@example.com", "ID": "14", "Gender": "Male"},
  {"Name": "Olivia", "Age": 30, "Email": "olivia@example.com", "ID": "15", "Gender": "Female"},
  {"Name": "Paul", "Age": 33, "Email": "paul@example.com", "ID": "16", "Gender": "Male"},
  {"Name": "Queenie", "Age": 21, "Email": "queenie@example.com", "ID": "17", "Gender": "Female"},
  {"Name": "Ryan", "Age": 34, "Email": "ryan@example.com", "ID": "18", "Gender": "Male"},
  {"Name": "Sophia", "Age": 28, "Email": "sophia@example.com", "ID": "19", "Gender": "Female"},
  {"Name": "Tom", "Age": 29, "Email": "tom@example.com", "ID": "20", "Gender": "Male"},
  {"Name": "Uma", "Age": 26, "Email": "uma@example.com", "ID": "21", "Gender": "Female"},
  {"Name": "Victor", "Age": 31, "Email": "victor@example.com", "ID": "22", "Gender": "Male"},
  {"Name": "Wendy", "Age": 25, "Email": "wendy@example.com", "ID": "23", "Gender": "Female"},
  {"Name": "Xander", "Age": 27, "Email": "xander@example.com", "ID": "24", "Gender": "Male"},
  {"Name": "Yasmin", "Age": 33, "Email": "yasmin@example.com", "ID": "25", "Gender": "Female"},
  {"Name": "Zane", "Age": 34, "Email": "zane@example.com", "ID": "26", "Gender": "Male"},
  {"Name": "Bella", "Age": 22, "Email": "bella@example.com", "ID": "27", "Gender": "Female"},
  {"Name": "Caleb", "Age": 35, "Email": "caleb@example.com", "ID": "28", "Gender": "Male"},
  {"Name": "Diana", "Age": 29, "Email": "diana@example.com", "ID": "29", "Gender": "Female"},
  {"Name": "Ethan", "Age": 24, "Email": "ethan@example.com", "ID": "30", "Gender": "Male"},
];


  late List<Map<String, dynamic>> _filteredData;
  String _searchQuery = '';
  String _sortColumn = 'Name';
  bool _sortAscending = true;

  String? _selectedGender;
  String? _selectedNation;
  String? _selectedRegion;
  String? _selectedAgeGroup;
  String? _selectedMembershipCategory;

  final columns = {
    "lg": ["Name", "Age", "Gender", "Email"],
    "md": ["Name", "Email"],
    "sm": ["Name"],
  };

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

        // Gender filter
        final matchGender = _selectedGender == null || 
            item['Gender']?.toString().toLowerCase() == _selectedGender?.toLowerCase();

        // Age group filter
        final matchAgeGroup = _selectedAgeGroup == null || _matchesAgeGroup(item['Age'], _selectedAgeGroup);

        return matchSearch && matchGender && matchAgeGroup;
      }).toList();

      _sortData();
    });
  }

  bool _matchesAgeGroup(int? age, String? ageGroup) {
    if (age == null || ageGroup == null) return true;
    
    switch (ageGroup) {
      case '<18':
        return age < 18;
      case '18-30':
        return age >= 18 && age <= 30;
      case '31-50':
        return age >= 31 && age <= 50;
      case '51+':
        return age > 50;
      default:
        return true;
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedGender = null;
      _selectedNation = null;
      _selectedRegion = null;
      _selectedAgeGroup = null;
      _selectedMembershipCategory = null;
      _searchQuery = '';
      _sortColumn = 'Name';
      _sortAscending = true;
      _applyFilters();
    });
  }

  Widget _buildFilterDropdown(String label, List<String> options, String? selectedValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          setState(() {
            onChanged(value);
            _applyFilters();
          });
        },
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('All'),
          ),
          ...options.map((option) => DropdownMenuItem<String>(
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
                      color: const Color(0xFF01438F),
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
                                        items: ['Name', 'Age', 'Email'].map((field) {
                                          return DropdownMenuItem(
                                            value: field,
                                            child: Text(field),
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
                                                  color: _sortAscending ? const Color(0xFF01438F) : Colors.white,
                                                  border: Border.all(color: const Color(0xFF01438F)),
                                                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.arrow_upward,
                                                      color: _sortAscending ? Colors.white : const Color(0xFF01438F),
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Ascending',
                                                      style: TextStyle(
                                                        color: _sortAscending ? Colors.white : const Color(0xFF01438F),
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
                                                  color: !_sortAscending ? const Color(0xFF01438F) : Colors.white,
                                                  border: Border.all(color: const Color(0xFF01438F)),
                                                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.arrow_downward,
                                                      color: !_sortAscending ? Colors.white : const Color(0xFF01438F),
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Descending',
                                                      style: TextStyle(
                                                        color: !_sortAscending ? Colors.white : const Color(0xFF01438F),
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
                          _buildFilterDropdown(
                            "Gender",
                            ["Male", "Female"],
                            _selectedGender,
                            (val) => setModalState(() => _selectedGender = val),
                          ),
                          _buildFilterDropdown(
                            "Nation",
                            ["Nation A", "Nation B"],
                            _selectedNation,
                            (val) => setModalState(() => _selectedNation = val),
                          ),
                          _buildFilterDropdown(
                            "Region",
                            ["Region 1", "Region 2"],
                            _selectedRegion,
                            (val) => setModalState(() => _selectedRegion = val),
                          ),
                          _buildFilterDropdown(
                            "Age Group",
                            ["<18", "18-30", "31-50", "51+"],
                            _selectedAgeGroup,
                            (val) => setModalState(() => _selectedAgeGroup = val),
                          ),
                          _buildFilterDropdown(
                            "Membership",
                            ["Basic", "Premium", "VIP"],
                            _selectedMembershipCategory,
                            (val) => setModalState(() => _selectedMembershipCategory = val),
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
                              backgroundColor: const Color(0xFF01438F),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Apply'),
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
      appBar: CustomAppBar(),
      backgroundColor: const Color(0xFFD9D9D9),
      endDrawer: EndDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const SizedBox(
                height: 80,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "MEMBERS",
                    style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
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
                    icon: const Icon(Icons.filter_list),
                    label: const Text("Filters"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF01438F),
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
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
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
                  columns: columns,
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
        ],
      ),
    );
  }
}
