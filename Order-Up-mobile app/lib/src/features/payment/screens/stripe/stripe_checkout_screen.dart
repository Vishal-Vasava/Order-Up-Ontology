import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';

class CheckoutScreenExample extends StatefulWidget {
  const CheckoutScreenExample({
    super.key,
  });

  @override
  _CheckoutScreenExample createState() => _CheckoutScreenExample();
}

class _CheckoutScreenExample extends State<CheckoutScreenExample> {
  @override
  Widget build(BuildContext context) {
    // return ExampleScaffold(
    //   title: 'Checkout Page',
    //   padding: EdgeInsets.all(16),
    //   children: [
    //     SizedBox(height: 120),
    //     Center(
    //       child: ElevatedButton(
    //         onPressed: getCheckout,
    //         child: Text('Open Checkout'),
    //       ),
    //     )
    //   ],
    // );
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Checkout Page',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(height: 4),
            // Padding(
            //   child: Row(
            //     children: [
            //       for (final tag in tags) Chip(label: Text(tag)),
            //     ],
            //   ),
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            // ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Open Checkout'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
