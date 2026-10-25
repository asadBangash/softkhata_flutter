import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:soft_khata_flutter/data/remote/error_handling/http_exception.dart';
import 'package:soft_khata_flutter/data/remote/responses/add_customer_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/add_entry_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/delete_entry_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/edit_customer_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/edit_entry_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/edit_profile_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/entry_details_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/generic_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/get_customer_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/get_entry_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/get_profile_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/login_response.dart';
import 'package:soft_khata_flutter/data/remote/responses/signup_response.dart';
import 'package:soft_khata_flutter/utils/app_constants.dart';
import 'package:soft_khata_flutter/utils/end_points.dart';

class ApiDataSource {
  Client client = Client();

  Future<LoginResponse> login(String email, String password) async {
    try {
      final request = json.encode(<String, String> {
        "email": email,
        "password": password,
      });
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.login),
        body: request,
        headers: {
          'Content-type' : "application/json"
        },
      );
      if (response.statusCode == 200) {
        final result = LoginResponse.fromJson(json.decode(response.body));
        print("Login Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("Login Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("Login Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("Login Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<SignupResponse> signup(
      String name, String email, String password,
      String number, String businessName, String businessCategory,
  ) async {
    try {
      final request = json.encode(<String, String> {
        'name': name,
        'email': email,
        'password': password,
        'number': number,
        'businessName': businessName,
        'businessCategory': businessCategory,
      });

      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.signup),
        body: request,
        headers: {
          'Content-type' : "application/json"
        },
      );

      if (response.statusCode == 200) {
        final result = SignupResponse.fromJson(json.decode(response.body));
        print("Signup Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("Signup Error ${result.result.message}");
        throw Exception(result.result.message);
      }

    } on SocketException catch (e) {
      print("Signup Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("Signup Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<ProfileResponse> getProfile(String userId) async {
    try {
      final request = json.encode(<String, String> {
        "userId": userId,
      });
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.getProfile),
        body: request,
        headers: {
          'Content-type' : "application/json"
        },
      );
      if (response.statusCode == 200) {
        final result = ProfileResponse.fromJson(json.decode(response.body));
        print("GetProfile Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("GetProfile Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("GetProfile Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("GetProfile Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<EditProfileResponse> updateProfile(String body) async {
    try {
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.updateProfile),
        body: body,
        headers: {
          'Content-type' : "application/json"
        },
      );
      if (response.statusCode == 200) {
        final result = EditProfileResponse.fromJson(json.decode(response.body));
        print("UpdateProfile Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("UpdateProfile Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("UpdateProfile Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("UpdateProfile Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<AddCustomerResponse> addCustomer(String userId, String name, String number) async {
    try {
      final body = {
        "user": userId,
        "name": name,
        "number": number
      };
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.addCustomer),
        body: jsonEncode(body),
        headers: {
          'Content-type' : "application/json"
        },
      );
      if (response.statusCode == 200) {
        final result = AddCustomerResponse.fromJson(json.decode(response.body));
        print("AddCustomer Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("AddCustomer Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("AddCustomer Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("AddCustomer Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<GetCustomersResponse> getCustomers(String userId) async {
    try {
      final body = {
        "userId": userId,
      };
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.getCustomer),
        body: jsonEncode(body),
        headers: {
          'Content-type' : "application/json"
        },
      );
      if (response.statusCode == 200) {
        final result = GetCustomersResponse.fromJson(json.decode(response.body));
        print("GetCustomer Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("GetCustomer Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("GetCustomer Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("GetCustomer Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<EditCustomerResponse> editCustomers(String body) async {
    try {
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.editCustomer),
        body: body,
        headers: {
          'Content-type' : "application/json"
        },
      );
      if (response.statusCode == 200) {
        final result = EditCustomerResponse.fromJson(json.decode(response.body));
        print("EditCustomer Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("EditCustomer Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("EditCustomer Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("EditCustomer Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<GenericResponse> deleteCustomer(String customerId) async {
    try {
      final request = {
        "customerId" : customerId
      };
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.deleteCustomer),
        body: jsonEncode(request),
        headers: {
          'Content-type' : "application/json"
        },
      );
      if (response.statusCode == 200) {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("DeleteCustomer Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("DeleteCustomer Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("DeleteCustomer Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("DeleteCustomer Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<GetEntriesResponse> getEntries(String customerId) async {
    try {
      final body = {
        "customerId": customerId,
      };
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.getEntry),
        headers: {
          'Content-type' : "application/json"
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final result = GetEntriesResponse.fromJson(json.decode(response.body));
        print("GetEntries Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("GetEntries Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("GetEntries Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("GetEntries Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<AddEntryResponse> addEntry(String body) async {
    try {
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.addEntry),
        body: body,
        headers: {
          'Content-type' : "application/json"
        },
      );
      if (response.statusCode == 200) {
        final result = AddEntryResponse.fromJson(json.decode(response.body));
        print("AddEntries Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("AddEntries Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("AddEntries Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("AddEntries Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<EditEntryResponse> editEntry(String body) async {
    try {
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.editEntry),
        body: body,
        headers: {
          'Content-type' : "application/json"
        },
      );
      if (response.statusCode == 200) {
        final result = EditEntryResponse.fromJson(json.decode(response.body));
        print("EditEntry Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("EditEntry Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("EditEntry Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("EditEntry Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<EntryDetailsResponse> entryDetails(String entryId) async {
    try {
      final request = {
        "entryId" : entryId
      };
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.entryDetail),
        body: jsonEncode(request),
        headers: {
          'Content-type' : "application/json"
        },
      );
      if (response.statusCode == 200) {
        final result = EntryDetailsResponse.fromJson(json.decode(response.body));
        print("EntryDetails Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("EntryDetails Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("EntryDetails Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("EntryDetails Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }

  Future<DeleteEntryResponse> deleteEntry(String entryId) async {
    try {
      final body = {
        "entryId" : entryId
      };
      final response = await client.post(
        Uri.parse(AppConstants.BASE_URL + EndPoints.deleteEntry),
        body: jsonEncode(body),
        headers: {
          'Content-type' : "application/json"
        },
      );
      if (response.statusCode == 200) {
        final result = DeleteEntryResponse.fromJson(json.decode(response.body));
        print("DeleteEntry Response ${response.body}");
        return result;
      } else {
        final result = GenericResponse.fromJson(json.decode(response.body));
        print("DeleteEntry Error ${result.result.message}");
        throw HttpException(error: result.result.message);
      }
    } on SocketException catch (e) {
      print("DeleteEntry Error ${e.toString()}");
      throw HttpException(error: "No Internet Connection. Please check your internet connection and try again.");
    } on Exception catch(e) {
      print("DeleteEntry Error ${e.toString()}");
      throw HttpException(error: e.toString());
    }
  }
}
