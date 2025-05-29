import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/navigation/app_routes.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/features/login/cubit/login_form_cubit.dart';
import 'package:linos/features/login/cubit/login_form_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.secondaryContainer,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 100.0),
            Image.asset('assets/png/linos_logo.png', height: 100, width: 100),
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
            FilledButton(onPressed: () {}, child: Text(context.l10n.loginPage_createAccountButton)),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      context.read<LoginFormCubit>().emailChanged(_usernameController.text);
    });
    _passwordController.addListener(() {
      context.read<LoginFormCubit>().passwordChanged(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginFormCubit, LoginFormState>(
      listener: (context, state) {
        if (state.submissionStatus is RequestSuccess<bool>) {
          final success = (state.submissionStatus as RequestSuccess<bool>).data;
          if (success) {
            context.go(AppRoutes.mainPage);
            return;
          }
        }
        if (state.submissionStatus is RequestError<bool>) {
          final errorMessage = (state.submissionStatus as RequestError<bool>).message;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
          return;
        }
      },
      builder: (context, state) {
        final bool isSubmitting = state.submissionStatus is RequestLoading<bool>;

        return Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: context.l10n.loginPage_usernameHint, errorText: state.emailError),
              onChanged: (value) => context.read<LoginFormCubit>().emailChanged(value),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.l10n.loginPage_passwordHint,
                errorText: state.passwordError,
              ),
              onChanged: (value) => context.read<LoginFormCubit>().passwordChanged(value),
            ),
            const SizedBox(height: 16.0),
            isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      context.read<LoginFormCubit>().submitForm();
                    },
                    child: Text(context.l10n.loginPage_loginButton),
                  ),
          ],
        );
      },
    );
  }
}
