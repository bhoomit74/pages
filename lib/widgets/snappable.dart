import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as image;

class Snappable extends StatefulWidget {
  final String text;
  const Snappable({Key? key, required this.text}) : super(key: key);

  @override
  _SnappableState createState() => _SnappableState();
}

class _SnappableState extends State<Snappable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey _globalKey = GlobalKey();
  final int numberOfBuckets = 16;
  List<Uint8List> _layers = [];

  /// Values from -1 to 1 to dislocate the layers a bit
  late List<double> _randoms;

  /// Size of child widget
  late Size size;

  final Offset offset = const Offset(64, -32);
  final Offset randomDislocationOffset = const Offset(64, 32);
  static const double _singleLayerAnimationLength = 0.6;
  static const double _lastLayerAnimationStart =
      1 - _singleLayerAnimationLength;
  bool snapOnceWidgetPrepared = false;
  bool widgetIsBeingPrepared = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 100));
      prepareWidgetForSnap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await snap();
      },
      child: Stack(children: <Widget>[
        if (_layers != null) ..._layers.map(_imageToWidget),
        AnimatedBuilder(
          animation: _controller,
          child: RepaintBoundary(
            key: _globalKey,
            child: Center(
                child: Text(
              widget.text,
              style: const TextStyle(fontSize: 35, color: Colors.black),
            )),
          ),
          builder: (context, child) {
            return _controller.isDismissed ? child! : Container();
          },
        )
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> snap() async {
    //get image from child
    /*final fullImage = await _getImageFromWidget();

    //create an image for every bucket
    List<image.Image> _images = List<image.Image>.generate(
      numberOfBuckets,
          (i) => image.Image(fullImage.width, fullImage.height),
    );

    //for every line of pixels
    for (int y = 0; y < fullImage.height; y++) {
      //generate weight list of probabilities determining
      //to which bucket should given pixels go
      List<int> weights = List.generate(
        numberOfBuckets,
            (bucket) => _gauss(
          y / fullImage.height,
          bucket / numberOfBuckets,
        ),
      );
      int sumOfWeights = weights.fold(0, (sum, el) => sum + el);

      //for every pixel in a line
      for (int x = 0; x < fullImage.width; x++) {
        //get the pixel from fullImage
        int pixel = fullImage.getPixel(x, y);
        //choose a bucket for a pixel
        int imageIndex = _pickABucket(weights, sumOfWeights);
        //set the pixel from chosen bucket
        _images[imageIndex].setPixel(x, y, pixel);
      }
    }

    _layers = await compute<List<image.Image>, List<Uint8List>>(
        _encodeImages, _images);

    //prepare random dislocations and set state
    setState(() {
      _randoms = List.generate(
        numberOfBuckets,
            (i) => (math.Random().nextDouble() - 0.5) * 2,
      );
    });

    //give a short delay to draw images
    await Future.delayed(const Duration(milliseconds: 100));*/

    //start the snap!
    if (widgetIsBeingPrepared) {
      snapOnceWidgetPrepared = true;
    } else {
      _controller.forward();
    }
  }

  Future<void> prepareWidgetForSnap() async {
    widgetIsBeingPrepared = true;
    final fullImage = await _getImageFromWidget();

    //create an image for every bucket
    List<image.Image> _images = List<image.Image>.generate(
      numberOfBuckets,
      (i) => image.Image(fullImage.width, fullImage.height),
    );

    //for every line of pixels
    for (int y = 0; y < fullImage.height; y++) {
      //generate weight list of probabilities determining
      //to which bucket should given pixels go
      List<int> weights = List.generate(
        numberOfBuckets,
        (bucket) => _gauss(
          y / fullImage.height,
          bucket / numberOfBuckets,
        ),
      );
      int sumOfWeights = weights.fold(0, (sum, el) => sum + el);

      //for every pixel in a line
      for (int x = 0; x < fullImage.width; x++) {
        //get the pixel from fullImage
        int pixel = fullImage.getPixel(x, y);
        //choose a bucket for a pixel
        int imageIndex = _pickABucket(weights, sumOfWeights);
        //set the pixel from chosen bucket
        _images[imageIndex].setPixel(x, y, pixel);
      }
    }

    _layers = await compute<List<image.Image>, List<Uint8List>>(
        _encodeImages, _images);

    //prepare random dislocations and set state
    setState(() {
      _randoms = List.generate(
        numberOfBuckets,
        (i) => (math.Random().nextDouble() - 0.5) * 2,
      );
    });

    //give a short delay to draw images
    await Future.delayed(const Duration(milliseconds: 100));
    widgetIsBeingPrepared = false;
    if (snapOnceWidgetPrepared) {
      _controller.forward();
    }
  }

  Widget _imageToWidget(Uint8List layer) {
    //get layer's index in the list
    int index = _layers.indexOf(layer);

    //based on index, calculate when this layer should start and end
    double animationStart = (index / _layers.length) * _lastLayerAnimationStart;
    double animationEnd = animationStart + _singleLayerAnimationLength;

    //create interval animation using only part of whole animation
    CurvedAnimation animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        animationStart,
        animationEnd,
        curve: Curves.easeOut,
      ),
    );

    Offset randomOffset = randomDislocationOffset.scale(
      _randoms[index],
      _randoms[index],
    );

    Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: offset + randomOffset,
    ).animate(animation);

    return AnimatedBuilder(
      animation: _controller,
      child: Image.memory(layer),
      builder: (context, child) {
        return Transform.translate(
          offset: offsetAnimation.value,
          child: Opacity(
            opacity: math.cos(animation.value * math.pi / 2),
            child: child,
          ),
        );
      },
    );
  }

  /// Returns index of a randomly chosen bucket
  int _pickABucket(List<int> weights, int sumOfWeights) {
    int rnd = math.Random().nextInt(sumOfWeights);
    int chosenImage = 0;
    for (int i = 0; i < numberOfBuckets; i++) {
      if (rnd < weights[i]) {
        chosenImage = i;
        break;
      }
      rnd -= weights[i];
    }
    return chosenImage;
  }

  /// Gets an Image from a [child] and caches [size] for later us
  Future<image.Image> _getImageFromWidget() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    //cache image for later
    size = boundary.size;
    var img = await boundary.toImage();
    var byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData?.buffer.asUint8List();

    return image.decodeImage(pngBytes!)!;
  }

  int _gauss(double center, double value) =>
      (1000 * math.exp(-(math.pow((value - center), 2) / 0.14))).round();
}

List<Uint8List> _encodeImages(List<image.Image> images) {
  return images.map((img) => Uint8List.fromList(image.encodePng(img))).toList();
}
