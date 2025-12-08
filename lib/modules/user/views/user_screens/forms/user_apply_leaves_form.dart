import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/modules/user/controller/user_leaves_controller.dart';
import 'package:attedance_management_system/widgets/form_widgets/radio_button_widget.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/form_widgets/text_field_widget.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../../../widgets/form_widgets/dropdown_field_widget.dart';
import '../../../../auth/controller/auth_controller.dart';
import '../../../../common/controller/common_controller.dart';
import '../../../../models/apply_leave_request.dart';
import '../../../../models/masterData.dart';

class UserApplyLeavesForm extends StatefulWidget {
  const UserApplyLeavesForm({super.key, this.editForm});

  final ApplyLeaveRequest? editForm;

  @override
  State<UserApplyLeavesForm> createState() => _UserApplyLeavesFormState();
}

class _UserApplyLeavesFormState extends State<UserApplyLeavesForm> {

  final UserLeavesController _userLeavesController = Get.find<UserLeavesController>();
  final AuthController _auth = Get.find<AuthController>();
  final CommonController _commonController = Get.find<CommonController>();





  final _formKey = GlobalKey<FormState>();

  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _daysController =
  TextEditingController(text: '1');
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  bool isSaved = false;
  MasterData? masterData;

  // For API
  String _leaveType = 'Casual';
  String? _startDate; // yyyy-MM-dd
  String? _endDate; // yyyy-MM-dd

  // For date picker
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  bool _isFullDay = true;
  bool _isHalfDay = false;



  String? leaveTypeId;
  List<Map<String, dynamic>> leaveTypeList = [];

  String? leaveDurationsId;
  List<Map<String, dynamic>> leaveDurationsList = [];

  @override
  void initState() {
    super.initState();
    getMasterData();
    _initEditData();
  }

  getMasterData() async {
    masterData = _commonController.masterData.value;
    leaveTypeList = masterData!.leaveType
        .map((item) => item.toJson()) // Converts each MasterDataItem instance to a Map
        .toList();                     // Collects the resulting Maps into a new List

    leaveDurationsList = masterData!.leaveDurationsType
        .map((item) => item.toJson()) // Converts each MasterDataItem instance to a Map
        .toList();

  }
  Future<void> _initEditData() async {

    final edit = widget.editForm;
    if (edit == null) return;

    // Reason
    _reasonController.text = edit.reason ?? '';

    // Days
    final n = edit.numberOfLeaves;
    _daysController.text =
    n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(1);

    // Leave type (map backend string to our dropdown)
    _leaveType = edit.leaveType ?? 'Casual';
    final typeItem = leaveTypeList
        .firstWhereOrNull((e) => e['name']?.toLowerCase() == _leaveType.toLowerCase());
    leaveTypeId = typeItem?['id'];

    // Full / half day
    leaveDurationsId = _isHalfDay ? '2' : '1';

    // Dates: assume backend sends yyyy-MM-dd or yyyy-MM-ddTHH:mm...
    if (edit.startDate.isNotEmpty) {
      _startDate = _normalizeApiDate(edit.startDate!);
      final dt = DateTime.tryParse(_startDate!);
      if (dt != null) {
        _startDateTime = dt;
        _startDateController.text = _formatDateForUi(dt);
      }
    }

    if (edit.endDate != null && edit.endDate!.isNotEmpty) {
      _endDate = _normalizeApiDate(edit.endDate!);
      final dt = DateTime.tryParse(_endDate!);
      if (dt != null) {
        _endDateTime = dt;
        _endDateController.text = _formatDateForUi(dt);
      }
    }
  }

  String _normalizeApiDate(String raw) {
    // If date has time part, keep only date.
    final parts = raw.split('T');
    return parts.first;
  }

  String _formatDateForApi(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  String _formatDateForUi(DateTime d) {
    // DD/MM/YYYY or whatever you prefer
    final day = d.day.toString().padLeft(2, '0');
    final m = d.month.toString().padLeft(2, '0');
    final y = d.year.toString();
    return '$day/$m/$y';
  }

  errorMessageFunc() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: AppTextWidget.medium("Required Field",
          color: AppThemeColors.errorColor),
    );
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final initial = _startDateTime ?? now;
    final first = DateTime(now.year - 1);
    final last = DateTime(now.year + 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );

    if (picked != null) {
      setState(() {
        _startDateTime = picked;
        _startDate = _formatDateForApi(picked);
        _startDateController.text = _formatDateForUi(picked);

        // If end date is before start, reset end
        if (_endDateTime != null && _endDateTime!.isBefore(picked)) {
          _endDateTime = picked;
          _endDate = _formatDateForApi(picked);
          _endDateController.text = _formatDateForUi(picked);
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    if (_startDateTime == null) {
      Get.snackbar(
        'Select start date',
        'Please select start date first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final first = _startDateTime!;
    final last = DateTime(first.year + 1);
    final initial = _endDateTime ?? first;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );

    if (picked != null) {
      setState(() {
        _endDateTime = picked;
        _endDate = _formatDateForApi(picked);
        _endDateController.text = _formatDateForUi(picked);
      });
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isSaved = true;
    });

    if (_formKey.currentState?.validate() != true) return;

    // Check date presence
    if (_startDate == null || _endDate == null) {
      Get.snackbar(
        'Missing dates',
        'Please select start and end dates',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Check logical order
    final s = DateTime.tryParse(_startDate!);
    final e = DateTime.tryParse(_endDate!);
    if (s != null && e != null && e.isBefore(s)) {
      Get.snackbar(
        'Invalid date range',
        'End date cannot be before start date',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Set full/half day based on radio selection
    _isFullDay = leaveDurationsId == '1';
    _isHalfDay = leaveDurationsId == '2';

    if (!_isFullDay && !_isHalfDay) {
      Get.snackbar(
        'Select leave duration',
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

    final int numberOfLeaves = int.tryParse(_daysController.text.trim()) ?? 1;

    final req = ApplyLeaveRequest(
      // if you want to keep original key on edit
      key: widget.editForm?.key,
      id: widget.editForm?.id,
      rev: widget.editForm?.rev,
      isActive: true,
      userKey: userKey,
      approverByKey:  widget.editForm?.approverByKey,
      approverByName:  widget.editForm?.approverByName,
      leaveStatus: widget.editForm?.leaveStatus ?? AppStrings.pendingStatusKey,
      startDate: _startDate ?? "",
      endDate: _endDate ?? "",
      reason: _reasonController.text.trim(),
      leaveType: _leaveType,
      numberOfLeaves: numberOfLeaves.toDouble(),
      actionDate: widget.editForm?.actionDate ?? DateTime.now().toString(),
      leaveDurationsType: widget.editForm?.leaveDurationsType ?? leaveDurationsId!,
      modifiedDate: '',
      createdDate: '',
    );

    print('ApplyLeaveRequest payload: ${req.toJson()}');

    // For now we always call applyLeave; if you add update API,
    // you can branch here on widget.editForm != null.
    final ok = await _userLeavesController.applyLeave(req);

    if (ok) {
      Get.back();
      Get.snackbar(
        'Success',
        widget.editForm == null
            ? 'Leave applied successfully'
            : 'Leave updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to submit leave. Try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _daysController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isEdit = widget.editForm != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextWidget.large(
                isEdit ? 'Edit Leave' : 'Apply Leave',
                color: AppThemeColors.textPrimaryColor,
              ),
              AppIconButtonWidget.large(
                onPressed: () => Get.back(),
                icon: Icons.close,
                color: AppThemeColors.iconColor,
              ),
            ],
          ).marginOnly(bottom: 10),

          Form(
            key: _formKey,
            child: Column(
              children: [
                // Start Date
                TextFieldWidget(
                  controller: _startDateController,
                  labelText: "Start Date",
                  suffixIcon: const Icon(Icons.date_range),
                  onTep: _pickStartDate,
                  keyboardInputType: TextInputType.datetime,
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required Field *";
                    }
                    return null;
                  },
                ),

                // End Date
                TextFieldWidget(
                  controller: _endDateController,
                  labelText: "End Date",
                  suffixIcon: const Icon(Icons.date_range),
                  onTep: _pickEndDate,
                  keyboardInputType: TextInputType.datetime,
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required Field *";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Leave Type dropdown
                DropdownFieldWidget(
                  labelText: "Leave Type",
                  items: leaveTypeList,
                  value: leaveTypeId,
                  onChanged: (value) {
                    setState(() {
                      leaveTypeId = value;
                      final match = leaveTypeList
                          .firstWhereOrNull((e) => e['id'] == value);
                      _leaveType = match?['name'] ?? 'Casual';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required *";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Number of days
                TextFieldWidget(
                  controller: _daysController,
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

                // Full day / Half day radio
                FormField<String>(
                  initialValue: leaveDurationsId,
                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppRadioListTileFieldWidget(
                          radioList: leaveDurationsList,
                          radioId: leaveDurationsId,
                          onChanged: (String? value) {
                            if (value != leaveDurationsId) {
                              setState(() {
                                leaveDurationsId = value!;
                                _isFullDay = value == '1';
                                _isHalfDay = value == '2';
                              });
                              state.didChange(value);
                            }
                          },
                        ),
                        if (state.hasError && leaveDurationsId == null)
                          errorMessageFunc(),
                      ],
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required Field *";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Reason
                TextFieldWidget(
                  controller: _reasonController,
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

                // Submit button / loader
                Obx(() {
                  if (_userLeavesController.applyingLeave.value) {
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
                        isEdit ? 'Update Leave' : 'Apply Leave',
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
