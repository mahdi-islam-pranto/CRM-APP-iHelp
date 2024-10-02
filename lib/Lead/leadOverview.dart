import 'package:flutter/material.dart';

import '../resourses/app_colors.dart';

class LeadOverview extends StatefulWidget {
  const LeadOverview({super.key});

  @override
  State<LeadOverview> createState() => _LeadOverviewState();
}

class _LeadOverviewState extends State<LeadOverview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0x300D6EFD),
                    radius: 50,
                    child: Icon(
                      Icons.person_2_outlined,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "MM Organic Farm",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Mahdi Islam",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Phone: 01610681903",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Email: mahdipranto2020@gmail.com",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Lead Information Section
            Card(
              color: Colors.blue[100],
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text("Lead Information",
                    style: Theme.of(context).textTheme.titleLarge),
                subtitle: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text("Lead Type: Organic"),
                    Text("Lead Status: Open"),
                    Text("Lead Source: Facebook"),
                    Text("Lead Date: 2022-08-08"),
                  ],
                ),
              ),
            ),

            // Assign Users Section
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text("Assigned Users",
                    style: Theme.of(context).textTheme.titleLarge),
                subtitle: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text("Assign to: Mehedi Hasan Obama"),
                    Text("Associate To: Osama Bin Laden"),
                  ],
                ),
              ),
            ),

            // Description Section
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text("Description",
                    style: Theme.of(context).textTheme.titleLarge),
                subtitle: const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "This is a detailed description of the lead. Here you can provide more information about the lead and any other relevant details that might be useful.",
                  ),
                ),
              ),
            ),

            // Bottom Section (Optional actions or additional info)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Delete lead
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(164, 52),
                        maximumSize: const Size(181, 52),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.redAccent, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "DELETE LEAD",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                  const SizedBox(
                    width: 11,
                  ),

                  // update lead
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(164, 52),
                      maximumSize: const Size(181, 52),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("EDIT LEAD",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
