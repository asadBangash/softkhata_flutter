import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/customer/get_customer/get_customer_cubit.dart';
import 'package:soft_khata_flutter/bloc/customer/get_customer/get_customer_states.dart';
import 'package:soft_khata_flutter/components/loading_dialog.dart';
import 'package:soft_khata_flutter/components/snackbar.dart';
import 'package:soft_khata_flutter/data/remote/responses/get_customer_response.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/utils/login_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<GetCustomerCubit>(context).getCustomer(
        LoginPreferences.getUserId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
        elevation: 1.5,
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.addCustomer).then((value) {
            BlocProvider.of<GetCustomerCubit>(context).getCustomer(
                LoginPreferences.getUserId());
          });
        },
        label: Text(
          "Add Customer",
          style: TextStyle(
              color: ThemeColors.COLOR_WHITE
          ),
        ),
        icon: Icon(
            Icons.add,
            color: ThemeColors.COLOR_WHITE
        ),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
      body: SafeArea(
        child: BlocConsumer<GetCustomerCubit, GetCustomerStates>(
          listener: (_, state) {
            if (state is GetCustomerError) {
              errorSnackBar(context, message: state.message);
            }
          },
          builder: (_, state) {
            if (state is GetCustomerLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetCustomerSuccess) {
              return SingleChildScrollView(
                child: initWidget(state.response.result.customers),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget initWidget(List<Customers> customers) {
    final totalBalance = customers.fold(
        0, (sum, value) => sum + int.parse(value.totalBalance));
    final totalExpense = customers.fold(
        0, (sum, value) => sum + int.parse(value.totalExpense));
    final totalIncome = customers.fold(
        0, (sum, value) => sum + int.parse(value.totalIncome));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 100,
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          decoration: BoxDecoration(
            color: ThemeColors.COLOR_PRIMARY.withOpacity(0.2),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Total Balance",
                style: TextStyle(
                    color: ThemeColors.COLOR_PRIMARY,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                ),
              ),
              Text(
                "USD $totalBalance",
                style: TextStyle(
                  color: ThemeColors.COLOR_PRIMARY,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 70,
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 5),
                  decoration: BoxDecoration(
                    color: ThemeColors.COLOR_RED.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "USD $totalIncome",
                        style: TextStyle(
                          color: ThemeColors.COLOR_RED,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "You will give",
                        style: TextStyle(
                          color: ThemeColors.COLOR_RED,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 20, left: 5),
                  decoration: BoxDecoration(
                    color: ThemeColors.COLOR_GREEN.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "USD $totalExpense",
                        style: TextStyle(
                          color: ThemeColors.COLOR_GREEN,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "You will take",
                        style: TextStyle(
                          color: ThemeColors.COLOR_GREEN,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 15),
          child: Text(
            "Customers",
            style: TextStyle(
              color: ThemeColors.COLOR_PRIMARY,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 20, top: 15, right: 20),
            child: ListView.builder(
              itemCount: customers.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.customerEntries, arguments: {
                      "customerId": customers[index].sId,
                      "customerName": customers[index].name,
                      "number": customers[index].number
                    }).then((value) {
                      BlocProvider.of<GetCustomerCubit>(context).getCustomer(
                          LoginPreferences.getUserId());
                    });
                  },
                  child: customerListItem(customers[index]),
                );
              },
            )
        ),
      ],
    );
  }

  Widget customerListItem(Customers customer) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: ThemeColors.COLOR_GRAY.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 0,
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(left: 16, top: 15, bottom: 15),
              decoration: BoxDecoration(
                color: ThemeColors.COLOR_WHITE,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  customer.name.substring(0, 1),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: TextStyle(
                      color: ThemeColors.COLOR_BLACK,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Date: ${customer.createdAt.substring(0, 10)}",
                    style: TextStyle(
                      color: ThemeColors.COLOR_BLACK,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    customer.lastEntryType == "" ? "" : customer
                        .lastEntryType == "income" ? "+USD ${customer
                        .lastEntry}" : "-USD ${customer.lastEntry}",
                    style: TextStyle(
                      color: customer.lastEntryType == "income" ? ThemeColors
                          .COLOR_GREEN : ThemeColors.COLOR_RED,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    customer.lastEntryType == "" ? "" : customer
                        .lastEntryType == "income" ? "Take" : "Give",
                    style: TextStyle(
                      color: customer.lastEntryType == "income" ? ThemeColors
                          .COLOR_GREEN : ThemeColors.COLOR_RED,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit Customer':
        break;
    }
  }
}