import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attedance_management_system/controller/auth_controller.dart';
import 'package:attedance_management_system/controller/user_controller.dart';
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:attedance_management_system/models/apply_leave_request.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/form_widgets/text_field_widget.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';

class UserApplyLeavesForm extends StatefulWidget {
  const UserApplyLeavesForm({super.key});

  @override
  State<UserApplyLeavesForm> createState() => _UserApplyLeavesFormState();
}

class _UserApplyLeavesFormState extends State<UserApplyLeavesForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _reasonC = TextEditingController();
  final TextEditingController _daysC = TextEditingController(text: '1');

  String _leaveType = 'Casual';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isFullDay = true;
  bool _isHalfDay = false;

  final UserController _userController = Get.find<UserController>();
  final AuthController _auth = Get.find<AuthController>();

  @override
  void dispose() {
    _reasonC.dispose();
    _daysC.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      initialDate: _startDate ?? now,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    if (_startDate == null) {
      Get.snackbar(
        'Select start date',
        'Please select start date first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final picked = await showDatePicker(
      context: context,
      firstDate: _startDate!,
      lastDate: DateTime(_startDate!.year + 1),
      initialDate: _endDate ?? _startDate!,
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return 'Select date';
    return '${d.year.toString().padLeft(4, "0")}-${d.month.toString().padLeft(2, "0")}-${d.day.toString().padLeft(2, "0")}';
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_startDate == null || _endDate == null) {
      Get.snackbar(
        'Missing dates',
        'Please select start and end dates',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_formKey.currentState?.validate() != true) return;

    if (!_isFullDay && !_isHalfDay) {
      Get.snackbar(
        'Select leave type',
        'Choose full day or half day',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final currentUser = _auth.currentUser.value;
    final userKey = currentUser?.key ?? currentUser?.id ?? '';

    if (userKey.isEmpty) {
      Get.snackbar(
        'User not found',
        'Unable to find logged in user key',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final int numberOfLeaves = int.tryParse(_daysC.text.trim()) ?? 1;

    final req = ApplyLeaveRequest(
      userKey: userKey,
      startDate: _formatDate(_startDate),
      endDate: _formatDate(_endDate),
      reason: _reasonC.text.trim(),
      leaveType: _leaveType,
      numberOfLeaves: numberOfLeaves.toDouble(),
      isFullDay: _isFullDay,
      isHalfDay: _isHalfDay,
    );

    print('res is the ${req.toJson()}');

    final ok = await _userController.applyLeave(req);

    if (ok) {
      Get.back();
      Get.snackbar(
        'Success',
        'Leave applied successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to apply leave. Try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 60,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppThemeColors.dividerColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close, color: AppThemeColors.iconColor),
              ),
              AppTextWidget.large(
                'Apply Leave',
                color: AppThemeColors.textPrimaryColor,
              ),
            ],
          ),

          const SizedBox(height: 8),
          AppTextWidget.verySmall(
            'Fill the details below to apply for leave.',
            color: AppThemeColors.muted,
          ),
          const SizedBox(height: 16),

          Form(
            key: _formKey,
            child: Column(
              children: [
                // Date range row
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickStartDate,
                        borderRadius: BorderRadius.circular(12),
                        child: CommonCardWidget(
                          color: AppThemeColors.cardBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextWidget.verySmall(
                                'Start Date',
                                color: AppThemeColors.textSecondaryColor,
                              ),
                              const SizedBox(height: 6),
                              AppTextWidget.small(
                                _startDate == null
                                    ? 'Select date'
                                    : _formatDate(_startDate),
                                color: AppThemeColors.textPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: _pickEndDate,
                        borderRadius: BorderRadius.circular(12),
                        child: CommonCardWidget(
                          color: AppThemeColors.cardBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextWidget.verySmall(
                                'End Date',
                                color: AppThemeColors.textSecondaryColor,
                              ),
                              const SizedBox(height: 6),
                              AppTextWidget.small(
                                _endDate == null
                                    ? 'Select date'
                                    : _formatDate(_endDate),
                                color: AppThemeColors.textPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Leave type dropdown
                DropdownButtonFormField<String>(
                  value: _leaveType,
                  decoration: InputDecoration(
                    labelText: 'Leave Type',
                    filled: true,
                    fillColor: AppThemeColors.cardBackgroundColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      BorderSide(color: AppThemeColors.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      BorderSide(color: AppThemeColors.primaryColor),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Casual',
                      child: Text('Casual Leave'),
                    ),
                    DropdownMenuItem(
                      value: 'Sick',
                      child: Text('Sick Leave'),
                    ),
                    DropdownMenuItem(
                      value: 'Annual',
                      child: Text('Annual Leave'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _leaveType = v);
                  },
                ),

                const SizedBox(height: 12),

                // Number of days (common text field)
                TextFieldWidget(
                  controller: _daysC,
                  labelText: 'Number of Leaves',
                  hintText: 'Enter number of days',
                  keyboardInputType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter number of leaves';
                    }
                    final n = int.tryParse(v.trim());
                    if (n == null || n <= 0) {
                      return 'Enter valid number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Full day / Half day toggle
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _isFullDay,
                        onChanged: (v) {
                          setState(() {
                            _isFullDay = v ?? false;
                            if (_isFullDay) _isHalfDay = false;
                          });
                        },
                        title: AppTextWidget.small(
                          'Full Day',
                          color: AppThemeColors.textPrimaryColor,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _isHalfDay,
                        onChanged: (v) {
                          setState(() {
                            _isHalfDay = v ?? false;
                            if (_isHalfDay) _isFullDay = false;
                          });
                        },
                        title: AppTextWidget.small(
                          'Half Day',
                          color: AppThemeColors.textPrimaryColor,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Reason (common text field, multiline)
                TextFieldWidget(
                  controller: _reasonC,
                  labelText: 'Reason',
                  hintText: 'Describe your reason for leave',
                  keyboardInputType: TextInputType.multiline,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter reason';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Submit button
                Obx(() {
                  if (_userController.applyingLeave.value) {
                    return SizedBox(
                      height: 46,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            AppThemeColors.primaryColor,
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: AppTextWidget.medium(
                        'Apply Leave',
                        color: AppThemeColors.whiteColor,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
