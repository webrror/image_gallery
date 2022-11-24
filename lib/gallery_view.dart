import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gallery_view/view_photo.dart';

class GalleryView extends StatelessWidget {
  final List<String> imageUrlList;
  final int crossAxisCount;
  const GalleryView({
    Key? key,
    required this.imageUrlList,
    required this.crossAxisCount,
  }) : super(key: key);

  static const MethodChannel _channel = const MethodChannel('gallery_view');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: imageUrlList.length,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 6.0,
          mainAxisSpacing: 6.0),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) {
                      return ViewPhotos(
                        imageIndex: index,
                        imageList: imageUrlList,
                        heroTitle: "image$index",
                      );
                    },
                    fullscreenDialog: true));
          },
          child: Container(
            child: Hero(
                tag: "photo$index",
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: imageUrlList[index],
                  placeholder: (context, url) => Container(
                      child: Center(child: CupertinoActivityIndicator())),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
          ),
        );
      },
    );
  }
}
