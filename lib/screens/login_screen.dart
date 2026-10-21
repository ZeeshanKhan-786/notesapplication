
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    auth.isLogin ? 'Login' : 'Create Account',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (auth.errorMessage != null)
                    Text(
                      auth.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                        final success = await context.read<AuthProvider>().submit(
                          emailController.text,
                          passwordController.text,
                        );

                        if (success && context.mounted) {
                          Navigator.of(context)
                              .pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(),
                            ),
                          );
                        }
                      },
                      child: auth.isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                        auth.isLogin ? 'Login' : 'Sign Up',
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: auth.isLoading
                        ? null
                        : () {
                      context
                          .read<AuthProvider>()
                          .toggleMode();
                    },
                    child: Text(
                      auth.isLogin
                          ? 'New user? Create account'
                          : 'Already registered? Login',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
