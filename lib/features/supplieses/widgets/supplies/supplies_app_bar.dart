import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

class SuppliesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SuppliesAppBar({super.key, this.onAddBox});
  final VoidCallback? onAddBox;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              BlocBuilder<SuppliesBloc, SuppliesState>(
                builder: (context, state) {
                  return Positioned.fill(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text('${state.supplieses.length}')));
                },
              ),
              const Icon(Icons.check_box_outline_blank, size: 40)
            ],
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
