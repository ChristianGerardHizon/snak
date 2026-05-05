import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'failure.mapper.dart';

@MappableClass(discriminatorKey: 'type')
sealed class Failure with FailureMappable {
  final dynamic message;
  final StackTrace? stackTrace;
  final String? identifier;

  const Failure(this.message, this.stackTrace, this.identifier);

  String get messageString {
    final error = message;
    var returnMessage = 'Something went wrong';

    if (error is PostgrestException) {
      if (kDebugMode) {
        debugPrint(error.toString());
      }
      returnMessage = error.message;
    }

    if (error is AuthException) {
      if (kDebugMode) {
        debugPrint(error.toString());
      }
      returnMessage = error.message;
    }

    if (error is StorageException) {
      if (kDebugMode) {
        debugPrint(error.toString());
      }
      returnMessage = error.message;
    }

    if (error is JsonUnsupportedObjectError) {
      if (kDebugMode) {
        debugPrint(error.toString());
      }
      returnMessage = 'Unsupported Object';
    }

    if (error is GenericFailure) {
      if (kDebugMode) {
        debugPrint(error.toString());
      }
      final defaultMessage = 'Generic Failure';
      final data = error.message;
      returnMessage = data ?? defaultMessage;
    }

    if (error is String) {
      returnMessage = error;
    }

    if (error is Failure) {
      returnMessage = error.message;
    }

    return returnMessage;
  }

  static const fromMap = FailureMapper.fromMap;
  static const fromJson = FailureMapper.fromJson;

  static Failure handle(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
    }

    if (error is Failure) {
      return error;
    }

    if (error is MapperException) {
      if (kDebugMode) {
        debugPrint(error.message.toString());
      }
      return MapperFailure(error, stackTrace, 'mapper_error');
    }

    if (error is AuthException) {
      return AuthFailure(error, stackTrace, 'auth_error');
    }

    if (error is PostgrestException) {
      final code = error.code;
      // Postgres permission/JWT errors → AuthFailure
      if (code == '42501' || code == 'PGRST301' || code == 'PGRST302') {
        return AuthFailure(error, stackTrace, 'auth_error');
      }
      return DataFailure(error, stackTrace, 'data_error');
    }

    if (error is StorageException) {
      return DataFailure(error, stackTrace, 'storage_error');
    }

    // Handle user-cancelled errors (e.g., platform cancel actions)
    if (error.toString().contains('User cancelled')) {
      return CancelledFailure(error, stackTrace, 'user_cancelled');
    }

    // Handle presentation-related errors (UI layer)
    if (error is FormatException || error is StateError) {
      return PresentationFailure(error, stackTrace, 'presentation_error');
    }

    return GenericFailure(error, stackTrace, 'generic_error');
  }
}

@MappableClass()
class AuthFailure extends Failure with AuthFailureMappable {
  const AuthFailure([
    dynamic message,
    StackTrace? stackTrace,
    String? identifier,
  ]) : super(message, stackTrace, identifier);
}

@MappableClass()
class PresentationFailure extends Failure with PresentationFailureMappable {
  const PresentationFailure([
    dynamic message,
    StackTrace? stackTrace,
    String? identifier,
  ]) : super(message, stackTrace, identifier);
}

@MappableClass()
class DataFailure extends Failure with DataFailureMappable {
  const DataFailure([
    dynamic message,
    StackTrace? stackTrace,
    String? identifier,
  ]) : super(message, stackTrace, identifier);
}

@MappableClass()
class CancelledFailure extends Failure with CancelledFailureMappable {
  const CancelledFailure([
    dynamic message,
    StackTrace? stackTrace,
    String? identifier,
  ]) : super(message, stackTrace, identifier);
}

@MappableClass()
class NoAuthFailure extends Failure with NoAuthFailureMappable {
  const NoAuthFailure([
    dynamic message,
    StackTrace? stackTrace,
    String? identifier,
  ]) : super(message, stackTrace, identifier);
}

@MappableClass()
class GenericFailure extends Failure with GenericFailureMappable {
  const GenericFailure([
    dynamic message,
    StackTrace? stackTrace,
    String? identifier,
  ]) : super(message, stackTrace, identifier);
}

@MappableClass()
class MapperFailure extends Failure with MapperFailureMappable {
  const MapperFailure([
    dynamic message,
    StackTrace? stackTrace,
    String? identifier,
  ]) : super(message, stackTrace, identifier);
}
