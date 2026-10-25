import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/profile/get_profile/get_profile_cubit.dart';
import 'package:soft_khata_flutter/bloc/profile/get_profile/get_profile_states.dart';
import 'package:soft_khata_flutter/components/snackbar.dart';
import 'package:soft_khata_flutter/data/remote/responses/get_profile_response.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/utils/app_constants.dart';
import 'package:soft_khata_flutter/utils/login_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {

  ProfileResponse response;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<GetProfileCubit>(context).getProfile(LoginPreferences.getUserId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1.5,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: "SemiBold",
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.editProfile, arguments: {
            AppConstants.mobileNumber : response.result.user.number.toString(),
            AppConstants.businessName : response.result.user.businessName,
            AppConstants.email : response.result.user.email,
            AppConstants.businessCat : response.result.user.businessCategory,
            AppConstants.fullname: response.result.user.name
          }).then((value) {
            BlocProvider.of<GetProfileCubit>(context).getProfile(LoginPreferences.getUserId());
          });
        },
        child: Icon(
          Icons.edit,
          color: ThemeColors.COLOR_WHITE,
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<GetProfileCubit, GetProfileStates>(
          listener: (_, state) {
            if(state is GetProfileError) {
              errorSnackBar(context, message: state.message);
            }
          },
          builder: (_, state) {
            if(state is GetProfileLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: ThemeColors.COLOR_PRIMARY,
                ),
              );
            } else if(state is GetProfileSuccess) {
              response = state.response;
              return SingleChildScrollView(
                child: initScreen(),
              );
            } else {
              return Container();
            }
          },
        ),
      )
    );
  }

  Widget initScreen() {
    return Container(
      margin: EdgeInsets.only(left: 30, top: 30, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Name",
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 19,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              response.result.user.name,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 25,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "Mobile Number",
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 19,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              "+92${response.result.user.number.toString()}",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 26,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "Business Name",
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 19,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              response.result.user.businessName,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 25,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "Business Category",
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 19,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              response.result.user.businessCategory,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
