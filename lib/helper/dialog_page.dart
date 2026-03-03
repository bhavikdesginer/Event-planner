import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'CommonFuctions.dart';
import 'LoadingDialog.dart';


class DialogPageDialog extends StatelessWidget {
  String title;
  String subTitle;

  DialogPageDialog(this.title, this.subTitle);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: CommonFunctionClass.dialogPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12.0),
          Text(subTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    style: Theme.of(context).textButtonTheme.style!.copyWith(
                        backgroundColor: WidgetStateProperty.all(Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No',
                        style: Theme.of(context).textTheme.bodyMedium)),
                TextButton(
                    style: Theme.of(context).textButtonTheme.style,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes',
                        style: Theme.of(context).textTheme.labelMedium)),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

class CustomDialogPageDialog extends StatelessWidget {
  String title;
  String subTitle;
  String yesBtn;
  String noBtn;

  CustomDialogPageDialog(this.title, this.subTitle, this.yesBtn, this.noBtn);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: CommonFunctionClass.dialogPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12.0),
          Text(subTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        alignment: Alignment.center,
                        elevation: 0),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text(noBtn,
                        style: Theme.of(context).textTheme.bodyMedium)),
                TextButton(
                    style: Theme.of(context).textButtonTheme.style,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(yesBtn,
                        style: Theme.of(context).textTheme.labelMedium)),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

class ThreeBtnDialogPageDialog extends StatelessWidget {
  String title;
  String subTitle;
  String firstBtn;
  String secondBtn;
  String thirdBtn;

  ThreeBtnDialogPageDialog(
      this.title, this.subTitle, this.firstBtn, this.secondBtn, this.thirdBtn);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: CommonFunctionClass.dialogPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12.0),
          Text(subTitle,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.colorPrimary,
                      alignment: Alignment.center,
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false); // To close the dialog
                    },
                    child: Text(secondBtn,
                        style: Theme.of(context).textTheme.titleSmall)),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.colorPrimary,
                      alignment: Alignment.center,
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true); // To close the dialog
                    },
                    child: Text(firstBtn,
                        style: Theme.of(context).textTheme.titleSmall)),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.colorPrimary,
                      alignment: Alignment.center,
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(thirdBtn,
                        style: Theme.of(context).textTheme.titleSmall)),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

class SingleButtonPageDialog extends StatelessWidget {
  String title;
  String subTitle;
  String btnText;

  SingleButtonPageDialog(this.title, this.subTitle, this.btnText);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: CommonFunctionClass.dialogPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12.0),
          Text(subTitle,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    style: Theme.of(context).textButtonTheme.style,
                    onPressed: () {
                      Navigator.of(context).pop(true); // To close the dialog
                    },
                    child: Text(btnText,
                        style: Theme.of(context).textTheme.labelMedium)),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

class ErrorDialogPageDialog extends StatelessWidget {
  String title;
  String subTitle;

  ErrorDialogPageDialog(this.title, this.subTitle);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: CommonFunctionClass.dialogPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close))
            ],
          ),
          const Icon(Icons.error_outline_rounded,color: Colors.red,size: 50,),
          const SizedBox(height: 20,),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10.0),
          Text(subTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class SignOutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: CommonFunctionClass.dialogPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text("Sign Out", style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12.0),
          Text("Are you sure to sign out from the app?",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(false); // To close the dialog
                    },
                    child: Text("No",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
                Container(
                  width: 40,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(true); // To close the dialog
                    },
                    child: Text("Yes",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
