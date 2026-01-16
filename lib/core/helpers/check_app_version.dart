bool isVersionLower(String local, String server) {
  final localParts =
      local.split('.').map((e) => int.parse(e)).toList();
  final serverParts =
      server.split('.').map((e) => int.parse(e)).toList();

  final maxLength =
      localParts.length > serverParts.length
          ? localParts.length
          : serverParts.length;

  for (int i = 0; i < maxLength; i++) {
    final localNum = i < localParts.length ? localParts[i] : 0;
    final serverNum = i < serverParts.length ? serverParts[i] : 0;

    if (localNum < serverNum) return true;   // يحتاج تحديث
    if (localNum > serverNum) return false;  // أحدث
  }
  return false; // نفس الإصدار
}