import 'package:flutter/material.dart';
import 'package:ffwpu_flutter_view/api/ApiService.dart';
import 'package:ffwpu_flutter_view/components/end_drawer.dart';
import 'package:ffwpu_flutter_view/components/app_bar.dart';

class ViewWorshipEvent extends StatefulWidget {
  final String eventId;

  const ViewWorshipEvent({Key? key, required this.eventId}) : super(key: key);

  @override
  State<ViewWorshipEvent> createState() => _ViewWorshipEventState();
}

class _ViewWorshipEventState extends State<ViewWorshipEvent> {
  final _apiService = ApiService();
  List<Map<String, dynamic>> attendees = [];
  List<Map<String, dynamic>> guests = [];
  Map<String, dynamic> worshipInfo = {};
  String church = '';
  List<dynamic> images = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  Future<void> fetchEventData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Replace the direct HTTP call with ApiService call
      final data = await _apiService.fetchWorshipEvent(widget.eventId);

      if (data != null) {
        setState(() {
          // Process attendees data if it exists
          if (data['Attendees'] != null) {
            guests = List<Map<String, dynamic>>.from(
                data['Attendees'].where((a) => a['Type'] == 'Guest').toList());

            final members =
                data['Attendees'].where((a) => a['Type'] == 'Member').toList();

            if (members.isNotEmpty) {
              attendees = List<Map<String, dynamic>>.from(members.map((a) => {
                    'ID': a['Member']['ID'],
                    'Full Name': a['Member']['Full Name'],
                  }));
            }
          } else {
            guests = [];
            attendees = [];
          }

          worshipInfo = data;
          church = data['Church']?['Name'] ?? '';
          images = data['Images'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch event information';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print('Error fetching worship event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "EVENT INFORMATION"),
      backgroundColor: const Color.fromRGBO(248, 250, 252, 1),
      endDrawer: EndDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Attendance Tables
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Member Attendees',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFCBCBCB)),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: AnotherTable(
                                  data: attendees,
                                  columns: ['Full Name'],
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Guest Attendees',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFCBCBCB)),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: AnotherTable(
                                  data: guests,
                                  columns: ['Full Name'],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Worship Event Details
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Worship Event Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              DetailField(
                                label: 'Worship ID',
                                value: worshipInfo['ID']?.toString() ?? '-',
                              ),
                              const SizedBox(height: 12),
                              DetailField(
                                label: 'Event Name',
                                value: worshipInfo['Event Name']?.toString() ??
                                    '-',
                              ),
                              const SizedBox(height: 12),
                              DetailField(
                                label: 'Date',
                                value: worshipInfo['Date']?.toString() ?? '-',
                              ),
                              const SizedBox(height: 12),
                              DetailField(
                                label: 'Worship Type',
                                value:
                                    worshipInfo['Worship Type']?.toString() ??
                                        '-',
                              ),
                              const SizedBox(height: 12),
                              DetailField(
                                label: 'Church',
                                value: church,
                              ),

                              // Images
                              if (images.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                const Text(
                                  'Event Images',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...images.map((image) {
                                  final src = image['url'] ??
                                      image['photoUrl'] ??
                                      image['photo'] ??
                                      '';
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        src,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 150,
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child:
                                                  Text('Failed to load image'),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
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

class AnotherTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final List<String> columns;
  final Function(Map<String, dynamic>)? onRowSelect;
  final Function(Map<String, dynamic>)? onRowDoubleTap;
  final String? idName;

  const AnotherTable({
    Key? key,
    required this.data,
    required this.columns,
    this.onRowSelect,
    this.onRowDoubleTap,
    this.idName,
  }) : super(key: key);

  @override
  State<AnotherTable> createState() => _AnotherTableState();
}

class _AnotherTableState extends State<AnotherTable> {
  int? selectedRowIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table Header
        Container(
          color: const Color(0xFF1C5CA8),
          child: Row(
            children: widget.columns.map((header) {
              return Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text(
                    header,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Table Body
        Expanded(
          child: ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              final row = widget.data[index];
              final isSelected = selectedRowIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRowIndex = index;
                  });
                  if (widget.onRowSelect != null) {
                    widget.onRowSelect!(row);
                  }
                },
                onDoubleTap: () {
                  if (widget.onRowDoubleTap != null && widget.idName != null) {
                    widget.onRowDoubleTap!(row);
                  }
                },
                child: Container(
                  color: isSelected ? const Color(0xFFE7E6E6) : Colors.white,
                  child: Row(
                    children: widget.columns.map((header) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: Text(
                            row[header]?.toString() ?? '-',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DetailField extends StatelessWidget {
  final String label;
  final String value;

  const DetailField({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade400,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
