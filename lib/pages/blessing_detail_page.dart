import 'package:flutter/material.dart';
import 'package:ffwpu_flutter_view/api/ApiService.dart';
import 'package:ffwpu_flutter_view/components/app_bar.dart';
import 'package:ffwpu_flutter_view/components/end_drawer.dart';
import 'package:ffwpu_flutter_view/components/data_table.dart';
import 'package:ffwpu_flutter_view/components/table_config.dart';

class ViewBlessingPage extends StatefulWidget {
  final String blessingId;

  const ViewBlessingPage({Key? key, required this.blessingId})
      : super(key: key);

  @override
  State<ViewBlessingPage> createState() => _ViewBlessingPageState();
}

class _ViewBlessingPageState extends State<ViewBlessingPage> {
  final _apiService = ApiService();
  List<Map<String, dynamic>> members = [];
  List<String> memberIds = [];
  List<Map<String, dynamic>> guests = [];
  List<Map<String, dynamic>> newGuests = [];
  Map<String, dynamic> formData = {
    'name_of_blessing': '',
    'blessing_date': '',
    'chaenbo': '',
  };
  final Map<String, int> chaenboMap = {'Vertical': 1, 'Horizontal': 2};

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchBlessingData();
  }

  Future<void> fetchBlessingData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      print('Fetching blessing data for ID: ${widget.blessingId}');
      final data = await _apiService.fetchBlessing(widget.blessingId);

      if (data != null) {
        print('Successfully received blessing data: $data');
        setState(() {
          // Safely process Recipients
          if (data['Recipients'] != null) {
            final List<dynamic> recipients =
                data['Recipients'] as List<dynamic>;

            // Process guests with explicit casting
            final guestsList = recipients
                .where((attendee) => attendee['Type'] == 'Guest')
                .toList();

            guests = guestsList.map((guest) {
              // Ensure we're working with a Map<String, dynamic>
              final Map<String, dynamic> guestMap =
                  Map<String, dynamic>.from(guest);
              return {
                'ID': guestMap['ID']?.toString() ?? '',
                'Type': guestMap['Type'] ?? '',
                'Full Name': guestMap['Full Name'] ?? guestMap['Name'] ?? '',
                'Email': guestMap['Email'] ?? '',
              };
            }).toList();

            // Process members with explicit casting
            final membersList = recipients
                .where((attendee) => attendee['Type'] == 'Member')
                .toList();

            members = membersList.map((member) {
              // Ensure we're working with a Map<String, dynamic>
              final Map<String, dynamic> memberMap =
                  Map<String, dynamic>.from(member);
              final Map<String, dynamic> memberData =
                  memberMap['Member'] != null
                      ? Map<String, dynamic>.from(memberMap['Member'])
                      : <String, dynamic>{};

              return {
                'ID': memberData['ID']?.toString() ?? '',
                'Full Name': memberData['Full Name'] ?? '',
                'attendee_id': memberMap['ID']?.toString() ?? '',
                'Member ID': memberData['ID']?.toString() ?? '',
              };
            }).toList();
          } else {
            // Handle case where Recipients is null
            print('No Recipients found in blessing data');
            guests = [];
            members = [];
          }

          // Set form data with safe access
          formData = {
            'name_of_blessing': data['Name']?.toString() ?? '',
            'blessing_date': data['Date']?.toString() ?? '',
            'chaenbo': data['Chaenbo']?.toString() ?? '',
          };

          isLoading = false;
        });
      } else {
        print('Received null blessing data');
        setState(() {
          errorMessage = 'Failed to fetch blessing information';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error in fetchBlessingData: $e');
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "VIEW BLESSING"),
      endDrawer: EndDrawer(),
      backgroundColor: const Color.fromRGBO(248, 250, 252, 1),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchBlessingData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Content
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 800) {
                            // Desktop layout (side by side)
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildAttendeesSection()),
                                const SizedBox(width: 16),
                                Expanded(child: _buildBlessingDetailsSection()),
                              ],
                            );
                          } else {
                            // Mobile layout (stacked)
                            return Column(
                              children: [
                                _buildAttendeesSection(),
                                const SizedBox(height: 16),
                                _buildBlessingDetailsSection(),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildAttendeesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
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
              border: Border.all(color: const Color(0xFFCBCBCB)),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                ),
              ],
            ),
            child: members.isEmpty
                ? const Center(child: Text('No member attendees'))
                : CustomTable(
                    data: members,
                    config: TableConfig(
                      columns: [
                        TableColumn(
                          key: 'ID',
                          header: 'ID',
                          width: 100,
                          textAlign: TextAlign.left,
                        ),
                        TableColumn(
                          key: 'Full Name',
                          header: 'Full Name',
                          width: 200,
                          textAlign: TextAlign.left,
                        ),
                      ],
                      responsiveColumns: {
                        'lg': ['ID', 'Full Name'],
                        'md': ['ID', 'Full Name'],
                        'sm': ['Full Name'],
                      },
                    ),
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
              border: Border.all(color: const Color(0xFFCBCBCB)),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                ),
              ],
            ),
            child: guests.isEmpty
                ? const Center(child: Text('No guest attendees'))
                : CustomTable(
                    data: guests,
                    config: TableConfig(
                      columns: [
                        TableColumn(
                          key: 'Full Name',
                          header: 'Full Name',
                          width: 200,
                          textAlign: TextAlign.left,
                        ),
                        TableColumn(
                          key: 'Email',
                          header: 'Email',
                          width: 200,
                          textAlign: TextAlign.left,
                        ),
                      ],
                      responsiveColumns: {
                        'lg': ['Full Name', 'Email'],
                        'md': ['Full Name', 'Email'],
                        'sm': ['Full Name'],
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlessingDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Blessing',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Name field
          const Text(
            'Name',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: formData['name_of_blessing'],
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Enter Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: Color(0xFF01438F),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: Color(0xFF01438F),
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),

          // Date field
          const SizedBox(height: 20),
          const Text(
            'Date',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: formData['blessing_date'],
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'MM/DD/YYYY',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: Color(0xFF01438F),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: Color(0xFF01438F),
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),

          // Chaenbo/HTM radio buttons
          const SizedBox(height: 32),
          const Text(
            'Chaenbo/HTM',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio(
                value: 'Vertical',
                groupValue: formData['chaenbo'],
                onChanged: null, // Disabled
              ),
              const Text('Vertical'),
            ],
          ),
          Row(
            children: [
              Radio(
                value: 'Horizontal',
                groupValue: formData['chaenbo'],
                onChanged: null, // Disabled
              ),
              const Text('Horizontal'),
            ],
          ),
        ],
      ),
    );
  }
}
