import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_constants.dart';
import '../viewmodel/login_viewmodel.dart';
import '../../otp/view/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  static const String _countryCode = '+91';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _onLogin(BuildContext providerContext) async {
    if (!_formKey.currentState!.validate()) return;

    final vm = providerContext.read<LoginViewModel>();
    final success = await vm.login(_phoneController.text.trim());

    if (!mounted) return;

    if (success) {
      Navigator.of(providerContext).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => OtpScreen(
            phoneNo: _phoneController.text.trim(),
            countryCode: _countryCode,
            otpId: vm.otpId,
          ),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position:
              Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(animation),
              child: child,
            );
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(providerContext).showSnackBar(
        SnackBar(
          content: Text(
            vm.errorMessage,
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (providerContext, vm, _) {
          final isLoading = vm.state == LoginState.loading;

          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.background,
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40),

                              // Header Row
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome Back!',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Login to your account',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                    ),
                                    child: Image.asset(
                                      'assets/image/logo.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 48),

                              // Phone Label
                              const Text(
                                'Phone Number',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Phone Input
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFE8ECF0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Static India flag + code
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 16,
                                      ),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Color(0xFFE8ECF0),
                                          ),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text(
                                            '🇮🇳',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            _countryCode,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Phone Number Field
                                    Expanded(
                                      child: TextFormField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'Enter phone number',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: AppColors.lightGrey,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 16,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter phone number';
                                          }
                                          if (value.length < 10) {
                                            return 'Enter a valid 10-digit phone number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _onLogin(providerContext),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    disabledBackgroundColor:
                                    AppColors.primary.withOpacity(0.6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                      : const Text(
                                    'Send OTP',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Terms
                              const Center(
                                child: Text(
                                  'By continuing, you agree to our',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: AppColors.lightGrey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _termsLink('Terms of Service'),
                                  const Text(
                                    ' | ',
                                    style: TextStyle(
                                      color: AppColors.lightGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  _termsLink('Privacy Policy'),
                                  const Text(
                                    ' | ',
                                    style: TextStyle(
                                      color: AppColors.lightGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  _termsLink('Content Policy'),
                                ],
                              ),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Full-screen progress overlay while sending OTP
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.35),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 28),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 48,
                            height: 48,
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 3,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Sending OTP...',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Please wait a moment',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: AppColors.grey.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _termsLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}