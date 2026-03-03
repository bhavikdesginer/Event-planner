import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        height: 40,
        width: 40,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colorPrimary),
            ),
          ),
        ),
      ),
    );
  }

  static showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: LoadingDialog(),
          );
        });
  }
}
