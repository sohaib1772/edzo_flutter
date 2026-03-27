import 'package:edzo/controllers/course_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CourseDetailsStatsWidget extends StatelessWidget {
  final CourseController controller;

  const CourseDetailsStatsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatRow(
          icon: Icons.people,
          label: "عدد المشتركين",
          value: controller.courseModel?.subscribersCount.toString() ?? "0",
        ),
        SizedBox(height: 10.h),
        _buildStatRow(
          icon: Icons.videocam_sharp,
          label: "عدد المحاضرات",
          value: Obx(
            () => Text(
              (controller.videos.length +
                      controller.playlists.fold(
                        0,
                        (previous, element) =>
                            previous + (element.videos?.length ?? 0),
                      ))
                  .toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp.clamp(18, 22),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        _buildStatRow(
          icon: Icons.timer_outlined,
          label: "اجمالي وقت المحاضرات",
          value: Obx(
            () => Text(
              controller
                  .durationFromSeconds(
                    controller.totalDuration.value +
                        controller.playlists.fold(
                          0,
                          (previousPlaylistSum, playlist) =>
                              previousPlaylistSum +
                              (playlist.videos?.fold(
                                    0,
                                    (previousVideoSum, video) =>
                                        (previousVideoSum ?? 0) +
                                        (video.duration ?? 0),
                                  ) ??
                                  0),
                        ),
                  )
                  .value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp.clamp(18, 22),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required dynamic value,
  }) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 8.w),
        Text(label),
        const Spacer(),
        value is Widget
            ? value
            : Text(
                value.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp.clamp(18, 22),
                ),
              ),
        SizedBox(width: 8.w),
      ],
    );
  }
}
