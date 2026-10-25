import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soft_khata_flutter/bloc/entry/delete_entry/delete_entry_cubit.dart';
import 'package:soft_khata_flutter/bloc/entry/delete_entry/delete_entry_states.dart';
import 'package:soft_khata_flutter/bloc/entry/entry_details/entry_details_cubit.dart';
import 'package:soft_khata_flutter/bloc/entry/entry_details/entry_details_states.dart';
import 'package:soft_khata_flutter/components/entry_details_column.dart';
import 'package:soft_khata_flutter/components/loading_dialog.dart';
import 'package:soft_khata_flutter/components/snackbar.dart';
import 'package:soft_khata_flutter/data/remote/responses/entry_details_response.dart';
import 'package:soft_khata_flutter/extensions/string_ext.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/ui/edit_entry/edit_entry_screen.dart';

class EntryDetailsScreen extends StatefulWidget {

  var arguments;
  EntryDetailsScreen({this.arguments});

  @override
  _EntryDetailsScreenState createState() => _EntryDetailsScreenState();
}

class _EntryDetailsScreenState extends State<EntryDetailsScreen> {

  Data entryData;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<EntryDetailsCubit>().entryDetails(widget.arguments["entryId"]);
    });
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
          "Entry Details",
          style: TextStyle(
              color: Theme.of(context).primaryColor
          ),
        ),
        elevation: 1.5,
        backgroundColor: ThemeColors.COLOR_WHITE,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.editEntry, arguments: {
                  "entryId" : entryData.sId,
                  "userId" : entryData.userId,
                  "customerId" : entryData.customerId,
                  "description" : entryData.description,
                  "time" : entryData.time,
                  "balance" : entryData.balance,
                  "entryType" : entryData.entryType,
                }).then((value) {
                  context.read<EntryDetailsCubit>().entryDetails(widget.arguments["entryId"]);
                });
              },
              child: SvgPicture.asset(
                "assets/icons/ic_edit.svg",
                width: 18,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<EntryDetailsCubit, EntryDetailsStates>(
          listener: (_, state) {
            if(state is EntryDetailsError) {
              errorSnackBar(context, message: state.message);
            }
          },
          builder: (_, state) {
            if(state is EntryDetailsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if(state is EntryDetailsSuccess) {
              entryData = state.response.data;
              return initScreen(entryData);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget initScreen(Data data) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 0, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "Entry Type",
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 17,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              data.entryType.capitalize(),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 23,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "Payment",
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 17,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              "USD: ${data.balance}",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 23,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "Payment Date",
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 17,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              data.time,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 23,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "Entry Description",
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 17,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              data.description,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 23,
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BlocConsumer<DeleteEntryCubit, DeleteEntryStates>(
                        listener: (_, state) {
                          if(state is DeleteEntrySuccess) {
                            loading(context, false);
                            Navigator.pop(context);
                          } else if(state is DeleteEntryError) {
                            loading(context, false);
                          } else {
                            loading(context, true);
                          }
                        },
                        builder: (_, state) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: ThemeColors.COLOR_RED.withOpacity(0.65)
                              ),
                              onPressed: () {
                                context.read<DeleteEntryCubit>().deleteEntry(widget.arguments["entryId"]);
                              },
                              child: Text(
                                "Delete Entry",
                                style: TextStyle(
                                  color: ThemeColors.COLOR_WHITE,
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    ]
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
