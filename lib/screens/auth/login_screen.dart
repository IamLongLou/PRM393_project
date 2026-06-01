import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final txtUser = TextEditingController();
  final txtPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.electric_meter,
              size: 100,
              color: Colors.blue,
            ),

            SizedBox(height: 20),

            Text(
              "Điện Nước Mobile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 30),

            TextField(
              controller: txtUser,
              decoration: InputDecoration(
                labelText: "Tên đăng nhập",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            TextField(
              controller: txtPass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Mật khẩu",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    "/home",
                  );
                },
                child: Text("Đăng nhập"),
              ),
            )
          ],
        ),
      ),
    );
  }
}