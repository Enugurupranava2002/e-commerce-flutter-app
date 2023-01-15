import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../../helpers/custom_route.dart';
import '../providers/auth.dart';
import '../screens/splash_screen.dart';

import '../screens/edit_product_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/auth_screen.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) {
              return Products(
                auth.token,
                auth.userId,
                (previousProducts == null || previousProducts.items == null)
                    ? []
                    : previousProducts.items,
              );
            },
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) {
              return Orders(
                auth.token,
                (previousOrders == null || previousOrders.orders == null)
                    ? []
                    : previousOrders.orders,
                auth.userId,
              );
            },
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) {
            return MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  fontFamily: 'Lato',

                  /// if we want to apply custom transition to all routes then we need to add this pageTransitionTheme
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    // for this we need to pass page transition builder function which defines how that should look like
                    TargetPlatform.android: CustomPageTrasistionBuilder(),
                    TargetPlatform.iOS: CustomPageTrasistionBuilder(),
                  })),
              home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      builder: (ctx, authResultsnapshot) =>
                          authResultsnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                      future: auth.tryAutoLogin(),
                    ),
              // AuthScreen(),
              routes: {
                ProductsOverviewScreen.routeName: (context) {
                  return ProductDetailScreen();
                },
                ProductDetailScreen.routeName: ((context) {
                  return ProductDetailScreen();
                }),
                CartScreen.routeName: ((context) {
                  return CartScreen();
                }),
                OrdersScreen.routeName: ((context) {
                  return OrdersScreen();
                }),
                UserProductScreen.routeName: ((context) {
                  return UserProductScreen();
                }),
                EditProductScreen.routeName: (context) {
                  return EditProductScreen();
                }
              },
            );
          },
        ));
  }
}
