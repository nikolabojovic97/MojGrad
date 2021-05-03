import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color drawerBgColor = Color.fromRGBO(24, 24, 24, 1);
Color backgroundColor = Colors.white;
Color contentBgColor = Colors.white38;

// shades of lightGreen for cards
Color lightGreen0 = Color(0xFF9CCC60);
Color lightGreen1 = Color(0xFF8BC34A);
Color lightGreen2 = Color(0xFF7CB342);

// shades of gray for cards
Color gray0 = Color(0xFF616160);
Color gray1 = Color(0xFF424242);
Color gray2 = Color(0xFF303030);

// charts colors
// Color chart1 = Color.fromRGBO(84, 96, 129, 1);
// Color chart2 = Color.fromRGBO(114, 195, 134, 1);
// Color chart3 = Color.fromRGBO(240, 197, 18, 1);
// Color chart4 = Color.fromRGBO(240, 121, 90, 1);

Color chart1 = Color.fromRGBO(84, 96, 129, 1);
Color chart2 = Colors.lightGreen;
Color chart3 = Color.fromRGBO(240, 197, 18, 1);
Color chart4 = Color.fromRGBO(240, 121, 90, 1);

//login
TextStyle loginStyle = GoogleFonts.comfortaa(
    fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600);
TextStyle alertLoginTitle = GoogleFonts.comfortaa(
    fontSize: 17, color: drawerBgColor, fontWeight: FontWeight.bold);
TextStyle alertLogin = GoogleFonts.comfortaa(
    fontSize: 15, color: drawerBgColor, fontWeight: FontWeight.normal);
TextStyle alertLoginOk = GoogleFonts.comfortaa(
    fontSize: 15, color: Colors.lightGreen, fontWeight: FontWeight.bold);   
TextStyle loginInput = GoogleFonts.comfortaa(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal);
TextStyle loginCity = GoogleFonts.comfortaa(
  fontSize: 15, color: Colors.grey, fontWeight: FontWeight.normal);
TextStyle loginInfo = GoogleFonts.comfortaa(
    fontSize: 13, color: Colors.black, fontWeight: FontWeight.w200);
TextStyle facebookInitial = GoogleFonts.comfortaa(
    fontSize: 25, color: Colors.white, fontWeight: FontWeight.w400);
TextStyle facebookInfo = GoogleFonts.comfortaa(
    fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600);
TextStyle fillFieldMsg = GoogleFonts.comfortaa(
    fontSize: 12, color: Colors.red, fontWeight: FontWeight.normal);

// registration
TextStyle registrationStyle = GoogleFonts.comfortaa(
    fontSize: 15, color: Colors.lightGreen, fontWeight: FontWeight.w600);
TextStyle backStyle = GoogleFonts.comfortaa(
    fontSize: 15, color: Colors.lightGreen, fontWeight: FontWeight.w600);

// sidebar
TextStyle sideBarItem = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 16, fontWeight: FontWeight.normal);
TextStyle sideBarLogout = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle sideBarName = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 20, fontWeight: FontWeight.normal);
TextStyle sideBarEmail = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 14, fontWeight: FontWeight.normal);

// app bar
TextStyle appBarTitle = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 24, fontWeight: FontWeight.normal);

// info cards
TextStyle infoCardTitleStyle = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal);
TextStyle infoCardInfoStyle = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 17, fontWeight: FontWeight.normal);

// chart cards
TextStyle cardTitleStyle = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 14, fontWeight: FontWeight.normal);
TextStyle cardInfoStyle = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 17, fontWeight: FontWeight.normal);

// link cards
TextStyle linkCardTitleStyle = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 30, fontWeight: FontWeight.bold);
TextStyle linkCardInfoStyle = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 20, fontWeight: FontWeight.normal);

//institutions
TextStyle instColumnName = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle instColumnNameMobile = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold);

TextStyle instRowContent = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 16, fontWeight: FontWeight.normal);
TextStyle instRowContentMobile = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 13, fontWeight: FontWeight.normal);

//users
TextStyle usersColumnName = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle usersColumnNameMobile = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold);

TextStyle userRowContent = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 16, fontWeight: FontWeight.normal);
TextStyle userRowContentMobile = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 13, fontWeight: FontWeight.normal);

// reports
TextStyle reportType = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle reportColumnName = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle reportColumnNameMobile = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold);

TextStyle reportRowContent = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 16, fontWeight: FontWeight.normal);
TextStyle reportRowContentMobile = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 13, fontWeight: FontWeight.normal);

// post report details
TextStyle postReportDetailsCardUsername = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 18, fontWeight: FontWeight.bold);
TextStyle postReportDetailsCardMain = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 17, fontWeight: FontWeight.bold);
TextStyle postReportDetailsCardInfo = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 15, fontWeight: FontWeight.normal);

TextStyle postReportDetailsCardMobileUsername = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 18, fontWeight: FontWeight.bold);
TextStyle postReportDetailsCardMainMobile = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle postReportDetailsCardInfoMobile = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 14, fontWeight: FontWeight.normal);

TextStyle postReportDetailsMobile = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 16, fontWeight: FontWeight.normal);

// alerts
TextStyle alertTitle = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 20, fontWeight: FontWeight.bold);
TextStyle alertContent = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 18, fontWeight: FontWeight.normal);
TextStyle alertOption = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 18, fontWeight: FontWeight.normal);

TextStyle alertTitleMobile = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle alertContentMobile = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 14, fontWeight: FontWeight.normal);
TextStyle alertOptionMobile = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 14, fontWeight: FontWeight.normal);

// profile
TextStyle changePicture = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 14, fontWeight: FontWeight.bold);
TextStyle profileName = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 24, fontWeight: FontWeight.normal);
TextStyle profileInfoStyle = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 16, fontWeight: FontWeight.normal);
TextStyle profileInfoBold = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle saveChanges = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle entryItem = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 16, fontWeight: FontWeight.normal);
TextStyle profileUsername = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 16, fontWeight: FontWeight.normal);
TextStyle content = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 16, fontWeight: FontWeight.normal);

// paginated data table
TextStyle headerTable = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle itemTable = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 15, fontWeight: FontWeight.normal);

// comments 
TextStyle usernameComment = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 14, fontWeight: FontWeight.bold);
TextStyle contentComment = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 14, fontWeight: FontWeight.normal);
TextStyle popupTitle = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle inputComment = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal);

// search
TextStyle inputInfo = GoogleFonts.comfortaa(
    fontSize: 16, color: Colors.lightGreen, fontWeight: FontWeight.w200);
TextStyle inputStyle = GoogleFonts.comfortaa(
    fontSize: 16, color: Colors.black, fontWeight: FontWeight.w200);   

// popup problem
TextStyle popupMain = GoogleFonts.comfortaa(
    color: drawerBgColor, fontSize: 15, fontWeight: FontWeight.bold);
TextStyle popupDetails = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 13, fontWeight: FontWeight.normal);
TextStyle popupProblemTitle = GoogleFonts.comfortaa(
    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold); 

// add solution
TextStyle descriptionHint = GoogleFonts.comfortaa(
    color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal); 
TextStyle descriptionStyle = GoogleFonts.comfortaa(
    color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal); 
TextStyle imagePicker = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 14, fontWeight: FontWeight.normal);
TextStyle addSolutionBtn = GoogleFonts.comfortaa(
    color: Colors.lightGreen, fontSize: 16, fontWeight: FontWeight.normal);  