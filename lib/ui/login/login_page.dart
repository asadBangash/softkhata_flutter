import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soft_khata_flutter/bloc/login_cubit/login_cubit.dart';
import 'package:soft_khata_flutter/bloc/login_cubit/login_states.dart';
import 'package:soft_khata_flutter/components/loading_dialog.dart';
import 'package:soft_khata_flutter/components/snackbar.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/utils/login_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var preference = LoginPreferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginLoading) {
            loading(context, true);
          } else if (state is LoginSuccess) {
            final result = state.response.result.user;

            LoginPreferences.setLoggedIn(true);
            LoginPreferences.setUserId(result.id);
            LoginPreferences.setUserName(result.name);
            LoginPreferences.setUserEmail(result.email);

            loading(context, false);
            Navigator.pushReplacementNamed(context, RoutesName.dashboard);
          } else if(state is LoginError) {
            loading(context, false);
            snackBar(context, message: state.message);
          }
        },
        builder: (context, state) {
          return SafeArea(child: _loginScreen(context));
        },
      ),
    );
  }

  Widget _loginScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 80),
          child: Text(
            "Start with mobile number",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 26,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 10),
          child: Text(
            "Enter mobile number we will send you OTP to verify",
            style: TextStyle(
                color: ThemeColors.COLOR_GRAY,
                fontSize: 22,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 100, left: 17, right: 17),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            controller: _emailController,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Email',
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
          height: 45,
          margin: EdgeInsets.only(top: 15, left: 17, right: 17),
          child: MaterialButton(
            onPressed: () {
              _emailController.text.isEmpty || _passwordController.text.isEmpty
                  ? snackBar(context, message: "Email and Password must not be empty.")
                  : BlocProvider.of<LoginCubit>(context).loginUser(
                    _emailController.text, _passwordController.text,
                  );
            },
            color: Theme.of(context).primaryColor,
            child: Text(
              "Login",
              style: TextStyle(color: ThemeColors.COLOR_WHITE),
            ),
          ),
        ),
      ],
    );
  }
}
