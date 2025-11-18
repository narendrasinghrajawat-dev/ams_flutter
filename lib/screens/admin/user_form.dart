import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../widgets/app_text_type.dart';

typedef OnUserSaved = void Function(String name, String email, String role);

class UserForm extends StatefulWidget {
  final OnUserSaved onSaved;

  const UserForm({required this.onSaved, Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  String role = 'user';

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) return;
    widget.onSaved(nameC.text.trim(), emailC.text.trim(), role);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, sc) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppThemeColors.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: sc,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 6,
                    width: 60,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppThemeColors.dividerColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: (){
                      Get.back();
                    }, icon: Icon(Icons.arrow_back)),
                    AppTextWidget.large('Add New User', color: AppThemeColors.textPrimaryColor),
                  ],
                ),

                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameC,
                        decoration: InputDecoration(
                          label: AppTextWidget.small('Full Name'),
                          filled: true,
                          fillColor: AppThemeColors.cardBackgroundColor,
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppThemeColors.borderColor), borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppThemeColors.primaryColor), borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailC,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: AppTextWidget.small('Email'),
                          filled: true,
                          fillColor: AppThemeColors.cardBackgroundColor,
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppThemeColors.borderColor), borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppThemeColors.primaryColor), borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter email';
                          if (!GetUtils.isEmail(v.trim())) return 'Invalid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: role,
                        items: [
                          DropdownMenuItem(value: 'user', child: AppTextWidget.small('User')),
                          DropdownMenuItem(value: 'admin', child: AppTextWidget.small('Admin')),
                        ],
                        onChanged: (v) => setState(() => role = v ?? 'user'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppThemeColors.cardBackgroundColor,
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppThemeColors.borderColor), borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(backgroundColor: AppThemeColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: AppTextWidget.medium('Save', color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
