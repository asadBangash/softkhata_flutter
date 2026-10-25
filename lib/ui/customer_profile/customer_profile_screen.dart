import 'package:flutter/material.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';

class CustomerProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {Navigator.pop(context); },
          child: Icon(
            Icons.keyboard_backspace_outlined,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          "Customer Profile",
          style: TextStyle(
              color: Theme.of(context).primaryColor
          ),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: initScreen(),
    );
  }

  Widget initScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          margin: EdgeInsets.only(top: 30, left: 15, right: 15),
          child: TextField(
            cursorColor: Theme.of(context).primaryColor,
            keyboardType: TextInputType.number,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Enter Customer Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          margin: EdgeInsets.only(top: 20, left: 15, right: 15),
          child: TextField(
            cursorColor: Theme.of(context).primaryColor,
            keyboardType: TextInputType.text,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Enter Mobile Number',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: MaterialButton(
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            child: Text("Save Changes", style: TextStyle(color: ThemeColors.COLOR_WHITE),),
          ),
        ),
      ],
    );
  }
}