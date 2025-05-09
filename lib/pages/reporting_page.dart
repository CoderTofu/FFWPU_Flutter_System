import 'package:flutter/material.dart';
import 'package:ffwpu_flutter_view/components/app_bar.dart';
import 'package:ffwpu_flutter_view/components/end_drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ffwpu_flutter_view/api/ApiService.dart';
import 'package:intl/intl.dart';

class ReportingPage extends StatefulWidget {
  const ReportingPage({super.key});

  @override
  State<ReportingPage> createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  final _apiService = ApiService();
  String _selectedCurrency = 'USD';
  String _selectedPeriod = 'Month';
  bool _isLoading = true;
  String? _error;

  final List<String> _currencies = ['USD', 'PHP', 'EUR', 'JPY', 'KRW', 'CNY'];
  final List<String> _periods = ['Week', 'Month', 'Year'];

  // Currency symbol mapping
  Map<String, String> _currencySymbols = {
    'USD': '\$',
    'PHP': '₱',
    'EUR': '€',
    'JPY': '¥',
    'KRW': '₩',
    'CNY': 'CN¥',
  };

  // Data from API
  double _totalDonation = 0.0;
  double _averageDonation = 0.0;
  List<Map<String, dynamic>> _topDonorsYearly = [];
  List<Map<String, dynamic>> _topDonorsMonthly = [];
  List<Map<String, dynamic>> _topDonorsWeekly = [];
  List<Map<String, dynamic>> _timeSeriesMonthly = [];
  List<Map<String, dynamic>> _timeSeriesWeekly = [];
  List<Map<String, dynamic>> _timeSeriesYearly = [];

  @override
  void initState() {
    super.initState();
    _fetchDonationStatistics();
  }

  Future<void> _fetchDonationStatistics() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _apiService.fetchDonationStatistics();

      if (data != null) {
        setState(() {
          _totalDonation = data['total_donation'] ?? 0.0;
          _averageDonation = data['average_donation'] ?? 0.0;

          // Parse top donors
          if (data['top_donors'] != null) {
            if (data['top_donors']['yearly'] != null) {
              _topDonorsYearly =
                  List<Map<String, dynamic>>.from(data['top_donors']['yearly']);
            }
            if (data['top_donors']['monthly'] != null) {
              _topDonorsMonthly = List<Map<String, dynamic>>.from(
                  data['top_donors']['monthly']);
            }
            if (data['top_donors']['weekly'] != null) {
              _topDonorsWeekly =
                  List<Map<String, dynamic>>.from(data['top_donors']['weekly']);
            }
          }

          // Parse time series data
          if (data['time_series'] != null) {
            if (data['time_series']['monthly'] != null) {
              _timeSeriesMonthly = List<Map<String, dynamic>>.from(
                  data['time_series']['monthly']);
            }
            if (data['time_series']['weekly'] != null) {
              _timeSeriesWeekly = List<Map<String, dynamic>>.from(
                  data['time_series']['weekly']);
            }
            if (data['time_series']['yearly'] != null) {
              _timeSeriesYearly = List<Map<String, dynamic>>.from(
                  data['time_series']['yearly']);
            }
          }

          _isLoading = false;
        });
      } else {
        // If API fails, use fallback data
        setState(() {
          _error = 'Failed to load donation statistics';
          _isLoading = false;

          // Set fallback data
          _totalDonation = 25000.00;
          _averageDonation = 1250.00;
          _topDonorsYearly = [
            {'name': 'Sarah Johnson', 'amount': 5000.00},
            {'name': 'John Smith', 'amount': 4500.00},
            {'name': 'Maria Santos', 'amount': 4000.00},
          ];
          _topDonorsMonthly = _topDonorsYearly;
          _topDonorsWeekly = _topDonorsYearly;

          // Generate fallback time series data
          _timeSeriesMonthly = List.generate(12, (index) {
            final now = DateTime.now();
            final date = DateTime(now.year, now.month - index, 1);
            return {
              'date': DateFormat('yyyy-MM-dd').format(date),
              'amount': 1000.0 * (12 - index),
            };
          });
          _timeSeriesWeekly = List.generate(4, (index) {
            final now = DateTime.now();
            final date = DateTime(now.year, now.month, now.day - (index * 7));
            return {
              'date': DateFormat('yyyy-MM-dd').format(date),
              'amount': 2000.0 * (4 - index),
            };
          });
          _timeSeriesYearly = List.generate(5, (index) {
            final now = DateTime.now();
            final date = DateTime(now.year - index, 1, 1);
            return {
              'date': DateFormat('yyyy-MM-dd').format(date),
              'amount': 10000.0 * (5 - index),
            };
          });
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;

        // Set fallback data
        _totalDonation = 25000.00;
        _averageDonation = 1250.00;
        _topDonorsYearly = [
          {'name': 'Sarah Johnson', 'amount': 5000.00},
          {'name': 'John Smith', 'amount': 4500.00},
          {'name': 'Maria Santos', 'amount': 4000.00},
        ];
        _topDonorsMonthly = _topDonorsYearly;
        _topDonorsWeekly = _topDonorsYearly;

        // Generate fallback time series data
        _timeSeriesMonthly = List.generate(12, (index) {
          final now = DateTime.now();
          final date = DateTime(now.year, now.month - index, 1);
          return {
            'date': DateFormat('yyyy-MM-dd').format(date),
            'amount': 1000.0 * (12 - index),
          };
        });
        _timeSeriesWeekly = List.generate(4, (index) {
          final now = DateTime.now();
          final date = DateTime(now.year, now.month, now.day - (index * 7));
          return {
            'date': DateFormat('yyyy-MM-dd').format(date),
            'amount': 2000.0 * (4 - index),
          };
        });
        _timeSeriesYearly = List.generate(5, (index) {
          final now = DateTime.now();
          final date = DateTime(now.year - index, 1, 1);
          return {
            'date': DateFormat('yyyy-MM-dd').format(date),
            'amount': 10000.0 * (5 - index),
          };
        });
      });
    }
  }

  List<BarChartGroupData> _getBarGroups() {
    List<Map<String, dynamic>> timeSeriesData;

    // Select the appropriate time series data based on the selected period
    switch (_selectedPeriod) {
      case 'Week':
        timeSeriesData = _timeSeriesWeekly;
        break;
      case 'Year':
        timeSeriesData = _timeSeriesYearly;
        break;
      case 'Month':
      default:
        timeSeriesData = _timeSeriesMonthly;
        break;
    }

    // Sort data by date
    timeSeriesData.sort((a, b) => a['date'].compareTo(b['date']));

    // Get the maximum value for scaling
    double maxY = 0;
    for (var item in timeSeriesData) {
      if (item['amount'] > maxY) {
        maxY = item['amount'];
      }
    }

    // Generate bar chart groups
    return List.generate(timeSeriesData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: timeSeriesData[index]['amount'].toDouble(),
            color: const Color.fromRGBO(28, 92, 168, 1),
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }

  List<Map<String, dynamic>> _getTopDonors() {
    // Select the appropriate top donors based on the selected period
    switch (_selectedPeriod) {
      case 'Week':
        return _topDonorsWeekly;
      case 'Year':
        return _topDonorsYearly;
      case 'Month':
      default:
        return _topDonorsMonthly;
    }
  }

  Widget _buildFilterDropdown(String value, List<String> items, String label,
      Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item == value && label == 'Currency'
                  ? '${_currencySymbols[item]} $item'
                  : item,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        underline: Container(),
        style: const TextStyle(
          color: Color.fromRGBO(28, 92, 168, 1),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 280,
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(28, 92, 168, 1),
            ),
          ),
        ],
      ),
    );
  }

  // Updated to match the React component's x-axis labels
  String _getXAxisLabel(int value) {
    switch (_selectedPeriod) {
      case 'Week':
        // Match React component's "Week 1", "Week 2", etc. format
        return 'Week ${value + 1}';
      case 'Year':
        // For yearly data, use the actual year from the data
        if (_timeSeriesYearly.isNotEmpty && value < _timeSeriesYearly.length) {
          final sortedData = [..._timeSeriesYearly]
            ..sort((a, b) => a['date'].compareTo(b['date']));
          final date = DateTime.parse(sortedData[value]['date']);
          return date.year.toString();
        }
        // Fallback if data is not available
        final now = DateTime.now();
        return (now.year - (4 - value)).toString();
      case 'Month':
      default:
        // For monthly data, use the month abbreviation from the data
        if (_timeSeriesMonthly.isNotEmpty &&
            value < _timeSeriesMonthly.length) {
          final sortedData = [..._timeSeriesMonthly]
            ..sort((a, b) => a['date'].compareTo(b['date']));
          final date = DateTime.parse(sortedData[value]['date']);
          return DateFormat('MMM')
              .format(date); // Short month name (Jan, Feb, etc.)
        }
        // Fallback if data is not available
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        final now = DateTime.now();
        final monthIndex = (now.month - 1 - (11 - value)) % 12;
        return months[monthIndex];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "REPORTING"),
      endDrawer: EndDrawer(),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchDonationStatistics,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Monthly Donations Chart
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFBE9231).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.insert_chart_rounded,
                                          color: Color(0xFFBE9231),
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          '${_selectedPeriod}ly Donation',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFBE9231),
                                          ),
                                        ),
                                      ],
                                    ),
                                    _buildFilterDropdown(
                                      _selectedPeriod,
                                      _periods,
                                      'Period',
                                      (value) {
                                        if (value != null) {
                                          setState(
                                              () => _selectedPeriod = value);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 400,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Add SUM Amount label like in React component
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        'SUM Amount (${_selectedCurrency})',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: BarChart(
                                        BarChartData(
                                          alignment:
                                              BarChartAlignment.spaceAround,
                                          maxY: _getBarGroups().isEmpty
                                              ? 1000
                                              : null,
                                          barTouchData: BarTouchData(
                                            enabled: true,
                                            touchTooltipData:
                                                BarTouchTooltipData(
                                              tooltipBgColor:
                                                  const Color.fromRGBO(
                                                      28, 92, 168, 1),
                                              getTooltipItem: (group,
                                                  groupIndex, rod, rodIndex) {
                                                return BarTooltipItem(
                                                  '${_currencySymbols[_selectedCurrency]} ${rod.toY.toStringAsFixed(2)}',
                                                  const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                getTitlesWidget: (value, meta) {
                                                  if (value >= 0 &&
                                                      value <
                                                          _getBarGroups()
                                                              .length) {
                                                    return Text(
                                                      _getXAxisLabel(
                                                          value.toInt()),
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    );
                                                  }
                                                  return const Text('');
                                                },
                                              ),
                                            ),
                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                getTitlesWidget: (value, meta) {
                                                  // Format currency values like in React component
                                                  String formattedValue;
                                                  if (_selectedCurrency ==
                                                          'JPY' ||
                                                      _selectedCurrency ==
                                                          'KRW') {
                                                    formattedValue = value
                                                        .toInt()
                                                        .toString();
                                                  } else {
                                                    formattedValue = value
                                                        .toInt()
                                                        .toString();
                                                  }
                                                  return Text(
                                                    '${_currencySymbols[_selectedCurrency]} $formattedValue',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  );
                                                },
                                                reservedSize: 60,
                                              ),
                                            ),
                                            topTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            rightTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                          ),
                                          gridData: FlGridData(
                                            show: true,
                                            drawVerticalLine: false,
                                            horizontalInterval: 2000,
                                            getDrawingHorizontalLine: (value) {
                                              return FlLine(
                                                color: Colors.grey[200],
                                                strokeWidth: 1,
                                              );
                                            },
                                          ),
                                          borderData: FlBorderData(show: false),
                                          barGroups: _getBarGroups(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Currency Selection - Wrapped in a Card
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 600),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Select currency:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(28, 92, 168, 1),
                                ),
                              ),
                              _buildFilterDropdown(
                                _selectedCurrency,
                                _currencies,
                                'Currency',
                                (value) {
                                  if (value != null) {
                                    setState(() => _selectedCurrency = value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Stats Cards Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'TOTAL DONATION',
                                '${_currencySymbols[_selectedCurrency]} ${_totalDonation.toStringAsFixed(2)}',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'AVERAGE DONATION',
                                '${_currencySymbols[_selectedCurrency]} ${_averageDonation.toStringAsFixed(2)}',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Top Donors Card
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 580),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(28, 92, 168, 1)
                                                .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            size: 20,
                                            color:
                                                Color.fromRGBO(28, 92, 168, 1),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'TOP MEMBER DONOR',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  28, 92, 168, 1),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _getTopDonors().isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child:
                                          Text('No top donors data available'),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 16),
                                      itemCount: _getTopDonors().length,
                                      itemBuilder: (context, index) {
                                        final donor = _getTopDonors()[index];
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.grey[200]!,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                          28, 92, 168, 1)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromRGBO(
                                                          28, 92, 168, 1),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      donor['name'] ??
                                                          'Unknown',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                          28, 92, 168, 1)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  '${_currencySymbols[_selectedCurrency]} ${donor['amount']?.toStringAsFixed(2) ?? '0.00'}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        28, 92, 168, 1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
