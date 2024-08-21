import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'Utils/Essentials.dart';

class MyCachedNetworkWidget extends StatefulWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? shimmerSize;
  final double? height;
  final double? width;
  final BorderRadiusGeometry borderRadius;

  const MyCachedNetworkWidget({
    super.key,
    required this.imageUrl,
    this.fit,
    this.shimmerSize,
    this.height,
    this.width,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<MyCachedNetworkWidget> createState() => _MyCachedNetworkWidgetState();
}

class _MyCachedNetworkWidgetState extends State<MyCachedNetworkWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: CachedNetworkImage(
        height: widget.height,
        width: widget.width ?? double.maxFinite,
        imageUrl: widget.imageUrl,
        placeholder: (context, url) {
          return LayoutBuilder(builder: (_, constraints) {
            return Essentials.getShimmerBox(
              constraints.maxHeight.isInfinite ? 250 : constraints.maxHeight,
              width:
                  constraints.maxWidth.isInfinite ? 250 : constraints.maxWidth,
            );
          });
        },
        fit: widget.fit,
        errorWidget: (context, url, error) {
          return CachedNetworkImage(
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/panda-af5f0.appspot.com/o/noImagePlaceholder.png?alt=media",
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
