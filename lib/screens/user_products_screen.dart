import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(
      context,
      listen: false,
    ).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () {
                    return _refreshProducts(context);
                  },
                  child:
                      Consumer<Products>(builder: (ctx, productsData, child) {
                    print("ProductData: ");
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          print(productsData.items[index].title +
                              " " +
                              productsData.items[index].imageUrl +
                              " " +
                              productsData.items[index].id +
                              " ");
                          return UserProductItem(
                            productsData.items[index].title,
                            productsData.items[index].imageUrl,
                            productsData.items[index].id,
                          );
                        },
                        itemCount: productsData.items.length,
                      ),
                    );
                  }),
                );
        },
      ),
    );
  }
}
