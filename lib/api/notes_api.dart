import 'package:bloc_study/models.dart';
import 'package:flutter/foundation.dart' show immutable;


@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle
  });

}

@immutable
class NotesApi implements NotesApiProtocol{


  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) =>
      Future.delayed(const Duration(seconds: 1),
            ()=>loginHandle == const LoginHandle.fooBar() ? mockNotes : null,
      );
}