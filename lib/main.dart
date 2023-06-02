import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice_app/firebase_options.dart';
import 'package:practice_app/view/login_view.dart';
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
        notesRoute: (context) => const NoteView()
      },
    ),
  );
}
class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              // if (user.emailVerified) {
              //   return const NoteView();
              // } else {
              //   return const VerifyEmailView();
              // }
              return user.emailVerified ? const NoteView() : const VerifyEmailView();
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

enum MenuAction { logout }

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async { // Capture the BuildContext
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Future.delayed(Duration.zero, () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      );
                    });
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text("Log Out")),
              ];
            },
          )
        ],
      ),
      body: const Text('Hello world'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log out'),
            )
          ],
        );
      },).then((value) => value ?? false);
}
