import 'package:flutter/material.dart';

class CustomTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Map<String, List<String>> columns;
  final Function(Map<String, dynamic>? row)? onRowTap;

  const CustomTable({
    super.key,
    required this.data,
    required this.columns,
    this.onRowTap,
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  String _tableSize = 'lg';
  int? _selectedRow;
  final ScrollController _headerHorizontalController = ScrollController();
  final ScrollController _bodyHorizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  // Define fixed column widths
  final Map<String, double> columnWidths = {
    'ID': 80,
    'Name': 200,
    'Age': 100,
    'Email': 250,
  };

  List<String> get visibleHeaders => widget.columns[_tableSize] ?? [];

  @override
  void initState() {
    super.initState();
    // Sync horizontal scroll controllers
    _headerHorizontalController.addListener(_syncHeaderScroll);
    _bodyHorizontalController.addListener(_syncBodyScroll);
  }

  @override
  void dispose() {
    _headerHorizontalController.removeListener(_syncHeaderScroll);
    _bodyHorizontalController.removeListener(_syncBodyScroll);
    _headerHorizontalController.dispose();
    _bodyHorizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  void _syncHeaderScroll() {
    if (_headerHorizontalController.position.pixels != _bodyHorizontalController.position.pixels) {
      _bodyHorizontalController.jumpTo(_headerHorizontalController.position.pixels);
    }
  }

  void _syncBodyScroll() {
    if (_bodyHorizontalController.position.pixels != _headerHorizontalController.position.pixels) {
      _headerHorizontalController.jumpTo(_bodyHorizontalController.position.pixels);
    }
  }

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

  double _calculateTableWidth(BoxConstraints constraints) {
    double totalWidth = 0;
    for (String header in visibleHeaders) {
      totalWidth += columnWidths[header] ?? 150;
    }
    return totalWidth > constraints.maxWidth ? totalWidth : constraints.maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _updateTableSize(constraints);
        final tableWidth = _calculateTableWidth(constraints);
        
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                // Header
                Container(
                  width: constraints.maxWidth,
                  color: const Color(0xFF01438F),
                  child: SingleChildScrollView(
                    controller: _headerHorizontalController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      child: DataTable(
                        showCheckboxColumn: false,
                        headingRowHeight: 48,
                        dataRowMaxHeight: 0,
                        horizontalMargin: 0,
                        columnSpacing: 0,
                        columns: visibleHeaders.map((header) => 
                          DataColumn(
                            label: Container(
                              width: columnWidths[header] ?? 150,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                header,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ).toList(),
                        rows: const [],
                      ),
                    ),
                  ),
                ),
                // Table body
                Expanded(
                  child: Scrollbar(
                    controller: _verticalController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _verticalController,
                      child: Scrollbar(
                        controller: _bodyHorizontalController,
                        thumbVisibility: true,
                        scrollbarOrientation: ScrollbarOrientation.bottom,
                        child: SingleChildScrollView(
                          controller: _bodyHorizontalController,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: tableWidth,
                            child: DataTable(
                              showCheckboxColumn: false,
                              headingRowHeight: 0,
                              dataRowMinHeight: 48,
                              dataRowMaxHeight: 48,
                              horizontalMargin: 0,
                              columnSpacing: 0,
                              columns: visibleHeaders.map((header) => 
                                DataColumn(
                                  label: Container(),
                                ),
                              ).toList(),
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
                                  color: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (isSelected) return const Color(0xFFE7E6E6);
                                      if (states.contains(MaterialState.hovered)) {
                                        return const Color(0xFFE7E6E6);
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                  cells: visibleHeaders.map((header) {
                                    return DataCell(
                                      Container(
                                        width: columnWidths[header] ?? 150,
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          '${row[header] ?? "-"}',
                                          overflow: TextOverflow.ellipsis,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
