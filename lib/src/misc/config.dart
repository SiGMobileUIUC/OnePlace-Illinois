import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final baseEndpoint = dotenv.env["BASE_ENDPOINT"];
}
