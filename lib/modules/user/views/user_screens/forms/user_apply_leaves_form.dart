import 'package:attedance_management_system/core/constants/app_icons.dart';
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
  String? _startDate; // yyyy-MM-dd
  String? _endDate; // yyyy-MM-dd

  // For date picker
  DateTime? _startDateTime;
  DateTime? _endDateTime;

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
    final today = DateTime(now.year, now.month, now.day);
    final initial = _startDateTime ?? today;
    final first = today; // prevent past date selection
    final last = DateTime(now.year + 2); // allow up to two years ahead

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );

    if (picked != null) {
      // ensure not past
      final pickedDateOnly = DateTime(picked.year, picked.month, picked.day);
      if (pickedDateOnly.isBefore(today)) {
        Get.snackbar(
          'Invalid Date',
          'Start date cannot be in the past.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.08),
          colorText: Colors.red,
        );
        return;
      }

      setState(() {
        _startDateTime = pickedDateOnly;
        _startDate = _formatDateForApi(pickedDateOnly);
        _startDateController.text = _formatDateForUi(pickedDateOnly);

        // If end date is before start, reset end to start
        if (_endDateTime != null && _endDateTime!.isBefore(pickedDateOnly)) {
          _endDateTime = pickedDateOnly;
          _endDate = _formatDateForApi(pickedDateOnly);
          _endDateController.text = _formatDateForUi(pickedDateOnly);
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

    final first = DateTime(_startDateTime!.year, _startDateTime!.month, _startDateTime!.day);
    final last = DateTime(first.year + 2);
    final initial = _endDateTime ?? first;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first, // cannot pick before start
      lastDate: last,
    );

    if (picked != null) {
      final pickedDateOnly = DateTime(picked.year, picked.month, picked.day);
      if (pickedDateOnly.isBefore(first)) {
        Get.snackbar(
          'Invalid Date',
          'End date cannot be before start date.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.08),
          colorText: Colors.red,
        );
        return;
      }

      setState(() {
        _endDateTime = pickedDateOnly;
        _endDate = _formatDateForApi(pickedDateOnly);
        _endDateController.text = _formatDateForUi(pickedDateOnly);
      });
    }
  }

  /// Helper: inclusive days between two dates (start..end)
  int _calculateInclusiveDays(DateTime start, DateTime end) {
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day);
    return endOnly.difference(startOnly).inDays + 1;
  }

  /// VALIDATE LEAVE BALANCE BASED ON SELECTED TYPE ID
  /// Returns null when valid, otherwise returns error string.
  String? _validateLeaveBalanceById() {
    try {
      final balances = _userLeavesController.filteredLeaveBalanceList;
      if (balances.isEmpty) return "Leave balance not available.";


      // Find selected balance by ID safely
      dynamic selected;
      try {
        selected = balances.firstWhere((e) => (e.id).toString() == leaveTypeId);
      } catch (e) {
        selected = null;
      }

      if (selected == null) {
        return "Selected leave type has no balance record.";
      }

      final requested = int.tryParse(_daysController.text.trim()) ?? 0;
      if (requested <= 0) return "Enter valid number of leaves.";

      // Depending on your LeaveBalance model, selected.balance may be int or num
      final available = (selected.balance ?? selected['balance'] ?? 0);
      final availableInt = (available is num) ? available.toInt() : int.tryParse(available.toString()) ?? 0;

      if (requested > availableInt) {
        final name = (selected.name ?? selected['name'] ?? 'Selected leave').toString();
        return "$name balance is insufficient. Available: $availableInt, Requested: $requested";
      }

      return null;
    } catch (e) {
      return "Failed to validate leave balance.";
    }
  }

  /// VALIDATE DATE RANGE VS NUMBER OF LEAVES
  /// Returns null when valid, otherwise error string.
  String? _validateDateRangeMatchesDays() {
    if (_startDateTime == null || _endDateTime == null) {
      return "Please select both start and end dates.";
    }

    final daysBetween = _calculateInclusiveDays(_startDateTime!, _endDateTime!);

    final requested = int.tryParse(_daysController.text.trim()) ?? 0;
    if (requested <= 0) return "Enter valid number of leaves.";

    // If half-day selected, enforce that start==end and requested == 1 (we treat 1 as one half-day unit)
    final isHalfDay = leaveDurationsId == '2';
    if (isHalfDay) {
      if (daysBetween != 1) {
        return "For half day leave, start and end date must be the same day.";
      }
      // requested should be 1 (representing the half-day unit in your UI)
      if (requested != 1) {
        return "For half day leave, number of leaves must be 1 (half-day).";
      }
      return null;
    }

    // Full day: requested must match daysBetween
    if (requested != daysBetween) {
      return "Number of days ($requested) does not match date range ($daysBetween).";
    }

    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isSaved = true;
    });

    if (_formKey.currentState?.validate() != true) return;

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

    // Date range vs number of leaves validation
    final dateRangeError = _validateDateRangeMatchesDays();
    if (dateRangeError != null) {
      Get.snackbar(
        'Date/Days Mismatch',
        dateRangeError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.08),
        colorText: Colors.red,
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
      modifiedDate: '',
      createdDate: '',
    );

    // Submit to controller (controller handles applyingLeave flag)
    final ok = await _userLeavesController.applyLeave(req);

    if (ok) {
      Get.back();
      Get.snackbar(
        'Success',
        widget.editForm == null ? 'Leave applied successfully' : 'Leave updated successfully',
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
                  labelText: "Start Date",
                  suffixIcon: const Icon(Icons.date_range),
                  onTep: _pickStartDate,
                  keyboardInputType: TextInputType.datetime,
                  readOnly: true,
                  validator: (value) {
                    if ((value == null || value.isEmpty) && isSaved == true) {
                      return "Required Field";
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
                    if ((value == null || value.isEmpty) && isSaved == true) {
                      return "Required Field";
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
                      return "Required Field";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Number of days
                TextFieldWidget(
                  controller: _daysController,
                  labelText: 'Number of Leaves',
                  keyboardInputType: TextInputType.number,
                  validator: (v) {

                    if (_startDateTime != null && _endDateTime != null) {
                      final dateErr = _validateDateRangeMatchesDays();
                      if (dateErr != null) return dateErr;
                    }

                    if (v == null || v.trim().isEmpty) {
                      return 'Enter number of leaves';
                    }
                    final n = int.tryParse(v.trim());
                    if (n == null || n <= 0) {
                      return 'Enter valid number';
                    }


                    final balanceErr = isSaved == true ? _validateLeaveBalanceById() : null;
                    if (balanceErr != null) return balanceErr;

                    // If dates are selected, ensure days match date range

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
                            if (value != leaveDurationsId) {
                              setState(() {
                                leaveDurationsId = value!;
                              });
                              state.didChange(value);
                            }
                          },
                        ),
                        if (state.hasError && leaveDurationsId == null) errorMessageFunc(),
                      ],
                    );
                  },
                  validator: (value) {
                    if ((value == null || value.isEmpty) && isSaved == true) {
                      return "Required Field";
                    }
                    return null;
                  },
                ),


                // Reason
                TextFieldWidget(
                  controller: _reasonController,
                  labelText: 'Reason',
                  hintText: 'Describe your reason for leave',
                  keyboardInputType: TextInputType.multiline,
                  validator: (value) {
                    if ((value == null || value.isEmpty) && isSaved == true) {
                      return "Required Field";
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
