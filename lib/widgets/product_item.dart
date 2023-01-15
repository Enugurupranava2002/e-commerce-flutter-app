import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    print('Product Rebuilts');
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          // fading loaded images in
          child: Hero(
            // this animation makes sense when we are switching between two screens
            // while using this widget we also need to a widget to widget to which we are navigating to next
            // this animation is used between two different screens. We need this tag to know that which image in previous screens needs to float over
            tag: product.id, // this should be unique per image
            // adding hero animation
            child: FadeInImage(
              // this place holder requires a image provider like AssetImage, Network ...
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              // this is the image that actually needs to be replaced with place holder
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: Container(
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTileBar(
              leading: Consumer<Product>(
                builder: (ctx, value, child) => IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  onPressed: (() {
                    product.toggleFacvoriteState(
                        authData.token, authData.userId);
                  }),
                  color: Theme.of(context).accentColor,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: (() {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added item to cart!',
                      ),
                      // here we can also add actions
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: (() {
                          cart.removeSingleItem(product.id);
                        }),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }),
                color: Theme.of(context).accentColor,
              ),
              backgroundColor: Colors.black87,
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
