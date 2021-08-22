import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.signal_wifi_off_outlined, size: 40,),
              Text("You are offline", style: TextStyle(
               fontSize: 30,
                fontWeight: FontWeight.w600
              )),
              Text("It seems there is problem with your connection. Please check you network status", style: TextStyle(
                fontSize: 17,
                color: Colors.black54,
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
