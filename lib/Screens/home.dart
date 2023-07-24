import 'package:flutter/material.dart';
import '../settings/colors.dart';
import '../tabs/announce.dart';
import '../tabs/student_leave.dart';
import '../tabs/teacher_leave.dart';
import '../widgets/floating_action.dart';
import '../widgets/info_drawer.dart';
class home extends StatefulWidget {
 final bool userType;
  const home({super.key, required this.userType});
  @override
  State<home> createState() => _homeState();
}
class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        drawer: info_drawer(
          userType: widget.userType,
        ),
        appBar: AppBar(
          title: Text(
            'GGCSF ${widget.userType ? 'Teacher' : 'student'}',
          ),
          titleTextStyle: TextStyle(
            color: custom_Colors.labelColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
          backgroundColor: custom_Colors.appbar_color,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Notice',
              ),
              Tab(
                text: 'Leave',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            announcement(
              userType: widget.userType,
            ),
            widget.userType ? const teacher_leave() : const student_leave()
          ],
        ),
        floatingActionButton: student_floating_action(
          usertype: widget.userType,
        ),
      ),
    );
  }
}
