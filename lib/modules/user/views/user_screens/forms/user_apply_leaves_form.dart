import 'package:attedance_management_system/core/constants/app_icons.dart';
import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/modules/user/controller/user_leaves_controller.dart';
import 'package:attedance_management_system/widgets/common/ui_helper_widgets.dart';
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
import '../../../helper/user_apply_leave_helper.dart';

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
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  bool isSaved = false;
  MasterData? masterData;

  // For API
  String? _startDate; // yyyy-MM-dd
  String? _endDate; // yyyy-MM-dd

  // For date picker
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  String? leaveTypeId;
  List<Map<String, dynamic>> leaveTypeList = [];

  String? leaveDurationsId;
  List<Map<String, dynamic>> leaveDurationsList = [];

  String? halfDayShiftTypeId;
  List<Map<String, dynamic>> halfDayShiftTypeList = [];

  @override
  void initState() {
    super.initState();
    getMasterData();
    _initEditData();
  }

  // load master data (leave types, durations, etc.)
  getMasterData() async {
    masterData = _commonController.masterData.value;
    if (masterData != null) {
      leaveTypeList = masterData!.leaveType
          .map((item) => item.toJson())
          .toList();
      leaveDurationsList = masterData!.leaveDurationsType
          .map((item) => item.toJson())
          .toList();

      halfDayShiftTypeList = masterData!.halfDayShiftType
          .map((item) => item.toJson())
          .toList();

      setState(() {}); // update UI after loading lists
    }
  }

  Future<void> _initEditData() async {
    final edit = widget.editForm;
    if (edit == null) return;

    // Reason
    _reasonController.text = edit.reason ?? '';

    // Days
    final n = edit.numberOfLeaves ?? 1.0;
    _daysController.text = n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(1);

    // Full / half day
    leaveDurationsId = edit.leaveDurationsType ?? '1';

    // Dates: assume backend sends yyyy-MM-dd or yyyy-MM-ddTHH:mm...
    if (edit.startDate.isNotEmpty) {
      _startDate = _normalizeApiDate(edit.startDate);
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

    setState(() {});
  }

  String _normalizeApiDate(String raw) {
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
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDateTime ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );

    if (picked == null) return;

    setState(() {
      _startDateTime = picked;
      _startDate = picked.toIso8601String();

      _startDateController.text = UserApplyLeaveHelper.formatDateForUi(picked);

      if (_endDateTime != null && _endDateTime!.isBefore(picked)) {
        _endDateTime = picked;
        _endDate = picked.toIso8601String();

        _endDateController.text =
            UserApplyLeaveHelper.formatDateForUi(picked);
      }

      _recalculateDays();
    });
  }

  Future<void> _pickEndDate() async {
    if (_startDateTime == null) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: _endDateTime ?? _startDateTime!,
      firstDate: _startDateTime!,
      lastDate: DateTime(_startDateTime!.year + 2),
    );

    if (picked == null) return;

    setState(() {
      _endDateTime = picked;
      _endDate = picked.toIso8601String();
      _endDateController.text = UserApplyLeaveHelper.formatDateForUi(picked);

      _recalculateDays();
    });
  }

  void _recalculateDays() {
    if (_startDateTime == null || _endDateTime == null) {
      _daysController.clear();
      return;
    }

    final isHalfDay = leaveDurationsId == '2';

    final days = UserApplyLeaveHelper.calculateDaysBetween(
      start: _startDateTime!,
      end: _endDateTime!,
      isHalfDay: isHalfDay,
    );

    _daysController.text = days % 1 == 0 ? days.toInt().toString() : days.toString();
  }


  /// VALIDATE LEAVE BALANCE BASED ON SELECTED TYPE ID
  /// Returns null when valid, otherwise returns error string.
  String? _validateLeaveBalanceById() {
    try {
      final balances = _userLeavesController.filteredLeaveBalanceList;
      if (balances.isEmpty) {
        return "Leave balance not available.";
      }

      /// Find selected leave balance by ID
      final selected = balances.firstWhere(
            (e) => e.id.toString() == leaveTypeId,
      );

      if (selected == null) {
        return "Selected leave type has no balance record.";
      }

      /// ✅ PARSE AS DOUBLE (IMPORTANT)
      final requested =
          double.tryParse(_daysController.text.trim()) ?? 0.0;

      if (requested <= 0) {
        return "Enter valid number of leaves.";
      }

      /// Available balance (can be int or double)
      final availableRaw = selected.balance ?? 0;
      final available = availableRaw is num
          ? availableRaw.toDouble()
          : double.tryParse(availableRaw.toString()) ?? 0.0;

      /// HALF DAY LOGIC
      if (leaveDurationsId == '2') {
        if (requested != 0.5) {
          return "Half day leave must be 0.5 day.";
        }

        if (available < 0.5) {
          return "${selected.name} balance is insufficient. "
              "Available: $available";
        }

        return null;
      }

      /// FULL DAY LOGIC
      if (requested > available) {
        return "${selected.name} balance is insufficient. "
            "Available: $available, Requested: $requested";
      }

      return null;
    } catch (e) {
      return "Failed to validate leave balance.";
    }
  }


  /// VALIDATE DATE RANGE VS NUMBER OF LEAVES
  /// Returns null when valid, otherwise error string.

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isSaved = true;
    });

    if (_formKey.currentState?.validate() != true) return;
    final currentUser = AppHelper.getProfileUser();
    final double numberOfLeaves = double.parse(_daysController.text.toString());

    // Balance validation (ID based)
    final balanceError = _validateLeaveBalanceById();

    if (balanceError != null) {
      Get.snackbar(
        "Insufficient Balance",
        balanceError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.08),
        colorText: Colors.red,
      );
      return;
    }
    if (leaveTypeId == "2" && numberOfLeaves > 1) {
      UIHelper.showSnackbar("Warning", "Leave Limit Reached", type: SnackbarType.warning);
      return;
    }

    // Date presence & logical checks already in pickers, but double-check
    if (_startDateTime == null || _endDateTime == null) {
      Get.snackbar(
        'Missing dates',
        'Please select start and end dates',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final s = _startDateTime!;
    final e = _endDateTime!;
    if (e.isBefore(s)) {
      Get.snackbar(
        'Invalid date range',
        'End date cannot be before start date',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }


    final userKey = currentUser.key ?? currentUser.id ?? '';

    if (userKey.isEmpty) {
      Get.snackbar(
        'User not found',
        'Unable to find logged in user key',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }


    final req = ApplyLeaveRequest(
      key: widget.editForm?.key,
      id: widget.editForm?.id,
      rev: widget.editForm?.rev,
      isActive: true,
      userKey: userKey,
      approverByKey: widget.editForm?.approverByKey,
      approverByName: widget.editForm?.approverByName,
      leaveStatus: widget.editForm?.leaveStatus ?? AppStrings.pendingLeavesStatusKey,
      startDate: _startDate ?? "",
      endDate: _endDate ?? "",
      reason: _reasonController.text.trim(),
      leaveType: leaveTypeId!,
      numberOfLeaves: numberOfLeaves.toDouble(),
      actionDate: widget.editForm?.actionDate ?? DateTime.now().toString(),
      leaveDurationsType: widget.editForm?.leaveDurationsType ?? leaveDurationsId ?? '1',
      halfDayShiftType: halfDayShiftTypeId,
      modifiedDate: '',
      createdDate: '',
    );

    // Submit to controller (controller handles applyingLeave flag)

    print('apply leave ofrm ${req.toJson()}');

    final ok = await _userLeavesController.applyLeave(req);

    if (ok) {
      Get.back();
      UIHelper.showSnackbar("Success", widget.editForm == null ? 'Leave applied successfully' : 'Leave updated successfully',);
    } else {
      UIHelper.showSnackbar("Error", "Failed to submit leave. Try again.",type: SnackbarType.error);
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
              AppIconButtonWidget.large(
                onPressed: () => Get.back(),
                icon: AppConstIcons.backIcon,
                color: AppThemeColors.iconColor,
              ),
              AppTextWidget.large(
                isEdit ? 'Edit' : 'Apply',
                color: AppThemeColors.textPrimaryColor,
              ),
              AppIconButtonWidget.large(
                onPressed: () => _submit(),
                icon: AppConstIcons.saveIcon,
                color: AppThemeColors.iconColor,
              ),
            ],
          ).marginOnly(bottom: 10),

          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                // Start Date
                TextFieldWidget(
                  controller: _startDateController,
                  labelText: "Start Date *",
                  suffixIcon: const Icon(Icons.date_range),
                  onTep: _pickStartDate,
                  keyboardInputType: TextInputType.datetime,
                  readOnly: true,
                  validator: (value) {
                    if ((value == null || value.isEmpty) && isSaved == true) {
                      return "Required Field *";
                    }
                    return null;
                  },
                ),

                // End Date
                TextFieldWidget(
                  controller: _endDateController,
                  labelText: "End Date *",
                  suffixIcon: const Icon(Icons.date_range),
                  onTep: _pickEndDate,
                  keyboardInputType: TextInputType.datetime,
                  readOnly: true,
                  validator: (value) {
                    if ((value == null || value.isEmpty) && isSaved == true) {
                      return "Required Field *";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Leave Type dropdown
                DropdownFieldWidget(
                  labelText: "Leave Type *",
                  items: leaveTypeList,
                  value: leaveTypeId,
                  onChanged: (value) {
                    setState(() {
                      leaveTypeId = value;
                    });

                    final err = _validateLeaveBalanceById();
                    if (err != null) {
                      Get.snackbar(
                        "Balance Warning",
                        err,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange.withOpacity(0.08),
                        colorText: Colors.orange,
                      );
                    }
                  },
                  validator: (value) {
                    if ((value == null || value.isEmpty) && isSaved == true) {
                      return "Required Field *";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),


                TextFieldWidget(
                  enabled: false,
                  controller: _daysController,
                  labelText: 'Number of Leaves *',
                  keyboardInputType: TextInputType.number,
                  validator: (value) {
                    if ((value == null || value.isEmpty) && isSaved == true) {
                      return "Required Field *";
                    }
                    if(value.toString().toLowerCase() == "0"){
                      return "Please Enter Valid Leaves *";
                    }
                    return null;
                  },
                ),


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
                            if (value == null) return;
                            setState(() {
                              leaveDurationsId = value;
                              halfDayShiftTypeId = null;
                              _recalculateDays();
                            });
                          },
                          validator: (value) {
                            if ((value == null || value.isEmpty) && isSaved == true) {
                              return "Required Field *";
                            }

                            return null;
                          },
                        ),
                        if (state.hasError && leaveDurationsId == null) errorMessageFunc(),
                      ],
                    );
                  },

                ),
                // Full day / Half day radio
                if(leaveDurationsId == AppStrings.halfDayKey)
                FormField<String>(
                  initialValue: leaveDurationsId,
                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppRadioListTileFieldWidget(
                          radioList: halfDayShiftTypeList,
                          radioId: halfDayShiftTypeId,
                          onChanged: (String? value) {
                            if (value == null) return;
                            setState(() {
                              halfDayShiftTypeId = value;
                              _recalculateDays();
                            });
                          },
                          validator: (value) {
                            if ((value == null || value.isEmpty) && isSaved == true) {
                              return "Required Field *";
                            }

                            return null;
                          },
                        ),
                        if (state.hasError && halfDayShiftTypeId == null) errorMessageFunc(),
                      ],
                    );
                  },

                ),




                // Reason
                TextFieldWidget(
                  controller: _reasonController,
                  labelText: 'Reason *',
                  keyboardInputType: TextInputType.multiline,
                  validator: (value) {
                    if ((value == null || value.isEmpty) && isSaved == true) {
                      return "Required Field *";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 10),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper extension used in several places (if you don't already have it)
// If you have package:collection or other extension, remove this or keep both.
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
