import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_converter/utils.dart';

enum Temperature { celsius, fahrenheit, kelvin }

class HomeController extends GetxController {
  static final to = Get.find<HomeController>();
  RxDouble celsius = 0.0.obs;
  RxDouble fahrenheit = 0.0.obs;
  RxDouble kelvin = 0.0.obs;
  Rx<Temperature> selected = Temperature.celsius.obs;
  Rx<Color> color = Color(0xff448aff).obs;
  final controller = TextEditingController();

  void changeValue(Temperature val) => selected.value = val;

  void changeTheme() => Get.changeTheme(
      Get.theme.brightness == Brightness.dark ? lightTheme : darkTheme);

  void updateValues([double temp]) {
    final double tempValue = temp ?? double.tryParse(controller.text) ?? 0.0;
    double c = celsius.value;
    if (c >= 40)
      color.value = Colors.redAccent;
    else if (c < 40 && c > 10)
      color.value = Colors.green;
    else
      color.value = Colors.blueAccent;

    switch (selected.value) {
      case Temperature.celsius:
        celsius.value = tempValue;
        fahrenheit.value = tempValue * 1.8 + 32.0;
        kelvin.value = tempValue + 273.15;
        break;

      case Temperature.fahrenheit:
        fahrenheit.value = tempValue;
        celsius.value = (tempValue - 32.0) * 5.0 / 9.0;
        kelvin.value = celsius.value + 273.15;
        break;

      case Temperature.kelvin:
        kelvin.value = tempValue;
        celsius.value = tempValue - 273.15;
        fahrenheit.value = celsius.value * 1.8 + 32.0;
        break;
    }
  }

  @override
  void onInit() {
    controller..addListener(updateValues);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
