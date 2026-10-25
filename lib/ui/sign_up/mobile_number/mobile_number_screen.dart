import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soft_khata_flutter/components/signup_steps.dart';
import 'package:soft_khata_flutter/components/snackbar.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/utils/app_constants.dart';

class MobileNumberScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MobileNumberState();
}

class _MobileNumberState extends State<MobileNumberScreen> {

  var _numberController = TextEditingController();
  var _fullNameController = TextEditingController();
  var _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () { Navigator.pop(context); },
              child: Container(
                child: SvgPicture.asset(
                  "svgs/ic_back_button.svg",
                  color: Theme.of(context).primaryColor,
                ),
                margin: EdgeInsets.only(top: 60, left: 25),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: SignUpSteps(step: 1),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 60),
              child: Text(
                "Start with personal information",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 23,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "Enter personal information to proceed",
                style: TextStyle(
                  color: ThemeColors.COLOR_GRAY,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: EdgeInsets.only(top: 50, left: 17, right: 17),
              child: TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                controller: _numberController,
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
              height: 60,
              margin: EdgeInsets.only(top: 20, left: 17, right: 17),
              child: TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                controller: _fullNameController,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'Enter Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: EdgeInsets.only(top: 20, left: 17, right: 17),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                controller: _emailController,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'Enter Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              margin: EdgeInsets.only(top: 15, left: 17, right: 17),
              child: MaterialButton(
                onPressed: () {
                  if(validation()) {
                    Navigator.pushNamed(context, RoutesName.accountDetails, arguments: {
                      AppConstants.mobileNumber: _numberController.text,
                      AppConstants.fullname: _fullNameController.text,
                      AppConstants.email: _emailController.text,
                    });
                  } else {
                    return;
                  }
                },
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Continue",
                  style: TextStyle(color: ThemeColors.COLOR_WHITE),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validation() {
    if(_numberController.text.isEmpty) {
      snackBar(context, message: "Please enter mobile number");
      return false;
    } else if(_fullNameController.text.isEmpty) {
      snackBar(context, message: "Please enter full name");
      return false;
    } else if(_emailController.text.isEmpty) {
      snackBar(context, message: "Please enter email");
      return false;
    } else {
      return true;
    }
  }
}