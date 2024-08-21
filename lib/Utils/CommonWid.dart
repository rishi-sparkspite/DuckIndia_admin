import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Essentials.dart';
import 'HelperFunctions.dart';

class CommonWid {
  static Widget buildNotFound() {
    return SizedBox(
      height: 100,
      width: 100,
      child: Image.asset('assets/notFound.png'),
    );
  }

  static String getTimeAgo(timestamp) {
    timestamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (timestamp.toString().isNotEmpty) {
      final now = DateTime.now();
      final dateTime = timestamp;
      final difference = now.difference(dateTime);
      return DateFormat('MMMM d, y').format(dateTime);
    }
    return "";
  }

  static List<int> convertStringToId(List<String> inputList, String type) {
    List<Map<String, dynamic>> result = categoriesMapper[type]!;
    return List<int>.from(result
        .where((element) => inputList.contains(element['name']))
        .map((e) => e['id'])
        .toList());
  }

  static List<String> convertIdToString(List<dynamic> inputList, String type) {
    List<Map<String, dynamic>> result = categoriesMapper[type]!;
    List<int> intList = List<int>.from(inputList.cast<int>());

    return List<String>.from(result
        .where((element) => intList.contains(element['id']))
        .map((e) => e['name'])
        .toList());
  }

  static Map<String, List<Map<String, dynamic>>> categoriesMapper = {
    'workingIn': workingList,
    'interests': interestedItem,
    'weekendInterests': weekendItemsList,
    'musicInterests': musicItemsList,
    'nationality': nationality,
  };

  //
  static List<Map<String, dynamic>> workingList = [
    {'id': 1, 'name': "Artist"},
    {'id': 2, 'name': "Athlete"},
    {'id': 3, 'name': "Business Owner"},
    {'id': 4, 'name': "Culinary"},
    {'id': 5, 'name': "Educator"},
    {'id': 6, 'name': "Engineer"},
    {'id': 7, 'name': "Finance"},
    {'id': 8, 'name': "Healthcare"},
    {'id': 9, 'name': "IT"},
    {'id': 10, 'name': "Lawyer"},
    {'id': 11, 'name': "Military"},
    {'id': 12, 'name': "Model"},
    {'id': 13, 'name': "Nonprofit"},
    {'id': 14, 'name': "Public Relations and Media"},
    {'id': 15, 'name': "Real Estate"},
    {'id': 16, 'name': "Scientist"},
    {'id': 17, 'name': "Technology"},
    {'id': 18, 'name': "Venture Capital"}
  ];

  static List<Map<String, dynamic>> interestedItem = [
    {'id': 1, 'name': "Indian food"},
    {'id': 2, 'name': "style"},
    {'id': 3, 'name': "finance"},
    {'id': 4, 'name': "reading vogue"},
    {'id': 5, 'name': "karaoke king"},
    {'id': 6, 'name': "wonder lust"},
    {'id': 7, 'name': "movie"}
  ];

  static List<Map<String, dynamic>> weekendItemsList = [
    {'id': 1, 'name': "Sleeping"},
    {'id': 2, 'name': "working"},
    {'id': 3, 'name': "Golfing"},
    {'id': 4, 'name': "Picnic"},
    {'id': 5, 'name': "Cooking"}
  ];

  static List<Map<String, dynamic>> musicItemsList = [
    {'id': 1, 'name': "Western classical"},
    {'id': 2, 'name': "Blues"},
    {'id': 3, 'name': "Golfing"},
    {'id': 4, 'name': "Swiftie"},
    {'id': 5, 'name': "Hindustani Classical"},
    {'id': 6, 'name': "80's rock"},
    {'id': 7, 'name': "Jazz"},
    {'id': 8, 'name': "2000's Bollywood"},
    {'id': 9, 'name': "Pop"},
    {'id': 10, 'name': "Techno"}
  ];

  static List<Map<String, dynamic>> nationality = [
    {'id': 1, 'name': "Indian"},
    {'id': 2, 'name': "Chinese"},
  ];
  static List<String> convertIdToStringList(List<int> inputList, String type) {
    List<Map<String, dynamic>> result = categoriesMapper[type]!;
    List<String> stringList = [];

    for (int id in inputList) {
      var matchingEntry = result.firstWhere((element) => element['id'] == id,
          orElse: () => {'name': ''});
      stringList.add(matchingEntry['name']);
    }

    return stringList;
  }

  //
  static Widget dialogWrapper(
      {required BuildContext context,
      required String header,
      required Widget child,
      double? dialogWidth,
      double? childHeight,
      double? headerSize,
      Function? singleButtonCallback,
      VoidCallback? onBackArrowPressed,
      VoidCallback? onClosedCallback,
      String? buttonTitle,
      bool closeButton = true,
      bool actionButtonLoading = false}) {
    Widget titleTextWidget = Essentials.myText(
        context: context,
        title: header,
        fontSize: headerSize ?? Essentials.bHeader,
        fontWeight: FontWeight.w700,
        color: Essentials.primaryColor);
    return SimpleDialog(
      title: onBackArrowPressed != null || closeButton
          ? Stack(
              children: [
                if (onBackArrowPressed != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: onBackArrowPressed,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                Center(
                  child: titleTextWidget,
                ),
                if (closeButton)
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: onClosedCallback ??
                          () {
                            Navigator.of(context).pop();
                          },
                      child: Icon(
                        Icons.cancel,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            )
          : titleTextWidget,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.all(20),
      children: [
        SizedBox(
          width: dialogWidth ?? 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: childHeight ?? 400,
                child: child,
              ),
              if (singleButtonCallback != null) ...[
                Essentials.heightSpacer(10),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Essentials.myRaisedButton(
                        context: context,
                        text: buttonTitle ?? "Confirm",
                        handleResponsive: true,
                        callback: singleButtonCallback,
                        loading: actionButtonLoading),
                  ),
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

String formatDate(DateTime dateTime) {
  return DateFormat('MMMM d, y').format(dateTime);
}

const String errorImageUrl =
    'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=';
