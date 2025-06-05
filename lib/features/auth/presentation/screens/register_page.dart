import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/navigation/app_router_config.dart';
import 'package:linos/core/utils/app_images.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/auth/cubit/auth_cubit.dart';
import 'package:linos/features/auth/cubit/auth_state.dart';
import 'package:linos/features/auth/presentation/register/cubit/register_form_cubit.dart';
import 'package:linos/features/auth/presentation/register/widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 70.0),
              Image.asset(AppImages.logo, height: 100, width: 100),
              const SizedBox(height: 16.0),
              Text(
                context.l10n.registerPage_title,
                style: context.theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32.0),
              BlocProvider(create: (context) => RegisterFormCubit(), child: const RegisterForm()),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () => context.go(AppRouterConfig.login),
                child: Text(
                  context.l10n.registerPage_loginButton,
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
    );
  }
}
