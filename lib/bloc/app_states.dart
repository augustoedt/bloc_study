import 'package:bloc_study/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginErrors;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState.empty() :
        isLoading = false,
        loginErrors = null,
        loginHandle = null,
        fetchedNotes = null;

  const AppState({
    required this.isLoading,
    required this.loginErrors,
    required this.loginHandle,
    required this.fetchedNotes,
  });

  @override
  toString() => {
    'isLoading': isLoading,
    'LoginErrors': loginErrors,
    'loginHandle': loginHandle,
    'fetchedNotes': fetchedNotes,
  }.toString();

}