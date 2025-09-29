import 'package:edzo/models/playlist_model.dart';
import 'package:edzo/repos/playlist/playlist_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherPlaylistController extends GetxController {
  PlaylistRepo playlistRepo = Get.find();
  RxBool isLoading = false.obs;
  RxList<PlaylistModel> playlists = <PlaylistModel>[].obs;

  Future<void> getPlaylists(int courseId) async {
    isLoading.value = true;
    var res = await playlistRepo.getPlaylists(courseId);
    if (!res.status) {
      Get.snackbar(
        "خطاء في جلب المنشورات",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      isLoading.value = false;
      return;
    }
    playlists.value = res.data ?? [];
    isLoading.value = false;
  }

  Future<void> updatePlaylist(AddPlaylistModel data) async {
    isLoading.value = true;
    final res = await playlistRepo.updatePlaylist(data.id ?? 0, data);
    if (!res.status) {
      Get.snackbar(
        "خطاء في تعديل المنشور",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      isLoading.value = false;
      return;
    }
    Get.back();
    Get.snackbar(
      "تم تعديل المنشور بنجاح",
      "",
      colorText: Colors.green.shade300,
    );
    playlists.where((element) => element.id == data.id).first.title =
        data.title;
    playlists.refresh();
    isLoading.value = false;
  }

  Future<void> deletePlaylist(int id) async {
    isLoading.value = true;
    final res = await playlistRepo.delete(id);
    if (!res.status) {
      Get.snackbar(
        "خطاء في حذف المنشور",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      isLoading.value = false;
      return;
    } else {
      Get.snackbar(
        "تم حذف المنشور بنجاح",
        "",
        colorText: Colors.green.shade300,
      );
      playlists.removeWhere((element) => element.id == id);
    }
    isLoading.value = false;
  }

  Future<void> addPlaylist(AddPlaylistModel data) async {
    isLoading.value = true;
    final res = await playlistRepo.addPlaylist(data);
    if (!res.status) {
      Get.snackbar(
        "خطاء في اضافة المنشور",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      isLoading.value = false;
      return;
    }
    Get.back();
    Get.snackbar(
      "تم اضافة المنشور بنجاح",
      "",
      colorText: Colors.green.shade300,
    );
    playlists.add(res.data!);
    isLoading.value = false;
  }

  Future<void> updateOrder() async {
    List<Map<String, dynamic>> videosOrder = [];
    for (int listIndex = 0; listIndex < playlists.length; listIndex++) {
      for (
        int itemIndex = 0;
        itemIndex < playlists[listIndex].videos!.length;
        itemIndex++
      ) {
        videosOrder.add({
          "id": playlists[listIndex].videos![itemIndex].id,
          "playlist_id": playlists[listIndex].id,
          "order": itemIndex,
        });
      }
    }

    final res = await playlistRepo.updateOrder(videosOrder);
    if (!res.status) {
      Get.snackbar(
        "خطاء في تحديث ترتيب قوائم التشغيل",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      return;
    }
   

  }
  Future<void> updatePlaylistsOrder() async {
  List<Map<String, dynamic>> playlistsOrder = [];
  for (int i = 0; i < playlists.length; i++) {
    playlistsOrder.add({
      "id": playlists[i].id,
      "order": i,
    });
  }

  final res = await playlistRepo.updatePlaylistOrder(playlistsOrder);
  if (!res.status) {
    Get.snackbar(
      "خطأ في تحديث ترتيب القوائم",
      res.errorHandler!.getErrorsList(),
      colorText: Colors.red.shade300,
    );
  }
}
}
