import 'package:attedance_management_system/controller/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../models/address.dart';
import '../../models/user.dart';
import '../../widgets/form_widgets/dropdown_field_widget.dart';
import '../../widgets/form_widgets/text_field_widget.dart';
import '../../widgets/text_and_icon_widgets/app_text_type.dart';

typedef OnUserSaved = void Function(Map<String, dynamic> userData);

class UserForm extends StatefulWidget {
  final User? initialData; // optional to edit existing user

  const UserForm({this.initialData, Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {

  final AdminController _adminController =  Get.find<AdminController>();
  final _formKey = GlobalKey<FormState>();

  User? editUser;

  // controllers
  late final TextEditingController firstNameC;
  late final TextEditingController middleNameC;
  late final TextEditingController lastNameC;
  late final TextEditingController emailC;
  late final TextEditingController phoneC;
  late final TextEditingController usernameC;
  late final TextEditingController passwordC;
  late final TextEditingController dobC;
  late final TextEditingController addressC;

  String role = 'user';
  DateTime? selectedDob;

  @override
  void initState() {
    super.initState();
    editUser = widget.initialData;

    firstNameC = TextEditingController(text: editUser?.firstName ?? '');
    middleNameC = TextEditingController(text: editUser?.middleName ?? '');
    lastNameC = TextEditingController(text: editUser?.lastName ?? '');
    emailC = TextEditingController(text: editUser?.email ?? '');
    phoneC = TextEditingController(text: editUser?.phoneNo ?? '');
    usernameC = TextEditingController(text: editUser?.username ?? '');
    selectedDob = editUser?.dob is DateTime ? editUser?.dob as DateTime : null;
    dobC = TextEditingController(text: selectedDob != null ? _formatDate(selectedDob!) : '');
    role = editUser?.role ?? 'user';
    addressC = TextEditingController();
    passwordC = TextEditingController();
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
      initialDate: selectedDob ?? DateTime(now.year - 20),
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
      selectedDob = picked;
      dobC.text = _formatDate(picked);
      setState(() {});
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() != true) return;

    // Build Address (use your actual Address model fields)
    final address = Address(
      street: '45, Ganesh Nagar',
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
      countryCode: '122',
      phoneNo: phoneC.text.trim(),
      username: usernameC.text.trim(),
      password: passwordC.text, // keep secure handling in real app
      genderId: '3',
      departmentId: '3',
      dob: dobC.text, // DateTime or null
      address: address,
      role: role,
      roleId: '7',
    );

    // FIX 1: Declare a single nullable variable outside the blocks to hold the result
    dynamic result;
    String successMessage = "";

    // Call controller method that accepts User
    if (widget.initialData == null) {
      result = await _adminController.addUser(user: user);
      successMessage = 'User created successfully';
    } else if (widget.initialData != null && widget.initialData?.key != null) {
      result = await _adminController.updateUser(widget.initialData!.key!, user);
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
    // Use a draggable sheet if used as bottom sheet; otherwise it's a responsive card
    return  DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        builder: (context, sc) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppThemeColors.containerBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: SingleChildScrollView(
              controller: sc,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // grab handle
                  Center(
                    child: Container(
                      height: 6,
                      width: 60,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: AppThemeColors.dividerColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  Row(

                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.arrow_back,),
                      ),
                      AppTextWidget.medium(widget.initialData == null ? 'Add New User' : 'Edit User', color: AppThemeColors.textPrimaryColor),
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
                                hintText: 'Optional',
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
                                hintText: 'Enter last name',
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
                          hintText: 'example@mail.com',
                          keyboardInputType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 5),


                        TextFieldWidget(
                          controller: phoneC,
                          labelText: 'Phone No',
                          hintText: '+91 99999 99999',
                          keyboardInputType: TextInputType.phone,
                          validator: _validatePhone,
                        ),
                        const SizedBox(height: 5),

                        // Username & DOB
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldWidget(
                                controller: usernameC,
                                labelText: 'Username',
                                hintText: 'username123',
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
                                    hintText: 'DD/MM/YYYY',
                                    readOnly: true,
                                    validator: (v) {
                                      if (selectedDob == null) return 'Select DOB';
                                      return null;
                                    },
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
                          hintText: 'Password',
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
                          hintText: 'Street, City, State, ZIP',
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
                          value: role,
                          items: [
                            {'id': 'user', 'name': 'User'},
                            {'id': 'admin', 'name': 'Admin'},
                          ],
                          onChanged: (v) => setState(() => role = v ?? 'user'),
                        ),

                        const SizedBox(height: 18),

                        // Save button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppThemeColors.primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: AppTextWidget.medium('Save', color: Colors.white),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  }
}
