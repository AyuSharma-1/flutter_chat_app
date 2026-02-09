import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ayush"),
    
      ),
      body: Column(
        children: [
          Text("Ayush"),
          Text('1data'),
          Text('2data'),
          Text('3data'),
          Text('4data'),
          Text('5data'),
          Text('6data'),
          Text('7data'),
          Text('8data'),
          Text('9data'),
          Text('10data'),
        ],
      ),
    );
  }
}