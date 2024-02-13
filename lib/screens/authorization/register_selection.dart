import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/authorization/customerregistration.dart';
import 'package:tasklocal/Screens/login_pages/loginpagecustomer.dart';
import 'package:tasklocal/Screens/authorization/tasker_registration.dart';
import 'package:tasklocal/components/customer_register_button.dart';
import 'package:tasklocal/components/tasker_register_button.dart';

class RegisterSelection extends StatelessWidget {
  RegisterSelection({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[500],
      appBar: AppBar(
        backgroundColor: Colors.green[500],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // Logo
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset('lib/images/tasklocaltransparent.png'),
                ),
                SizedBox(height: 16), 

                // Name
                Text(
                  'TaskLocal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),

                const SizedBox(height: 25),

                // Register as Tasker
                RegisterButtonTasker( 
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskerRegistration()), 
                    );
                  },
                ),

                const SizedBox(height: 10),

                // Register as Customer
                RegisterButtonCustomer(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CustomerRegistration()),
                    );
                  },
                ),

                const SizedBox(height: 160),
              ],
            ),
          ),
        ),
      ),
    );
  }
}