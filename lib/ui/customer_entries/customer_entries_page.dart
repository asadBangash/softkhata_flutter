import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/customer/delete_customer/delete_customer_cubit.dart';
import 'package:soft_khata_flutter/bloc/customer/delete_customer/delete_customer_states.dart';
import 'package:soft_khata_flutter/bloc/entry/get_entries/get_entries_cubit.dart';
import 'package:soft_khata_flutter/bloc/entry/get_entries/get_entries_states.dart';
import 'package:soft_khata_flutter/components/loading_dialog.dart';
import 'package:soft_khata_flutter/components/snackbar.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';

import '../../data/remote/responses/get_entry_response.dart';

class CustomerEntriesPage extends StatefulWidget {

  var arguments;
  CustomerEntriesPage({this.arguments});

  @override
  State<CustomerEntriesPage> createState() => _CustomerEntriesPageState();
}

class _CustomerEntriesPageState extends State<CustomerEntriesPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<GetEntriesCubit>().getEntries(widget.arguments["customerId"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.COLOR_WHITE,
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: ThemeColors.COLOR_GREEN,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.addEntry, arguments: {
                      "entryType" : "income",
                      "customerId" : widget.arguments["customerId"]
                    }).then((value) {
                      context.read<GetEntriesCubit>().getEntries(widget.arguments["customerId"]);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.arrow_downward,
                          size: 18,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text("Take"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: ThemeColors.COLOR_RED,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.addEntry, arguments: {
                      "entryType" : "expense",
                      "customerId" : widget.arguments["customerId"]
                    }).then((value) {
                      context.read<GetEntriesCubit>().getEntries(widget.arguments["customerId"]);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.arrow_upward,
                          size: 18,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text("Give",),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
          "${widget.arguments["customerName"]}",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          BlocConsumer<DeleteCustomerCubit, DeleteCustomerStates>(
            listener: (_, state) {
              if(state is DeleteCustomerSuccess) {
                loading(context, false);
                Navigator.pop(context);
              } else if(state is DeleteCustomerError) {
                loading(context, false);
                errorSnackBar(context, message: state.message);
              } else {
                loading(context, true);
              }
            },
            builder: (_, state) {
              return PopupMenuButton<String>(
                onSelected: handleClick,
                iconSize: 24.0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: ThemeColors.COLOR_PRIMARY,
                  size: 24.0,
                ),
                itemBuilder: (BuildContext context) {
                  return {'Edit Customer', 'Delete Customer'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: GestureDetector(
                        onTap: () {
                          if(choice == "Edit Customer") {
                            Navigator.pushNamed(context, RoutesName.editCustomer, arguments: {
                              "customerId" : widget.arguments["customerId"],
                              "customerName": widget.arguments["customerName"],
                              "number": widget.arguments["number"]
                            });
                          } else {
                            Navigator.pop(context);
                            context.read<DeleteCustomerCubit>().deleteCustomer(widget.arguments["customerId"]);
                          }
                        },
                        child: Text(
                          choice,
                          style: TextStyle(
                            color: choice == "Delete Customer" ? ThemeColors.COLOR_RED : ThemeColors.COLOR_PRIMARY,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }).toList();
                },
              );
            },
          ),
        ],
        elevation: 1.5,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: BlocConsumer<GetEntriesCubit, GetEntriesStates>(
        builder: (_, state) {
          if(state is GetEntriesLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if(state is GetEntriesSuccess) {
            if(state.response.entries.isEmpty) {
              return Center(
                child: Text(
                  "No Entries Found",
                  style: TextStyle(
                    color: ThemeColors.COLOR_PRIMARY,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              );
            } else {
              return SafeArea(
                child: SingleChildScrollView(
                  child: initWidget(state.response.entries),
                ),
              );
            }
          } else {
            return Container();
          }
        },
        listener: (_, state) {
          if(state is GetEntriesError) {
            errorSnackBar(context, message: state.message);
          }
        },
      ),
    );
  }

  Widget initWidget(List<Entries> entries) {
    var expense = 0;
    var income = 0;

    if(entries.where((e) => e.entryType == 'income').isNotEmpty) {
      income = entries
          .where((e) => e.entryType == 'income')
          .map((e) => int.parse(e.balance))
          .reduce((x,y) => x+y);
    }
    if(entries.where((e) => e.entryType == 'expense').isNotEmpty) {
      expense = entries
          .where((e) => e.entryType == 'expense')
          .map((e) => int.parse(e.balance))
          .reduce((x,y) => x+y);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(right: 15, left: 15, top: 15),
          decoration: BoxDecoration(
            color: income > expense
                ? ThemeColors.COLOR_GREEN.withOpacity(0.1)
                : ThemeColors.COLOR_RED.withOpacity(0.1),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                income > expense ? "USD $income" : "USD $expense",
                style: TextStyle(
                  color: income > expense ? ThemeColors.COLOR_GREEN : ThemeColors.COLOR_RED,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                income > expense ? "You will take" : "You will give",
                style: TextStyle(
                  color: income > expense ? ThemeColors.COLOR_GREEN : ThemeColors.COLOR_RED,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 0, right: 0, top: 15),
          padding: EdgeInsets.only(top: 15, bottom: 10),
          color: ThemeColors.COLOR_GRAY.withOpacity(0.15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    "Date & Time",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    "Income",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    "Expense",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: ListView.builder(
            itemCount: entries.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return Container(
                margin: EdgeInsets.only(left: 0, right: 0, top: 15),
                color: ThemeColors.COLOR_WHITE,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entries[index].description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  entries[index].time,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, RoutesName.entryDetails, arguments: {
                                      "entryId" : entries[index].sId
                                    }).then((value) {
                                      context.read<GetEntriesCubit>().getEntries(widget.arguments["customerId"]);
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "See Details",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: ThemeColors.COLOR_PRIMARY,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(right: 0),
                            child: Text(
                              entries[index].entryType == "income" ? "USD ${entries[index].balance}" : "",
                              style: TextStyle(
                                fontSize: 14,
                                color: ThemeColors.COLOR_GREEN,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              entries[index].entryType == "expense" ? "USD ${entries[index].balance}" : "",
                              style: TextStyle(
                                fontSize: 14,
                                color: ThemeColors.COLOR_RED,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    divider()
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      height: 0.3,
      color: ThemeColors.COLOR_GRAY,
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit Customer':
        break;
      case 'Delete Customer':
        break;
    }
  }
}
