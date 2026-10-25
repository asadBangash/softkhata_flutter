import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/customer/add_customer/add_customer_cubit.dart';
import 'package:soft_khata_flutter/bloc/customer/add_customer/add_customer_states.dart';
import 'package:soft_khata_flutter/components/loading_dialog.dart';
import 'package:soft_khata_flutter/components/snackbar.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/ui/add_entry/add_entry_screen.dart';
import 'package:soft_khata_flutter/ui/customer_profile/customer_profile_screen.dart';
import 'package:soft_khata_flutter/ui/sign_up/mobile_number/mobile_number_screen.dart';
import 'package:soft_khata_flutter/utils/login_preferences.dart';

class AddCustomerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomerScreen> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

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
          "Add Customer",
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
        BlocConsumer<AddCustomerCubit, AddCustomerStates>(
          listener: (_, state) {
            if(state is AddCustomerSuccess) {
              loading(context, false);
              Navigator.pop(context);
            } else if(state is AddCustomerError) {
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
                    context.read<AddCustomerCubit>().addCustomer(
                      LoginPreferences.getUserId(),
                      _nameController.text, _numberController.text,
                    );
                  } else {
                    return;
                  }
                },
                color: Theme.of(context).primaryColor,
                child: Text("Add Customer", style: TextStyle(color: ThemeColors.COLOR_WHITE),),
              ),
            );
          },
        ),
        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   margin: EdgeInsets.only(left: 15, right: 15),
        //   child: OutlinedButton(
        //     onPressed: () {
        //       Navigator.push(context, MaterialPageRoute(
        //         builder: (context) => AddEntryScreen(),
        //       ));
        //     },
        //     child: Text("Import from contact",
        //       style: TextStyle(
        //           color: Theme.of(context).primaryColor
        //       ),
        //     ),
        //   ),
        // )
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