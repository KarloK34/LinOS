import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/navigation/app_router_config.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/core/utils/request_state_extensions.dart';
import 'package:linos/core/widgets/custom_email_field.dart';
import 'package:linos/core/widgets/custom_password_field.dart';
import 'package:linos/features/auth/presentation/login/cubit/login_form_cubit.dart';
import 'package:linos/features/auth/presentation/login/cubit/login_form_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      context.read<LoginFormCubit>().emailChanged(_emailController.text, context.l10n);
    });
    _passwordController.addListener(() {
      context.read<LoginFormCubit>().passwordChanged(_passwordController.text, context.l10n);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
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
            context.go(AppRouterConfig.mainPage);
            return;
          }
        }
        if (state.submissionStatus is RequestError<bool>) {
          state.submissionStatus.showErrorSnackBar(context);
        }
      },
      builder: (context, state) {
        final bool isSubmitting = state.submissionStatus is RequestLoading<bool>;

        return Column(
          children: [
            CustomEmailField(
              controller: _emailController,
              labelText: context.l10n.emailHint,
              errorText: state.emailError,
              onChanged: (email) => context.read<LoginFormCubit>().emailChanged(email, context.l10n),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16.0),
            CustomPasswordField(
              controller: _passwordController,
              labelText: context.l10n.passwordHint,
              errorText: state.passwordError,
              onChanged: (password) => context.read<LoginFormCubit>().passwordChanged(password, context.l10n),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16.0),
            isSubmitting ? const CircularProgressIndicator() : _buildLoginButton(context),
          ],
        );
      },
    );
  }

  ElevatedButton _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
      onPressed: () {
        context.read<LoginFormCubit>().processLogin(context.l10n);
      },
      child: Text(context.l10n.loginPage_loginButton),
    );
  }
}
