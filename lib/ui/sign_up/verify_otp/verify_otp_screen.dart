import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:soft_khata_flutter/components/outline_button.dart';
import 'package:soft_khata_flutter/components/signup_steps.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/ui/sign_up/account_details/account_details_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
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
            margin: EdgeInsets.only(top: 60),
            child: Text(
              "Verify OTP Code",
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
              "Verify the OTP Code to continue",
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
            margin: EdgeInsets.only(top: 90, left: 15, right: 15),
            child: OTPTextField(
              length: 6,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldWidth: 50,
              fieldStyle: FieldStyle.underline,
              outlineBorderRadius: 10,
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).primaryColor,
              ),
              otpFieldStyle: OtpFieldStyle(
                disabledBorderColor: Theme.of(context).primaryColor,
                focusBorderColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
                enabledBorderColor: Theme.of(context).primaryColor,
              ),
              onChanged: (pin) {},
              onCompleted: (pin) {
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            margin: EdgeInsets.only(left: 25, right: 25, top: 30),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 0.3, color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountDetailsScreen(),
                  )
                );
              },
              child: Text("Resend Otp",
                style: TextStyle(
                    color: Theme.of(context).primaryColor
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}