import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/modules/common/controller/common_controller.dart';
import 'package:attedance_management_system/modules/models/masterData.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/form_widgets/text_field_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/constants/app_theme_colors.dart';
import '../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../common/services/device_information_service.dart';
import '../../common/services/location_service.dart';
import '../../common/services/storage_service.dart';
import '../../models/device_info.dart';
import '../../models/login.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _auth = Get.find<AuthController>();
  final _box = GetStorage();
  final StorageService storageService = StorageService();
  final CommonController _commonController = Get.find<CommonController>();

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final RxBool rememberMe = false.obs;
  final RxBool obscure = true.obs;

  @override
  void initState() {
    super.initState();
    // load saved email if remember-me was used before
    final saved = _box.read(AppStrings.rememberMe) ?? false;
    rememberMe.value = saved;
    if (saved) {
      final savedEmail = _box.read(AppStrings.savedEmail) as String?;
      if (savedEmail != null) emailC.text = savedEmail;
    }
    emailC.text = "";
    passC.text = "";
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

    // Persist remember me choice
    if (rememberMe.value) {
      _box.write(AppStrings.rememberMe, true);
      _box.write(AppStrings.savedEmail, emailC.text.trim());
    } else {
      _box.remove(AppStrings.rememberMe);
      _box.remove(AppStrings.savedEmail);
    }

    // Location Retrieval
    double? lat;
    double? lng;
    try {
      final locRes = await LocationService.instance.getCurrentLocation();

      if (locRes.ok && locRes.position != null) {
        lat = locRes.position!.latitude;
        lng = locRes.position!.longitude;

        storageService.saveString(AppStrings.loginLat, lat.toString());
        storageService.saveString(AppStrings.loginLong, lng.toString());
      } else {
        final message = locRes.message != null && locRes.message!.isNotEmpty
            ? locRes.message!
            : 'Location not available';
        Get.snackbar('Location', message, snackPosition: SnackPosition.BOTTOM);
        return;
      }
    } catch (e) {
      Get.snackbar(
        'Location',
        'Failed to retrieve location',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (lat == null || lng == null) {
      Get.snackbar(
        'Location',
        'Unable to get your current location.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final Map<String, dynamic> deviceDataMap = await DeviceService.getDeviceInformation();
    final DeviceInfo deviceInformation = DeviceInfo.fromJson(deviceDataMap);

    final loginPayload = Login(
      email: emailC.text.trim(),
      password: passC.text.trim(),
      lat: lat,
      long: lng,
      deviceInformation: deviceInformation,
    );

    await _auth.login(loginPayload);

    if (_auth.isLoggedIn) {
      storageService.saveMap(AppStrings.deviceInformation, deviceInformation.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppThemeColors.isDark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppThemeColors.scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: kIsWeb ? 440 : double.infinity,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Brand Icon / Header
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppThemeColors.primaryColor,
                            AppThemeColors.primaryDarkColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppThemeColors.primaryColor.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.event_available_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Welcome Text
                    AppTextWidget.veryLarge(
                      'Welcome to AMS',
                      align: TextAlign.center,
                      color: AppThemeColors.textPrimaryColor,
                    ),

                    const SizedBox(height: 6),

                    AppTextWidget.small(
                      'Sign in to manage attendance & leaves',
                      align: TextAlign.center,
                      color: AppThemeColors.textSecondaryColor,
                    ),

                    const SizedBox(height: 28),

                    // Card with form
                    CommonCardWidget(
                      padding: 20,
                      borderRadius: 18,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldWidget(
                              controller: emailC,
                              keyboardInputType: TextInputType.emailAddress,
                              labelText: 'Email Address',
                              hintText: "name@company.com",
                              prefix: const Icon(Icons.email_outlined, size: 20),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Please enter email';
                                if (!GetUtils.isEmail(v.trim())) return 'Enter a valid email';
                                return null;
                              },
                            ),

                            const SizedBox(height: 12),

                            Obx(() => TextFieldWidget(
                              controller: passC,
                              labelText: 'Password',
                              hintText: "••••••••",
                              prefix: const Icon(Icons.lock_outline, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscure.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                ),
                                onPressed: () => obscure.toggle(),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Please enter password';
                                }
                                if (v.trim().length < 4) {
                                  return 'Password too short';
                                }
                                return null;
                              },
                            )),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => InkWell(
                                  onTap: () => rememberMe.toggle(),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: rememberMe.value,
                                          onChanged: (v) => rememberMe.value = v ?? false,
                                          activeColor: AppThemeColors.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      AppTextWidget.small('Remember me', color: AppThemeColors.textSecondaryColor),
                                    ],
                                  ),
                                )),
                                TextButton(
                                  onPressed: () {
                                    Get.snackbar('Info', 'Contact admin to reset password', snackPosition: SnackPosition.BOTTOM);
                                  },
                                  child: AppTextWidget.small('Forgot Password?', color: AppThemeColors.primaryColor),
                                )
                              ],
                            ),

                            const SizedBox(height: 22),

                            // Login button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppThemeColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                  shadowColor: AppThemeColors.primaryColor.withOpacity(0.4),
                                ),
                                child: AppTextWidget.medium(
                                  'Sign In',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Version footer
                    AppTextWidget.verySmall(
                      'Version ${AppStrings.appVersion}',
                      color: AppThemeColors.textSecondaryColor,
                      align: TextAlign.center,
                    ),
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
