import 'package:soft_khata_flutter/core/api/api_client.dart';
import 'package:soft_khata_flutter/data/repositories/laravel_auth_repository.dart';
import 'package:soft_khata_flutter/data/repositories/laravel_catalog_repository.dart';
import 'package:soft_khata_flutter/data/repositories/laravel_party_repository.dart';

class LaravelApiHolder {
  LaravelApiHolder({
    required this.auth,
    required this.parties,
    required this.catalog,
    required this.client,
  });

  final LaravelAuthRepository auth;
  final LaravelPartyRepository parties;
  final LaravelCatalogRepository catalog;
  final ApiClient client;
}
