import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/navigation/app_router_config.dart';
import 'package:linos/core/utils/app_images.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/auth/cubit/auth_cubit.dart';
import 'package:linos/features/auth/cubit/auth_state.dart';
import 'package:linos/features/auth/presentation/login/cubit/login_form_cubit.dart';
import 'package:linos/features/auth/presentation/login/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state) {
          case Authenticated():
            context.go(AppRouterConfig.mainPage);
          case AuthError(message: final message):
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          default:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.secondaryContainer,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 60.0),
                Image.asset(AppImages.logo, height: 100, width: 100),
                const SizedBox(height: 16.0),
                Text(
                  context.l10n.loginPage_title,
                  style: context.theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32.0),
                BlocProvider(create: (context) => LoginFormCubit(), child: const LoginForm()),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () => context.go(AppRouterConfig.register),
                  child: Text(
                    context.l10n.loginPage_createAccountButton,
                    style: context.theme.textTheme.titleSmall?.copyWith(
                      color: context.theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: context.theme.colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.push(AppRouterConfig.forgotPassword);
                  },
                  child: Text(
                    context.l10n.loginPage_forgotPasswordButton,
                    style: context.theme.textTheme.titleSmall?.copyWith(
                      color: context.theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: context.theme.colorScheme.primary,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
