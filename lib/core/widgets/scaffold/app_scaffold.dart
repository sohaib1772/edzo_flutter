import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/scaffold/app_bar_default_leading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScaffold extends StatelessWidget {
  AppScaffold({
    super.key,
    this.showAppBar = true,
    this.title = '',
    required this.body,
    this.bottomNavigationBar,
    this.defaultLeading = false,
    this.leading,
  });
  Widget body;
  bool showAppBar;
  String title;
  Widget? bottomNavigationBar;
  bool defaultLeading = false;
  Widget? leading;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              bottomOpacity: 0,
              elevation: 0,
              scrolledUnderElevation: 0,

              title: Text(title),
              centerTitle: true,
              actions: [Image.asset("assets/images/edzo_logo.png")],
              leading: defaultLeading ? AppBarDefaultLeading() : leading,

            )
          : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
