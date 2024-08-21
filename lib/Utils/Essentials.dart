import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class Essentials {
  static double bHeader = 22;
  static double sHeader = 18;

  static const Color primaryColor = Colors.black;
  static const Color disableGreyColor = Color(0xff676767);

  static looseFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static SizedBox heightSpacer(double height) {
    return SizedBox(
      height: height,
    );
  }

  static SizedBox widthSpacer(double width) {
    return SizedBox(
      width: width,
    );
  }

  static Widget getProgressBar({double size = 50}) {
    return Center(
      child: SpinKitThreeBounce(
        color: Colors.black,
        size: size,
      ),
    );
  }

  static Text myText(
      {key,
      required BuildContext context,
      required String title,
      FontWeight? fontWeight,
      Color? color,
      double? fontSize,
      TextAlign textAlign = TextAlign.center,
      int? maxlines,
      TextOverflow? overflow,
      TextDecoration? textDecoration,
      bool isHeader = false}) {
    return Text(title,
        key: key,
        style: TextStyle(
            color: color ?? Colors.black,
            fontWeight: fontWeight,
            fontSize: fontSize,
            decoration: textDecoration ?? TextDecoration.none,
            decorationThickness: 3),
        textScaleFactor: 1,
        textAlign: textAlign,
        maxLines: maxlines,
        overflow: overflow);
  }

  static Widget myRaisedButton(
      {required BuildContext context,
      required String text,
      required Function? callback,
      Color? buttonColor,
      bool loading = false,
      double fontSize = 16,
      bool handleResponsive = false,
      bigHeight = false,
      double? borderRadius,
      double? elevation,
      Color? fontColor,
      FontWeight? fontWeight,
      Color? borderColor,
      bool disable = false,
      IconData? iconData}) {
    fontColor = Colors.white;
    if (disable) {
      callback = null;
      buttonColor = disableGreyColor;
    }
    var buttonStyle = ButtonStyle(
      textStyle:
          MaterialStateProperty.all(const TextStyle(color: Colors.white)),
      elevation: MaterialStateProperty.all(elevation ?? 0),
      backgroundColor: MaterialStateProperty.all(buttonColor ?? primaryColor),

      // overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      //   if (buttonColor==Colors.white && (states.contains(MaterialState.hovered) || states.contains(MaterialState.selected) || states.contains(MaterialState.pressed))){
      //     return Essentials.primaryLessOpacity;
      //   }
      //   return Colors.transparent;
      // },
      // ),
      padding: MaterialStateProperty.all(
          const EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 16)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        side: BorderSide(color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      )),
    );

    Widget buttonTextWid = Text(
      text,
      style: TextStyle(
          fontSize: fontSize, color: fontColor, fontWeight: fontWeight),
    );

    Widget raised;
    if (iconData != null) {
      raised = SelectionContainer.disabled(
        child: ElevatedButton.icon(
          onPressed: () {
            callback!();
          },
          style: buttonStyle,
          icon: Icon(
            iconData,
            color: buttonColor == Colors.white
                ? Essentials.primaryColor
                : Colors.white,
          ),
          label: buttonTextWid,
        ),
      );
    } else {
      raised = SelectionContainer.disabled(
        child: ElevatedButton(
          onPressed: () {
            callback!();
          },
          style: buttonStyle,
          child: buttonTextWid,
        ),
      );
    }
    if (loading) {
      raised = Center(
        child: getProgressBar(),
      );
    }
    return raised;
  }

  static Widget getShimmerBox(double height, {double? width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
      ),
    );
  }

  static AppBar myappbar(
      {Key? key,
      Widget? leading,
      bool automaticallyImplyLeading = true,
      Widget? title,
      List<Widget>? actions,
      Widget? flexibleSpace,
      PreferredSizeWidget? bottom,
      double? elevation,
      double? scrolledUnderElevation,
      ScrollNotificationPredicate notificationPredicate =
          defaultScrollNotificationPredicate,
      Color? shadowColor,
      Color? surfaceTintColor,
      ShapeBorder? shape,
      Color? backgroundColor,
      Color? foregroundColor,
      IconThemeData? iconTheme,
      IconThemeData? actionsIconTheme,
      bool primary = true,
      bool? centerTitle,
      bool excludeHeaderSemantics = false,
      double? titleSpacing,
      double toolbarOpacity = 1.0,
      double bottomOpacity = 1.0,
      double? toolbarHeight,
      double? leadingWidth,
      TextStyle? toolbarTextStyle,
      TextStyle? titleTextStyle,
      bool forceMaterialTransparency = false,
      Clip? clipBehavior}) {
    return AppBar(
      key: key,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      notificationPredicate: notificationPredicate,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      primary: primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      clipBehavior: clipBehavior,
    );
  }
}
