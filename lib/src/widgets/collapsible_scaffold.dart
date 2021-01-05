
import 'package:flutter/material.dart';


class CollapsibleScaffold extends StatelessWidget {

  Widget preview;
  String title;
  Widget body;
  Widget leading;
  List<Widget> actions;


  static const _kBasePadding = 16.0;
  static double kExpandedHeight;

  CollapsibleScaffold(this.title,this.body,this.leading,{this.preview,this.actions}){
    kExpandedHeight = this.preview!=null?250.0:100.0;
  }




  final ValueNotifier<double> _titlePaddingNotifier = ValueNotifier(_kBasePadding);

  final _scrollController = ScrollController();




  double get _horizontalTitlePadding {
    const kCollapsedPadding = 60.0;

    if (_scrollController.hasClients) {
      double a=_kBasePadding + kCollapsedPadding;
      double b=_kBasePadding + (kCollapsedPadding * _scrollController.offset)/(kExpandedHeight - kToolbarHeight);
      return a<b?a:b;
    }

    return _kBasePadding;
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });

    return  NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: actions,
                expandedHeight: kExpandedHeight,
                floating: false,
                pinned: true,
                leading: leading,
                flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    centerTitle: false,
                    titlePadding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    title: ValueListenableBuilder(
                      valueListenable: _titlePaddingNotifier,
                      builder: (context, value, child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: value),
                          child: Text(
                              title),
                        );
                      },
                    ),
                    background: Container(color: Colors.black,
                      child:preview==null?Container(height: 0,width: 0,):preview,
                    )
                )
            ),
          ];
        },
        body: body
    );
  }
}