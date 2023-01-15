import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/custom_route.dart';
import '../providers/auth.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello!'),
            // this make sure that back button is not added
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(OrdersScreen.routeName);
              /// using custom animation that we had defined
              Navigator.of(context).pushReplacement(
                CustomRoute(
                  builder: (ctx) => OrdersScreen(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          Spacer(),
          Container(
            child: Column(
              children: [
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.of(context).pop(); // this will clear drawer
                    // Navigator.of(context)
                    //     .pushReplacementNamed(UserProductScreen.routeName);
                    Navigator.of(context).pushReplacementNamed('/');
                    // this will make sure that we will always navigate to home route
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
