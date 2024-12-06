import 'package:flutter/material.dart';
import 'package:todo_app/views/otpView/otp_send_view.dart';
import 'package:todo_app/widgets/button_widget.dart';

import '../../colors.dart';
import '../../services/verify_otp_service.dart';

class OtpVerificationView extends StatelessWidget {
  OtpVerificationView({super.key});

  final otpController = TextEditingController();
  final service = VerifyOTPService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return OtpSendView();
                }));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: primaryColor,
              )),
        ),
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Enter the OTP to activate your account",
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              Column(
                children: [
                  TextField(
                    controller: otpController,
                    cursorColor: primaryColor,
                    style: const TextStyle(color: whiteColor),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(17),
                        fillColor: inputFilledColor,
                        filled: true,
                        hintText: "Enter your otp...",
                        hintStyle: const TextStyle(color: inputFilledTextColor),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: primaryColor))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      await service.verifyOTP(context, otpController);
                    },
                    child: const ButtonWidget(
                      label: "Verify",
                      textColor: backgroundColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
