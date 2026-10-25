import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/customer/add_customer/add_customer_cubit.dart';
import 'package:soft_khata_flutter/bloc/customer/delete_customer/delete_customer_cubit.dart';
import 'package:soft_khata_flutter/bloc/customer/edit_customer/edit_customer_cubit.dart';
import 'package:soft_khata_flutter/bloc/customer/get_customer/get_customer_cubit.dart';
import 'package:soft_khata_flutter/bloc/entry/add_entry/add_entry_cubit.dart';
import 'package:soft_khata_flutter/bloc/entry/delete_entry/delete_entry_cubit.dart';
import 'package:soft_khata_flutter/bloc/entry/edit_entry/edit_entry_cubit.dart';
import 'package:soft_khata_flutter/bloc/entry/entry_details/entry_details_cubit.dart';
import 'package:soft_khata_flutter/bloc/entry/get_entries/get_entries_cubit.dart';
import 'package:soft_khata_flutter/bloc/login_cubit/login_cubit.dart';
import 'package:soft_khata_flutter/bloc/profile/edit_profile/edit_profile_cubit.dart';
import 'package:soft_khata_flutter/bloc/profile/get_profile/get_profile_cubit.dart';
import 'package:soft_khata_flutter/bloc/signup_cubit/signup_cubit.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/ui/add_customer/add_customer.dart';
import 'package:soft_khata_flutter/ui/add_entry/add_entry_screen.dart';
import 'package:soft_khata_flutter/ui/auth/auth_screen.dart';
import 'package:soft_khata_flutter/ui/customer_entries/customer_entries_page.dart';
import 'package:soft_khata_flutter/ui/customer_profile/customer_profile_screen.dart';
import 'package:soft_khata_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:soft_khata_flutter/ui/edit_customer/edit_customer_page.dart';
import 'package:soft_khata_flutter/ui/edit_entry/edit_entry_screen.dart';
import 'package:soft_khata_flutter/ui/edit_profile/edit_profile_screen.dart';
import 'package:soft_khata_flutter/ui/entry_details/entry_details_screen.dart';
import 'package:soft_khata_flutter/ui/login/login_page.dart';
import 'package:soft_khata_flutter/ui/profile/profile_screen.dart';
import 'package:soft_khata_flutter/ui/sign_up/account_details/account_details_screen.dart';
import 'package:soft_khata_flutter/ui/sign_up/mobile_number/mobile_number_screen.dart';

class AppRoutes {
  AppRepository repository;
  LoginCubit loginCubit;

  AppRoutes() {
    repository = AppRepository();
  }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.auth:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => LoginCubit(repository),
            child: LoginPage(),
          ),
        );
      case RoutesName.mobileNumber:
        return MaterialPageRoute(
          builder: (_) => MobileNumberScreen(),
        );
      case RoutesName.accountDetails:
        var args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => SignupCubit(repository),
            child: AccountDetailsScreen(arguments: args),
          ),
        );
      case RoutesName.signupDone:
        return MaterialPageRoute(
          builder: (_) => SignUpDoneScreen(),
        );
      case RoutesName.dashboard:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<GetCustomerCubit>.value(value: GetCustomerCubit(repository)),
              BlocProvider<GetProfileCubit>.value(value: GetProfileCubit(repository))
            ],
            child: DashboardScreen(),
          ),
        );
      case RoutesName.editProfile:
        final argument = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => EditProfileCubit(repository),
            child: EditProfileScreen(argument: argument),
          ),
        );
      case RoutesName.addCustomer:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => AddCustomerCubit(repository),
            child: AddCustomerScreen(),
          ),
        );
      case RoutesName.customerDetails:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => AddCustomerCubit(repository),
            child: CustomerProfileScreen(),
          ),
        );
      case RoutesName.customerEntries:
        var args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<GetEntriesCubit>.value(value: GetEntriesCubit(repository)),
              BlocProvider<DeleteCustomerCubit>.value(value: DeleteCustomerCubit(repository)),
            ],
            child: CustomerEntriesPage(arguments: args),
          ),
        );
      case RoutesName.editCustomer:
        var args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => EditCustomerCubit(repository),
            child: EditCustomerScreen(arguments: args),
          ),
        );
      case RoutesName.addEntry:
        var args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => AddEntryCubit(repository),
            child: AddEntryScreen(argument: args,),
          ),
        );
      case RoutesName.editEntry:
        final argument = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => EditEntryCubit(repository),
            child: EditEntryScreen(arguments: argument),
          ),
        );
      case RoutesName.entryDetails:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<EntryDetailsCubit>.value(value: EntryDetailsCubit(repository)),
              BlocProvider<DeleteEntryCubit>.value(value: DeleteEntryCubit(repository)),
            ],
            child: EntryDetailsScreen(arguments: args),
          ),
        );  
    }
  }
}
