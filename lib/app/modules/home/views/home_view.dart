import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final hc = HomeController.to;
  final gradient = LinearGradient(colors: [
    Colors.blue,
    Colors.green,
    Colors.red,
  ]);

  void changeUnit() {
    Get.defaultDialog(
      title: 'Select a temperature unit',
      content: Obx(
        () => Column(
          children: [
            RadioListTile(
                title: Text('Celsius'),
                value: Temperature.celsius,
                groupValue: hc.selected.value,
                onChanged: hc.changeValue),
            RadioListTile(
                title: Text('Fahrenheit'),
                value: Temperature.fahrenheit,
                groupValue: hc.selected.value,
                onChanged: hc.changeValue),
            RadioListTile(
                title: Text('Kelvin'),
                value: Temperature.kelvin,
                groupValue: hc.selected.value,
                onChanged: hc.changeValue),
          ],
        ),
      ),
    );
  }

  Container buildTextField() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: hc.controller,
              decoration: InputDecoration(
                  hintText: "e.g. 26.5", border: InputBorder.none),
            ),
          ),
          InkWell(
            onTap: hc.controller.clear,
            child: Icon(CupertinoIcons.clear_circled_solid),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(FlutterIcons.theme_light_dark_mco),
              onPressed: hc.changeTheme)
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: buildTextField(),
          ),
          Obx(
            () => Card(
              margin: EdgeInsets.all(18),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      FlutterIcons.temperature_celsius_mco,
                    ),
                    title: Text('${hc.celsius.value.toPrecision(2)} ',
                        style: TextStyle(
                            fontWeight: hc.selected.value == Temperature.celsius
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16)),
                    subtitle: Text('Temperature in Celsius'),
                  ),
                  ListTile(
                    leading: Icon(
                      FlutterIcons.temperature_fahrenheit_mco,
                    ),
                    title: Text('${hc.fahrenheit.value.toPrecision(2)} ',
                        style: TextStyle(
                            fontWeight:
                                hc.selected.value == Temperature.fahrenheit
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            fontSize: 16)),
                    subtitle: Text('Temperature in Fahrenheit'),
                  ),
                  ListTile(
                    leading: Icon(
                      FlutterIcons.temperature_kelvin_mco,
                    ),
                    title: Text('${hc.kelvin.value.toPrecision(2)} ',
                        style: TextStyle(
                            fontWeight: hc.selected.value == Temperature.kelvin
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16)),
                    subtitle: Text('Temperature in Kelvin'),
                  ),
                  hc.selected.value == Temperature.celsius &&
                          hc.celsius.value >= -50 &&
                          hc.celsius.value <= 100
                      ? ListTile(
                          leading: Icon(FlutterIcons.thermometer_0_faw),
                          title: SliderTheme(
                            data: SliderThemeData(
                              trackShape: GradientRectSliderTrackShape(
                                  gradient: gradient, darkenInactive: false),
                            ),
                            child: Slider(
                              value: hc.celsius.value,
                              onChanged: hc.updateValues,
                              activeColor: hc.color.value,
                              max: 100,
                              min: -50,
                            ),
                          ))
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() => FloatingActionButton(
            child: Icon(
              hc.selected.value == Temperature.celsius
                  ? FlutterIcons.temperature_celsius_mco
                  : hc.selected.value == Temperature.fahrenheit
                      ? FlutterIcons.temperature_fahrenheit_mco
                      : FlutterIcons.temperature_kelvin_mco,
            ),
            onPressed: changeUnit,
          )),
    );
  }
}

//* By: https://gist.github.com/CinePlays/758fd5c5c51295d675bc2144033a1abe
class GradientRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  final LinearGradient gradient;
  final bool darkenInactive;
  const GradientRectSliderTrackShape(
      {this.gradient:
          const LinearGradient(colors: [Colors.lightBlue, Colors.blue]),
      this.darkenInactive: true});

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    @required RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    @required Animation<double> enableAnimation,
    @required TextDirection textDirection,
    @required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(context != null);
    assert(offset != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting  can be a no-op.
    if (sliderTheme.trackHeight <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = darkenInactive
        ? ColorTween(
            begin: sliderTheme.disabledInactiveTrackColor,
            end: sliderTheme.inactiveTrackColor)
        : activeTrackColorTween;
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation);
    final Paint inactivePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = inactiveTrackColorTween.evaluate(enableAnimation);
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius = Radius.circular(trackRect.height / 2 + 1);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );
  }
}
