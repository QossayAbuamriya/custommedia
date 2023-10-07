import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';

class CheckoutPage extends StatefulWidget {
  final String spotid;

  CheckoutPage({required this.spotid});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final requestsRef = FirebaseFirestore.instance.collection('requests');
  final currentUserId = FirebaseAuth.instance.currentUser!.email;

  void submitRequest(String spotId) async {
    await requestsRef.add({
      'userId': currentUserId,
      'spotId': spotId,
      'status': 'pending',
      'timestamp': DateTime.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PayPal Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PaypalCheckout(
                sandboxMode: true,
                clientId:
                    "AchHlFa0trVGY9e3mgqAy4vr7cxySJfD_gsaJCquH3eS_XaEbpKDtr5hIeUhTdcSPTWhofJT0tWDbhvL",
                secretKey:
                    "EP69lh4ycG6gzEmW0L-oy_tJ1aU46Vy2mlSbhsXw8I0W4YjANG6BEWgzwPdcsY6IHaYNVHLb0vqEBLvQ",
                returnURL: "success.custommedia.com",
                cancelURL: "cancel.custommedia.com",
                transactions: const [
                  {
                    "amount": {
                      "total": '70',
                      "currency": "USD",
                      "details": {
                        "subtotal": '70',
                        "shipping": '0',
                        "shipping_discount": 0
                      }
                    },
                    "description": "The payment transaction description.",
                    // "payment_options": {
                    //   "allowed_payment_method":
                    //       "INSTANT_FUNDING_SOURCE"
                    // },
                    "item_list": {
                      "items": [
                        {
                          "name": "Apple",
                          "quantity": 4,
                          "price": '5',
                          "currency": "USD"
                        },
                        {
                          "name": "Pineapple",
                          "quantity": 5,
                          "price": '10',
                          "currency": "USD"
                        }
                      ],
                    }
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  print("onSuccess: $params");
                  try {
                    submitRequest(widget
                        .spotid); // Using widget.spotid to reference the spotId from the previous page
                    print('Request successfully added to Firestore');
                  } catch (error) {
                    print('Error inserting into Firestore: $error');
                  }
                },
                
                onError: (error) {
                  print("onError: $error");
                  Navigator.pop(context);
                },
                onCancel: () {
                  print('cancelled:');
                },
              ),
            ));
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
            ),
          ),
          child: const Text('redirect to PayPal'),
        ),
      ),
    );
  }
}
