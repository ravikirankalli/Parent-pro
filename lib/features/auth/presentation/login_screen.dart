import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import 'widgets/student_quick_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _parentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _parentIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    // Placeholder for the real authentication call.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  void _onForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset is not available yet.')),
    );
  }

  void _onStudentLogin(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label login is not available yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      // Fixed, non-scrolling layout: the whole screen fits one viewport.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            _buildHero(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                child: Column(
                  children: <Widget>[
                    _buildBrand(),
                    const SizedBox(height: 14),
                    _buildLoginCard(),
                    const SizedBox(height: 12),
                    _buildStudentShortcuts(),
                    const Spacer(),
                    _buildTrustFooter(),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      child: Image.asset(
        AppAssets.loginHero,
        width: width,
        height: width * 0.46,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBrand() {
    final TextStyle base = GoogleFonts.montserrat(
      fontSize: 28,
      fontWeight: FontWeight.w800,
    );
    return Column(
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: base,
            children: <TextSpan>[
              TextSpan(
                text: AppStrings.brandFirst,
                style: base.copyWith(color: AppColors.navy),
              ),
              TextSpan(
                text: AppStrings.brandSecond,
                style: base.copyWith(color: AppColors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(width: 78, height: 3, color: AppColors.red),
        const SizedBox(height: 8),
        Text(
          AppStrings.loginTagline,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.hint,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.menu_book_rounded,
                    color: AppColors.brightBlue, size: 26),
                const SizedBox(width: 8),
                Text(
                  AppStrings.login,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              AppStrings.loginSubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.hint,
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _parentIdController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: AppStrings.parentId,
                prefixIcon: Icon(Icons.person_outline, color: AppColors.navy),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (String? value) =>
                  (value == null || value.trim().isEmpty)
                      ? AppStrings.parentIdRequired
                      : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _onLogin(),
              decoration: InputDecoration(
                hintText: AppStrings.password,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                prefixIcon:
                    const Icon(Icons.lock_outline, color: AppColors.navy),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.hint,
                  ),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.passwordRequired;
                }
                if (value.length < 6) return AppStrings.passwordTooShort;
                return null;
              },
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: _submitting ? null : _onLogin,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: AppColors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(AppStrings.login),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _onForgotPassword,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.forgotPassword,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentShortcuts() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: StudentQuickLogin(
              label: 'Student 1',
              color: AppColors.blue,
              onTap: () => _onStudentLogin('Student 1'),
            ),
          ),
          _divider(),
          Expanded(
            child: StudentQuickLogin(
              label: 'Student 2',
              color: AppColors.accentGreen,
              onTap: () => _onStudentLogin('Student 2'),
            ),
          ),
          _divider(),
          Expanded(
            child: StudentQuickLogin(
              label: 'Student 3',
              color: AppColors.accentOrange,
              onTap: () => _onStudentLogin('Student 3'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 48,
        color: AppColors.border,
      );

  Widget _buildTrustFooter() {
    return Column(
      children: <Widget>[
        Text(
          AppStrings.fromLabel,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(width: 24, height: 2, color: AppColors.red),
            const SizedBox(width: 8),
            Text(
              AppStrings.trustName,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 24, height: 2, color: AppColors.red),
          ],
        ),
      ],
    );
  }
}
