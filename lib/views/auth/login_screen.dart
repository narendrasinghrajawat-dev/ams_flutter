import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/widgets/form_widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controller/auth_controller.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../core/constants/text_styles.dart';
import '../../widgets/app_text_type.dart';
import '../admin/admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _auth = Get.find<AuthController>();
  final _box = GetStorage();

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final RxBool rememberMe = false.obs;
  final RxBool obscure = true.obs;

  @override
  void initState() {
    super.initState();
    // load saved email if remember-me was used before
    final saved = _box.read('remember_me') ?? false;
    rememberMe.value = saved;
    if (saved) {
      final savedEmail = _box.read('saved_email') as String?;
      if (savedEmail != null) emailC.text = savedEmail;
    }

    emailC.text = "nsr@gmail.com";
    passC.text = "123456";
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) return;

    // persist remember me choice
    if (rememberMe.value) {
      _box.write(AppStrings.rememberMe, true);
      _box.write(AppStrings.savedEmail, emailC.text.trim());
    } else {
      _box.remove(AppStrings.rememberMe);
      _box.remove(AppStrings.savedEmail);
    }

    // call auth
    await _auth.login(emailC.text.trim(), passC.text.trim());
    // Get.to(AdminDashboard());

    // handle login failure (AuthController shows snackbar on error already,
    // but you can add extra checks here)
    if (!_auth.isLoggedIn && !_auth.loading.value) {
      Get.snackbar('Login failed', 'Please check credentials', snackPosition: SnackPosition.BOTTOM);
    }
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppThemeColors.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Top brand area with soft gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppThemeColors.primaryLightColor.withOpacity(0.25),
                        child: Icon(Icons.event_available_rounded, size: 48, color: AppThemeColors.primaryColor),
                      ),
                      const SizedBox(height: 12),
                      AppTextWidget.veryLarge(
                        'Welcome',
                        align: TextAlign.center,
                        color: AppThemeColors.whiteColor,
                      ),
                      const SizedBox(height: 4),
                      AppTextWidget.medium(
                        '${'login'.tr} to continue',
                        align: TextAlign.center,
                        color: AppThemeColors.whiteColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Card with form
                Card(
                  elevation: 4,
                  color: AppThemeColors.cardBackgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 18, left: 18, bottom: 5),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email

                           TextFieldWidget(
                              controller: emailC,
                              keyboardInputType: TextInputType.emailAddress,
                              labelText: 'Email',
                              hintText: "abc@gmail.com",
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Please enter email';
                                if (!GetUtils.isEmail(v.trim())) return 'Enter a valid email';
                                return null;
                              },
                            ),

                          const SizedBox(height: 5),
                          TextFieldWidget(
                              controller: passC,
                              keyboardInputType: TextInputType.emailAddress,
                              labelText: 'Password',
                              validator: (v) {
                                if (v == null || v
                                    .trim()
                                    .isEmpty) {
                                  return 'Please enter password';
                                }
                                if (v
                                    .trim()
                                    .length < 4) {
                                  return 'Password too short';
                                }
                                return null;
                              },
                            ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => InkWell(
                                onTap: () => rememberMe.toggle(),
                                borderRadius: BorderRadius.circular(6),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: rememberMe.value,
                                      onChanged: (v) => rememberMe.value = v ?? false,
                                      activeColor: AppThemeColors.primaryColor,
                                    ),
                                    AppTextWidget.small('Remember me', color: AppThemeColors.textSecondaryColor),
                                  ],
                                ),
                              )),
                              TextButton(
                                onPressed: () {
                                  Get.snackbar('Info', 'Forgot password tapped', snackPosition: SnackPosition.BOTTOM);
                                },
                                child: AppTextWidget.small('Forgot?', color: AppThemeColors.primaryColor),
                              )
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Login button / loader
                          Obx(() {
                            if (_auth.loading.value) {
                              return SizedBox(
                                height: 48,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(AppThemeColors.primaryColor),
                                  ),
                                ),
                              );
                            }

                            return SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppThemeColors.buttonBgColor,
                                  foregroundColor: AppThemeColors.buttonTextColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 1.5,
                                ),
                                child: AppTextWidget.medium('login'.tr, color: Colors.white),
                              ),
                            );
                          }),

                          const SizedBox(height: 12),

                          // OR separator
                          Row(
                            children: [
                              Expanded(child: Divider(color: AppThemeColors.dividerColor)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: AppTextWidget.small('OR', color: AppThemeColors.textSecondaryColor),
                              ),
                              Expanded(child: Divider(color: AppThemeColors.dividerColor)),
                            ],
                          ),

                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => Get.toNamed('/register'),
                            child: AppTextWidget.small('Create an account', color: AppThemeColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Footer or version
                AppTextWidget.verySmall('Version 1.0.0', color: AppThemeColors.whiteColor, align: TextAlign.center),
              ],
            ).marginAll(10),
          )        ),
      ),
    );
  }
}
