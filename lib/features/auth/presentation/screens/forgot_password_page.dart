import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/utils/app_images.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/widgets/app_bar_back_button.dart';
import 'package:linos/features/auth/data/repositories/auth_repository.dart';
import 'package:linos/features/auth/presentation/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:linos/features/auth/presentation/forgot_password/widgets/forgot_password.form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.secondaryContainer,
      appBar: AppBar(backgroundColor: context.theme.colorScheme.secondaryContainer, leading: AppBarBackButton()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(AppImages.logo, height: 100, width: 100),
            const SizedBox(height: 16.0),
            Text(
              context.l10n.forgotPassword_title,
              style: context.theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              context.l10n.forgotPassword_description,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32.0),
            BlocProvider(
              create: (context) => ForgotPasswordCubit(getIt<AuthRepository>()),
              child: const ForgotPasswordForm(),
            ),
          ],
        ),
      ),
    );
  }
}
