import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/theme_cubit.dart';

void showAppModalBottomSheet(
  BuildContext context, {
  required double heightFactor,
  required Widget child,
}) {
  final theme = context.read<ThemeCubit>().state;

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: theme.material.colorScheme.background,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) => FractionallySizedBox(
      heightFactor: heightFactor,
      child: DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 0.98,
        builder: (context, controller) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.material.colorScheme.background,
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 4,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 32),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    ),
  );
}
