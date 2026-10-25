import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/components/loading_dialog.dart';
import 'package:soft_khata_flutter/components/snackbar.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/utils/login_preferences.dart';
import 'package:soft_khata_flutter/utils/shared_preferences.dart';

import '../../bloc/customer/edit_customer/edit_customer_cubit.dart';
import '../../bloc/customer/edit_customer/edit_customer_states.dart';

class EditCustomerScreen extends StatefulWidget {

  var arguments;
  EditCustomerScreen({this.arguments});


  @override
  State<StatefulWidget> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomerScreen> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.arguments["customerName"];
    _numberController.text = widget.arguments["number"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () { Navigator.pop(context); },
          child: Icon(
            Icons.keyboard_backspace_outlined,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          "Edit Customer",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        elevation: 1.5,
        backgroundColor: Theme.of(context).backgroundColor,
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
            controller: _nameController,
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
            controller: _numberController,
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
        BlocConsumer<EditCustomerCubit, EditCustomerStates>(
          listener: (_, state) {
            if(state is EditCustomerSuccess) {
              loading(context, false);
              Navigator.pushNamedAndRemoveUntil(context, RoutesName.dashboard, (route) => false);
            } else if(state is EditCustomerError) {
              errorSnackBar(context, message: state.message);
              loading(context, false);
            } else {
              loading(context, true);
            }
          },
          builder: (_, state) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: MaterialButton(
                onPressed: () {
                  if(validation()) {
                    final body = {
                      "_id" : widget.arguments["customerId"],
                      "user" : LoginPreferences.getUserId(),
                      "name" : _nameController.text,
                      "number" : _numberController.text
                    };
                    context.read<EditCustomerCubit>().editCustomer(jsonEncode(body),);
                  } else {
                    return;
                  }
                },
                color: Theme.of(context).primaryColor,
                child: Text("Save Changes", style: TextStyle(color: ThemeColors.COLOR_WHITE),),
              ),
            );
          },
        ),
      ],
    );
  }

  bool validation() {
    if(_nameController.text.isEmpty) {
      snackBar(context, message: "Name must not be empty");
      return false;
    } else if(_numberController.text.isEmpty) {
      snackBar(context, message: "Mobile number must not be empty");
      return false;
    } else {
      return true;
    }
  }
}