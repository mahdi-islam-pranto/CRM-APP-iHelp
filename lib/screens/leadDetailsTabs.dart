import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../resourses/resourses.dart';

class AllLeadList extends StatefulWidget {
  const AllLeadList({Key? key}) : super(key: key);

  @override
  State<AllLeadList> createState() => _AllLeadListState();
}

class _AllLeadListState extends State<AllLeadList> {
  final _dateController = TextEditingController();
  final _testController = TextEditingController();
  List<bool> isSelected = List.generate(6, (_) => false);

  @override
  void dispose() {
    _dateController.dispose();
    _testController.dispose();
    super.dispose();
  }

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Number of tabs
      child: Scaffold(
        backgroundColor: R.appColors.white,
        appBar: AppBar(
          actions: [
            Builder(
              builder: (context) {
                double screenWidth = MediaQuery.of(context).size.width;
                double avatarRadius =
                    screenWidth * 0.05; // Adjust radius based on screen width
                double iconSize = screenWidth *
                    0.045; // Adjust icon size based on screen width
                double padding =
                    screenWidth * 0.025; // Adjust padding based on screen width

                return Padding(
                  padding: EdgeInsets.all(padding), // Use calculated padding
                  child: CircleAvatar(
                    radius: avatarRadius, // Use calculated radius
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        color: R.appColors.grey,
                        size: iconSize, // Use calculated icon size
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          title: const Text("Details Page"),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18, // Replace with the desired custom icon
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: R.appColors.buttonColor,
            labelColor: R.appColors.buttonColor,
            unselectedLabelColor: R.appColors.grey,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Ticket'),
              Tab(text: 'Task'),
              Tab(text: 'Follow Up'),
              Tab(text: 'Note'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              // Overview
              SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'skkkkk',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.call, color: Colors.white),
                              label: Text('Call'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.message, color: Colors.blue),
                              label: Text('Message'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(thickness: 1.5, height: 20),
                        _buildInfoRow('Contact Score', '40'),
                        _buildInfoRow('Lead Quality', '4/10'),
                        _buildInfoRow('Lead Owner', 'Mehedi Hasan Shamim'),
                        _buildInfoRow('Lead Pipeline', 'Demo'),
                        _buildInfoRow('Contact Status', 'Lead'),
                        _buildInfoRow('Lead Creator', 'Mehedi Hasan Shamim'),
                        _buildInfoRow('Lead Age', '7 Days'),
                      ],
                    ),
                  ),
                ),
              ),

              SingleChildScrollView(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.white.withOpacity(0.5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.blue.withOpacity(0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.04),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Custom buttons
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(6, (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TaskContainer(
                                    text: 'Task ${index}',
                                    isSelected: isSelected[index],
                                    onTap: () {
                                      setState(() {
                                        isSelected[index] = !isSelected[index];
                                      });
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),

                          ListTile(
                            title: Text("Sk Bhai"),
                            subtitle: Text("+88 01733364274"),
                            trailing: Builder(
                              builder: (context) {
                                double screenWidth =
                                    MediaQuery.of(context).size.width;
                                double avatarRadius = screenWidth *
                                    0.05; // Adjust radius based on screen width
                                double iconSize = screenWidth *
                                    0.05; // Adjust icon size based on screen width
                                double spacing = screenWidth *
                                    0.02; // Adjust spacing based on screen width

                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: avatarRadius,
                                      backgroundColor: Colors.grey[200],
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.call,
                                          color: Colors.green,
                                          size: iconSize,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: spacing),
                                    CircleAvatar(
                                      radius: avatarRadius,
                                      backgroundColor: Colors.grey[200],
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.phone_disabled,
                                          color: Colors.red,
                                          size: iconSize,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: spacing),
                                    CircleAvatar(
                                      radius: avatarRadius,
                                      backgroundColor: Colors.grey[200],
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.mark_email_read,
                                          color: Colors.blue,
                                          size: iconSize,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Divider(
                            thickness: 1.5,
                            height: MediaQuery.of(context).size.height * 0.03,
                            color: Colors.grey[400],
                          ),
                          _buildInfoRow('Contact Score', '40'),
                          _buildInfoRow('Lead Quality', '4/10'),
                          _buildInfoRow('Lead Owner', 'Sk Nayeem Ur Rahman'),
                          _buildInfoRow('Lead Pipeline', 'Demo'),
                          _buildInfoRow('Contact Status', 'Lead'),
                          _buildInfoRow('Lead Creator', 'Sk Nayeem Ur Rahman'),
                          _buildInfoRow('Lead Age', '7 Days'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Other tabs (Ticket, Task, Follow Up, Note) would be implemented similarly
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskContainer extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TaskContainer({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.blueGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
