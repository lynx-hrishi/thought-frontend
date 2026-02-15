import 'dart:async';
import 'package:currency_converter/http_service.dart';
import 'package:currency_converter/utils/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'pages/dashboard_page.dart';
import 'personal_details_page_new.dart';

class OtpPage extends StatefulWidget {
  final String email;
  final bool isRegistered;

  const OtpPage({
    super.key,
    required this.email,
    required this.isRegistered,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  bool isOtpComplete = false;
  int secondsRemaining = 30;
  Timer? timer;

  late AnimationController shakeController;
  late Animation<double> shakeAnimation;

  @override
  void initState() {
    super.initState();
    startTimer();

    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    shakeAnimation =
        Tween<double>(begin: 0, end: 12).chain(CurveTween(curve: Curves.elasticIn)).animate(shakeController);
  }

  void startTimer() {
    secondsRemaining = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining == 0) {
        t.cancel();
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  void checkOtp() {
    String otp = controllers.map((c) => c.text).join();
    setState(() => isOtpComplete = otp.length == 6);
  }

  void verifyOtp() async {
    String otp = controllers.map((c) => c.text).join();
    HttpService httpService = HttpService();

    try{
      Response res = await httpService.otpVerify(email: widget.email, otp: int.parse(otp));
      bool isProfileSet = res.data['data']['user']['isProfileSet'];
      // print(res.data.data.isProfileSet);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => isProfileSet
              ? const DashboardPage()
              : const PersonalDetailsPage(),
        ),
      );

      // } else {
      //   shakeController.forward(from: 0);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Incorrect OTP")),
      //   );:731343
      // }
    }
    catch(err){
      shakeController.forward(from: 0);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(getErrorMessage(err))),
        );
    }
  }

  Widget otpBox(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(counterText: ""),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            focusNodes[index + 1].requestFocus();
          }
          checkOtp();
        },
        onSubmitted: (_) => checkOtp(),
        // onTap: () => controllers[index].selection =
        //     TextSelection.fromPosition(
        //         TextPosition(offset: controllers[index].text.length)),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    shakeController.dispose();
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(shakeAnimation.value, 0),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFEDE7F6),
                    Color(0xFFFCE4EC),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Icon(Icons.lock_outline_rounded,
                      size: 50, color: AppTheme.pink),
                  const SizedBox(height: 16),
                  Text(
                    "OTP Verification",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter the code sent to\n${widget.email}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  const SizedBox(height: 28),
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, otpBox),
                  ),
            
                  const SizedBox(height: 30),
            
                  ElevatedButton(
                    onPressed: isOtpComplete ? verifyOtp : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text("Verify OTP"),
                  ),
            
                  const SizedBox(height: 16),
            
                  secondsRemaining == 0
                      ? TextButton(
                    onPressed: () async {
                      try {
                        await HttpService().loginUser(email: widget.email);
                        startTimer();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('OTP resent successfully')),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(getErrorMessage(e))),
                          );
                        }
                      }
                    },
                    child: const Text("Resend OTP"),
                  )
                      : Text(
                    "Resend in $secondsRemaining s",
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
