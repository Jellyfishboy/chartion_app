
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/charity_list_screen.dart';
import './screens/single_charity_screen.dart';
import './screens/charity_select_donation_screen.dart';

import './providers/charity.dart';
import './providers/donation_price.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CharityProvider()),
          ChangeNotifierProvider(create: (_) => DonationPriceProvider()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.purple,
          ),
          home: CharityListScreen(),
          routes: {
            SingleCharityScreen.routeName: (_) => SingleCharityScreen(),
            CharitySelectDonationScreen.routeName: (_) => CharitySelectDonationScreen(),
            // SearchCharityScreen.routeName: (_) => SearchCharityScreen(),
          }
        ));
  }
}
