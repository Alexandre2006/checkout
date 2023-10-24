import 'package:flutter/foundation.dart';

String getRedirectURI() {
  if (kReleaseMode) {
    return 'https://checkout.thinkalex.dev/';
  } else {
    return 'http://localhost:3000/';
  }
}
