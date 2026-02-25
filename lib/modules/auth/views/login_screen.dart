import 'dart:convert';

import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/modules/common/controller/common_controller.dart';
import 'package:attedance_management_system/modules/models/masterData.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/container/common_container.dart';
import 'package:attedance_management_system/widgets/form_widgets/text_field_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/constants/app_theme_colors.dart';
import '../../../../core/constants/text_styles.dart';
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

    // emailC.text = "nsr@gmail.com";
    // passC.text = "123456";

    emailC.text = "";
    passC.text = "";

  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }


// updated _submit()
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

    // --- Location Retrieval ---
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
      print('Location error: $e');
      Get.snackbar(
        'Location',
        'Failed to retrieve location',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // --- Master Data & Office Radius Validation ---
    MasterData? masterData = _commonController.masterData.value;

    if (lat == null || lng == null) {
      Get.snackbar(
        'Location',
        'Unable to get your current location.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final officeLat = double.tryParse(masterData?.officeLat ?? '');
    final officeLng = double.tryParse(masterData?.officeLong ?? '');
    final officeRadius = masterData?.officeRadius;

    if (officeLat == null || officeLng == null) {
      Get.snackbar(
        'Office Location',
        'Office coordinates are not configured properly.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final isInsideOfficeRadius = LocationService.instance.isWithinRadius(
      userLat: lat,
      userLng: lng,
      targetLat: officeLat,
      targetLng: officeLng,
      radiusInMeters: officeRadius?.toDouble() ?? 100, // 100 meters
    );
    // --- Device Information Retrieval ---
    final Map<String, dynamic> deviceDataMap = await DeviceService.getDeviceInformation();

    final DeviceInfo deviceInformation = DeviceInfo.fromJson(deviceDataMap);
    // --- Create Login Model and Call Auth Service ---
    final loginPayload = Login(
      email: emailC.text.trim(),
      password: passC.text.trim(),
      lat: lat,
      long: lng,
      deviceInformation: deviceInformation,
    );

    await _auth.login(loginPayload);

    if (!_auth.isLoggedIn) {
    } else {
      storageService.saveMap(AppStrings.deviceInformation, deviceInformation.toJson());
    }
  }


  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  width: kIsWeb ? MediaQuery.of(context).size.width * .3 : MediaQuery.of(context).size.width,
                  child: CommonCardWidget(
                    color: AppThemeColors.whiteColor,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email

                              SizedBox(height: 20,),
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
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppThemeColors.buttonBgColor,
                                foregroundColor: AppThemeColors.buttonTextColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: AppThemeColors.enableBorderColor)),
                                elevation: 1.5,

                              ),
                              child: AppTextWidget.medium('login'.tr, color: Colors.white),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // OR separator
                          // Row(
                          //   children: [
                          //     Expanded(child: Divider(color: AppThemeColors.dividerColor)),
                          //     Padding(
                          //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          //       child: AppTextWidget.small('OR', color: AppThemeColors.textSecondaryColor),
                          //     ),
                          //     Expanded(child: Divider(color: AppThemeColors.dividerColor)),
                          //   ],
                          // ),
                          //
                          // const SizedBox(height: 10),
                          // TextButton(
                          //   onPressed: () => Get.toNamed('/register'),
                          //   child: AppTextWidget.small('Create an account', color: AppThemeColors.primaryColor),
                          // ),
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
