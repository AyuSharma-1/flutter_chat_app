import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/core/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_chat_app/core/feature/auth/presentation/bloc/auth_event.dart';
import 'package:my_chat_app/core/feature/auth/presentation/bloc/auth_state.dart';
import 'package:my_chat_app/core/feature/auth/presentation/widget/auth_button.dart';
import 'package:my_chat_app/core/feature/auth/presentation/widget/auth_input_field.dart';
import 'package:my_chat_app/core/feature/auth/presentation/widget/login_prompt.dart';
import 'package:my_chat_app/core/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    BlocProvider.of<AuthBloc>(context).add(
      RegisterEvent(
        username: _usernameController.text,
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
                controller: _usernameController,
                hint: 'Username',
                icon: Icons.person,
              ),
              SizedBox(height: 10),
              AuthInputField(
                controller: _emailController,
                hint: 'Email',
                icon: Icons.email,
              ),
              SizedBox(height: 10),
              AuthInputField(
                hint: 'Password',
                icon: Icons.lock,
                controller: _passwordController,
                isPassword: true,
              ),
              SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return AuthButton(onPressed: _onRegister, text: 'Register');
                },
                listener: (context, state) {
                  if (state is AuthRegisterSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registration Successful")),
                    );
                    Navigator.pushNamed(context, '/login');
                  } else if (state is AuthRegisterFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
              ),
              SizedBox(height: 10),
              LoginPrompt(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                subtitle: 'Click here to Login',
                title: 'Already have an account? ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
