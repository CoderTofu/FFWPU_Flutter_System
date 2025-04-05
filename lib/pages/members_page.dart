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
    {"Name": "Charlsie", "Age": 28, "Email": "charlie@example.com", "ID": "3"},
    {"Name": "Alice", "Age": 25, "Email": "alice@example.com", "ID": "1"},
    {"Name": "Bob", "Age": 30, "Email": "bob@example.com", "ID": "2"},
    {"Name": "Charlsie", "Age": 28, "Email": "charlie@example.com", "ID": "3"},
    {"Name": "Alice", "Age": 25, "Email": "alice@example.com", "ID": "1"},
    {"Name": "Bob", "Age": 30, "Email": "bob@example.com", "ID": "2"},
    {"Name": "Charlsie", "Age": 28, "Email": "charlie@example.com", "ID": "3"},
    {"Name": "Alice", "Age": 25, "Email": "alice@example.com", "ID": "1"},
    {"Name": "Bob", "Age": 30, "Email": "bob@example.com", "ID": "2"},
  ];

  late List<Map<String, dynamic>> _filteredData;
  String _searchQuery = '';
  String _sortColumn = 'Name';
  bool _sortAscending = true;

  // Responsive column layout
  final columns = {
    "lg": ["Name", "Age", "Email"],
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
      _filteredData = _originalData.where((item) {
        return item.values.any((value) =>
            value.toString().toLowerCase().contains(_searchQuery));
      }).toList();
      _sortData();
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
    _filteredData.sort((a, b) {
      var aValue = a[_sortColumn];
      var bValue = b[_sortColumn];
      
      if (aValue == null || bValue == null) return 0;
      
      int comparison;
      if (aValue is num && bValue is num) {
        comparison = aValue.compareTo(bValue);
      } else {
        comparison = aValue.toString().compareTo(bValue.toString());
      }
      
      return _sortAscending ? comparison : -comparison;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: EndDrawer(),
      body: Column(
        children: [
          
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Enter search term...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: _handleSearch,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 200,
                      maxHeight: 400,
                    ),
                    child: CustomTable(
                      data: _filteredData,
                      columns: columns,
                      sortColumn: _sortColumn,
                      sortAscending: _sortAscending,
                      onSort: _handleSort,
                      onRowTap: (row) {
                        if (row != null) {
                          print("Selected row: $row");
                        } else {
                          print("No row selected");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}