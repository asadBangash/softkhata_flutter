import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:soft_khata_flutter/bloc/entry/edit_entry/edit_entry_cubit.dart';
import 'package:soft_khata_flutter/bloc/entry/edit_entry/edit_entry_states.dart';
import 'package:soft_khata_flutter/components/loading_dialog.dart';
import 'package:soft_khata_flutter/components/snackbar.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/utils/login_preferences.dart';

class EditEntryScreen extends StatefulWidget {

  var arguments;
  EditEntryScreen({this.arguments});

  @override
  _EditEntryScreenState createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  final _balanceController = TextEditingController();
  final _desController = TextEditingController();
  final _dateTimeController = TextEditingController();

  final format = new DateFormat('yyyy-MM-dd');
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _balanceController.text = widget.arguments["balance"];
    _desController.text = widget.arguments["description"];
    _dateTimeController.text = widget.arguments["time"];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {Navigator.pop(context); },
          child: Icon(
            Icons.keyboard_backspace_outlined,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          "Edit Entry",
          style: TextStyle(
              color: Theme.of(context).primaryColor
          ),
        ),
        elevation: 1.5,
        backgroundColor: ThemeColors.COLOR_WHITE,
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
            controller: _balanceController,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Enter Balance',
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
            controller: _desController,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Enter Description',
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
            controller: _dateTimeController,
            maxLines: 1,
            onTap: () { _selectDateAndTime(context); },
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Enter Date and Time',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: BlocConsumer<EditEntryCubit, EditEntryStates>(
            listener: (_, state) {
              if(state is EditEntrySuccess) {
                Navigator.pop(context);
                loading(context, false);
              } else if(state is EditEntryError) {
                loading(context, false);
                errorSnackBar(context, message: state.message);
              } else {
                loading(context, true);
              }
            },
            builder: (_, state) {
              return SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
                    child: MaterialButton(
                      onPressed: () {
                        if(validation()) {
                          final body = {
                            "userId" : LoginPreferences.getUserId(),
                            "_id": widget.arguments["entryId"],
                            "customerId": widget.arguments["customerId"],
                            "description": _desController.text,
                            "balance": _balanceController.text,
                            "entryType": widget.arguments["entryType"],
                            "time": _dateTimeController.text
                          };
                          context.read<EditEntryCubit>().editEntry(jsonEncode(body));
                        }
                      },
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Save Changes",
                        style: TextStyle(color: ThemeColors.COLOR_WHITE),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool validation() {
    if(_balanceController.text.isEmpty) {
      snackBar(context, message: "Balance should not be empty");
      return false;
    } else if(_desController.text.isEmpty) {
      snackBar(context, message: "Description should not be empty");
      return false;
    } else if(_dateTimeController.text.isEmpty) {
      snackBar(context, message: "Date and Time should not be empty");
      return false;
    } else {
      return true;
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: new DateTime.now().subtract(Duration(days: 7)),
      lastDate: new DateTime.now(),
    );

    if(picked != null && picked != _date) {
      print('Date selected: ${_date.toString()}');
      setState((){
        _date = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null && picked != _time) {
      print('Time selected: ${_time.toString()}');
      setState(() {
        _time = picked;
      });
    }
  }

  Future<Null> _selectDateAndTime(BuildContext context) async {
    await _selectDate(context);
    await _selectTime(context);
    _dateTimeController.text = "${format.format(_date)}, ${_time.format(context)}";
  }
}