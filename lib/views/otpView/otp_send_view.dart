import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../services/send_otp_service.dart';
import '../../widgets/button_widget.dart';

class OtpSendView extends StatelessWidget {
  OtpSendView({super.key});
  final controller = TextEditingController();
  final service = SendOTPService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //-----------------------Logo-----------------------
            Column(
              children: [
                Image.asset(
                  "assets/images/logo.png", // Replace with your image asset path
                  height: 100.0,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Your Task Management App",
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),

            Column(
              children: [
                TextField(
                  controller: controller,
                  style: const TextStyle(color: whiteColor),
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(
                        17,
                      ),
                      fillColor: inputFilledColor,
                      filled: true,
                      hintText: "Enter your Robi/Airtel number...",
                      hintStyle: const TextStyle(color: inputFilledTextColor),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: primaryColor))),
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () async {
                    await service.sendOTP(context, controller);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                        color: blackColor,
                        borderRadius: BorderRadius.circular(4)),
                    child: const ButtonWidget(
                      label: "Submit",
                      bgcolor: primaryColor,
                      textColor: backgroundColor,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
