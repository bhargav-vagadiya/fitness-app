import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/utils/themes.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.title,
      this.backgroundColor = Colors.black,
      this.foregroundColor = Colors.white});

  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: AppSize.h50,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppSize.r30)),
        child: Center(
          child: Text(
            title,
            style: AppTheme.boldText.copyWith(color: foregroundColor),
          ),
        ),
      ),
    );
  }
}
