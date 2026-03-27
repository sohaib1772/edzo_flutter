import 'package:edzo/controllers/bunny_upload_controller.dart';
import 'package:edzo/controllers/vimeo_upload_controller.dart';
import 'package:edzo/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UploadsMonitoringScreen extends StatelessWidget {
  const UploadsMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bunnyController = Get.find<BunnyUploadController>();
    final vimeoController = Get.find<VimeoUploadController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("مراقبة الرفع"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              bunnyController.fetchPendingVideos();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        final bunnyTasks = bunnyController.tasks;
        final vimeoTasks = vimeoController.tasks;
        final pending = bunnyController.pendingVideos;

        if (bunnyTasks.isEmpty && vimeoTasks.isEmpty && pending.isEmpty) {
          if (bunnyController.isLoadingPending.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 16.h),
                Text(
                  "لا توجد عمليات رفع حالياً",
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Active Local Vimeo Tasks ──
            if (vimeoTasks.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 8.r),
                  child: Text(
                    "عمليات الرفع الحالية (Vimeo)",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _buildVimeoTaskItem(vimeoTasks[index], vimeoController),
                    );
                  }, childCount: vimeoTasks.length),
                ),
              ),
            ],

            // ── Active Local Bunny Tasks ──
            if (bunnyTasks.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 8.r),
                  child: Text(
                    "عمليات الرفع الحالية (Bunny)",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _buildTaskItem(bunnyTasks[index], bunnyController),
                    );
                  }, childCount: bunnyTasks.length),
                ),
              ),
            ],

            // ── Server Pending Videos ──
            if (pending.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.r, 20.r, 16.r, 8.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "فيديوهات قيد المعالجة (سيرفر)",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      if (bunnyController.isLoadingPending.value)
                        SizedBox(
                          width: 14.w,
                          height: 14.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final video = pending[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _buildPendingVideoItem(video, bunnyController),
                    );
                  }, childCount: pending.length),
                ),
              ),
            ],
            SliverToBoxAdapter(child: SizedBox(height: 40.h)),
          ],
        );
      }),
    );
  }

  Widget _buildPendingVideoItem(
    dynamic video,
    BunnyUploadController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title ?? "بدون عنوان",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  "الحالة: قيد المعالجة من قبل السيرفر",
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.deletePendingVideo(video.id!),
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: "حذف السجل",
          ),
        ],
      ),
    );
  }

  Widget _buildVimeoTaskItem(VimeoUploadTask task, VimeoUploadController controller) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Obx(() => _buildStatusBadge(task.status.value)),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            task.fileName,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Obx(
            () => Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 8.h,
                    value: task.progress.value,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      task.status.value == UploadStatus.failed
                          ? Colors.red
                          : task.status.value == UploadStatus.success
                          ? Colors.green
                          : task.status.value == UploadStatus.cancelled
                          ? Colors.orange
                          : Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${(task.progress.value * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (task.status.value == UploadStatus.uploading)
                      TextButton.icon(
                        onPressed: () => controller.cancelUpload(task.id),
                        icon: const Icon(
                          Icons.cancel,
                          size: 16,
                          color: Colors.red,
                        ),
                        label: const Text(
                          "إلغاء",
                          style: TextStyle(color: Colors.red),
                        ),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                    else if (task.status.value == UploadStatus.failed)
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () => controller.retryUpload(task.id),
                            icon: const Icon(
                              Icons.refresh,
                              size: 16,
                              color: Colors.blue,
                            ),
                            label: const Text(
                              "إعادة المحاولة",
                              style: TextStyle(color: Colors.blue),
                            ),
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          IconButton(
                            onPressed: () => controller.removeTask(task.id),
                            icon: const Icon(Icons.delete_outline, size: 20),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      )
                    else
                      IconButton(
                        onPressed: () => controller.removeTask(task.id),
                        icon: const Icon(Icons.delete_outline, size: 20),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(UploadTask task, BunnyUploadController controller) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Obx(() => _buildStatusBadge(task.status.value)),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            task.fileName,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Obx(
            () => Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 8.h,
                    value: task.progress.value,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      task.status.value == UploadStatus.failed
                          ? Colors.red
                          : task.status.value == UploadStatus.success
                          ? Colors.green
                          : task.status.value == UploadStatus.cancelled
                          ? Colors.orange
                          : Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${(task.progress.value * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (task.status.value == UploadStatus.uploading)
                      TextButton.icon(
                        onPressed: () => controller.cancelUpload(task.id),
                        icon: const Icon(
                          Icons.cancel,
                          size: 16,
                          color: Colors.red,
                        ),
                        label: const Text(
                          "إلغاء",
                          style: TextStyle(color: Colors.red),
                        ),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                    else if (task.status.value == UploadStatus.failed)
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () => controller.retryUpload(task.id),
                            icon: const Icon(
                              Icons.refresh,
                              size: 16,
                              color: Colors.blue,
                            ),
                            label: const Text(
                              "إعادة المحاولة",
                              style: TextStyle(color: Colors.blue),
                            ),
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          IconButton(
                            onPressed: () => controller.removeTask(task.id),
                            icon: const Icon(Icons.delete_outline, size: 20),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      )
                    else
                      IconButton(
                        onPressed: () => controller.removeTask(task.id),
                        icon: const Icon(Icons.delete_outline, size: 20),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(UploadStatus status) {
    String text = "";
    Color color = Colors.grey;

    switch (status) {
      case UploadStatus.uploading:
        text = "جاري الرفع";
        color = Colors.blue;
        break;
      case UploadStatus.success:
        text = "تم بنجاح";
        color = Colors.green;
        break;
      case UploadStatus.failed:
        text = "فشل";
        color = Colors.red;
        break;
      case UploadStatus.cancelled:
        text = "ملغي";
        color = Colors.orange;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
