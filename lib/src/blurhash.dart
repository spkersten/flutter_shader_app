// MIT License
//
// Copyright (c) 2019 Robert Felker
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:math';

// copied from:
// https://github.com/fluttercommunity/flutter_blurhash/blob/master/lib/src/blurhash.dart

/// Returns a list of linear RGB colors, each as a list of three doubles
List<List<double>> decodeBlurHash(String blurHash, {double punch = 1}) {
  final sizeFlag = _decode83(blurHash[0]);
  final numY = (sizeFlag / 9).floor() + 1;
  final numX = (sizeFlag % 9) + 1;

  final quantisedMaximumValue = _decode83(blurHash[1]);
  final maximumValue = (quantisedMaximumValue + 1) / 166;

  final colors = List<List<double>>.generate(numX * numY, (_) => []);

  for (var i = 0; i < colors.length; i++) {
    if (i == 0) {
      final value = _decode83(blurHash.substring(2, 6));
      colors[i] = _decodeDC(value);
    } else {
      final value = _decode83(blurHash.substring(4 + i * 2, 6 + i * 2));
      colors[i] = _decodeAC(value, maximumValue * punch);
    }
  }

  return colors;
}

int _decode83(String str) {
  var value = 0;
  final units = str.codeUnits;
  final digits = _digitCharacters.codeUnits;
  for (var i = 0; i < units.length; i++) {
    final code = units.elementAt(i);
    final digit = digits.indexOf(code);
    if (digit == -1) {
      throw ArgumentError.value(str, 'str');
    }
    value = value * 83 + digit;
  }
  return value;
}

List<double> _decodeDC(int value) {
  final intR = value >> 16;
  final intG = (value >> 8) & 255;
  final intB = value & 255;
  return [_sRGBToLinear(intR), _sRGBToLinear(intG), _sRGBToLinear(intB)];
}

List<double> _decodeAC(int value, double maximumValue) {
  final quantR = (value / (19 * 19)).floor();
  final quantG = (value / 19).floor() % 19;
  final quantB = value % 19;

  final rgb = [
    _signPow((quantR - 9) / 9, 2.0) * maximumValue,
    _signPow((quantG - 9) / 9, 2.0) * maximumValue,
    _signPow((quantB - 9) / 9, 2.0) * maximumValue
  ];

  return rgb;
}

double _sRGBToLinear(int value) {
  final v = value / 255;
  if (v <= 0.04045) {
    return v / 12.92;
  } else {
    return pow((v + 0.055) / 1.055, 2.4) as double;
  }
}

int _sign(double n) => (n < 0 ? -1 : 1);

num _signPow(double val, double exp) => _sign(val) * pow(val.abs(), exp);

const _digitCharacters =
    "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#\$%*+,-.:;=?@[]^_{|}~";
