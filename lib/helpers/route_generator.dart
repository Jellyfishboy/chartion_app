import 'package:flutter/material.dart';

import '../screens/charity_list_screen.dart';
import '../screens/single_charity_screen.dart';
import '../screens/charity_select_donation_screen.dart';
import '../screens/payment_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => CharityListScreen());
      case SingleCharityScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => SingleCharityScreen(charityData: args),
        );
      case CharitySelectDonationScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => CharitySelectDonationScreen(charityData: args),
        );
      case PaymentScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => PaymentScreen(paymentData: args),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('ERROR'),
              centerTitle: true,
            ),
            body: const Center(
              child: Text('Page not found!'),
            ));
      },
    );
  }
}
