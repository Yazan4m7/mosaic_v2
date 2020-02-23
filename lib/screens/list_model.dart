import 'package:mosaic/models/Case.dart';
import 'case_row.dart';
import 'package:flutter/material.dart';

class ListModel {
  ListModel(this.listKey, items) : this.items = new List.of(items);

  final GlobalKey<AnimatedListState> listKey;
  final List<Case> items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, Case item) {
    items.insert(index, item);
    _animatedList.insertItem(index, duration: new Duration(milliseconds: 150));
  }

  Case removeAt(int index) {
    final Case removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (context, animation) => new CaseRow(
          caseItem: removedItem,
              animation: animation,
            ),
        duration: new Duration(milliseconds: (150 + 200*(index/length)).toInt())
      );
    }
    return removedItem;
  }

  int get length => items.length;

  Case operator [](int index) => items[index];

  int indexOf(Case item) => items.indexOf(item);
}
