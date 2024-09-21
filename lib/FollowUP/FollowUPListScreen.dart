import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../Dashboard/bottom_navigation_page.dart';
import '../resourses/resourses.dart';
import 'followUpCreateForm.dart';

class FollowUpList extends StatefulWidget {
  const FollowUpList({super.key});

  @override
  State<FollowUpList> createState() => _FollowUpListState();
}

class _FollowUpListState extends State<FollowUpList> {
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: [
          Positioned(
            child: AnimatedFloatingActionButton(
              key: key,
              fabButtons: <Widget>[
                _createLead(), // Now we have two FABs
                _viewLeads(),
              ],
              colorStartAnimation: Colors.white,
              colorEndAnimation: Colors.red,
              animatedIconData: AnimatedIcons.menu_close,
            ),
          ),
        ],
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
          onPressed: () {
            showAnimatedDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return const BottomNavigationPage();
              },
              curve: Curves.fastOutSlowIn,
              duration: const Duration(seconds: 1),
            );
          },
        ),
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ),
        title: Container(
          height: 35,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text('Follow Up List'),
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Follow Up List'),
      ),
    );
  }

  Widget _createLead() {
    return FloatingActionButton(
      onPressed: () {
        showAnimatedDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return const FollowUpCreate();
          },
          curve: Curves.fastOutSlowIn,
          duration: const Duration(seconds: 1),
        );
      },
      heroTag: "Create Follow Up",
      tooltip: 'Create Lead',
      backgroundColor: R.appColors.buttonColor,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ), // Change this color if needed
    );
  }

  Widget _viewLeads() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          // Add your view leads logic here
        },
        heroTag: "View Leads",
        tooltip: 'View Leads',
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.list,
          color: Colors.white,
        ),
      ),
    );
  }
}
