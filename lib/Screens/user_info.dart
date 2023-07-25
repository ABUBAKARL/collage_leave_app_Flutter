import 'package:flutter/material.dart';

import '../widgets/details_chip.dart';

class user_info extends StatefulWidget {
  final String name;
  final String gmail;
  final String profile;
  final int rollno;
  final int semester;
  const user_info({
    super.key,
    required this.name,
    required this.gmail,
    required this.profile,
    required this.rollno,
    required this.semester,
  });

  @override
  State<user_info> createState() => user_infoState();
}

class user_infoState extends State<user_info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[400],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.purple.withOpacity(0.5),
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                radius: 75,
                backgroundImage: NetworkImage(widget.profile),
              ),
            ),
          ),
          details_chip(
            data: widget.name,
          ),
          details_chip(
            data: widget.gmail,
          ),
          details_chip(
            data: 'Semester # ${widget.semester}',
          ),
          details_chip(
            data: 'Roll # ${widget.rollno}',
          ),
        ],
      ),
    );
  }
}
