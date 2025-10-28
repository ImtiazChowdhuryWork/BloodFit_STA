class VideoDetailsModel {
  final String imagePath;
  final String videoTitle;
  final bool isWatched;
  final String duration;
  final int totalSets;
  final double totalCal;

  VideoDetailsModel({
    required this.imagePath,
    required this.videoTitle,
    required this.isWatched,
    required this.duration,
    required this.totalSets,
    required this.totalCal,
  });
}
