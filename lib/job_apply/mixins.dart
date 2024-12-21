import 'package:flutter/material.dart';

abstract class ColorFull {
  const ColorFull();
  Color get color;
}

abstract class Labeled {
  const Labeled();
  String get label;
}

abstract class Indexed {
  const Indexed();

  String get index;
}

abstract class LabeledIndex extends Labeled implements Indexed {
  const LabeledIndex();

  @override
  String get index;
}
