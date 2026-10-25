import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/profile/edit_profile/edit_profile_cubit.dart';
import 'package:soft_khata_flutter/bloc/profile/edit_profile/edit_profile_states.dart';
import 'package:soft_khata_flutter/components/loading_dialog.dart';
import 'package:soft_khata_flutter/components/snackbar.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/ui/settings/settings_screen.dart';
import 'package:soft_khata_flutter/utils/app_constants.dart';
import 'package:soft_khata_flutter/utils/login_preferences.dart';
import 'package:soft_khata_flutter/utils/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  var argument;
  EditProfileScreen({this.argument});

  @override
  State<StatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileScreen> {

  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _businessCatController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mobileNumberController.text = widget.argument[AppConstants.mobileNumber];
    _businessNameController.text = widget.argument[AppConstants.businessName];
    _businessCatController.text = widget.argument[AppConstants.businessCat];
    _nameController.text = widget.argument[AppConstants.fullname];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {Navigator.pop(context); },
          child: Icon(
            Icons.keyboard_backspace_outlined,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
              color: Theme.of(context).primaryColor
          ),
        ),
        elevation: 1.5,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      floatingActionButton: BlocConsumer<EditProfileCubit, EditProfileStates>(
        listener: (_, state) {
          if(state is EditProfileError) {
            loading(context, false);
            errorSnackBar(context, message: state.message);
          } else if(state is EditProfileSuccess) {
            loading(context, false);
            Future.delayed(Duration.zero, () {
              Navigator.pop(context);
            });
          } else {
            loading(context, true);
          }
        },
        builder: (_, state) {
          return FloatingActionButton(
            backgroundColor: ThemeColors.COLOR_GREEN,
            onPressed: () {
              final body = {
                "userId" : LoginPreferences.getUserId(),
                "name" : _nameController.text,
                "email" : widget.argument[AppConstants.email],
                "number" : _mobileNumberController.text,
                "businessName" : _businessNameController.text,
                "businessCategory" : _businessCatController.text
              };
              context.read<EditProfileCubit>().getProfile(jsonEncode(body));
            },
            child: Icon(
              Icons.done,
              color: ThemeColors.COLOR_WHITE,
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: initScreen(),
      ),
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
          margin: EdgeInsets.only(top: 30, left: 17, right: 17),
          child: TextField(
            keyboardType: TextInputType.number,
            controller: _mobileNumberController,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Change Mobile Number',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          margin: EdgeInsets.only(top: 20, left: 17, right: 17),
          child: TextField(
            keyboardType: TextInputType.text,
            controller: _businessNameController,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Business Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          margin: EdgeInsets.only(top: 20, left: 17, right: 17),
          child: TextField(
            keyboardType: TextInputType.text,
            maxLines: 1,
            controller: _businessCatController,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Business Category',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          margin: EdgeInsets.only(top: 20, left: 17, right: 17),
          child: TextField(
            keyboardType: TextInputType.text,
            controller: _nameController,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Owner Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  bool validation() {
    if(_mobileNumberController.text.isEmpty) {
      snackBar(context, message: "Mobile must not be empty");
      return false;
    } else if(_businessNameController.text.isEmpty) {
      snackBar(context, message: "Business name must not be empty");
      return false;
    } else if(_businessCatController.text.isEmpty) {
      snackBar(context, message: "Business Category must not be empty");
      return false;
    } else if(_nameController.text.isEmpty) {
      snackBar(context, message: "Name must not be empty");
      return false;
    } else {
      return true;
    }
  }
}