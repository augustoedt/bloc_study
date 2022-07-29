import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<Map, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String content,
  required String title,
  required DialogOptionBuilder optionBuilder
}) {
  final options = optionBuilder();
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: options.keys.map((optionTitle){
        final value = options[optionTitle];
        return TextButton(onPressed: (){
          if (value != null) {
            Navigator.of(context).pop(value);
          } else {
            Navigator.of(context).pop();
          }
        }, child: Text(value));
      }).toList(),
    );
  });
}