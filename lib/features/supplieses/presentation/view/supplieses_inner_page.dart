import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/supplies_entity.dart';

class SuppliesesInnerPage extends StatelessWidget {
  final SuppliesEntity? suppliesEntity;

  const SuppliesesInnerPage({super.key, this.suppliesEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            toolbarHeight: kToolbarHeight * 1.7,
            backgroundColor: Colors.transparent,
            pinned: true,
            // automaticallyImplyLeading: false,
            snap: false,
            title: null,
            // title: SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Text(suppliesEntity.name),
            // ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              // title: SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Text(
              //     suppliesEntity?.name ?? '',
              //   ),
              // ),
              title: Container(
                color: Colors.grey.withOpacity(0.11),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: SizedBox(
                        height: kToolbarHeight * 2.5,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 19),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 40),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child:
                                            Text(suppliesEntity?.name ?? ''))),
                              )),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text('0',
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 4),
                                  Image.asset(
                                    'lib/assets/box.png',
                                    width: 28,
                                    height: 28,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(
                bottom: kBottomNavigationBarHeight + 130, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Card(child: Text('Box')),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(
                bottom: kBottomNavigationBarHeight + 130, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Card(child: Text('Box')),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(
                bottom: kBottomNavigationBarHeight + 130, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Card(child: Text('Box')),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(
                bottom: kBottomNavigationBarHeight + 130, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Card(child: Text('Box')),
              ),
            ),
          )
        ],
      ),
    );
  }
}
