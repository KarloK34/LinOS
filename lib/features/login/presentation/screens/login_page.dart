import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/navigation/app_routes.dart';
import 'package:linos/core/utils/app_images.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/login/cubit/login_form_cubit.dart';
import 'package:linos/features/login/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.secondaryContainer,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 100.0),
            Image.asset(AppImages.logo, height: 100, width: 100),
            const SizedBox(height: 16.0),
            Text(
              context.l10n.loginPage_title,
              style: context.theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32.0),
            BlocProvider(create: (context) => LoginFormCubit(), child: LoginForm()),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Handle forgot password logic here
              },
              child: Text(context.l10n.loginPage_forgotPasswordButton),
            ),
            const SizedBox(height: 16.0),
            FilledButton(
              onPressed: () => context.go(AppRoutes.register),
              child: Text(context.l10n.loginPage_createAccountButton),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
