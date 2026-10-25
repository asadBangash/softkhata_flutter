import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soft_khata_flutter/bloc/signup_cubit/signup_cubit.dart';
import 'package:soft_khata_flutter/bloc/signup_cubit/signup_state.dart';
import 'package:soft_khata_flutter/components/loading_dialog.dart';
import 'package:soft_khata_flutter/components/signup_steps.dart';
import 'package:soft_khata_flutter/components/snackbar.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/utils/app_constants.dart';

class AccountDetailsScreen extends StatefulWidget {

  var arguments;

  AccountDetailsScreen({this.arguments});

  @override
  State<StatefulWidget> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetailsScreen> {

  var _storeNameController = TextEditingController();
  var _storeCatController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();

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
              child: SignUpSteps(step: 2),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 50),
              child: Text(
                "Account Details ",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "Enter account details to secure your account",
                style: TextStyle(
                    color: ThemeColors.COLOR_GRAY,
                    fontSize: 22,
                    fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: EdgeInsets.only(top: 60, left: 17, right: 17),
              child: TextField(
                keyboardType: TextInputType.text,
                maxLines: 1,
                controller: _storeNameController,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'Enter Store Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: EdgeInsets.only(top: 15, left: 17, right: 17),
              child: TextField(
                keyboardType: TextInputType.text,
                maxLines: 1,
                controller: _storeCatController,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'Select Store Category',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: EdgeInsets.only(top: 15, left: 17, right: 17),
              child: TextField(
                keyboardType: TextInputType.text,
                maxLines: 1,
                controller: _passwordController,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: EdgeInsets.only(top: 15, left: 17, right: 17),
              child: TextField(
                keyboardType: TextInputType.text,
                maxLines: 1,
                controller: _confirmPasswordController,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            BlocConsumer<SignupCubit, SignupStates>(
              listener: (_, state) {
                if(state is SignupSuccess) {
                  loading(context, false);
                  Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
                } else if(state is SignupError) {
                  loading(context, false);
                  errorSnackBar(context, message: state.message);
                } else {
                  loading(context, true);
                }
              },
              builder: (_, state) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  margin: EdgeInsets.only(top: 15, left: 17, right: 17, bottom: 20),
                  child: MaterialButton(
                    onPressed: () {
                      if(validation()) {
                        context.read<SignupCubit>().signupUser(
                          widget.arguments[AppConstants.fullname],
                          widget.arguments[AppConstants.email],
                          _passwordController.text, widget.arguments[AppConstants.mobileNumber],
                          _storeNameController.text, _storeCatController.text,
                        );
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
                );
              },
            ),
          ],
        ),
      )
    );
  }

  bool validation() {
    if(_storeNameController.text.isEmpty) {
      snackBar(context, message: "Please enter store name");
      return false;
    } else if(_storeCatController.text.isEmpty) {
      snackBar(context, message: "Please enter store category");
      return false;
    } else if(_passwordController.text.isEmpty) {
      snackBar(context, message: "Please enter password");
      return false;
    } else if(_confirmPasswordController.text.isEmpty) {
      snackBar(context, message: "Please enter confirm password");
      return false;
    } else if(_passwordController.text != _confirmPasswordController.text) {
      snackBar(context, message: "Password must be same...");
      return false;
    } else {
      return true;
    }
  }
}

class SignUpDoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () { Navigator.pop(context); },
            child: Container(
              margin: EdgeInsets.only(top: 60, left: 25),
              child: Visibility(
                visible: false,
                child: SvgPicture.asset(
                  "svgs/ic_back_button.svg",
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50, left: 20, right: 20),
            child: SignUpSteps(step: 3),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 150),
            child: Text(
              "Your Done",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 25, left: 17, right: 17),
            child: SvgPicture.asset(
              "svgs/done.svg",
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25, left: 17, right: 17),
            child: Align(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed: () {},
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Continue",
                  style: TextStyle(color: ThemeColors.COLOR_WHITE),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}