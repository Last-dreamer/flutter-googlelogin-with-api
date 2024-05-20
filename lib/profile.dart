
import 'package:flutter/material.dart';



class Profile extends StatelessWidget {
  final String? email;
  const Profile({Key? key,   this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Scaffold(body: Center(child: Text(email ?? "empty"),),);
  }
}
