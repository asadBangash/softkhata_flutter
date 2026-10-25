import 'package:soft_khata_flutter/utils/status.dart';

class Resource<T> {
  Resource(Status status, T data, String message);

  Resource<T> loading() {
    return Resource(Status.SUCCESS, null, null);
  }

  Resource<T> error(String message, T data) {
    return Resource(Status.ERROR, data, message);
  }

  Resource<T> success(T data) {
    return Resource(Status.SUCCESS, data, null);
  }

}