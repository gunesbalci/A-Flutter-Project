import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget intentUrlLauncher(String text, bool isDone) {
  String cleanedText = text.replaceAll(RegExp(r'[\s-]'), '');
  final urlRegex = RegExp(r'^(https?:\/\/[^\s]+)$');
  final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

  final style = TextStyle(
    decoration: isDone ? TextDecoration.lineThrough : null,
  );

  if (urlRegex.hasMatch(text)) 
  {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(text), mode: LaunchMode.externalApplication),
      child: Text(
        text,
        style: style.copyWith(color: Colors.blue, decoration: TextDecoration.combine([
          if (isDone) TextDecoration.lineThrough,
          TextDecoration.underline,
        ]))
      ),
    );
  } 
  else if (phoneRegex.hasMatch(cleanedText)) 
  {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse('tel:$cleanedText')),
      child: Text(
        text,
        style: style.copyWith(color: Colors.green, decoration: TextDecoration.combine([
          if (isDone) TextDecoration.lineThrough,
          TextDecoration.underline,
        ])),
      ),
    );
  } 
  else 
  {
    return Text(
      text,
      style: style,
    );
  }
}
