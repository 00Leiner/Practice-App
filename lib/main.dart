import 'package:flutter/material.dart';
import 'package:practice_app/services/auth/auth_service.dart';
import 'package:practice_app/view/login_view.dart';
import 'package:practice_app/view/notes_view.dart';
import 'package:practice_app/view/register_view.dart';
import 'package:practice_app/view/verify_email_view.dart';
import 'constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
     MaterialApp(
      title: 'Flutter Demo',
      home: const Homepage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView()
      },
    ),
  );
}
class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
            if (user != null) {
              // if (user.isEmailVerified) {
              //   return const NoteView();
              // } else {
              //   return const VerifyEmailView();
              // }
              return user.isEmailVerified ? const NotesView() : const VerifyEmailView();
            } else {
              return const LoginView();
            }
            default:
              return const CircularProgressIndicator();
          }
        },
      );
  }
}