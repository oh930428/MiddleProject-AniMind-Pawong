extension DateTimeExtensions on DateTime {
  String getTimeAgo() {
    final Duration diff = DateTime.now().difference(this);

    if (diff.inDays >= 1) {
      return '${diff.inDays}일 전';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}시간 전';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}
