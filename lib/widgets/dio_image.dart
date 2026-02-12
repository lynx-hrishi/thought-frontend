import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../http_service.dart';

class DioImage extends ImageProvider<DioImage> {
  final String url;
  final double scale;
  final int? cacheKey;

  const DioImage(this.url, {this.scale = 1.0, this.cacheKey});

  @override
  Future<DioImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DioImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(DioImage key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(DioImage key, ImageDecoderCallback decode) async {
    try {
      final response = await HttpService().dio.get<List<int>>(
        key.url,
        options: Options(responseType: ResponseType.bytes),
      );
      
      if (response.data == null || response.data!.isEmpty) {
        throw Exception('Image data is empty');
      }

      final buffer = await ui.ImmutableBuffer.fromUint8List(
        Uint8List.fromList(response.data!),
      );
      
      return decode(buffer);
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is DioImage && 
           other.url == url && 
           other.scale == scale &&
           other.cacheKey == cacheKey;
  }

  @override
  int get hashCode => Object.hash(url, scale, cacheKey);
}
