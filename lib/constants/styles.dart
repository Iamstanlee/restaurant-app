import 'package:fgrestaurant/helpers/functions.dart';
import 'package:flutter/material.dart';
import 'fonts.dart';

const kHorizontalPadding = 20.0;
Color primaryColor = Colors.teal;
// white text styles
TextStyle whiteTextStyleNormal = new TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontFamily: primaryFont,
);
TextStyle whiteTextStyleMedium = new TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
  fontFamily: primaryFont,
);
TextStyle whiteTextStyleBold = new TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
  fontFamily: primaryFont,
);

// black text styles
TextStyle blackTextStyleNormal = new TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontFamily: primaryFont,
);
TextStyle blackTextStyleMedium = new TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
  fontFamily: primaryFont,
);
TextStyle blackTextStyleBold = new TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
  fontFamily: primaryFont,
);

//
TextStyle textStyle = new TextStyle(fontSize: 14.0, fontFamily: primaryFont);

TextStyle headingWhite = new TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
  fontFamily: primaryFont,
);

TextStyle headingWhite18 = new TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont);

TextStyle headingWhite18Bold = new TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: primaryFont,
);

TextStyle heading18 = new TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  fontFamily: primaryFont,
);

TextStyle heading18Black = new TextStyle(
  color: Colors.black,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: primaryFont,
);

TextStyle heading18BlackNormal = new TextStyle(
  color: Colors.black,
  fontSize: 18.0,
  fontWeight: FontWeight.normal,
  fontFamily: primaryFont,
);

TextStyle headingBlack = new TextStyle(
  color: Colors.black,
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
  fontFamily: primaryFont,
);

Color transparentColor = Color.fromRGBO(0, 0, 0, 0.2);
Color dangerButtonColor = Color(0XFFf53a4d);

Widget raisedButton(Function onPressed, String child,
    {Color color, double horizontalPadding = 0.0, BorderRadius borderRadius}) {
  return FlatButton(
    onPressed: onPressed,
    shape: ContinuousRectangleBorder(
        borderRadius:
            borderRadius != null ? borderRadius : BorderRadius.circular(12.0)),
    color: color == null ? primaryColor : color,
    child: Text(child,
        style: textStyle.copyWith(
            fontFamily: primaryFont,
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600)),
    padding:
        EdgeInsets.symmetric(vertical: 14.0, horizontal: horizontalPadding),
  );
}

Widget flatButton(VoidCallback callback, String label) {
  return FlatButton(
    onPressed: callback,
    color: primaryColor,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontFamily: primaryFont),
    ),
  );
}

Widget outlineButton(VoidCallback callback, String label) {
  return OutlineButton(
    onPressed: callback,
    borderSide: BorderSide(color: primaryColor),
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontFamily: primaryFont),
    ),
  );
}

Widget raisedIconButton(Function onPressed, String child,
    {Color color, double horizontalPadding = 0.0, Widget icon}) {
  return FlatButton.icon(
    icon: icon != null ? icon : Text(''),
    label: Text(child,
        style: textStyle.copyWith(
            fontFamily: primaryFont, fontSize: 16, color: Colors.white)),
    onPressed: onPressed,
    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
    color: color == null ? primaryColor : color,
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: horizontalPadding),
  );
}

Widget kPadding(Widget child) {
  return Padding(
    padding: EdgeInsets.all(kHorizontalPadding),
    child: child,
  );
}
