import 'package:currency_converter/http_service.dart';
import 'package:currency_converter/utils/error_handler.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 900),
          child: Row(
            children: [
              /// LEFT INFO PANEL (WEB ONLY)
              if (isWide)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ThoughtDrop",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "A place where meaningful thoughts\ncreate meaningful connections.",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              /// LOGIN CARD
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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
                        const Icon(
                          Icons.favorite_rounded,
                          size: 52,
                          color: AppTheme.pink,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "Welcome to ThoughtDrop",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 30),
                  
                        /// EMAIL FIELD
                        TextField(
                          controller: emailController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Login using your email"
                          ),
                        ),
                  
                        const SizedBox(height: 24),
                  
                        /// CONTINUE BUTTON → OTP PAGE
                        ElevatedButton(
                          onPressed: isLoading ? null : () {
                            continueBtnHandler(emailController, context, (loading) {
                              setState(() => isLoading = loading);
                            });
                          },
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Continue",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                  
                        const SizedBox(height: 20),
                        const Text("or"),
                        const SizedBox(height: 16),
                  
                        /// GOOGLE BUTTON
                        createOutlineButton(Icon(Icons.g_mobiledata), "Continue with Google"),
                  
                        const SizedBox(height: 10),
                  
                        /// EMAIL BUTTON
                        createOutlineButton(Icon(Icons.email_outlined), "Continue with Email")
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool isValidEmail(String email) {
  return RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  ).hasMatch(email);
}

bool isEmailRegistered(String email) {
  // TEMP logic – replace with Firebase later
  return email.contains("student") || email.contains("admin");
}

void continueBtnHandler(
  TextEditingController emailController,
  BuildContext context,
  Function(bool) setLoading,
) async {
  final email = emailController.text.trim();
  HttpService httpService = HttpService();

  if (!isValidEmail(email)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter a valid email address"),
      ),
    );
    return;
  }

  setLoading(true);
  try {
    Response loginData = await httpService.loginUser(email: email);
    print(loginData);

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpPage(
            email: email,
            isRegistered: isEmailRegistered(email),
          ),
        ),
      );
    }
  } catch (err) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getErrorMessage(err))),
      );
    }
  } finally {
    setLoading(false);
  }
}

Widget createOutlineButton(Icon icon, String label){
  return OutlinedButton.icon(
    onPressed: () {},
    icon: icon,
    label: Text(label),
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  );
}