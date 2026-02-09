import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/core/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_chat_app/core/feature/auth/presentation/bloc/auth_event.dart';
import 'package:my_chat_app/core/feature/auth/presentation/bloc/auth_state.dart';
import 'package:my_chat_app/core/feature/auth/presentation/widget/auth_button.dart';
import 'package:my_chat_app/core/feature/auth/presentation/widget/auth_input_field.dart';
import 'package:my_chat_app/core/feature/auth/presentation/widget/login_prompt.dart';
import 'package:my_chat_app/core/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    BlocProvider.of<AuthBloc>(context).add(
      LoginEvent(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColors.messageListPage,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthInputField(
                hint: 'Email',
                icon: Icons.email,
                controller: _emailController,
              ),
              SizedBox(height: 10),
              AuthInputField(
                hint: 'Password',
                icon: Icons.lock,
                controller: _passwordController,
                isPassword: true,
              ),
              SizedBox(height: 20),
              // AuthButton(onPressed: _onLogin, text: 'Login'),
              // SizedBox(height: 10),
              BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return AuthButton(onPressed: _onLogin, text: 'Login');
                },
                listener: (context, state) {
                  if (state is AuthLoginSuccess) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Login Successful")));
                    Navigator.pushNamedAndRemoveUntil(context, '/conversationPage', (route) => false);
                  } else if (state is AuthLoginFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
              ),
              SizedBox(height: 10),
              LoginPrompt(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                subtitle: 'Click here to Register',
                title: 'Don\'t have an account? ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
