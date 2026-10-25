import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(18.0),
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Please Wait...",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}

loading(BuildContext context, bool startLoading) {
  if(!startLoading) {
    return Navigator.pop(context);
  }

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return LoadingDialog();
    },
  );
}

// loading(bool isShown) {
//   isShown ? Get.defaultDialog(
//       title: "Loading...",
//       content: CircularProgressIndicator(),
//       barrierDismissible: false
//   ) : Get.back();
// }
