import 'package:flutter/cupertino.dart';
import 'package:whatsapp_ui/utils/components/mytext.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyText(text: error),
    );
  }
}
