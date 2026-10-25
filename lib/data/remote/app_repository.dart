import 'package:dartz/dartz.dart';
import 'package:soft_khata_flutter/data/remote/api_data_source.dart';
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

class AppRepository {
  final ApiDataSource _apiDataSource = ApiDataSource();

  Future<Either<String, LoginResponse>> login(String email, String password) async {
    try {
      final result = await _apiDataSource.login(email, password);
      if(result.status) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, SignupResponse>> signUp(
      String name, String email, String password,
      String number, String businessName, String businessCategory,
  ) async {
    try {
      final result = await _apiDataSource.signup(name, email, password, number, businessName, businessCategory);
      if(result.success) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ProfileResponse>> getProfile(String userId) async {
    try {
      final result = await _apiDataSource.getProfile(userId);
      if(result.status) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, EditProfileResponse>> updateProfile(String body) async {
    try {
      final result = await _apiDataSource.updateProfile(body);
      if(result.success) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, AddCustomerResponse>> addCustomer(String userId, String name, String number) async {
    try {
      final result = await _apiDataSource.addCustomer(userId, name, number);
      if(result.success) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, GetCustomersResponse>> getCustomers(String userId) async {
    try {
      final result = await _apiDataSource.getCustomers(userId);
      if(result.success) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, EditCustomerResponse>> editCustomers(String body) async {
    try {
      final result = await _apiDataSource.editCustomers(body);
      if(result.success) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, GetEntriesResponse>> getEntries(String customerId) async {
    try {
      final result = await _apiDataSource.getEntries(customerId);
      if(result.status) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, EntryDetailsResponse>> entryDetails(String entryId) async {
    try {
      final result = await _apiDataSource.entryDetails(entryId);
      if(result.status) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, AddEntryResponse>> addEntry(String body) async {
    try {
      final result = await _apiDataSource.addEntry(body);
      if(result.status) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, EditEntryResponse>> editEntry(String body) async {
    try {
      final result = await _apiDataSource.editEntry(body);
      if(result.success) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, DeleteEntryResponse>> deleteEntry(String entryId) async {
    try {
      final result = await _apiDataSource.deleteEntry(entryId);
      if(result.status) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, GenericResponse>> deleteCustomer(String customerId) async {
    try {
      final result = await _apiDataSource.deleteCustomer(customerId);
      if(result.success) {
        return Right(result);
      } else {
        return const Left("Something went wrong...");
      }
    } on Exception catch(e) {
      return Left(e.toString());
    }
  }
}