import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/navigation/app_router_config.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/core/utils/request_state_extensions.dart';
import 'package:linos/core/widgets/custom_email_field.dart';
import 'package:linos/features/auth/presentation/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:linos/features/auth/presentation/forgot_password/cubit/forgot_password_state.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      context.read<ForgotPasswordCubit>().emailChanged(_emailController.text, context.l10n);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.submissionStatus is RequestSuccess<bool>) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.l10n.forgotPassword_successMessage)));
          context.go(AppRouterConfig.login);
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
              onChanged: (email) => context.read<ForgotPasswordCubit>().emailChanged(email, context.l10n),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 32.0),
            isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    onPressed: () {
                      context.read<ForgotPasswordCubit>().resetPassword(context.l10n);
                    },
                    child: Text(context.l10n.forgotPassword_resetButton),
                  ),
          ],
        );
      },
    );
  }
}
