import 'package:flutter/material.dart';

import 'Service.dart';

class Server {
  static String? url;
  static const firebaseNotification = 'https://fcm.googleapis.com/fcm/send';

  static Future<void> initialize() async {
    final configService = ConfigService();
    try {
      url = await configService.fetchUrl();
    } catch (e) {
      print("Error initializing server URL: $e");
    }
  }
}

class MyImages {
  static const userAvatar =
      "https://cdn-icons-png.flaticon.com/512/149/149071.png";
}

class MyColors {
  //graph
  static const Color mainGridLineColor = Colors.white10;

  static const Color contentColorBlue = Color(0xFF2196F3);

  static const Color contentColorCyan = Color(0xFF50E4FF);
  //

  static Color menuColor = const Color(0xff1b1b1c);
  static Color dashboardColor = const Color(0xff101014);

  static Color greenForest = const Color.fromARGB(255, 36, 94, 78);
  static Color darkContainer = const Color.fromARGB(255, 21, 21, 21);
  static Color lightContainer = const Color.fromARGB(255, 245, 245, 245);
  static Color dark = Colors.black;
  static Color light = Colors.white;
  static Color chatDark = const Color.fromARGB(255, 57, 57, 57);
  static Color chatLight = const Color.fromARGB(255, 220, 220, 220);
}

class MyRequest {
  static String getTotalCount = "admin/getTotalCount";
  static const getAllUsers = "admin/getAllUsers";
  static const getAllMatches = "admin/getAllMatches";
  static const getAllFeedback = "admin/getAllFeedback";
  static String getAllReports = "admin/getAllReports";
  static String getAllStories = "admin/getAllStories";
  static const isAppAdmin = "admin/isAppAdmin";
  static const verifyUser = "admin/verifyUser";
  static const blockUser = "admin/blockUser";
  static const unblockUser = "admin/unblockUser";
  static var jsonHeaders = {'Content-Type': 'application/json'};
  // static const getAllPost = "admin/getAllPost";
  // static const getSinglePost = "admin/getSinglePost";
  // static String getUserById = "getUserById";
  // static String comments = "comments";
  // static String getSingleCommunity = "getSingleCommunity";
  // static const getAllCommunity = "admin/getAllCommunity";
  // static const getReportedUsersList = "admin/getReportedUsersList";
  // static const isAppAdmin = "admin/isAppAdmin";
  // static const getAllComments = "admin/getAllComments";
  // static const getVerificationRequests = "admin/getVerificationRequests";
  // static const media = "media";
  // static const deleteUser = "admin/deleteUser";
  // static const updateVerificationStatus = "admin/updateVerificationStatus";
  // static const blockUser = "admin/blockUser";
  // static const unblockUser = "admin/unblockUser";
  // static var jsonHeaders = {'Content-Type': 'application/json'};
  // static const searchPosts = 'admin/searchPosts';
  // static const searchUsers = 'admin/searchUsers';
  // static const searchCommunity = 'admin/searchCommunity';
  // static String getPostByCommunityId = "/getPostByCommunityId";
}
