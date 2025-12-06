


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



  // user apis
  static const punch = 'attendance/punch';
  static const getAllAttedanceActivity = 'attendance/getAllAttedanceActivity/';
  static const getAllLeavesStatus = 'leaves/getLeavesStatus/';

  static const cancelLeaves = 'leaves/cancel/';
  static const applyLeaves = 'leaves/applyLeaves/';

}
