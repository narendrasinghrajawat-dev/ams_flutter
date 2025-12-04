


class ApiEndpoints {
  // static const baseUrl = 'https://api.example.com'; // change per env
  static const login = 'auth/login/';
  static const attendance = 'attendance/';





  // admin employee apis
  static const createUser = 'admin/create-user/';
  static const usersList = 'admin/user-list/';
  static const updateUser = 'admin/update-user/';
  static const deleteUser = 'admin/delete-user/';



  // user apis
  static const punch = 'attendance/punch';
  static const getAllAttedanceActivity = 'attendance/getAllAttedanceActivity/';
  static const getAllLeavesStatus = 'leaves/getLeavesStatus/';

  static const cancelLeaves = 'leaves/cancel/';
  static const applyLeaves = 'leaves/applyLeaves/';

}
