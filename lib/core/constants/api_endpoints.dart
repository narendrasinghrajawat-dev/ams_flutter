


class ApiEndpoints {
  // static const baseUrl = 'https://api.example.com'; // change per env
  static const login = 'auth/login/';
  static const attendance = 'attendance/';

  static const getAllMasterDataUrl = 'masterData/';




  // admin employee apis
  static const createUser = 'admin/create-user/';
  static const usersList = 'admin/user-list/';
  static const updateUser = 'admin/update-user/';
  static const deleteUser = 'admin/delete-user/';
  static const getTotalAttendance = 'admin/getTotalAttendance/';
  static const getAllLeavesRequests = 'admin/getAllLeavesRequests';
  static const adminActionOnLeaveRequest = 'admin/adminActionOnLeaveRequest/';
  static const fetchLeavesByDate = 'admin/fetchLeavesByDate/';
  static const fetchAttendanceByDate = 'admin/fetchAttendanceByDate/';
  static const fetchActivitiesByDate = 'admin/fetchActivitiesByDate/';
  static const changeUserPasswordByAdmin = 'admin/changeUserPasswordByAdmin';



  // user apis
  static const punch = 'user/attendance/punch';
  static const getAllAttedanceActivity = 'user/attendance/getAllAttedanceActivity/';
  static const getAllLeavesStatus = 'user/leaves/getLeavesStatus/';
  static const getLeaveBalance = 'user/leaves/getLeavesBalance/';

  static const applyLeaves = 'user/leaves/applyLeaves/';
  static const cancelLeaves = 'user/leaves/cancel/';
  static const changePasswordByUser = 'user/changePasswordByUser';

}
