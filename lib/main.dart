
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => CartModel(),
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      useMaterial3: true,
    ),
    home: const ProductPage(),
  );
}

final products = [
  Product(
  'Vans SK8-Hi',
    'https://assets.vans.com/images/t_img/c_fill,g_center,f_auto,h_550,w_440,e_unsharp_mask:100/dpr_2.0/v1734656306/VN000D5IB8C-ALT1/Sk8Hi-Shoe.png',
  ),
  Product(
    'Docmartens 1460',
    'https://images.tokopedia.net/img/cache/500-square/VqbcmM/2023/6/3/a7e8f1a3-20b0-4891-86fb-5a4e77440a38.jpg',
  ),
  Product(
    'Adidas Samba X Fucking Awesome',
    'https://tse2.mm.bing.net/th/id/OIP.2n4rvI0gLNh05DvtGroapAAAAA?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
  ),
  Product(
    'Convsere 70s x madhappy',
    'https://akn-converse.a-cdn.akinoncloud.com/products/2026/02/03/96689/7867bfc1-2613-4d8e-bf45-ec1cb5b92960_size1410x2115.jpg',
  ),
];

Widget productImage(String url, {double? width, double? height}) =>
    ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
    const Icon(Icons.image_not_supported),
      ),
    );

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Discover Store',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      actions: [
        Consumer<CartModel>(
          builder: (context, cart, _) => IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CartPage(),
              ),
            ),
            icon: Badge(
              label: Text('${cart.totalItems}'),
              isLabelVisible: cart.totalItems > 0,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: products.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) {
          final p = products[index];

          return Card(
            color: Colors.white,
            elevation: 2,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: productImage(p.imageUrl)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          Provider.of<CartModel>(
                            context,
                            listen: false,
                          ).add(p);
                        },
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'My Cart',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    body: Consumer<CartModel>(
      builder: (context, cart, _) => cart.items.isEmpty
          ? const Center(
              child: Text(
                'Keranjang masih kosong',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];

                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        productImage(
                          item.product.imageUrl,
                          width: 85,
                          height: 85,
                        ),
                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${item.quantity}x',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tombol Hapus
                        ElevatedButton.icon(
                          onPressed: () {
                            cart.remove(item.product);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${item.product.name} berhasil dihapus',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                          ),
                          label: const Text('Hapus'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    ),
  );
}
