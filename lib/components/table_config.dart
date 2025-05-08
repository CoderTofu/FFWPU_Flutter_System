import 'package:flutter/material.dart';

class FilterOption {
  final String label;
  final List<String> options;
  final String field;

  const FilterOption({
    required this.label,
    required this.options,
    required this.field,
  });
}

class TableColumn {
  final String key;
  final String header;
  final double width;
  final bool isSortable;
  final TextAlign? textAlign;
  final Widget Function(dynamic value)? customCellBuilder;

  const TableColumn({
    required this.key,
    required this.header,
    required this.width,
    this.isSortable = true,
    this.textAlign,
    this.customCellBuilder,
  });
}

class TableConfig {
  final List<TableColumn> columns;
  final Map<String, List<String>> responsiveColumns;
  final List<FilterOption> filterOptions;
  final Color? headerColor;
  final Color? rowColor;
  final Color? selectedRowColor;
  final Color? hoverRowColor;
  final double? rowHeight;
  final double? headerHeight;
  final BorderRadius? borderRadius;
  final bool showCheckboxColumn;
  final bool showVerticalScrollbar;
  final bool showHorizontalScrollbar;

  const TableConfig({
    required this.columns,
    required this.responsiveColumns,
    this.filterOptions = const [],
    this.headerColor = const Color.fromRGBO(28, 92, 168, 1),
    this.rowColor = Colors.white,
    this.selectedRowColor = const Color(0xFFE8F1FF),
    this.hoverRowColor = const Color(0xFFF5F9FF),
    this.rowHeight = 48,
    this.headerHeight = 48,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.showCheckboxColumn = false,
    this.showVerticalScrollbar = true,
    this.showHorizontalScrollbar = true,
  });

  List<String> getVisibleColumns(String size) {
    return responsiveColumns[size] ?? columns.map((c) => c.key).toList();
  }

  List<TableColumn> getVisibleTableColumns(String size) {
    final visibleKeys = getVisibleColumns(size);
    return columns.where((col) => visibleKeys.contains(col.key)).toList();
  }

  double getTotalWidth(String size) {
    return getVisibleTableColumns(size)
        .fold(0.0, (sum, column) => sum + column.width);
  }
}
