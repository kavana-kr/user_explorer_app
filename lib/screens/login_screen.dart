import 'package:flutter/material.dart';
import 'package:user_explorer_app/utils/app_constants.dart';
import '../services/shared_pref_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_themes.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // form validation key

  final emailController = TextEditingController(); // stores email input
  final passwordController = TextEditingController(); // stores password input

  bool rememberMe = false; // whether credentials must be stored
  bool passwordVisible = false; // toggle for password visibility

  @override
  void initState() {
    super.initState();
    _loadRememberedData(); // load saved email/password if available
  }

  // loads saved login credentials from SharedPreferences
  Future<void> _loadRememberedData() async {
    await Future.delayed(const Duration(milliseconds: 120));

    final creds = await PrefService.getCredentials();

    if (creds["email"]!.isNotEmpty) {
      if (mounted) {
        setState(() {
          emailController.text = creds["email"]!;
          passwordController.text = creds["password"]!;
          rememberMe = true; // auto-enable remember me
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose(); // cleanup controllers
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light; // check theme
    final gradient = isLight
        ? AppThemes.loginLightGradient
        : AppThemes.loginDarkGradient; // background gradient

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient), // gradient background
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420), // card width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ------- TOP LOGO + TEXT ------- //
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(
                              isLight ? 0.25 : 0.18,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          AppConstants.appName, // app name text
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: isLight ? Colors.black87 : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppConstants.signInMsg, // subtitle
                          style: TextStyle(
                            color: isLight ? Colors.black54 : Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ------- LOGIN CARD ------- //
                    Card(
                      color: isLight ? Colors.white : const Color(0xFF101010),
                      elevation: 10,
                      shadowColor: Colors.black.withOpacity(0.18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 24,
                        ),
                        child: Form(
                          key: _formKey, // enable validation fields
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ------- EMAIL FIELD ------- //
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: AppConstants.email,
                                  hintText: "you@example.com",
                                  prefixIcon: const Icon(
                                    Icons.email_rounded,
                                    color: AppColors.primary,
                                  ),
                                  filled: true,
                                  fillColor: isLight
                                      ? Colors.blue.shade50
                                      : Colors.white.withOpacity(0.06),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return AppConstants.emailMsg;
                                  }
                                  if (!v.contains("@") || !v.contains(".")) {
                                    return AppConstants.emailValidationMsg;
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // ------- PASSWORD FIELD ------- //
                              TextFormField(
                                controller: passwordController,
                                obscureText: !passwordVisible, // hide text
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: AppConstants.password,
                                  hintText: "Abcd@1234",
                                  prefixIcon: const Icon(
                                    Icons.lock_rounded,
                                    color: AppColors.primary,
                                  ),
                                  filled: true,
                                  fillColor: isLight
                                      ? Colors.blue.shade50
                                      : Colors.white.withOpacity(0.06),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility, // eye icon
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () {
                                      setState(() =>
                                          passwordVisible = !passwordVisible);
                                    },
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return AppConstants.passwordMsg;
                                  }

                                  // strong password validator
                                  final regex = RegExp(
                                    r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$',
                                  );

                                  if (!regex.hasMatch(v)) {
                                    return AppConstants.passwordValidationMsg;
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 10),

                              // ------- REMEMBER ME ------- //
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberMe,
                                    onChanged: (v) {
                                      setState(() => rememberMe = v ?? false);
                                    },
                                  ),
                                  const Text(AppConstants.rememberMe),
                                ],
                              ),

                              const SizedBox(height: 18),

                              // ------- LOGIN BUTTON ------- //
                              SizedBox(
                                width: double.infinity,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: AppThemes.buttonGradient,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // validate fields before login
                                      if (_formKey.currentState!.validate()) {
                                        await PrefService.saveLogin(); // mark logged in

                                        if (rememberMe) {
                                          // save email/password locally
                                          await PrefService.saveCredentials(
                                            emailController.text,
                                            passwordController.text,
                                          );
                                        }

                                        // navigate to home and remove backstack
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const HomeScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      AppConstants.logIn,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
