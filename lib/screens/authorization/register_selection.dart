import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/authorization/customerregistration.dart';
import 'package:tasklocal/Screens/authorization/loginpagecustomer.dart';
import 'package:tasklocal/Screens/authorization/tasker_registration.dart';
import 'package:tasklocal/components/customer_register_button.dart';
import 'package:tasklocal/components/tasker_register_button.dart';
import 'package:tasklocal/screens/authorization/tasker_auth.dart';
import 'package:tasklocal/screens/authorization/customer_auth.dart';

class RegisterSelection extends StatelessWidget {
  RegisterSelection({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green[500],
      appBar: AppBar(
        //backgroundColor: Colors.green[800],
      ),
      body: SafeArea(
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
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 32,
                ),
              ),
        
              const SizedBox(height: 25),
        
              // Register as Tasker
              RegisterButtonTasker( 
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskerAuthPage(showLoginPage: false)), 
                  );
                },
              ),
        
              const SizedBox(height: 10),
        
              // Register as Customer
              RegisterButtonCustomer(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerAuthPage(showLoginPageCust: false)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}