import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/supplies_bloc.dart';

class SuppliesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SuppliesAppBar({super.key, this.onAddBox});
  final VoidCallback? onAddBox;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<SuppliesBloc, SuppliesState>(
            builder: (context, state) {
              return Align(
                  alignment: Alignment.center,
                  child: Text('${state.supplieses.length}'));
            },
          ),
          ElevatedButton(
            onPressed: onAddBox,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add_box_rounded, size: 24),
                SizedBox(
                  width: 12,
                ),
                Text('Создать Короб'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
