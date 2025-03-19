import 'package:get/get.dart';

import 'controller/network_controller.dart';
import 'services/call_detection_service.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put<CallDetectionService>(CallDetectionService(), permanent: true);
  }
}
