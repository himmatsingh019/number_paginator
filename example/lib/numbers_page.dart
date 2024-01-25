import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

class NumbersPage extends StatefulWidget {
  const NumbersPage({Key? key}) : super(key: key);

  @override
  _NumbersPageState createState() => _NumbersPageState();
}

class _NumbersPageState extends State<NumbersPage> {
  final int _numPages = 60;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var pages = List.generate(
      _numPages,
      (index) => Center(
        child: Text(
          "Page ${index + 1}",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          pages[_currentPage],
          Container(
            color: Colors.amber,
            alignment: Alignment.center,
            child: NumberPaginator(
              config: NumberPaginatorUIConfig(
                mainAxisAlignment: MainAxisAlignment.center,
                height: 46,
                buttonShape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // by default, the paginator shows numbers as center content
              numberPages: _numPages,
              onPageChange: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
        ],
      ),
      // card for elevation
      // bottomNavigationBar:
    );
  }
}
