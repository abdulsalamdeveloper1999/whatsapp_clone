import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = '/otp-screen';
  final String verificatiomId;
  const OtpScreen({
    super.key,
    required this.verificatiomId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
