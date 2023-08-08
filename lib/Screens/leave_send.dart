import 'package:flutter/material.dart';
import '../settings/colors.dart';
import '../applications/applications.dart';
import '../functions/leave_send_func.dart';
class leave_send extends StatefulWidget {
  const leave_send({super.key});

  @override
  State<leave_send> createState() => _leave_sendState();
}

class _leave_sendState extends State<leave_send> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: custom_Colors.appbar_color,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: Applications.application.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      date_select(
                        context,
                        Applications.application[index].toString(),
                      );
                    },
                    title: Text(
                      Applications.application[index],
                    ),
                    trailing: const Icon(
                      Icons.forward_to_inbox_outlined,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
