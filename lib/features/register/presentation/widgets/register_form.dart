import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/navigation/app_routes.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/core/widgets/custom_email_field.dart';
import 'package:linos/core/widgets/custom_password_field.dart';
import 'package:linos/features/register/cubit/register_form_cubit.dart';
import 'package:linos/features/register/cubit/register_form_state.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterFormCubit, RegisterFormState>(
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
            CustomEmailField(
              controller: _emailController,
              labelText: context.l10n.emailHint,
              errorText: state.emailError,
              onChanged: (email) => context.read<RegisterFormCubit>().emailChanged(email, context.l10n),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16.0),
            CustomPasswordField(
              controller: _passwordController,
              labelText: context.l10n.passwordHint,
              errorText: state.passwordError,
              onChanged: (password) => context.read<RegisterFormCubit>().passwordChanged(password, context.l10n),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16.0),
            CustomPasswordField(
              controller: _confirmPasswordController,
              labelText: context.l10n.confirmPasswordHint,
              errorText: state.confirmPasswordError,
              onChanged: (confirmPassword) =>
                  context.read<RegisterFormCubit>().confirmPasswordChanged(confirmPassword, context.l10n),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 32.0),
            isSubmitting ? const Center(child: CircularProgressIndicator()) : _buildRegisterButton(context),
          ],
        );
      },
    );
  }

  ElevatedButton _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
      onPressed: () {
        context.read<RegisterFormCubit>().processRegistration(context.l10n);
      },
      child: Text(context.l10n.registerButton),
    );
  }
}
