import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final baseEndpoint = dotenv.env["BASE_ENDPOINT"];
  static final mediaSpaceVideoUrl = dotenv.env["MEDIASPACE_VIDEO_URL"];
  static final mediaSpaceThumbnailUrl = dotenv.env["MEDIASPACE_THUMBNAIL_URL"];
}
