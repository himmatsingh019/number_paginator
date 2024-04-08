import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/src/ui/widgets/buttons/paginator_button.dart';
import 'package:number_paginator/src/ui/widgets/inherited_number_paginator.dart';

class NumberContent extends StatelessWidget {
  final int currentPage;

  const NumberContent({
    Key? key,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        /// Buttons have an aspect ratio of 1:1. Therefore use paginator height as
        /// button width.
        var buttonWidth = constraints.maxHeight;
        var availableSpots = (double.maxFinite / buttonWidth).floor();

        availableSpots = _getAvailableSpots(context, availableSpots);
        final totalPages = InheritedNumberPaginator.of(context).numberPages;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showFirstButton(totalPages)) _buildPageButton(context, 0),
            if (_frontDotsShouldShow(context, availableSpots))
              _buildDots(context) ?? Container(),
            if (InheritedNumberPaginator.of(context).numberPages > 1)
              ..._generateButtonList(context, availableSpots),
            if (_backDotsShouldShow(context, availableSpots))
              _buildDots(context) ?? Container(),
            if (_showLastButton(context))
              _buildPageButton(
                context,
                InheritedNumberPaginator.of(context).numberPages - 1,
              ),
          ],
        );
      },
    );
  }

  _getAvailableSpots(
    BuildContext context,
    int spots,
  ) {
    final totalPages = InheritedNumberPaginator.of(context).numberPages;

    if (spots >= 6) {
      if (currentPage < 2) {
        return 5;
      } else if (currentPage > 2 && currentPage + 1 >= totalPages - 1) {
        return 5;
      } else {
        return 6;
      }
    }

    return spots;
  }

  bool _showFirstButton(final int totalPages) {
    if (totalPages < 4) {
      return true;
    }

    if (currentPage < 2) {
      return true;
    } else {
      return false;
    }
  }

  bool _showLastButton(
    BuildContext context,
  ) {
    final totalPages = InheritedNumberPaginator.of(context).numberPages;

    if (totalPages <= 3) {
      return true;
    }

    if (totalPages > 1) {
      if (currentPage >= totalPages - 2) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  /// Generates the variable button list which is at the center of the (optional)
  /// dots. The very last and first pages are shown independently of this list.
  List<Widget> _generateButtonList(BuildContext context, int availableSpots) {
    // if dots shown: available minus (2 for first and last pages + 2 for dots)
    var shownPages = availableSpots -
        2 -
        (_backDotsShouldShow(context, availableSpots) ? 1 : 0) -
        (_frontDotsShouldShow(context, availableSpots) ? 1 : 0);

    var numberPages = InheritedNumberPaginator.of(context).numberPages;

    int minValue, maxValue;
    minValue = max(1, currentPage - shownPages ~/ 2);
    maxValue = min(minValue + shownPages, numberPages - 1);
    if (maxValue - minValue < shownPages) {
      minValue = (maxValue - shownPages).clamp(1, numberPages - 1);
    }

    return List.generate(maxValue - minValue,
        (index) => _buildPageButton(context, minValue + index));
  }

  /// Builds a button for the given index.
  Widget _buildPageButton(BuildContext context, int index) => PaginatorButton(
        onPressed: () =>
            InheritedNumberPaginator.of(context).onPageChange?.call(index),
        selected: _selected(index),
        child: AutoSizeText(
          (index + 1).toString(),
          maxLines: 1,
          minFontSize: 5,
          style: _selected(index)
              ? InheritedNumberPaginator.of(context).selectedButtonTextStyle
              : InheritedNumberPaginator.of(context).unselectedButtonTextStyle,
        ),
      );

  Widget? _buildDots(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: const EdgeInsets.all(4.0),
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.bottomCenter,
          decoration: ShapeDecoration(
            shape: InheritedNumberPaginator.of(context).config.buttonShape ??
                const CircleBorder(),
            color: InheritedNumberPaginator.of(context)
                .config
                .buttonUnselectedBackgroundColor,
          ),
          child: AutoSizeText(
            "...",
            style: TextStyle(
              color: InheritedNumberPaginator.of(context)
                      .config
                      .buttonUnselectedForegroundColor ??
                  Theme.of(context).colorScheme.secondary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  /// Checks if pages don't fit in available spots and dots have to be shown.
  bool _backDotsShouldShow(BuildContext context, int availableSpots) {
    final totalPages = InheritedNumberPaginator.of(context).numberPages;

    if (totalPages > 3) {
      if (currentPage <= totalPages - 3) {
        return true;
      }
    }

    return availableSpots < InheritedNumberPaginator.of(context).numberPages &&
        currentPage <
            InheritedNumberPaginator.of(context).numberPages -
                availableSpots ~/ 2;
  }

  bool _frontDotsShouldShow(
    BuildContext context,
    int availableSpots,
  ) {
    final totalPages = InheritedNumberPaginator.of(context).numberPages;

    // if(totalPages)

    if (totalPages > 3) {
      if (currentPage >= 2) {
        return true;
      }
    }

    return availableSpots < totalPages && currentPage > availableSpots ~/ 2 - 1;
  }

  /// Checks if the given index is currently selected.
  bool _selected(index) => index == currentPage;
}
