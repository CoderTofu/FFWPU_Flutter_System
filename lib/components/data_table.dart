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
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
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

  Widget _buildTableCell({
    required double width,
    required Widget child,
    TextAlign? textAlign,
    Color? backgroundColor,
  }) {
    return Container(
      width: width,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: textAlign == TextAlign.center ? Alignment.center : Alignment.centerLeft,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _updateTableSize(constraints);
        final visibleColumns = widget.config.getVisibleTableColumns(_tableSize);
        final totalMinWidth = visibleColumns.fold<double>(0, (sum, col) => sum + col.width);
        final availableWidth = constraints.maxWidth;
        final shouldExpand = totalMinWidth < availableWidth;
        
        final expansionRatio = shouldExpand ? availableWidth / totalMinWidth : 1.0;
        
        Widget buildTableContent(List<TableColumn> columns) {
          return SizedBox(
            width: totalMinWidth * expansionRatio,
            child: Column(
              children: [
                // Header
                Container(
                  color: widget.config.headerColor,
                  child: Row(
                    children: columns.map((column) {
                      final adjustedWidth = column.width * expansionRatio;
                      return _buildTableCell(
                        width: adjustedWidth,
                        backgroundColor: widget.config.headerColor,
                        textAlign: column.textAlign,
                        child: SizedBox(
                          height: widget.config.headerHeight,
                          child: Center(
                            child: Text(
                              column.header,
                              style: const TextStyle(
                                color: Color(0xFFFFD700),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              textAlign: column.textAlign,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Table body
                ...widget.data.map((row) {
                  final index = widget.data.indexOf(row);
                  final isSelected = _selectedRow == index;
                  
                  return InkWell(
                    onTap: () => _handleRowTap(index, row),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? widget.config.selectedRowColor
                            : widget.config.rowColor,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: columns.map((column) {
                          final value = row[column.key];
                          final adjustedWidth = column.width * expansionRatio;
                          return _buildTableCell(
                            width: adjustedWidth,
                            textAlign: column.textAlign,
                            child: SizedBox(
                              height: widget.config.rowHeight,
                              child: Center(
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
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: widget.config.borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: widget.config.borderRadius ?? BorderRadius.zero,
            child: SingleChildScrollView(
              controller: _verticalController,
              child: SingleChildScrollView(
                controller: _horizontalController,
                scrollDirection: Axis.horizontal,
                child: buildTableContent(visibleColumns),
              ),
            ),
          ),
        );
      },
    );
  }
}
