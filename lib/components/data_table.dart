import 'package:flutter/material.dart';

class CustomTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Map<String, List<String>> columns;
  final Function(Map<String, dynamic>? row)? onRowTap;
  final Function(String column)? onSort;
  final String? sortColumn;
  final bool sortAscending;

  const CustomTable({
    super.key,
    required this.data,
    required this.columns,
    this.onRowTap,
    this.onSort,
    this.sortColumn,
    this.sortAscending = true,
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  String _tableSize = 'lg';
  int? _selectedRow;

  List<String> get visibleHeaders => widget.columns[_tableSize] ?? [];

  void _updateTableSize(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    if (width >= 600) {
      _tableSize = 'lg';
    } else {
      _tableSize = 'md';
    }
  }

  void _handleRowTap(int index, Map<String, dynamic> row) {
    setState(() => _selectedRow = index);
    widget.onRowTap?.call(row);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _updateTableSize(constraints);
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() => _selectedRow = null);
            widget.onRowTap?.call(null);
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      showCheckboxColumn: false,
                      headingRowColor: WidgetStateProperty.all(const Color(0xFF01438F)),
                      headingTextStyle: const TextStyle(
                        color: Color(0xFFFCC346),
                        fontWeight: FontWeight.bold,
                      ),
                      dataRowMinHeight: 50,
                      dataRowMaxHeight: double.infinity,
                      sortColumnIndex: widget.sortColumn != null 
                          ? visibleHeaders.indexOf(widget.sortColumn!)
                          : null,
                      sortAscending: widget.sortAscending,
                      columns: visibleHeaders
                          .map(
                            (header) => DataColumn(
                              label: Container(
                                alignment: Alignment.center,
                                width: 150,
                                child: Text(
                                  header,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onSort: widget.onSort != null ? (_, __) => widget.onSort!(header) : null,
                            ),
                          )
                          .toList(),
                      rows: List.generate(widget.data.length, (index) {
                        final row = widget.data[index];
                        final isSelected = _selectedRow == index;
  
                        return DataRow(
                          selected: isSelected,
                          onSelectChanged: (selected) {
                            if (selected != null && selected) {
                              _handleRowTap(index, row);
                            } else {
                              setState(() => _selectedRow = null);
                              widget.onRowTap?.call(null);
                            }
                          },
                          color: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (isSelected) return const Color(0xFFE7E6E6);
                              if (states.contains(WidgetState.hovered)) {
                                return const Color(0xFFE7E6E6);
                              }
                              return Colors.white;
                            },
                          ),
                          cells: visibleHeaders.map((header) {
                            return DataCell(
                              Container(
                                alignment: Alignment.center,
                                width: 150,
                                child: Text(
                                  '${row[header] ?? "-"}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
