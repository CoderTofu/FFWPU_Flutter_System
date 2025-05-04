import 'package:flutter/material.dart';
import 'package:ffwpu_flutter_view/components/end_drawer.dart';
import 'package:ffwpu_flutter_view/components/app_bar.dart';

class MemberDetailPage extends StatefulWidget {
  final String memberID;

  const MemberDetailPage({Key? key, required this.memberID}) : super(key: key);

  @override
  _MemberDetailPageState createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> userData = {};
  List<dynamic> userBlessings = [];
  late TabController _tabController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load dummy data instead of fetching from API
    loadDummyData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void loadDummyData() {
    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        userData = {
          'Full Name': 'Jane Doe',
          'Membership Category': 'Regular',
          'Generation': '1st',
          'Email': 'janedoe@gmail.com',
          'Phone': '09991112345',
          'Gender': 'Female',
          'Date Of Birth': '12 April 2000',
          'Age': '25',
          'Country': 'Philippine',
          'Marital Status': 'Single',
          'Address': '1738 Bato St., Tondo, Manila',
          'Spiritual Birthday': '18 July 2024',
          'Spiritual Parent': 'Zhu Yuan'
        };

        userBlessings = [
          {
            'Name Of Blessing': 'First Blessing',
            'Blessing Date': '15 August 2010'
          },
          {
            'Name Of Blessing': 'Marriage Blessing',
            'Blessing Date': '22 February 2015'
          },
          {
            'Name Of Blessing': 'Family Blessing',
            'Blessing Date': '30 November 2018'
          }
        ];

        isLoading = false;
      });
    });
  }

  Widget infoField(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value ?? '—',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "MEMBER INFORMATION"),
      backgroundColor: const Color(0xFFD9D9D9),
      endDrawer: EndDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Header
                            Center(
                              child: Column(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 96,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      child: Text(
                                        userData['Full Name'] != null
                                            ? userData['Full Name']
                                                .substring(0, 1)
                                            : 'U',
                                        style: TextStyle(
                                          fontSize: 36,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Name
                                  Text(
                                    userData['Full Name'] ?? 'Unknown Member',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  // Badges
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      Chip(
                                        backgroundColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        label: Text(
                                            userData['Membership Category'] ??
                                                'Unknown'),
                                      ),
                                      Chip(
                                        backgroundColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        label: Text(
                                            'Generation: ${userData['Generation'] ?? 'Unknown'}'),
                                      ),
                                    ],
                                  ),

                                  // Contact Info
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.email,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        userData['Email'] ?? 'No email',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.phone,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        userData['Phone'] ?? 'No phone',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Tabs
                            TabBar(
                              controller: _tabController,
                              tabs: const [
                                Tab(text: 'Personal'),
                                Tab(text: 'Spiritual'),
                                Tab(text: 'History'),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Tab Content
                            SizedBox(
                              height: 450, // Adjust based on content
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // Personal Tab
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Personal Information',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFFBE9231),
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Grid layout for personal info
                                        GridView.count(
                                          crossAxisCount: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 3
                                              : 1,
                                          childAspectRatio: MediaQuery.of(
                                                          context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 4
                                              : 5, // Increased ratio for more compact layout
                                          mainAxisSpacing:
                                              8, // Reduced spacing between rows
                                          crossAxisSpacing:
                                              12, // Reduced spacing between columns
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            infoField(
                                                'Gender', userData['Gender']),
                                            infoField('Date of Birth',
                                                userData['Date Of Birth']),
                                            infoField('Age',
                                                userData['Age']?.toString()),
                                            infoField(
                                                'Nation', userData['Country']),
                                            infoField('Marital Status',
                                                userData['Marital Status']),
                                          ],
                                        ),

                                        const SizedBox(height: 16),
                                        infoField(
                                            'Address', userData['Address']),
                                        const SizedBox(height: 6),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.location_on,
                                                size: 16, color: Colors.grey),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                userData['Address'] ??
                                                    'No address',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Spiritual Tab
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Spiritual Information',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFFBE9231),
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Grid layout for spiritual info
                                        GridView.count(
                                          crossAxisCount: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 2
                                              : 1,
                                          childAspectRatio: MediaQuery.of(
                                                          context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 4
                                              : 5, // Increased ratio for more compact layout
                                          mainAxisSpacing:
                                              8, // Reduced spacing between rows
                                          crossAxisSpacing:
                                              12, // Reduced spacing between columns
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            infoField('Generation',
                                                userData['Generation']),
                                            infoField('Spiritual Birthday',
                                                userData['Spiritual Birthday']),
                                            infoField(
                                                'Membership Category',
                                                userData[
                                                    'Membership Category']),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Spiritual Parents',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  userData[
                                                          'Spiritual Parent'] ??
                                                      '—',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 20),
                                        Text(
                                          'Blessings',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFFBE9231),
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        // Blessings list
                                        ...userBlessings
                                            .map((blessing) => Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 8),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.emoji_events,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 20,
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              blessing[
                                                                      'Name Of Blessing'] ??
                                                                  'Unknown Blessing',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 2),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .calendar_today,
                                                                    size: 12,
                                                                    color: Colors
                                                                        .grey),
                                                                const SizedBox(
                                                                    width: 4),
                                                                Text(
                                                                  blessing[
                                                                          'Blessing Date'] ??
                                                                      'Unknown Date',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                      ],
                                    ),
                                  ),

                                  // History Tab - Now with dummy mission history data
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mission History',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFFBE9231),
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Dummy mission history items
                                        _buildMissionHistoryItem(
                                            role: 'Volunteer Coordinator',
                                            organization:
                                                'Community Outreach Program',
                                            country: 'United States',
                                            date: 'Jan 2020 - Present'),

                                        _buildMissionHistoryItem(
                                            role: 'Youth Mentor',
                                            organization:
                                                'Youth Leadership Foundation',
                                            country: 'Canada',
                                            date: 'Mar 2018 - Dec 2019'),

                                        _buildMissionHistoryItem(
                                            role: 'Assistant Director',
                                            organization:
                                                'International Peace Initiative',
                                            country: 'South Korea',
                                            date: 'Jun 2015 - Feb 2018'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMissionHistoryItem({
    required String role,
    required String organization,
    required String country,
    required String date,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 4,
            ),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.work,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        organization,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  padding: const EdgeInsets.all(4),
                  backgroundColor: Colors.grey[100],
                  label: Text(country),
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
