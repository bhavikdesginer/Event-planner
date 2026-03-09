import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../widgets/top_model_sheet.dart';

class CommonFunctionClass extends StatelessWidget {
  static pageRouteBuilderFadeAnimation(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);
    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }


 static void showTopModel(
      Widget widget, BuildContext context, bool paddingFlag) async {
    Widget data = Container(
      color: Colors.white,
      padding: paddingFlag
          ? const EdgeInsets.only(top: 36, left: 16, right: 16, bottom: 16)
          : const EdgeInsets.all(0),
      child: widget,
    );
    showTopModalSheet(context, data);
  }

  static Route<Object?> pageRouteBuilder(dynamic routeChild) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation, // Use the animation directly for opacity
          child: routeChild,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return CommonFunctionClass.pageRouteBuilderFadeAnimation(
            context, animation, secondaryAnimation, child);
      },
    );
  }

  static dialogPadding(BuildContext context) {
    if (isWeb()) {
      return EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 800
              ? ((MediaQuery.of(context).size.width - 500) / 2)
              : 12,
          vertical: 12);
    } else {
      return const EdgeInsets.all(0);
    }
  }

  static String getCurrencyFormatted(num? value) {
    NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'en_IN', symbol: "₹ ", decimalDigits: 0);
    return currencyFormatter.format(value);
  }

  static String getFormattedDateTime(
      int type, DateTime date, BuildContext context) {
    if (type == 0) {
      return DateFormat("dd.MM.yyyy").format(date);
    } else if (type == 1) {
      return "${DateFormat("HH:mm").format(date)}";
    } else if (type == 2) {
      return "${DateFormat("dd.MM.yyyy - hh:mm a").format(date)}";
    } else if (type == 3) {
      return '${DateFormat("dd").format(date)}';
    } else if (type == 4) {
      return DateFormat("yyyyMMdd").format(date);
    } else if (type == 5) {
      return DateFormat("yyyy").format(date);
    } else if (type == 6) {
      return DateFormat("yyyyMM").format(date);
    } else if (type == 7) {
      return DateFormat("d MMMM").format(date);
    } else if (type == 8) {
      return DateFormat("MMMM yyyy").format(date);
    } else if (type == 9) {
      return DateFormat("hh:mm a").format(date);
    }else if (type == 10) {
      return DateFormat("MMdd").format(date);
    }else if (type == 11) {
      return DateFormat("MMM").format(date);
    } else {
      return "";
    }
  }


  static String getDateCollection(int type,DateTime date){
    if(type == 1) {
      return DateFormat("yyyyMM").format(date);
    } else if (type == 2){
      return DateFormat("yyyyMMdd").format(date);
    } else {
      return "";
    }
  }

  static Future<void> launchURL(String url) async {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  static String formatIndianPhoneNumber(String phoneNumber) {
    String cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanPhoneNumber.startsWith('91') && cleanPhoneNumber.length > 10) {
      cleanPhoneNumber = cleanPhoneNumber.substring(2);
    }

    if (cleanPhoneNumber.length == 10) {
      return "${cleanPhoneNumber.substring(0, 5)} ${cleanPhoneNumber.substring(5)}";
    } else {
      return phoneNumber;
    }
  }

  static getWidth(BuildContext context) {
    if (MediaQuery.of(context).size.width > 800) {
      return 800;
    } else {
      return MediaQuery.of(context).size.width;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static isWidthMobileSize(BuildContext context) {
    if (MediaQuery.of(context).size.width > 800) {
      return false;
    } else {
      return true;
    }
  }

  static getAppBarWidth(BuildContext context) {
    if (MediaQuery.of(context).size.width > 1500) {
      return 1500;
    } else if (MediaQuery.of(context).size.width > 1300) {
      return 1300;
    } else if (MediaQuery.of(context).size.width > 1100) {
      return 1100;
    } else {
      return MediaQuery.of(context).size.width;
    }
  }

  static void showSnackBar(String text, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: AppTheme.colorTextColor,
      duration: const Duration(seconds: 3),
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static scaffoldThemePadding(BuildContext context) {
    return EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 800
            ? ((MediaQuery.of(context).size.width - 800) / 2)
            : 0);
  }

  static scaffoldThemeDecoration(BuildContext context) {
    return const BoxDecoration(color: Color(0xFFf2f2f2));
  }

  static void showModalBottomMenu(
      Widget widget, BuildContext context, bool paddingFlag) async {
    Widget data = paddingFlag
        ? Container(
            color: Colors.white,
            padding:
                const EdgeInsets.only(top: 36, left: 16, right: 16, bottom: 16),
            child: widget,
          )
        : widget;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: false,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return data;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
