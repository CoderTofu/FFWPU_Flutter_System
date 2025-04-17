import 'package:flutter/material.dart';
import 'package:ffwpu_flutter_view/components/table_config.dart';

class CustomTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final TableConfig config;
  final Function(Map<String, dynamic>? row)? onRowTap;

  const CustomTable({
    super.key,
    required this.data,
    required this.config,
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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _updateTableSize(constraints);
        final visibleColumns = widget.config.getVisibleTableColumns(_tableSize);
        final tableWidth = widget.config.getTotalWidth(_tableSize);
        
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.config.borderRadius,
          ),
          child: ClipRRect(
            borderRadius: widget.config.borderRadius ?? BorderRadius.zero,
            child: Scrollbar(
              controller: _bodyHorizontalController,
              thumbVisibility: widget.config.showHorizontalScrollbar,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              child: Column(
                children: [
                  // Header
                  Container(
                    width: constraints.maxWidth,
                    color: widget.config.headerColor,
                    child: SingleChildScrollView(
                      controller: _headerHorizontalController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: tableWidth,
                        child: DataTable(
                          showCheckboxColumn: widget.config.showCheckboxColumn,
                          headingRowHeight: widget.config.headerHeight,
                          dataRowMaxHeight: 0,
                          horizontalMargin: 0,
                          columnSpacing: 0,
                          columns: visibleColumns.map((column) => 
                            DataColumn(
                              label: Container(
                                width: column.width,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.center,
                                child: Text(
                                  column.header,
                                  style: const TextStyle(
                                    color: Color(0xFFFFD700), // Golden yellow color
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  maxLines: 2,
                                  textHeightBehavior: const TextHeightBehavior(
                                    applyHeightToFirstAscent: false,
                                    applyHeightToLastDescent: false,
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
                      thumbVisibility: widget.config.showVerticalScrollbar,
                      child: SingleChildScrollView(
                        controller: _verticalController,
                        child: SingleChildScrollView(
                          controller: _bodyHorizontalController,
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: tableWidth,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: DataTable(
                              showCheckboxColumn: widget.config.showCheckboxColumn,
                              headingRowHeight: 0,
                              dataRowMinHeight: widget.config.rowHeight,
                              dataRowMaxHeight: widget.config.rowHeight,
                              horizontalMargin: 0,
                              columnSpacing: 0,
                              columns: visibleColumns.map((column) => 
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
                                      if (isSelected) return widget.config.selectedRowColor;
                                      if (states.contains(MaterialState.hovered)) {
                                        return widget.config.hoverRowColor;
                                      }
                                      return widget.config.rowColor;
                                    },
                                  ),
                                  cells: visibleColumns.map((column) {
                                    final value = row[column.key];
                                    return DataCell(
                                      Container(
                                        width: column.width,
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        alignment: column.textAlign != null 
                                            ? Alignment.center 
                                            : Alignment.centerLeft,
                                        child: column.customCellBuilder != null
                                            ? column.customCellBuilder!(value)
                                            : Text(
                                                '${value ?? "-"}',
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: column.textAlign,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
