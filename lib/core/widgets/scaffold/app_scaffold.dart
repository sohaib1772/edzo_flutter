import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/scaffold/app_bar_default_leading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edzo/core/widgets/responsive_center.dart';

class AppScaffold extends StatelessWidget {
  AppScaffold({
    super.key,
    this.showAppBar = true,
    this.title = '',
    required this.body,
    this.bottomNavigationBar,
    this.defaultLeading = false,
    this.leading,
    this.padding = 20,
    this.actions,
    this.useResponsive = true,
  });
  final Widget body;
  final bool showAppBar;
  final String title;
  final Widget? bottomNavigationBar;
  final bool defaultLeading;
  final Widget? leading;
  final double padding;
  final List<Widget>? actions;
  final bool useResponsive;

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
              actions: actions != null && actions!.isNotEmpty
                  ? [...actions!, Image.asset("assets/images/edzo_logo.png")]
                  : [Image.asset("assets/images/edzo_logo.png")],
              leading: defaultLeading ? AppBarDefaultLeading() : leading,
            )
          : null,
      body: useResponsive
          ? ResponsiveCenter(
              padding: padding,
              child: body,
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: padding.w),
              child: body,
            ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
