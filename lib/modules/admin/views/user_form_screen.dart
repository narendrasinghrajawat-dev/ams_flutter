import 'package:attedance_management_system/core/constants/app_icons.dart';
import 'package:attedance_management_system/modules/admin/controller/admin_employees_controller.dart';
import 'package:attedance_management_system/modules/common/controller/common_controller.dart';
import 'package:attedance_management_system/modules/models/masterData.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/constants/app_theme_colors.dart';
import '../../../../widgets/form_widgets/dropdown_field_widget.dart';
import '../../../../widgets/form_widgets/text_field_widget.dart';
import '../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../models/address.dart';
import '../../models/user.dart';

typedef OnUserSaved = void Function(Map<String, dynamic> userData);

class UserForm extends StatefulWidget {
  final User? initialData; // optional to edit existing user

  const UserForm({this.initialData, Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {


  final CommonController _commonController = Get.find<CommonController>();
  final AdminEmployeesController _adminEmployeesController =  Get.find<AdminEmployeesController>();
  final _formKey = GlobalKey<FormState>();

  User? editUser;

  // controllers
  final TextEditingController firstNameC = TextEditingController();
  final TextEditingController middleNameC = TextEditingController();
  final TextEditingController lastNameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController dobC = TextEditingController();
  final TextEditingController addressC = TextEditingController();

  MasterData? masterData;
  String? dateOfBirth;

  String? genderId;
  List genderList = [];

  String? roleId;
  List roleList = [];




  @override
  void initState() {
    super.initState();
    editUser = widget.initialData;
    masterData = _commonController.masterData.value;
    genderList = masterData?.gender.map((item) => item.toJson()).toList() ?? [];
    roleList = masterData?.role.map((item) => item.toJson()).toList() ?? [];

    if(widget.initialData == null){
      roleId = roleList[0]['id'];
    }

    if(widget.initialData != null){
      setEditData();
    }
  }

  @override
  void dispose() {
    firstNameC.dispose();
    middleNameC.dispose();
    lastNameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    usernameC.dispose();
    dobC.dispose();
    addressC.dispose();
    super.dispose();
  }


  setEditData(){
    firstNameC.text = widget.initialData?.firstName ?? "";
    middleNameC.text = widget.initialData?.middleName ?? "";
    lastNameC.text = widget.initialData?.lastName ?? "";
    emailC.text = widget.initialData?.email ?? "";
    phoneC.text = widget.initialData?.phoneNo ?? "";
    genderId = widget.initialData?.genderId;
    usernameC.text = widget.initialData?.username ?? "";
    dobC.text = widget.initialData?.dob ?? "";
    passwordC.text = widget.initialData?.password ?? "";
    roleId = widget.initialData?.roleId;

  }




  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  Future<void> _pickDob() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final first = DateTime(now.year - 70); // limit 70 years back
    final last = DateTime(now.year - 12);  // min age 12
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppThemeColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppThemeColors.textPrimaryColor,
            ),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppThemeColors.primaryColor)),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      dateOfBirth = picked.toIso8601String();
      dobC.text = _formatDate(picked);
      setState(() {});
    }
  }

  Future<void> _save() async {

    print('save called');
    if (_formKey.currentState?.validate() != true) return;

    // Build Address (use your actual Address model fields)
    final address = Address(
      street: addressC.text,
      cityName: 'Jaipur',
      cityId: '7',
      stateName: 'Rajasthan',
      stateId: '10',
      zipCode: '302020',
      countryName: 'India',
      countryId: '4',
    );

    // Create typed User object instead of raw Map
    final user = User(
      key: widget.initialData?.key,
      id: widget.initialData?.id,
      rev: widget.initialData?.rev,
      firstName: firstNameC.text.trim(),
      middleName: middleNameC.text.trim(),
      lastName: lastNameC.text.trim(),
      email: emailC.text.trim(),
      countryCode: '+91',
      phoneNo: phoneC.text.trim(),
      username: usernameC.text.trim(),
      password: passwordC.text, // keep secure handling in real app
      genderId: genderId,
      departmentId: null,
      dob: dateOfBirth ?? "", // DateTime or null
      address: address,
      roleId: roleId,

    );

    // FIX 1: Declare a single nullable variable outside the blocks to hold the result
    dynamic result;
    String successMessage = "";

    // Call controller method that accepts User
    if (widget.initialData == null) {
      result = await _adminEmployeesController.addUser(user);
      successMessage = 'User created successfully';
    } else if (widget.initialData != null && widget.initialData?.key != null) {
      result = await _adminEmployeesController.updateUser(widget.initialData!.key!, user);
      successMessage = 'User updated successfully';
    }

    // FIX 2: Check the 'result' variable instead of the out-of-scope 'created' variable.
    if (result != null) {
      Get.back(); // close sheet
      Get.snackbar('Success', successMessage, snackPosition: SnackPosition.BOTTOM);
    } else {
      // Determine the action that failed for a clearer error message
      final action = widget.initialData == null ? 'create' : 'update';
      Get.snackbar('Error', 'Failed to $action user', snackPosition: SnackPosition.BOTTOM);
    }
  }
  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    if (v.trim().length < 2) return 'Too short';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter email';
    if (!GetUtils.isEmail(v.trim())) return 'Invalid email';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter phone';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7) return 'Invalid phone';
    return null;
  }

  String? _validateUsername(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter username';
    if (!RegExp(r'^[a-zA-Z0-9._\-]{3,}$').hasMatch(v.trim())) return 'Invalid username';
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIconButtonWidget.large(icon: AppConstIcons.backIcon, onPressed:  () => Get.back()),
              AppTextWidget.large(widget.initialData == null ? 'Add' : 'Edit', color: AppThemeColors.textPrimaryColor),
              AppIconButtonWidget.large(icon: AppConstIcons.saveIcon, onPressed:  () => _save()),
            ],
          ),


          Form(
            key: _formKey,
            child: Column(
              children: [
                // Name row: First | Middle | Last
                TextFieldWidget(
                  controller: firstNameC,
                  labelText: 'First Name',
                  hintText: 'Enter first name',
                  validator: _validateName,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        controller: middleNameC,
                        labelText: 'Middle Name',
                        validator: (v) {
                          if (v != null && v.trim().isNotEmpty && v.trim().length < 2) return 'Too short';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFieldWidget(
                        controller: lastNameC,
                        labelText: 'Last Name',
                        validator: _validateName,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // Email & Phone

                TextFieldWidget(
                  controller: emailC,
                  labelText: 'Email',
                  keyboardInputType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 5),


                TextFieldWidget(
                  controller: phoneC,
                  labelText: 'Phone No',
                  keyboardInputType: TextInputType.phone,
                  validator: _validatePhone,
                ),

                const SizedBox(height: 5),

                DropdownFieldWidget(
                  labelText: 'Gender',
                  value: genderId,
                  items: genderList,
                  onChanged: (v) => setState(() => genderId = v),
                ),
                const SizedBox(height: 5),


                // Username & DOB
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        controller: usernameC,
                        labelText: 'Username',
                        validator: _validateUsername,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickDob,
                        child: AbsorbPointer(
                          child: TextFieldWidget(
                            controller: dobC,
                            labelText: 'Date of Birth',
                            readOnly: true,

                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // Address (multiline)
                TextFieldWidget(
                  controller: passwordC,
                  labelText: 'Password',
                  keyboardInputType: TextInputType.multiline,
                  onChanged: (_) {},
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter address';
                    return null;
                  },
                ),

                const SizedBox(height: 5),

                // Address (multiline)
                TextFieldWidget(
                  controller: addressC,
                  labelText: 'Address',
                  keyboardInputType: TextInputType.multiline,
                  onChanged: (_) {},
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter address';
                    return null;
                  },
                ),

                const SizedBox(height: 10),


                // Role dropdown (uses DropdownFieldWidget if you want to reuse it)
                DropdownFieldWidget(
                  labelText: 'Role',
                  value: roleId,
                  items: roleList,
                  onChanged: (v) => setState(() => roleId = v),
                ),


              ],
            ),
          ),

          SizedBox(height: 10,),
        ],
      ),
    ).paddingSymmetric(horizontal: 10);
  }
}
